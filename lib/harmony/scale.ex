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
        %{empty: true} ->
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
      from_n = Note.get(from_note)
      to_n = Note.get(to_note)

      case {from_n, to_n} do
        {%{empty: true}, _} ->
          []

        {_, %{empty: true}} ->
          []

        {%{height: from}, %{height: to}} ->
          Collection.range(from, to)
          |> Enum.map(&get_name.(&1))
          |> Enum.filter(&(!!&1))
      end
    end
  end

  @doc """
  Convert a scale degree to a MIDI note number.

  Degrees are 0-indexed (0 = root, 1 = 2nd, 2 = 3rd, etc.).
  Degrees beyond the scale length wrap to higher octaves.

  ## Examples

      iex> Harmony.Scale.degree_to_midi("C major", 0)
      60

      iex> Harmony.Scale.degree_to_midi("C major", 2)
      64

      iex> Harmony.Scale.degree_to_midi("C major", 7)
      72

      iex> Harmony.Scale.degree_to_midi("A minor", 0, 3)
      57
  """
  @spec degree_to_midi(String.t() | Scale.t(), integer(), integer()) :: integer() | nil
  def degree_to_midi(scale, degree, base_octave \\ 4)

  def degree_to_midi(scale_name, degree, base_octave) when is_binary(scale_name) do
    degree_to_midi(get(scale_name), degree, base_octave)
  end

  def degree_to_midi(%Scale{empty: true}, _degree, _base_octave), do: nil

  def degree_to_midi(%Scale{notes: notes}, degree, base_octave) when is_number(degree) do
    scale_length = length(notes)
    degree = trunc(degree)

    # Handle octave wrapping (when degree >= scale_length)
    octave_offset = div(degree, scale_length)
    index = rem(degree, scale_length)

    # Handle negative degrees
    {index, octave_offset} =
      if index < 0 do
        {index + scale_length, octave_offset - 1}
      else
        {index, octave_offset}
      end

    # Get root note and target note pitch classes
    root_note = Note.get("#{Enum.at(notes, 0)}#{base_octave}")
    target_note_name = Enum.at(notes, index)
    target_note = Note.get("#{target_note_name}#{base_octave}")

    # If the target pitch class is lower than the root, we've wrapped
    # around and need to add an octave
    pitch_class_wrap =
      if target_note.chroma < root_note.chroma do
        1
      else
        0
      end

    octave = base_octave + octave_offset + pitch_class_wrap

    case Note.get("#{target_note_name}#{octave}") do
      %Note{midi: midi} when is_integer(midi) -> midi
      _ -> nil
    end
  end

  @doc """
  Transpose a note within a scale by a step offset.

  Given a scale, an offset, and a note, returns the note that is `offset` steps
  away in the scale, handling octave wrapping correctly.

  ## Examples

      iex> Harmony.Scale.scale_transpose("C major", 2, "C4")
      "E4"

      iex> Harmony.Scale.scale_transpose("C major", -1, "C4")
      "B3"

      iex> Harmony.Scale.scale_transpose("C major", 7, "C4")
      "C5"

      iex> Harmony.Scale.scale_transpose("A minor", 3, "A3")
      "D4"

      iex> Harmony.Scale.scale_transpose("A minor", -2, "A3")
      "F3"
  """
  @spec scale_transpose(String.t() | Scale.t(), integer(), String.t()) :: String.t() | nil
  def scale_transpose(scale_name, offset, note) when is_binary(scale_name) do
    scale_transpose(get(scale_name), offset, note)
  end

  def scale_transpose(%Scale{empty: true}, _offset, _note), do: nil

  def scale_transpose(%Scale{notes: notes}, offset, note) when is_binary(note) do
    note_obj = Note.get(note)

    case note_obj do
      %Note{empty: true} ->
        nil

      %Note{pc: pc, oct: oct} ->
        # Get chromatic values for each scale note
        scale_chromas = Enum.map(notes, &Note.get(&1).chroma)

        case find_scale_index(pc, scale_chromas) do
          nil ->
            # Note not in scale - return nil
            nil

          index ->
            scale_length = length(scale_chromas)
            base_octave = oct || 4

            # Calculate target index with proper wrapping
            wrapped_index = Integer.mod(index + offset, scale_length)

            # Count octave changes by traversing the scale and counting
            # how many times we cross the chroma boundary (where chroma decreases)
            octave_change = count_octave_crossings(scale_chromas, index, offset)

            target_octave = base_octave + octave_change

            # Use enharmonic spelling from scale
            target_note_name = Enum.at(notes, wrapped_index) |> extract_pc()
            "#{target_note_name}#{target_octave}"
        end
    end
  end

  # Count how many times we cross the octave boundary (where chroma wraps from high to low)
  # when moving `offset` steps in the scale starting from `start_index`
  defp count_octave_crossings(_scale_chromas, _start_index, offset) when offset == 0, do: 0

  defp count_octave_crossings(scale_chromas, start_index, offset) when offset > 0 do
    scale_length = length(scale_chromas)

    # Moving forward: count transitions where next chroma < current chroma
    Enum.reduce(1..offset, {start_index, 0}, fn _step, {current_idx, crossings} ->
      next_idx = Integer.mod(current_idx + 1, scale_length)
      current_chroma = Enum.at(scale_chromas, current_idx)
      next_chroma = Enum.at(scale_chromas, next_idx)

      new_crossings =
        if next_chroma < current_chroma do
          crossings + 1
        else
          crossings
        end

      {next_idx, new_crossings}
    end)
    |> elem(1)
  end

  defp count_octave_crossings(scale_chromas, start_index, offset) when offset < 0 do
    scale_length = length(scale_chromas)

    # Moving backward: count transitions where prev chroma > current chroma
    Enum.reduce(1..abs(offset), {start_index, 0}, fn _step, {current_idx, crossings} ->
      prev_idx = Integer.mod(current_idx - 1, scale_length)
      current_chroma = Enum.at(scale_chromas, current_idx)
      prev_chroma = Enum.at(scale_chromas, prev_idx)

      new_crossings =
        if prev_chroma > current_chroma do
          crossings - 1
        else
          crossings
        end

      {prev_idx, new_crossings}
    end)
    |> elem(1)
  end

  # Find the index of a pitch class in the scale by matching chroma values
  defp find_scale_index(pc, scale_chromas) do
    chroma = Note.get(pc).chroma
    Enum.find_index(scale_chromas, &(&1 == chroma))
  end

  # Extract pitch class from a note name (handles both "C" and "C4" formats)
  defp extract_pc(note_name) do
    Note.get(note_name).pc
  end
end
