defmodule Harmony.KeyTest do
  use ExUnit.Case
  alias Harmony.Key

  test "from_alt" do
    assert "A" = Key.major_tonic_from_key_signature("###")
    assert "A" = Key.major_tonic_from_key_signature(3)
    assert "F" = Key.major_tonic_from_key_signature("b")
    assert "Bb" = Key.major_tonic_from_key_signature("bb")
    assert nil == Key.major_tonic_from_key_signature("other")
  end

  # test "major key_signature" do
  #   tonics = ~w(C D E F G A B)
  #   assert [""] ++ ~w(## #### b # ### #####) = Enum.map(tonics, &Key.major_key/1).key_signature)
  # end

  # test "minor key_signature" do
  #   tonics = ~w(C D E F G A B)
  #   assert ~w(bbb b # bbbb bb  ##) = Enum.map(tonics, &Key.minor_key(&1).key_signature)
  # end

  # test "natural scales" do
  #   chord_scales = Key.minor_key("C").natural.chord_scales;
  #   assert chord_scales.map(scale).map((scale) => scale.name) = [
  #     "C aeolian",
  #     "D locrian",
  #     "Eb major",
  #     "F dorian",
  #     "G phrygian",
  #     "Ab lydian",
  #     "Bb mixolydian",
  #   ]
  # end

  # test "harmonic scales" do
  #   chord_scales = Key.minor_key("C").harmonic.chord_scales;
  #   assert  [
  #     "C harmonic minor",
  #     "D locrian 6",
  #     "Eb major augmented",
  #     "F lydian diminished",
  #     "G phrygian dominant",
  #     "Ab lydian #9",
  #     "B ultralocrian",
  #   ] = Enum.map(chord_scales.map(scale).map((scale) => scale.name) =
  # end

  # test "melodic scales" do
  #   chord_scales = Key.minorKey("C").melodic.chord_scales;
  #   assert chord_scales.map(scale).map((scale) => scale.name) = [
  #     "C melodic minor",
  #     "D dorian b2",
  #     "Eb lydian augmented",
  #     "F lydian dominant",
  #     "G mixolydian b6",
  #     "A locrian #2",
  #     "B altered",
  #   ]
  # end

  # test "secondary dominants" do
  #   assert Key.majorKey("C").secondaryDominants = [
  #     "",
  #     "A7",
  #     "B7",
  #     "C7",
  #     "D7",
  #     "E7",
  #     "",
  #   ]
  # end

  # test "octaves are discarded" do
  #   assert Key.majorKey("b4").scale.join(" ") = "B C# D# E F# G# A#"
  #   assert Key.majorKey("g4").chords.join(" ") =
  #     "Gmaj7 Am7 Bm7 Cmaj7 D7 Em7 F#m7b5"

  #   assert Key.minorKey("C4").melodic.scale.join(" ") =
  #     "C D Eb F G A B"

  #   assert Key.minorKey("C4").melodic.chords.join(" ") =
  #     "Cm6 Dm7 Eb+maj7 F7 G7 Am7b5 Bm7b5"

  # end

  # test "valid chord names" do
  #   major = Key.majorKey("C")
  #   minor = Key.minorKey("C")

  #   [
  #     major.chords,
  #     major.secondaryDominants,
  #     major.secondaryDominantsMinorRelative,
  #     major.substituteDominants,
  #     major.substituteDominantsMinorRelative,
  #     minor.natural.chords,
  #     minor.harmonic.chords,
  #     minor.melodic.chords,
  #   ].forEach((chords) => {
  #     chords.forEach((name) => {
  #       if (name !== "") {
  #         if (chord(name).name === "") throw Error(`Invalid chord: ${name}`
  #         assert chord(name).name).not.toBe(""
  #       }
  #     end
  #   end
  # end

  # test "majorKey" do
  #   assert Key.majorKey("C")).toMatchInlineSnapshot(`
  #     Object {
  #       "alteration": 0,
  #       "chord_scales": Array [
  #         "C major",
  #         "D dorian",
  #         "E phrygian",
  #         "F lydian",
  #         "G mixolydian",
  #         "A minor",
  #         "B locrian",
  #       ],
  #       "chords": Array [
  #         "Cmaj7",
  #         "Dm7",
  #         "Em7",
  #         "Fmaj7",
  #         "G7",
  #         "Am7",
  #         "Bm7b5",
  #       ],
  #       "chordsHarmonicFunction": Array [
  #         "T",
  #         "SD",
  #         "T",
  #         "SD",
  #         "D",
  #         "T",
  #         "D",
  #       ],
  #       "grades": Array [
  #         "I",
  #         "II",
  #         "III",
  #         "IV",
  #         "V",
  #         "VI",
  #         "VII",
  #       ],
  #       "intervals": Array [
  #         "1P",
  #         "2M",
  #         "3M",
  #         "4P",
  #         "5P",
  #         "6M",
  #         "7M",
  #       ],
  #       "keySignature": "",
  #       "minorRelative": "A",
  #       "scale": Array [
  #         "C",
  #         "D",
  #         "E",
  #         "F",
  #         "G",
  #         "A",
  #         "B",
  #       ],
  #       "secondaryDominants": Array [
  #         "",
  #         "A7",
  #         "B7",
  #         "C7",
  #         "D7",
  #         "E7",
  #         "",
  #       ],
  #       "secondaryDominantsMinorRelative": Array [
  #         "",
  #         "Em7b5",
  #         "F#m7",
  #         "Gm7",
  #         "Am7",
  #         "Bm7b5",
  #         "",
  #       ],
  #       "substituteDominants": Array [
  #         "",
  #         "Eb7",
  #         "F7",
  #         "Gb7",
  #         "Ab7",
  #         "Bb7",
  #         "",
  #       ],
  #       "substituteDominantsMinorRelative": Array [
  #         "",
  #         "Em7",
  #         "Cm7",
  #         "Dbm7",
  #         "Am7",
  #         "Fm7",
  #         "",
  #       ],
  #       "tonic": "C",
  #       "type": "major",
  #     }
  #   `
  # end

  # test "empty major key " do
  #   assert Key.majorKey("")).toMatchObject({
  #     type: "major",
  #     tonic: "",
  #   end
  #   assert Object.keys(Key.majorKey("C")).sort() =
  #     Object.keys(Key.majorKey("")).sort()

  # end

  # test "minorKey" do
  #   assert Key.minorKey("C")).toMatchInlineSnapshot(`
  #     Object {
  #       "alteration": -3,
  #       "harmonic": Object {
  #         "chord_scales": Array [
  #           "C harmonic minor",
  #           "D locrian 6",
  #           "Eb major augmented",
  #           "F lydian diminished",
  #           "G phrygian dominant",
  #           "Ab lydian #9",
  #           "B ultralocrian",
  #         ],
  #         "chords": Array [
  #           "CmMaj7",
  #           "Dm7b5",
  #           "Eb+maj7",
  #           "Fm7",
  #           "G7",
  #           "Abmaj7",
  #           "Bo7",
  #         ],
  #         "chordsHarmonicFunction": Array [
  #           "T",
  #           "SD",
  #           "T",
  #           "SD",
  #           "D",
  #           "SD",
  #           "D",
  #         ],
  #         "grades": Array [
  #           "I",
  #           "II",
  #           "bIII",
  #           "IV",
  #           "V",
  #           "bVI",
  #           "VII",
  #         ],
  #         "intervals": Array [
  #           "1P",
  #           "2M",
  #           "3m",
  #           "4P",
  #           "5P",
  #           "6m",
  #           "7M",
  #         ],
  #         "scale": Array [
  #           "C",
  #           "D",
  #           "Eb",
  #           "F",
  #           "G",
  #           "Ab",
  #           "B",
  #         ],
  #         "tonic": "C",
  #       },
  #       "keySignature": "bbb",
  #       "melodic": Object {
  #         "chord_scales": Array [
  #           "C melodic minor",
  #           "D dorian b2",
  #           "Eb lydian augmented",
  #           "F lydian dominant",
  #           "G mixolydian b6",
  #           "A locrian #2",
  #           "B altered",
  #         ],
  #         "chords": Array [
  #           "Cm6",
  #           "Dm7",
  #           "Eb+maj7",
  #           "F7",
  #           "G7",
  #           "Am7b5",
  #           "Bm7b5",
  #         ],
  #         "chordsHarmonicFunction": Array [
  #           "T",
  #           "SD",
  #           "T",
  #           "SD",
  #           "D",
  #           "",
  #           "",
  #         ],
  #         "grades": Array [
  #           "I",
  #           "II",
  #           "bIII",
  #           "IV",
  #           "V",
  #           "VI",
  #           "VII",
  #         ],
  #         "intervals": Array [
  #           "1P",
  #           "2M",
  #           "3m",
  #           "4P",
  #           "5P",
  #           "6M",
  #           "7M",
  #         ],
  #         "scale": Array [
  #           "C",
  #           "D",
  #           "Eb",
  #           "F",
  #           "G",
  #           "A",
  #           "B",
  #         ],
  #         "tonic": "C",
  #       },
  #       "natural": Object {
  #         "chord_scales": Array [
  #           "C minor",
  #           "D locrian",
  #           "Eb major",
  #           "F dorian",
  #           "G phrygian",
  #           "Ab lydian",
  #           "Bb mixolydian",
  #         ],
  #         "chords": Array [
  #           "Cm7",
  #           "Dm7b5",
  #           "Ebmaj7",
  #           "Fm7",
  #           "Gm7",
  #           "Abmaj7",
  #           "Bb7",
  #         ],
  #         "chordsHarmonicFunction": Array [
  #           "T",
  #           "SD",
  #           "T",
  #           "SD",
  #           "D",
  #           "SD",
  #           "SD",
  #         ],
  #         "grades": Array [
  #           "I",
  #           "II",
  #           "bIII",
  #           "IV",
  #           "V",
  #           "bVI",
  #           "bVII",
  #         ],
  #         "intervals": Array [
  #           "1P",
  #           "2M",
  #           "3m",
  #           "4P",
  #           "5P",
  #           "6m",
  #           "7m",
  #         ],
  #         "scale": Array [
  #           "C",
  #           "D",
  #           "Eb",
  #           "F",
  #           "G",
  #           "Ab",
  #           "Bb",
  #         ],
  #         "tonic": "C",
  #       },
  #       "relativeMajor": "Eb",
  #       "tonic": "C",
  #       "type": "minor",
  #     }
  #   `
  # end

  # test "empty minor key " do
  #   assert Key.minorKey("nothing")).toMatchObject({
  #     type: "minor",
  #     tonic: "",
  #   end
  #   assert Object.keys(Key.minorKey("C")).sort() =
  #     Object.keys(Key.minorKey("nothing")).sort()

  # end
end
