defmodule Harmony.ScaleTest do
  use ExUnit.Case, async: true

  alias Harmony.Scale, as: Subject

  test "tokenize" do
    assert Subject.tokenize("c major") == ["C", "major"]
    assert Subject.tokenize("cb3 major") == ["Cb3", "major"]
    assert Subject.tokenize("melodic minor") == ["", "melodic minor"]
    assert Subject.tokenize("dorian") == ["", "dorian"]
    assert Subject.tokenize("c") == ["C", ""]
    assert Subject.tokenize("") == ["", ""]
  end

  test "scale" do
    assert %Subject{
             empty: false,
             tonic: "",
             notes: [],
             type: "major",
             name: "major",
             intervals: ~w(1P 2M 3M 4P 5P 6M 7M),
             aliases: ~w(ionian),
             set_num: 2773,
             chroma: "101011010101",
             normalized: "101010110101"
           } = Subject.get("major")

    assert %Subject{
             empty: false,
             name: "C5 major pentatonic",
             type: "major pentatonic",
             tonic: "C5",
             notes: ~w(C5 D5 E5 G5 A5),
             intervals: ~w(1P 2M 3M 5P 6M),
             aliases: ["pentatonic"],
             set_num: 2708,
             chroma: "101010010100",
             normalized: "100101001010"
           } = Subject.get("c5 pentatonic")

    c4maj = Subject.get("C4 major")
    assert ^c4maj = Subject.get("major", "C4")
  end

  test "is known" do
    assert %{empty: false} = Subject.get("major")
    assert %{empty: false} = Subject.get("Db major")
    assert %{empty: true} = Subject.get("hello")
    assert %{empty: true} = Subject.get("")
    assert %{empty: true} = Subject.get("Maj7")
  end

  test "intervals" do
    assert Subject.get("major").intervals == ~w(1P 2M 3M 4P 5P 6M 7M)
    assert Subject.get("C major").intervals == ~w(1P 2M 3M 4P 5P 6M 7M)
    assert Subject.get("blah").intervals == []
  end

  test "notes" do
    assert Subject.get("C major").notes == ~w(C D E F G A B)
    assert Subject.get("major", "C").notes == ~w(C D E F G A B)
    assert Subject.get("major", "C4").notes == ~w(C4 D4 E4 F4 G4 A4 B4)
    assert Subject.get("bebop", "eb").notes == ~w(Eb F G Ab Bb C Db D)
    assert Subject.get("C lydian #9").notes == ~w(C D# E F# G A B)
    assert Subject.get("no-scale", "C").notes == []
    assert Subject.get("major", "no-note").notes == []
  end

  test "Ukrainian Dorian scale" do
    # Source https://en.wikipedia.org/wiki/Ukrainian_Dorian_scale
    assert Subject.get("C romanian minor").notes == ~w(C D Eb F# G A Bb)
    assert Subject.get("C ukrainian dorian").notes == ~w(C D Eb F# G A Bb)
    assert Subject.get("B romanian minor").notes == ~w(B C# D E# F# G# A)
    assert Subject.get("B dorian #4").notes == ~w(B C# D E# F# G# A)
    assert Subject.get("B altered dorian").notes == ~w(B C# D E# F# G# A)
  end

  test "chords: find all chords that fits into this scale" do
    assert Subject.chords("pentatonic") == ~w(5 M 6 sus2 Madd9)
    assert Subject.chords("none") == []
  end

  test "extended: find all scales that extends this one" do
    assert Subject.extended("major") == [
             "bebop",
             "bebop major",
             "ichikosucho",
             "chromatic"
           ]

    assert Subject.extended("none") == []
  end

  test "Subject.reduced: all scales that are included in the given one" do
    assert Subject.reduced("major") == [
             "major pentatonic",
             "ionian pentatonic",
             "ritusen"
           ]

    assert Subject.reduced("D major") == Subject.reduced("major")
    assert Subject.reduced("none") == []
  end

  test "whole note scale should use 6th" do
    assert Subject.get("C whole tone").notes == ~w(C D E F# G# A#)
    assert Subject.get("Db whole tone").notes == ~w(Db Eb F G A B)
  end

  test "scale_notes" do
    assert Subject.notes(~w(C4 c3 C5 C4 c4)) == ~w(C)
    assert Subject.notes(~w(C4 f3 c#10 b5 d4 cb4)) == ~w(C C# D F B Cb)
    assert Subject.notes(~w(D4 c#5 A5 F#6)) == ~w(D F# A C#)
  end

  test "mode names" do
    assert Subject.modes("pentatonic") == [
             ["1P", "major pentatonic"],
             ["2M", "egyptian"],
             ["3M", "malkos raga"],
             ["5P", "ritusen"],
             ["6M", "minor pentatonic"]
           ]

    assert Subject.modes("whole tone pentatonic") == [
             ["1P", "whole tone pentatonic"]
           ]

    assert Subject.modes("C pentatonic") == [
             ["C", "major pentatonic"],
             ["D", "egyptian"],
             ["E", "malkos raga"],
             ["G", "ritusen"],
             ["A", "minor pentatonic"]
           ]

    assert Subject.modes("C whole tone pentatonic") == [
             ["C", "whole tone pentatonic"]
           ]
  end

  test "range of a scale name" do
    range = Subject.range_of("C pentatonic")
    assert range.("C4", "C5") == ~w(C4 D4 E4 G4 A4 C5)
    assert range.("C5", "C4") == ~w(C5 A4 G4 E4 D4 C4)
    assert range.("g3", "a2") == ~w(G3 E3 D3 C3 A2)
  end

  test "range of a scale name with flat" do
    range = Subject.range_of("Cb major")
    assert range.("Cb4", "Cb5") == ~w(Cb4 Db4 Eb4 Fb4 Gb4 Ab4 Bb4 Cb5)
  end

  test "range of a scale name with sharp" do
    range = Subject.range_of("C# major")
    assert range.("C#4", "C#5") == ~w(C#4 D#4 E#4 F#4 G#4 A#4 B#4 C#5)
  end

  test "range of a scale without tonic" do
    range = Subject.range_of("pentatonic")
    assert range.("C4", "C5") == []
  end

  test "range of a list of notes" do
    range = Subject.range_of(~w(c4 g4 db3 g))
    assert range.("c4", "c5") == ~w(C4 Db4 G4 C5)
  end

  describe "scale_transpose/3" do
    test "transpose forward in C major" do
      assert Subject.scale_transpose("C major", 0, "C4") == "C4"
      assert Subject.scale_transpose("C major", 2, "C4") == "E4"
      assert Subject.scale_transpose("C major", 1, "E4") == "F4"
      assert Subject.scale_transpose("C major", 7, "C4") == "C5"
    end

    test "transpose backward in C major" do
      assert Subject.scale_transpose("C major", -1, "C4") == "B3"
      assert Subject.scale_transpose("C major", -2, "C4") == "A3"
      assert Subject.scale_transpose("C major", -7, "C4") == "C3"
    end

    test "transpose forward in A minor (non-C root)" do
      assert Subject.scale_transpose("A minor", 0, "A3") == "A3"
      assert Subject.scale_transpose("A minor", 1, "A3") == "B3"
      # Crosses octave boundary at B->C
      assert Subject.scale_transpose("A minor", 2, "A3") == "C4"
      assert Subject.scale_transpose("A minor", 3, "A3") == "D4"
      assert Subject.scale_transpose("A minor", 7, "A3") == "A4"
    end

    test "transpose backward in A minor" do
      # Going backward from A doesn't cross B->C boundary
      assert Subject.scale_transpose("A minor", -1, "A3") == "G3"
      assert Subject.scale_transpose("A minor", -2, "A3") == "F3"
      assert Subject.scale_transpose("A minor", -5, "A3") == "C3"
      # Going from A to B crosses B->C boundary going backward
      assert Subject.scale_transpose("A minor", -6, "A3") == "B2"
      assert Subject.scale_transpose("A minor", -7, "A3") == "A2"
    end

    test "transpose from middle of scale" do
      assert Subject.scale_transpose("A minor", 2, "B3") == "D4"
      assert Subject.scale_transpose("A minor", -1, "C4") == "B3"
      assert Subject.scale_transpose("C major", 6, "D4") == "C5"
    end

    test "returns nil for note not in scale" do
      assert Subject.scale_transpose("C major", 2, "C#4") == nil
    end

    test "returns nil for invalid scale" do
      assert Subject.scale_transpose("invalid scale", 2, "C4") == nil
    end

    test "returns nil for invalid note" do
      assert Subject.scale_transpose("C major", 2, "invalid") == nil
    end
  end
end
