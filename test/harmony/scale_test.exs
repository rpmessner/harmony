defmodule Harmony.ScaleTest do
  use ExUnit.Case

  alias Harmony.Scale

  test "scale" do
    assert %Scale{
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
           } = Scale.get("major")

    assert %Scale{
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
           } = Scale.get("c5 pentatonic")

    c4maj = Scale.get("C4 major")
    assert ^c4maj = ~w(C4 major) |> Scale.get()
  end

  # test "tokenize" do
  #   assert ["C", "major"] = Scale.tokenize("c major")
  #   assert ["Cb3", "major"] = Scale.tokenize("cb3 major")
  #   assert ["", "melodic minor"] = Scale.tokenize("melodic minor")
  #   assert ["", "dorian"] = Scale.tokenize("dorian")
  #   assert ["C", ""] = Scale.tokenize("c")
  #   assert ["", ""] = Scale.tokenize("")
  # end

  # test "is_known" do
  #   assert %{empty: false} = Scale.get("major")
  #   assert %{emtpy: false} = Scale.get("Db major")
  #   assert %{empty: true} = Scale.get("hello")
  #   assert %{empty: true} = Scale.get("")
  #   assert %{empty: true} = Scale.get("Maj7")
  # end

  # test "intervals" do
  #   assert Scale.get("major").intervals = $("1P 2M 3M 4P 5P 6M 7M")
  #   assert Scale.get("C major").intervals = $("1P 2M 3M 4P 5P 6M 7M")
  #   assert Scale.get("blah").intervals = []
  # end

  # test "notes" do
  #   assert ~w(C D E F G A B) = Scale.get("C major")
  #   assert ~w(C D# E F# G A B) =  Scale.get("C lydian #9")
  #   assert ~w(C D E F G A B) = Scale.get(["C", "major"])
  #   assert ~w(C4 D4 E4 F4 G4 A4 B4) = Scale.get(["C4", "major"])
  #   assert ~w(Eb F G Ab Bb C Db D) = Scale.get(["eb", "bebop"])
  #   assert [] = Scale.get(["C", "no-scale"])
  #   assert [] = Scale.get(["no-note", "major"])
  # end

  # test "Ukrainian Dorian scale" do
  #   # Source https://en.wikipedia.org/wiki/Ukrainian_Dorian_scale
  #   assert ~w(C D Eb F# G A Bb) =  Scale.get("C romanian minor").notes
  #   assert ~w(C D Eb F# G A Bb) =  Scale.get("C ukrainian dorian").notes
  #   assert ~w(B C# D E# F# G# A)=  Scale.get("B romanian minor").notes
  #   assert ~w(B C# D E# F# G# A)=  Scale.get("B dorian #4").notes
  #   assert ~w(B C# D E# F# G# A)=  Scale.get("B altered dorian").notes
  # end

  # test "chords: find all chords that fits into this scale" do
  #   assert ~w(5 M 6 sus2 Madd9) = Scale.scaleChords("pentatonic")
  #   assert [] = Scale.scaleChords("none")
  # end

  # test "extended: find all scales that extends this one" do
  #   assert [
  #     "bebop",
  #     "bebop major",
  #     "ichikosucho",
  #     "chromatic",
  #   ] = Scale.extended("major")
  #   assert [] = Scale.extended("none")
  # end

  # test "Scale.reduced: all scales that are included in the given one" do
  #   assert  [
  #     "major pentatonic",
  #     "ionian pentatonic",
  #     "ritusen",
  #   ] = Scale.reduced("major")
  #   assert Scale.reduced("major") = Scale.reduced("D major") =
  #   assert [] = Scale.reduced("none")
  # end

  # test "scaleNotes" do
  #   assert ~w(C) = Scale.scale_notes(~w(C4 c3 C5 C4 c4))
  #   assert ~w(C C# D F B Cb) = Scale.scale_notes(~w(C4 f3 c#10 b5 d4 cb4))

  #   assert [
  #     "D",
  #     "F#",
  #     "A",
  #     "C#",
  #   ] = Scale.scaleNotes(~w(D4 c#5 A5 F#6))
  # end

  # test "mode names" do
  #   assert [
  #     ["1P", "major pentatonic"],
  #     ["2M", "egyptian"],
  #     ["3M", "malkos raga"],
  #     ["5P", "ritusen"],
  #     ["6M", "minor pentatonic"],
  #   ] =Scale.modeNames("pentatonic")
  #   assert [
  #     ["1P", "whole tone pentatonic"],
  #   ] =Scale.modeNames("whole tone pentatonic")
  #   assert [
  #     ["C", "major pentatonic"],
  #     ["D", "egyptian"],
  #     ["E", "malkos raga"],
  #     ["G", "ritusen"],
  #     ["A", "minor pentatonic"],
  #   ] =Scale.modeNames("C pentatonic")
  #   assert [
  #     ["C", "whole tone pentatonic"],
  #   ] = Scale.modeNames("C whole tone pentatonic")
  # end

  # test "range of a scale name" do
  #   range = Scale.range_of("C pentatonic")
  #   assert ~w(C4 D4 E4 G4 A4 C5) = range.("C4", "C5")
  #   assert ~w(C5 A4 G4 E4 D4 C4) = range.("C5", "C4")
  #   assert ~w(G3 E3 D3 C3 A2) = range.("g3", "a2")
  # end

  # test "range of a scale name with flat" do
  #   range = Scale.range_of("Cb major")
  #   assert ~w(Cb4 Db4 Eb4 Fb4 Gb4 Ab4 Bb4 Cb5) = range("Cb4", "Cb5")
  # end

  # test "range of a scale name with sharp" do
  #   range = Scale.range_of("C# major")
  #   assert ~w(C#4 D#4 E#4 F#4 G#4 A#4 B#4 C#5) = range("C#4", "C#5")
  # end

  # test "range of a scale without tonic" do
  #   range = Scale.range_of("pentatonic")
  #   assert [] = range("C4", "C5")
  # end

  # test "range of a list of notes" do
  #   range = ~w(c4 g4 db3 g) |> Scale.range_of()
  #   assert ~w(C4 Db4 G4 C5) = range("c4", "c5")
  # end
end
