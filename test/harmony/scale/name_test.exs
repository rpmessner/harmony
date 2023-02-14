defmodule Harmony.Scale.NameTest do
  use ExUnit.Case, async: true

  alias Harmony.Scale.Name, as: Subject
  alias Harmony.Pitch.ClassSet

  doctest Subject

  setup _ do
    Subject.reset()
    :ok
  end

  test "list names" do
    assert 92 = Enum.count(Subject.all())
    # sorted
    assert "major pentatonic" = List.first(Subject.all()).name
  end

  test "get" do
    assert %Subject{
             empty: false,
             set_num: 2773,
             name: "major",
             intervals: ~w(1P 2M 3M 4P 5P 6M 7M),
             aliases: ~w(ionian),
             chroma: "101011010101",
             normalized: "101010110101"
           } = Subject.get("major")
  end

  test "not valid get type" do
    assert %Subject{
             empty: true,
             name: "",
             set_num: 0,
             aliases: [],
             chroma: "000000000000",
             intervals: [],
             normalized: "000000000000"
           } = Subject.get("unknown")
  end

  test "add a chord type" do
    Subject.add(~w(1P 5P), "quinta")

    assert %{
             chroma: "100000010000"
           } = Subject.get("quinta")

    Subject.add(~w(1P 5P), "quinta", ~w(q Q))

    quinta = Subject.get("quinta")

    assert ^quinta = Subject.get("q")
    assert ^quinta = Subject.get("Q")
  end

  test "major modes" do
    chromas = ClassSet.modes(Subject.get("major").intervals, true)

    names = Enum.map(chromas, &Subject.get(&1).name)

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
    chromas = ClassSet.modes(Subject.get("harmonic minor").intervals, true)

    names = chromas |> Enum.map(&Subject.get(&1).name)

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
    chromas = ClassSet.modes(Subject.get("melodic minor").intervals, true)

    names = chromas |> Enum.map(&Subject.get(&1).name)

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
    Subject.clear()

    assert [] = Subject.all()
    assert [] = Subject.keys()
  end
end
