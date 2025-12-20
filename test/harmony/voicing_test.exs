defmodule Harmony.VoicingTest do
  use ExUnit.Case, async: true

  alias Harmony.Voicing, as: Subject

  describe "voice/2" do
    test "returns lefthand voicing for minor seventh chord" do
      assert Subject.voice("Cm7") == ["Eb", "G", "Bb", "D"]
      assert Subject.voice("Am7") == ["C", "E", "G", "B"]
    end

    test "returns lefthand voicing for dominant seventh chord" do
      assert Subject.voice("G7") == ["B", "E", "F", "A"]
      assert Subject.voice("C7") == ["E", "A", "Bb", "D"]
    end

    test "returns lefthand voicing for major seventh chord" do
      assert Subject.voice("Fmaj7") == ["A", "C", "E", "G"]
      assert Subject.voice("Cmaj7") == ["E", "G", "B", "D"]
    end

    test "returns guidetone voicing when specified" do
      assert Subject.voice("Cm7", dictionary: :guidetones) == ["Eb", "Bb"]
      assert Subject.voice("G7", dictionary: :guidetones) == ["B", "F"]
      assert Subject.voice("Fmaj7", dictionary: :guidetones) == ["A", "E"]
    end

    test "returns triad voicing when specified" do
      assert Subject.voice("C", dictionary: :triads) == ["C", "E", "G"]
      assert Subject.voice("Am", dictionary: :triads) == ["A", "C", "E"]
      assert Subject.voice("Dm", dictionary: :triads) == ["D", "F", "A"]
    end

    test "supports inversions for triads" do
      assert Subject.voice("Am", dictionary: :triads, inversion: 0) == ["A", "C", "E"]
      assert Subject.voice("Am", dictionary: :triads, inversion: 1) == ["C", "E", "A"]
      assert Subject.voice("Am", dictionary: :triads, inversion: 2) == ["E", "A", "C"]
    end

    test "supports inversions for lefthand voicings" do
      # Second voicing option for m7: "7m 9M 10m 12P"
      assert Subject.voice("Cm7", inversion: 1) == ["Bb", "D", "Eb", "G"]
    end

    test "returns nil for invalid chord" do
      assert Subject.voice("invalid") == nil
      assert Subject.voice("") == nil
    end

    test "returns nil for chord type not in dictionary" do
      # sus4 not in guidetones dictionary
      assert Subject.voice("Csus4", dictionary: :guidetones) == nil
    end
  end

  describe "intervals_for/2" do
    test "returns interval string for chord type" do
      assert Subject.intervals_for("m7", :lefthand) == "3m 5P 7m 9M"
      assert Subject.intervals_for("7", :lefthand) == "3M 6M 7m 9M"
      assert Subject.intervals_for("M", :triads) == "1P 3M 5P"
    end

    test "returns nil for unknown chord type" do
      assert Subject.intervals_for("unknown", :lefthand) == nil
    end
  end

  describe "dictionaries/0" do
    test "returns list of available dictionaries" do
      dicts = Subject.dictionaries()
      assert :lefthand in dicts
      assert :triads in dicts
      assert :guidetones in dicts
    end
  end

  describe "chord_types/1" do
    test "returns chord types for lefthand dictionary" do
      types = Subject.chord_types(:lefthand)
      assert "m7" in types
      assert "7" in types
      assert "maj7" in types
    end

    test "returns chord types for triads dictionary" do
      types = Subject.chord_types(:triads)
      assert "m" in types
      assert "M" in types
      assert "dim" in types
    end

    test "returns empty list for unknown dictionary" do
      assert Subject.chord_types(:unknown) == []
    end
  end
end
