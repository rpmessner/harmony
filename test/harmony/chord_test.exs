defmodule Harmony.ChordTest do
  use ExUnit.Case, async: true

  alias Harmony.Chord, as: Subject

  test "tokenize" do
    assert ["C", "maj7"] = Subject.tokenize("Cmaj7")
    assert ["C", "7"] = Subject.tokenize("c7")
    assert ["", "maj7"] = Subject.tokenize("maj7")
    assert ["C#4", "m7b5"] = Subject.tokenize("c#4 m7b5")
    assert ["C#4", "m7b5"] = Subject.tokenize("c#4m7b5")
    assert ["Cb", "7b5"] = Subject.tokenize("Cb7b5")
    assert ["Eb", "7add6"] = Subject.tokenize("Eb7add6")
    assert ["Bb", "6b5"] = Subject.tokenize("Bb6b5")
    assert ["", "aug"] = Subject.tokenize("aug")
    assert ["C", "11"] = Subject.tokenize("C11")
    assert ["C", "13no5"] = Subject.tokenize("C13no5")
    assert ["C", "64"] = Subject.tokenize("C64")
    assert ["C", "5"] = Subject.tokenize("C5")
    assert ["C", "4"] = Subject.tokenize("C4")
  end

  test "get/1" do
    assert %Subject{
             symbol: "dim",
             name: "diminished",
             tonic: "",
             root: "",
             root_degree: 0,
             type: "diminished",
             aliases: ["dim", "°", "o"],
             chroma: "100100100000",
             empty: false,
             intervals: ["1P", "3m", "5d"],
             normalized: "100000100100",
             notes: [],
             quality: "Diminished",
             set_num: 2336
           } = Subject.get("dim")
  end

  test "get/2" do
    assert %Subject{
             empty: false,
             symbol: "GM7",
             name: "G major seventh",
             notes: ["G", "B", "D", "F#"]
           } = Subject.get("M7", "G")
  end

  test "get/3" do
    assert %Subject{
             empty: false,
             name: "G major seventh",
             symbol: "Gmaj7",
             tonic: "G4",
             root: "G4",
             root_degree: 1,
             set_num: 2193,
             type: "major seventh",
             aliases: ["maj7", "Δ", "ma7", "M7", "Maj7", "^7"],
             chroma: "100010010001",
             intervals: ["1P", "3M", "5P", "7M"],
             normalized: "100010010001",
             notes: ["G4", "B4", "D5", "F#5"],
             quality: "Major"
           } = Subject.get("maj7", "G4", "G4")
  end

  test "first inversion" do
    assert %Subject{
             empty: false,
             name: "G major seventh over B",
             symbol: "Gmaj7/B",
             tonic: "G4",
             root: "B4",
             root_degree: 2,
             set_num: 2193,
             type: "major seventh",
             aliases: ["maj7", "Δ", "ma7", "M7", "Maj7", "^7"],
             chroma: "100010010001",
             intervals: ["3M", "5P", "7M", "8P"],
             normalized: "100010010001",
             notes: ["B4", "D5", "F#5", "G5"],
             quality: "Major"
           } = Subject.get("maj7", "G4", "B4")
  end

  test "first inversion without octave" do
    assert %Subject{
             empty: false,
             name: "G major seventh over B",
             symbol: "Gmaj7/B",
             tonic: "G",
             root: "B",
             root_degree: 2,
             set_num: 2193,
             type: "major seventh",
             aliases: ["maj7", "Δ", "ma7", "M7", "Maj7", "^7"],
             chroma: "100010010001",
             intervals: ["3M", "5P", "7M", "8P"],
             normalized: "100010010001",
             notes: ["B", "D", "F#", "G"],
             quality: "Major"
           } = Subject.get("maj7", "G", "B")
  end

  test "second inversion" do
    assert %Subject{
             empty: false,
             name: "G major seventh over D",
             symbol: "Gmaj7/D",
             tonic: "G4",
             root: "D5",
             root_degree: 3,
             set_num: 2193,
             type: "major seventh",
             aliases: ["maj7", "Δ", "ma7", "M7", "Maj7", "^7"],
             chroma: "100010010001",
             intervals: ["5P", "7M", "8P", "10M"],
             normalized: "100010010001",
             notes: ["D5", "F#5", "G5", "B5"],
             quality: "Major"
           } = Subject.get("maj7", "G4", "D5")
  end

  test "root_degrees" do
    assert Subject.get("maj7", "C", "C").root_degree == 1
    assert Subject.get("maj7", "C", "D").empty == true
  end

  test "chord" do
    assert %Subject{
             empty: false,
             symbol: "Cmaj7",
             name: "C major seventh",
             tonic: "C",
             root: "",
             root_degree: 0,
             set_num: 2193,
             type: "major seventh",
             aliases: ["maj7", "Δ", "ma7", "M7", "Maj7", "^7"],
             chroma: "100010010001",
             intervals: ["1P", "3M", "5P", "7M"],
             normalized: "100010010001",
             notes: ["C", "E", "G", "B"],
             quality: "Major"
           } = Subject.get("Cmaj7")

    assert Subject.get("hello").empty == true
    assert Subject.get("").empty == true
    assert Subject.get("C").name == "C major"
  end

  test "chord without tonic" do
    assert %Subject{name: "diminished"} = Subject.get("dim")
    assert %Subject{name: "diminished seventh"} = Subject.get("dim7")
    assert %Subject{name: "altered"} = Subject.get("alt7")
  end

  test "notes" do
    assert Subject.get("Cmaj7").notes == ["C", "E", "G", "B"]
    assert Subject.get("Eb7add6").notes == ["Eb", "G", "Bb", "Db", "C"]
    assert Subject.get("C4 maj7").notes == ["C4", "E4", "G4", "B4"]
    assert Subject.get("C7").notes == ["C", "E", "G", "Bb"]
    assert Subject.get("Cmaj7#5").notes == ["C", "E", "G#", "B"]
    assert Subject.get("blah").notes == []
  end

  test "notes with two params" do
    assert Subject.get("maj7", "C").notes == ["C", "E", "G", "B"]
    assert Subject.get("maj7", "C6").notes == ["C6", "E6", "G6", "B6"]
  end

  test "augmented chords (issue #52)" do
    assert Subject.get("Caug").notes == ["C", "E", "G#"]
    assert Subject.get("aug", "C").notes == ["C", "E", "G#"]
  end

  test "intervals" do
    assert Subject.get("maj7").intervals == ["1P", "3M", "5P", "7M"]
    assert Subject.get("Cmaj7").intervals == ["1P", "3M", "5P", "7M"]
    assert Subject.get("aug").intervals == ["1P", "3M", "5A"]

    assert Subject.get("C13no5").intervals == [
             "1P",
             "3M",
             "7m",
             "9M",
             "13M"
           ]

    assert Subject.get("major").intervals == ["1P", "3M", "5P"]
  end

  test "exists" do
    assert Subject.get("maj7").empty == false
    assert Subject.get("Cmaj7").empty == false
    assert Subject.get("mixolydian").empty == true
  end

  test "chord_scales" do
    names = "phrygian dominant,flamenco,spanish heptatonic,half-whole diminished,chromatic"
    assert Subject.chord_scales("C7b9") == names |> String.split(",")
  end

  test "transpose chord names" do
    assert Subject.transpose("Eb7b9", "5P") == "Bb7b9"
    assert Subject.transpose("7b9", "5P") == "7b9"
  end

  test "extended" do
    chords = "Cmaj#4 Cmaj7#9#11 Cmaj9 CM7add13 Cmaj13 Cmaj9#11 CM13#11 CM7b9"
    assert Subject.extended("CMaj7") |> Enum.sort() == chords |> String.split(" ") |> Enum.sort()
  end

  test "reduced" do
    assert Subject.reduced("CMaj7") == ["C5", "CM"]
  end
end
