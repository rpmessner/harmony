defmodule Harmony.Scale.NameTest do
  alias Harmony.Scale.Name
  alias Harmony.Pitch.ClassSet

  use ExUnit.Case

  setup _ do
    Name.reset()
    :ok
  end

  test "list names" do
    assert 92 = Enum.count(Name.all())
    # sorted
    assert "major pentatonic" = List.first(Name.all()).name
  end

  test "get" do
    assert %Name{
             empty: false,
             set_num: 2773,
             name: "major",
             intervals: ~w(1P 2M 3M 4P 5P 6M 7M),
             aliases: ~w(ionian),
             chroma: "101011010101",
             normalized: "101010110101"
           } = Name.get("major")
  end

  test "not valid get type" do
    assert %Name{
             empty: true,
             name: "",
             set_num: 0,
             aliases: [],
             chroma: "000000000000",
             intervals: [],
             normalized: "000000000000"
           } = Name.get("unknown")
  end

  test "add a chord type" do
    Name.add(~w(1P 5P), "quinta")

    assert %{
             chroma: "100000010000"
           } = Name.get("quinta")

    Name.add(~w(1P 5P), "quinta", ~w(q Q))

    quinta = Name.get("quinta")

    assert ^quinta = Name.get("q")
    assert ^quinta = Name.get("Q")
  end

  test "major modes" do
    chromas = ClassSet.modes(Name.get("major").intervals, true)

    names = Enum.map(chromas, &Name.get(&1).name)

    assert [
             "major",
             "dorian",
             "phrygian",
             "lydian",
             "mixolydian",
             "aeolian",
             "locrian"
           ] = names
  end

  test "harmonic minor modes" do
    chromas = ClassSet.modes(Name.get("harmonic minor").intervals, true)

    names = chromas |> Enum.map(&Name.get(&1).name)

    assert [
             "harmonic minor",
             "locrian 6",
             "major augmented",
             "dorian #4",
             "phrygian dominant",
             "lydian #9",
             "ultralocrian"
           ] = names
  end

  test "melodic minor modes" do
    chromas = ClassSet.modes(Name.get("melodic minor").intervals, true)

    names = chromas |> Enum.map(&Name.get(&1).name)

    assert [
             "melodic minor",
             "dorian b2",
             "lydian augmented",
             "lydian dominant",
             "mixolydian b6",
             "locrian #2",
             "altered"
           ] = names
  end

  test "clear dictionary" do
    Name.clear()

    assert [] = Name.all()
    assert [] = Name.keys()
  end
end
