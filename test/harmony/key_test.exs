defmodule Harmony.KeyTest do
  use ExUnit.Case, async: true

  alias Harmony.Scale
  alias Harmony.Chord

  alias Harmony.Key, as: Subject

  test "from altered" do
    assert Subject.major_tonic_from_key_signature("###") == "A"
    assert Subject.major_tonic_from_key_signature(3) == "A"
    assert Subject.major_tonic_from_key_signature("b") == "F"
    assert Subject.major_tonic_from_key_signature("bb") == "Bb"
    assert Subject.major_tonic_from_key_signature("other") == nil
  end

  test "major key_signature" do
    assert ~w(C D E F G A B) |> Enum.map(&Subject.major_key(&1).key_signature) ==
             ["", "##", "####", "b", "#", "###", "#####"]
  end

  test "minor key_signature" do
    assert ~w(C D E F G A B) |> Enum.map(&Subject.minor_key(&1).key_signature) ==
             ["bbb", "b", "#", "bbbb", "bb", "", "##"]
  end

  test "natural scales" do
    chord_scales = Subject.minor_key("C").natural.chord_scales

    assert chord_scales
           |> Enum.map(&Scale.get(&1).name) == [
             "C aeolian",
             "D locrian",
             "Eb major",
             "F dorian",
             "G phrygian",
             "Ab lydian",
             "Bb mixolydian"
           ]
  end

  test "harmonic scales" do
    chord_scales = Subject.minor_key("C").harmonic.chord_scales

    assert chord_scales |> Enum.map(&Scale.get(&1).name) == [
             "C harmonic minor",
             "D locrian 6",
             "Eb major augmented",
             "F lydian diminished",
             "G phrygian dominant",
             "Ab lydian #9",
             "B ultralocrian"
           ]
  end

  test "melodic scales" do
    chord_scales = Subject.minor_key("C").melodic.chord_scales

    assert chord_scales |> Enum.map(&Scale.get(&1).name) == [
             "C melodic minor",
             "D dorian b2",
             "Eb lydian augmented",
             "F lydian dominant",
             "G mixolydian b6",
             "A locrian #2",
             "B altered"
           ]
  end

  test "secondary dominants" do
    assert Subject.major_key("C").secondary_dominants == [
             "",
             "A7",
             "B7",
             "C7",
             "D7",
             "E7",
             ""
           ]
  end

  test "octaves are discarded" do
    assert Subject.major_key("b4").scale == ~w(B C# D# E F# G# A#)
    assert Subject.major_key("g4").chords == ~w(Gmaj7 Am7 Bm7 Cmaj7 D7 Em7 F#m7b5)
    assert Subject.minor_key("C4").melodic.scale == ~w(C D Eb F G A B)
    assert Subject.minor_key("C4").melodic.chords == ~w(Cm6 Dm7 Eb+maj7 F7 G7 Am7b5 Bm7b5)
  end

  test "valid chord names" do
    major = Subject.major_key("C")
    minor = Subject.minor_key("C")

    [
      major.chords,
      major.secondary_dominants,
      major.secondary_dominants_minor_relative,
      major.substitute_dominants,
      major.substitute_dominants_minor_relative,
      minor.natural.chords,
      minor.harmonic.chords,
      minor.melodic.chords
    ]
    |> Enum.each(fn chords ->
      chords
      |> Enum.each(fn name ->
        if name != "" do
          assert Chord.get(name).name != ""
        end
      end)
    end)
  end

  test "major_key" do
    assert %Subject.Major{
             alteration: 0,
             chord_scales: [
               "C major",
               "D dorian",
               "E phrygian",
               "F lydian",
               "G mixolydian",
               "A minor",
               "B locrian"
             ],
             chords: [
               "Cmaj7",
               "Dm7",
               "Em7",
               "Fmaj7",
               "G7",
               "Am7",
               "Bm7b5"
             ],
             chords_harmonic_function: [
               "T",
               "SD",
               "T",
               "SD",
               "D",
               "T",
               "D"
             ],
             grades: [
               "I",
               "II",
               "III",
               "IV",
               "V",
               "VI",
               "VII"
             ],
             intervals: [
               "1P",
               "2M",
               "3M",
               "4P",
               "5P",
               "6M",
               "7M"
             ],
             key_signature: "",
             minor_relative: "A",
             scale: [
               "C",
               "D",
               "E",
               "F",
               "G",
               "A",
               "B"
             ],
             secondary_dominants: [
               "",
               "A7",
               "B7",
               "C7",
               "D7",
               "E7",
               ""
             ],
             secondary_dominants_minor_relative: [
               "",
               "Em7b5",
               "F#m7",
               "Gm7",
               "Am7",
               "Bm7b5",
               ""
             ],
             substitute_dominants: [
               "",
               "Eb7",
               "F7",
               "Gb7",
               "Ab7",
               "Bb7",
               ""
             ],
             substitute_dominants_minor_relative: [
               "",
               "Em7",
               "Cm7",
               "Dbm7",
               "Am7",
               "Fm7",
               ""
             ],
             tonic: "C",
             type: "major"
           } = Subject.major_key("C")
  end

  test "empty major key " do
    assert %Subject.Major{
             empty: true,
             type: "major",
             tonic: ""
           } = Subject.major_key("")
  end

  test "minor_key" do
    assert %Subject.Minor{
             alteration: -3,
             harmonic: %{
               chord_scales: [
                 "C harmonic minor",
                 "D locrian 6",
                 "Eb major augmented",
                 "F lydian diminished",
                 "G phrygian dominant",
                 "Ab lydian #9",
                 "B ultralocrian"
               ],
               chords: [
                 "CmMaj7",
                 "Dm7b5",
                 "Eb+maj7",
                 "Fm7",
                 "G7",
                 "Abmaj7",
                 "Bo7"
               ],
               chords_harmonic_function: [
                 "T",
                 "SD",
                 "T",
                 "SD",
                 "D",
                 "SD",
                 "D"
               ],
               grades: [
                 "I",
                 "II",
                 "bIII",
                 "IV",
                 "V",
                 "bVI",
                 "VII"
               ],
               intervals: [
                 "1P",
                 "2M",
                 "3m",
                 "4P",
                 "5P",
                 "6m",
                 "7M"
               ],
               scale: [
                 "C",
                 "D",
                 "Eb",
                 "F",
                 "G",
                 "Ab",
                 "B"
               ],
               tonic: "C"
             },
             key_signature: "bbb",
             melodic: %{
               chord_scales: [
                 "C melodic minor",
                 "D dorian b2",
                 "Eb lydian augmented",
                 "F lydian dominant",
                 "G mixolydian b6",
                 "A locrian #2",
                 "B altered"
               ],
               chords: [
                 "Cm6",
                 "Dm7",
                 "Eb+maj7",
                 "F7",
                 "G7",
                 "Am7b5",
                 "Bm7b5"
               ],
               chords_harmonic_function: [
                 "T",
                 "SD",
                 "T",
                 "SD",
                 "D",
                 "",
                 ""
               ],
               grades: [
                 "I",
                 "II",
                 "bIII",
                 "IV",
                 "V",
                 "VI",
                 "VII"
               ],
               intervals: [
                 "1P",
                 "2M",
                 "3m",
                 "4P",
                 "5P",
                 "6M",
                 "7M"
               ],
               scale: [
                 "C",
                 "D",
                 "Eb",
                 "F",
                 "G",
                 "A",
                 "B"
               ],
               tonic: "C"
             },
             natural: %{
               chord_scales: [
                 "C minor",
                 "D locrian",
                 "Eb major",
                 "F dorian",
                 "G phrygian",
                 "Ab lydian",
                 "Bb mixolydian"
               ],
               chords: [
                 "Cm7",
                 "Dm7b5",
                 "Ebmaj7",
                 "Fm7",
                 "Gm7",
                 "Abmaj7",
                 "Bb7"
               ],
               chords_harmonic_function: [
                 "T",
                 "SD",
                 "T",
                 "SD",
                 "D",
                 "SD",
                 "SD"
               ],
               grades: [
                 "I",
                 "II",
                 "bIII",
                 "IV",
                 "V",
                 "bVI",
                 "bVII"
               ],
               intervals: [
                 "1P",
                 "2M",
                 "3m",
                 "4P",
                 "5P",
                 "6m",
                 "7m"
               ],
               scale: [
                 "C",
                 "D",
                 "Eb",
                 "F",
                 "G",
                 "Ab",
                 "Bb"
               ],
               tonic: "C"
             },
             relative_major: "Eb",
             tonic: "C",
             type: "minor"
           } = Subject.minor_key("C")
  end

  test "empty minor key " do
    assert %Subject.Minor{
             empty: true,
             type: "minor",
             tonic: ""
           } = Subject.minor_key("nothing")
  end
end
