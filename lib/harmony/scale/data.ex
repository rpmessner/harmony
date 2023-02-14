defmodule Harmony.Scale.Data do
  # SCALES
  # Format: {"intervals", "name", ["alias1", "alias2", ...]}

  # 5-note scales
  @scales [
    {~w(1P 2M 3M 5P 6M), "major pentatonic", ["pentatonic"]},
    {~w(1P 3M 4P 5P 7M), "ionian pentatonic", []},
    {~w(1P 3M 4P 5P 7m), "mixolydian pentatonic", ["indian"]},
    {~w(1P 2M 4P 5P 6M), "ritusen", []},
    {~w(1P 2M 4P 5P 7m), "egyptian", []},
    {~w(1P 3M 4P 5d 7m), "neopolitan major pentatonic", []},
    {~w(1P 3m 4P 5P 6m), "vietnamese 1", []},
    {~w(1P 2m 3m 5P 6m), "pelog", []},
    {~w(1P 2m 4P 5P 6m), "kumoijoshi", []},
    {~w(1P 2M 3m 5P 6m), "hirajoshi", []},
    {~w(1P 2m 4P 5d 7m), "iwato", []},
    {~w(1P 2m 4P 5P 7m), "in-sen", []},
    {~w(1P 3M 4A 5P 7M), "lydian pentatonic", ["chinese"]},
    {~w(1P 3m 4P 6m 7m), "malkos raga", []},
    {~w(1P 3m 4P 5d 7m), "locrian pentatonic", ["minor seven flat five pentatonic"]},
    {~w(1P 3m 4P 5P 7m), "minor pentatonic", ["vietnamese 2"]},
    {~w(1P 3m 4P 5P 6M), "minor six pentatonic", []},
    {~w(1P 2M 3m 5P 6M), "flat three pentatonic", ["kumoi"]},
    {~w(1P 2M 3M 5P 6m), "flat six pentatonic", []},
    {~w(1P 2m 3M 5P 6M), "scriabin", []},
    {~w(1P 3M 5d 6m 7m), "whole tone pentatonic", []},
    {~w(1P 3M 4A 5A 7M), "lydian #5P pentatonic", []},
    {~w(1P 3M 4A 5P 7m), "lydian dominant pentatonic", []},
    {~w(1P 3m 4P 5P 7M), "minor #7M pentatonic", []},
    {~w(1P 3m 4d 5d 7m), "super locrian pentatonic", []},

    # 6-note scales
    {~w(1P 2M 3m 4P 5P 7M), "minor hexatonic", []},
    {~w(1P 2A 3M 5P 5A 7M), "augmented", []},
    {~w(1P 2M 3m 3M 5P 6M), "major blues", []},
    {~w(1P 2M 4P 5P 6M 7m), "piongio", []},
    {~w(1P 2m 3M 4A 6M 7m), "prometheus neopolitan", []},
    {~w(1P 2M 3M 4A 6M 7m), "prometheus", []},
    {~w(1P 2m 3M 5d 6m 7m), "mystery #1", []},
    {~w(1P 2m 3M 4P 5A 6M), "six tone symmetric", []},
    {~w(1P 2M 3M 4A 5A 6A), "whole tone", ["messiaen's mode #1"]},
    {~w(1P 2m 4P 4A 5P 7M), "messiaen's mode #5", []},
    {~w(1P 3m 4P 5d 5P 7m), "minor blues", ["blues"]},

    # 7-note scales
    {~w(1P 2M 3M 4P 5d 6m 7m), "locrian major", ["arabian"]},
    {~w(1P 2m 3M 4A 5P 6m 7M), "double harmonic lydian", []},
    {~w(1P 2M 3m 4P 5P 6m 7M), "harmonic minor", []},
    {~w(1P 2m 2A 3M 4A 6m 7m), "altered", ["super locrian", "diminished whole tone", "pomeroy"]},
    {~w(1P 2M 3m 4P 5d 6m 7m), "locrian #2", ["half-diminished", "aeolian b5"]},
    {~w(1P 2M 3M 4P 5P 6m 7m), "mixolydian b6", ["melodic minor fifth mode", "hindu"]},
    {~w(1P 2M 3M 4A 5P 6M 7m), "lydian dominant", ["lydian b7", "overtone"]},
    {~w(1P 2M 3M 4A 5P 6M 7M), "lydian", []},
    {~w(1P 2M 3M 4A 5A 6M 7M), "lydian augmented", []},
    {~w(1P 2m 3m 4P 5P 6M 7m), "dorian b2", ["phrygian #6", "melodic minor second mode"]},
    {~w(1P 2M 3m 4P 5P 6M 7M), "melodic minor", []},
    {~w(1P 2m 3m 4P 5d 6m 7m), "locrian", []},
    {~w(1P 2m 3m 4d 5d 6m 7d), "ultralocrian", ["superlocrian bb7", "superlocrian diminished"]},
    {~w(1P 2m 3m 4P 5d 6M 7m), "locrian 6", ["locrian natural 6", "locrian sharp 6"]},
    {~w(1P 2A 3M 4P 5P 5A 7M), "augmented heptatonic", []},
    # Source https://en.wikipedia.org/wiki/Ukrainian_Dorian_scale
    {~w(1P 2M 3m 4A 5P 6M 7m), "dorian #4",
     ["ukrainian dorian", "romanian minor", "altered dorian"]},
    {~w(1P 2M 3m 4A 5P 6M 7M), "lydian diminished", []},
    {~w(1P 2m 3m 4P 5P 6m 7m), "phrygian", []},
    {~w(1P 2M 3M 4A 5A 7m 7M), "leading whole tone", []},
    {~w(1P 2M 3M 4A 5P 6m 7m), "lydian minor", []},
    {~w(1P 2m 3M 4P 5P 6m 7m), "phrygian dominant", ["spanish", "phrygian major"]},
    {~w(1P 2m 3m 4P 5P 6m 7M), "balinese", []},
    {~w(1P 2m 3m 4P 5P 6M 7M), "neopolitan major", []},
    {~w(1P 2M 3m 4P 5P 6m 7m), "aeolian", ["minor"]},
    {~w(1P 2M 3M 4P 5P 6m 7M), "harmonic major", []},
    {~w(1P 2m 3M 4P 5P 6m 7M), "double harmonic major", ["gypsy"]},
    {~w(1P 2M 3m 4P 5P 6M 7m), "dorian", []},
    {~w(1P 2M 3m 4A 5P 6m 7M), "hungarian minor", []},
    {~w(1P 2A 3M 4A 5P 6M 7m), "hungarian major", []},
    {~w(1P 2m 3M 4P 5d 6M 7m), "oriental", []},
    {~w(1P 2m 3m 3M 4A 5P 7m), "flamenco", []},
    {~w(1P 2m 3m 4A 5P 6m 7M), "todi raga", []},
    {~w(1P 2M 3M 4P 5P 6M 7m), "mixolydian", ["dominant"]},
    {~w(1P 2m 3M 4P 5d 6m 7M), "persian", []},
    {~w(1P 2M 3M 4P 5P 6M 7M), "major", ["ionian"]},
    {~w(1P 2m 3M 5d 6m 7m 7M), "enigmatic", []},
    {~w(1P 2M 3M 4P 5A 6M 7M), "major augmented", ["major #5", "ionian augmented", "ionian #5"]},
    {~w(1P 2A 3M 4A 5P 6M 7M), "lydian #9", []},

    # 8-note scales
    {~w(1P 2m 2M 4P 4A 5P 6m 7M), "messiaen's mode #4", []},
    {~w(1P 2m 3M 4P 4A 5P 6m 7M), "purvi raga", []},
    {~w(1P 2m 3m 3M 4P 5P 6m 7m), "spanish heptatonic", []},
    {~w(1P 2M 3M 4P 5P 6M 7m 7M), "bebop", []},
    {~w(1P 2M 3m 3M 4P 5P 6M 7m), "bebop minor", []},
    {~w(1P 2M 3M 4P 5P 5A 6M 7M), "bebop major", []},
    {~w(1P 2m 3m 4P 5d 5P 6m 7m), "bebop locrian", []},
    {~w(1P 2M 3m 4P 5P 6m 7m 7M), "minor bebop", []},
    {~w(1P 2M 3m 4P 5d 6m 6M 7M), "diminished", ["whole-half diminished"]},
    {~w(1P 2M 3M 4P 5d 5P 6M 7M), "ichikosucho", []},
    {~w(1P 2M 3m 4P 5P 6m 6M 7M), "minor six diminished", []},
    {~w(1P 2m 3m 3M 4A 5P 6M 7m), "half-whole diminished",
     ["dominant diminished", "messiaen's mode #2"]},
    {~w(1P 3m 3M 4P 5P 6M 7m 7M), "kafi raga", []},
    {~w(1P 2M 3M 4P 4A 5A 6A 7M), "messiaen's mode #6", []},

    # 9-note scales
    {~w(1P 2M 3m 3M 4P 5d 5P 6M 7m), "composite blues", []},
    {~w(1P 2M 3m 3M 4A 5P 6m 7m 7M), "messiaen's mode #3", []},

    # 10-note scales
    {~w(1P 2m 2M 3m 4P 4A 5P 6m 6M 7M), "messiaen's mode #7", []},

    # 12-note scales
    {~w(1P 2m 2M 3m 3M 4P 5d 5P 6m 6M 7m 7M), "chromatic", []}
  ]

  def data, do: @scales
end
