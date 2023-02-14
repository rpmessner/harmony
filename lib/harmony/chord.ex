defmodule Harmony.Chord do
  alias Harmony.Note
  alias Harmony.Interval
  alias Harmony.Pitch.ClassSet
  alias Harmony.Transpose
  alias Harmony.Chord.Name
  alias Harmony.Scale.Name, as: ScaleName
  alias __MODULE__

  defstruct(
    empty: true,
    name: "",
    symbol: "",
    root: "",
    root_degree: 0,
    type: "",
    tonic: "",
    set_num: 0,
    quality: "Unknown",
    chroma: "000000000000",
    normalized: "000000000000",
    aliases: [],
    notes: [],
    intervals: []
  )

  @num_types ["6", "64", "7", "9", "11", "13"]

  def tokenize(name) when is_binary(name) do
    case Note.tokenize(name) do
      [""] -> ["", name]
      ["A", _, _, "ug" <> rest] -> ["", "aug#{rest}"]
      ["A", _, _, "lt" <> rest] -> ["", "alt#{rest}"]
      ["D", _, _, "im" <> rest] -> ["", "dim#{rest}"]
      [letter, acc, oct, ""] when oct in ["4", "5"] -> ["#{letter}#{acc}", oct]
      [letter, acc, oct, type] when oct in @num_types -> ["#{letter}#{acc}", "#{oct}#{type}"]
      [letter, acc, oct, type] -> ["#{letter}#{acc}#{oct}", type]
    end
  end

  def get(""), do: %Chord{}

  def get(name) when is_binary(name) do
    apply(__MODULE__, :get, name |> tokenize() |> Enum.reverse())
  end

  def get(%Name{empty: true}), do: %Chord{}

  def get(name, ""), do: do_get(Name.get(name))

  def get(name, tonic) when is_binary(name) and is_binary(tonic) do
    chord_name = Name.get(name)
    tonic_note = Note.get(tonic)

    do_get({chord_name, name}, tonic_note)
  end

  def get(name, tonic, root) when is_binary(name) and is_binary(tonic) and is_binary(root) do
    chord_name = Name.get(name)
    tonic_note = Note.get(tonic)
    root_note = Note.get(root)

    do_get({chord_name, name}, tonic_note, root_note)
  end

  defp do_get(%Name{} = name) do
    symbol = name.aliases |> List.first()

    opts =
      name
      |> Map.from_struct()
      |> Map.merge(%{
        name: "#{name.name}",
        symbol: "#{symbol}",
        type: name.name,
        root_degree: 0,
        notes: []
      })

    struct(Chord, opts)
  end

  defp do_get({%Name{} = n, _}, %Note{empty: true}), do: do_get(n)
  defp do_get({%Name{empty: true}, _}, _), do: %Chord{}

  defp do_get({%Name{} = name, n}, %Note{} = tonic) do
    chord = do_get(name)

    %{intervals: intervals} = name

    notes = intervals |> Enum.map(&Transpose.transpose(tonic, &1))

    symbol =
      if chord.aliases |> Enum.member?(n) do
        n
      else
        chord.aliases |> List.first()
      end

    opts =
      chord
      |> Map.from_struct()
      |> Map.merge(%{
        empty: false,
        name: "#{tonic.pc} #{name.name}",
        symbol: "#{tonic.pc}#{symbol}",
        type: chord.name,
        intervals: intervals,
        root_degree: 0,
        tonic: tonic.name,
        notes: notes
      })

    struct(Chord, opts)
  end

  defp do_get(
         {%Name{} = chord_name, name},
         %Note{} = tonic_note,
         %Note{} = root_note
       ) do
    chord = do_get({chord_name, name}, tonic_note)

    root_interval = Interval.distance(tonic_note.pc, root_note.pc)
    root_interval_index = Enum.find_index(chord_name.intervals, &(&1 == root_interval))

    if root_interval_index == nil do
      %Chord{}
    else
      root_degree = root_interval_index + 1

      intervals =
        1..root_degree
        |> Enum.reduce(chord_name.intervals, fn
          1, intervals ->
            intervals

          _, intervals ->
            [_ | rest] = intervals
            num = intervals |> Enum.at(0) |> String.graphemes() |> Enum.at(0)
            quality = intervals |> Enum.at(0) |> String.graphemes() |> Enum.at(1)
            new_num = (Integer.parse(num) |> Tuple.to_list() |> Enum.at(0)) + 7
            rest ++ ["#{new_num}#{quality}"]
        end)

      notes = intervals |> Enum.map(&Transpose.transpose(tonic_note, &1))

      {name, symbol} =
        if root_degree > 1 do
          {"#{chord.name} over #{root_note.pc}", "#{chord.symbol}/#{root_note.pc}"}
        else
          {chord.name, chord.symbol}
        end

      opts =
        chord
        |> Map.from_struct()
        |> Map.merge(%{
          name: name,
          notes: notes,
          root_degree: root_degree,
          root: root_note.name,
          symbol: symbol,
          intervals: intervals
        })

      struct(Chord, opts)
    end
  end

  def chord_scales(symbol) do
    %{chroma: chroma} = get(symbol)

    is_chord_included = ClassSet.is_superset_of(chroma)

    ScaleName.all()
    |> Enum.filter(&is_chord_included.(&1.chroma))
    |> Enum.map(& &1.name)
  end

  def transpose(chord_name, interval) do
    [tonic, type] = tokenize(chord_name)

    if tonic == "" do
      chord_name
    else
      "#{Transpose.transpose(tonic, interval)}#{type}"
    end
  end

  def extended(chord_name) do
    %{chroma: chroma, tonic: tonic} = get(chord_name)
    is_superset = ClassSet.is_superset_of(chroma)

    Name.all()
    |> Enum.filter(&is_superset.(&1.chroma))
    |> Enum.map(&"#{tonic}#{&1.aliases |> List.first()}")
  end

  def reduced(chord_name) do
    %{chroma: chroma, tonic: tonic} = get(chord_name)
    is_subset = ClassSet.is_subset_of(chroma)

    Name.all()
    |> Enum.filter(&is_subset.(&1.chroma))
    |> Enum.map(&"#{tonic}#{&1.aliases |> List.first()}")
  end
end
