defmodule Harmony.Scale do
  @moduledoc """
  Functions for working with musical scales.

  Scales are ordered collections of notes. This module provides functionality for
  scale generation, mode calculation, finding compatible chords, and generating
  scale ranges with proper enharmonic spelling.

  ## Examples

      # Get a scale
      iex> scale = Harmony.Scale.get("C major")
      iex> scale.notes
      ["C", "D", "E", "F", "G", "A", "B"]

      # Get all modes
      iex> Harmony.Scale.modes("C major")
      [["C", "major"], ["D", "dorian"], ["E", "phrygian"], ...]

      # Find compatible chords
      iex> Harmony.Scale.chords("D dorian")
      ["m", "m7", "m9", "m11", ...]

  See the [Scales guide](docs/scales.md) for detailed documentation.
  """

  alias Harmony.Util
  alias Harmony.Scale.Name
  alias Harmony.Chord.Name, as: ChordName
  alias Harmony.Note
  alias Harmony.Transpose
  alias Harmony.Collection
  alias Harmony.Pitch.ClassSet

  alias __MODULE__

  defstruct(
    empty: true,
    tonic: "",
    notes: [],
    type: "",
    name: "",
    intervals: [],
    aliases: [],
    set_num: 0,
    chroma: "000000000000",
    normalized: "000000000000"
  )

  @type t :: %Scale{
          empty: boolean(),
          tonic: String.t(),
          notes: list(String.t()),
          type: String.t(),
          name: String.t(),
          intervals: list(String.t()),
          aliases: list(String.t()),
          set_num: integer(),
          chroma: String.t(),
          normalized: String.t()
        }

  @spec tokenize(String.t()) :: list(String.t())
  def tokenize(name) do
    i = name |> String.graphemes() |> Enum.find_index(&(&1 == " "))

    case name |> String.slice(0, i || 0) |> Note.get() do
      %Note{empty: true} ->
        case Note.get(name) do
          %Note{empty: true} -> ["", name]
          %Note{name: name} -> [name, ""]
        end

      %Note{name: n} ->
        length = String.length(n) + 1
        type = String.slice(name, length..String.length(name))
        type = if String.length(type) > 0, do: type, else: ""
        [n, type]
    end
  end

  @spec get(String.t()) :: Scale.t()
  def get(name) when is_binary(name) do
    apply(__MODULE__, :get, name |> tokenize() |> Enum.reverse())
  end

  def get(""), do: %Scale{}

  @spec get(String.t(), String.t()) :: Scale.t()
  def get(name, "") do
    scale_name = Name.get(name)
    do_get(scale_name)
  end

  def get(name, tonic) do
    scale_name = Name.get(name)
    tonic_note = Note.get(tonic)
    do_get(scale_name, tonic_note)
  end

  defp do_get(%Name{empty: true}), do: %Scale{}

  defp do_get(%Name{} = name) do
    %{name: type} = name

    opts =
      name
      |> Map.from_struct()
      |> Map.merge(%{
        name: type,
        type: type
      })

    struct(Scale, opts)
  end

  defp do_get(%Name{empty: true}, _), do: %Scale{}
  defp do_get(_, %Note{empty: true}), do: %Scale{}

  defp do_get(%Name{} = name, %Note{} = tonic) do
    %{name: type, intervals: intervals} = name

    notes = intervals |> Enum.map(&Transpose.transpose(tonic, &1))

    scale_name = "#{tonic.name} #{type}"

    opts =
      name
      |> Map.from_struct()
      |> Map.merge(%{
        notes: notes,
        type: type,
        tonic: tonic.name,
        name: scale_name
      })

    struct(Scale, opts)
  end

  @spec chords(String.t()) :: list(String.t())
  def chords(name) do
    %{chroma: scale_chroma} = get(name)

    in_scale = ClassSet.is_subset_of(scale_chroma)

    ChordName.all()
    |> Enum.filter(&in_scale.(&1.chroma))
    |> Enum.map(&(&1.aliases |> List.first()))
  end

  @spec reduced(String.t()) :: list(String.t())
  def reduced(name) do
    if ClassSet.is_chroma(name) do
      reduced_from_chroma(name)
    else
      case get(name) do
        %{empty: true} ->
          []

        %{chroma: scale_chroma} ->
          reduced_from_chroma(scale_chroma)
      end
    end
  end

  defp reduced_from_chroma(chroma) do
    is_subset = ClassSet.is_subset_of(chroma)

    Name.all()
    |> Enum.filter(&is_subset.(&1.chroma))
    |> Enum.map(& &1.name)
  end

  @spec extended(String.t()) :: list(String.t())
  def extended(name) do
    if ClassSet.is_chroma(name) do
      extended_from_chroma(name)
    else
      case get(name) do
        %{empty: true} ->
          []

        %{chroma: scale_chroma} ->
          extended_from_chroma(scale_chroma)
      end
    end
  end

  defp extended_from_chroma(chroma) do
    is_superset = ClassSet.is_superset_of(chroma)

    Name.all()
    |> Enum.filter(&is_superset.(&1.chroma))
    |> Enum.map(& &1.name)
  end

  @spec notes(list(String.t())) :: list(String.t())
  def notes(note_names) when is_list(note_names) do
    pcset = note_names |> Enum.map(&Note.get(&1).pc) |> Enum.filter(&(&1 != ""))
    tonic = pcset |> List.first()
    scale = Note.sorted_uniq_names(pcset)

    scale
    |> Enum.find_index(&(&1 == tonic))
    |> Util.rotate(scale)
  end

  def modes(name) when is_binary(name), do: modes(name |> Scale.get())
  def modes(%Name{empty: true}), do: []

  def modes(%Scale{} = scale) do
    %{chroma: chroma, tonic: tonic, notes: notes, intervals: intervals} = scale
    tonics = if tonic != "", do: notes, else: intervals

    ClassSet.modes(chroma)
    |> Enum.with_index()
    |> Enum.map(fn {chroma, i} ->
      case get(chroma) do
        %{name: ""} ->
          ["", ""]

        %{name: mode_name} ->
          [tonics |> Enum.at(i), mode_name]
      end
    end)
    |> Enum.filter(&(List.first(&1) != ""))
  end

  defp get_note_name_of(scale) when is_list(scale) do
    {notes(scale)} |> get_note_name_of()
  end

  defp get_note_name_of(scale) when is_binary(scale) do
    {get(scale).notes} |> get_note_name_of()
  end

  defp get_note_name_of({names}) do
    chromas = names |> Enum.map(&Note.get(&1).chroma)

    fn note_or_midi ->
      note =
        case note_or_midi do
          midi when is_number(midi) ->
            midi |> Note.from_midi() |> Note.get()

          note ->
            note |> Note.get()
        end

      case note do
        %{height: nil} ->
          nil

        %{height: h, name: n} ->
          chroma = rem(h, 12)

          case Enum.find_index(chromas, &(&1 == chroma)) do
            nil ->
              nil

            position ->
              Note.enharmonic(n, names |> Enum.at(position))
          end
      end
    end
  end

  def range_of(name) do
    get_name = get_note_name_of(name)

    fn from_note, to_note ->
      %{height: from} = Note.get(from_note)
      %{height: to} = Note.get(to_note)

      case {from, to} do
        {f, t} when nil in [f, t] ->
          []

        {f, t} ->
          Collection.range(f, t)
          |> Enum.map(&get_name.(&1))
          |> Enum.filter(&(!!&1))
      end
    end
  end
end
