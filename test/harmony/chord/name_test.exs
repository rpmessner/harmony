defmodule Harmony.Chord.NameTest do
  use ExUnit.Case, async: true

  alias Harmony.Chord.Name, as: Subject
  alias Harmony.Chord.Data
  alias Harmony.Interval

  doctest Subject

  setup _ do
    Subject.reset()
    :ok
  end

  test "names" do
    # sorted
    assert [
             "fifth",
             "suspended fourth",
             "suspended fourth seventh",
             "augmented",
             "major seventh flat sixth"
           ] = Subject.names() |> Enum.slice(0, 5)
  end

  test "symbols" do
    # sorted
    assert [
             "5",
             "M7#5sus4",
             "7#5sus4"
           ] = Subject.symbols() |> Enum.slice(0, 3)
  end

  test "all returns all chords" do
    assert 106 == Subject.all() |> length
  end

  test "get" do
    assert %Subject{
             empty: false,
             set_num: 2192,
             name: "major",
             quality: "Major",
             intervals: ["1P", "3M", "5P"],
             aliases: ["M", "^", "", "maj"],
             chroma: "100010010000",
             normalized: "100001000100"
           } = Subject.get("major")
  end

  test "add a chord" do
    Subject.add(["1P", "5P"], "q")

    assert %Subject{
             chroma: "100000010000"
           } = Subject.get("q")

    Subject.add(["1P", "5P"], "q", ["quinta"])

    q = Subject.get("quinta")

    assert ^q = Subject.get("q")
  end

  test "clear dictionary" do
    Subject.clear()
    assert [] = Subject.all()
    assert [] = Subject.keys()
  end

  test "no repeated intervals" do
    Data.data()
    |> Enum.map(fn {intervals, _, _} ->
      intervals
      |> Enum.sort()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.each(fn [prev, next] ->
        refute prev == next
      end)
    end)
  end

  test "all chords must have abbreviations" do
    Data.data()
    |> Enum.each(fn {_, _, abbrevs} ->
      assert length(abbrevs) > 0
    end)
  end

  test "intervals should be in ascending order" do
    Data.data()
    |> Enum.each(fn {intervals, _, _} ->
      intervals
      |> Enum.map(&Interval.get(&1).semitones)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.each(fn [prev, next] ->
        assert prev < next
      end)
    end)
  end
end
