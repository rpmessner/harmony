# Getting Started

A comprehensive music theory library for Elixir, ported from the popular tonal.js library.

## Installation

Add `harmony` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:harmony, "~> 0.1.0"}
  ]
end
```

Then run:

```bash
mix deps.get
```

## Quick Start

### Working with Notes

```elixir
# Get a note
note = Harmony.Note.get("C4")

# Access note properties
note.midi    # => 60
note.freq    # => 261.63
note.pc      # => "C"

# Create notes from MIDI or frequency
Harmony.Note.from_midi(60)     # => %Note{name: "C4", ...}
Harmony.Note.from_freq(440.0)  # => %Note{name: "A4", ...}

# Simplify complex notes
Harmony.Note.simplify("C###")  # => "D#"
Harmony.Note.simplify("B#4")   # => "C5"
```

### Working with Intervals

```elixir
# Get an interval
interval = Harmony.Interval.get("5P")  # Perfect fifth
interval.semitones  # => 7

# Calculate intervals between notes
Harmony.Interval.distance("C", "G")   # => "5P"
Harmony.Interval.distance("C4", "E4") # => "3M"

# Invert intervals
Harmony.Interval.invert("3M")  # => "6m"
```

### Transposing Notes

```elixir
# Transpose by interval
Harmony.Transpose.transpose("C4", "5P")   # => "G4"
Harmony.Transpose.transpose("D", "3M")    # => "F#"

# Create transposer functions
up_fifth = Harmony.Transpose.transpose_by("5P")
up_fifth.("C")  # => "G"
up_fifth.("D")  # => "A"
```

### Working with Chords

```elixir
# Get a chord
chord = Harmony.Chord.get("Cmaj7")
chord.notes      # => ["C", "E", "G", "B"]
chord.intervals  # => ["1P", "3M", "5P", "7M"]

# Just the chord type
Harmony.Chord.get("maj7").symbol  # => "M7"

# Two-argument form
Harmony.Chord.get("maj7", "D")  # => %Chord{name: "D major seventh", ...}

# Slash chords (inversions)
Harmony.Chord.get("maj7", "C", "E")  # => "C/E"

# Find compatible scales
Harmony.Chord.chord_scales("Cmaj7")
# => ["major", "lydian", "major pentatonic", ...]

# Transpose chords
Harmony.Chord.transpose("Cmaj7", "5P")  # => "Gmaj7"
```

### Working with Scales

```elixir
# Get a scale
scale = Harmony.Scale.get("C major")
scale.notes      # => ["C", "D", "E", "F", "G", "A", "B"]
scale.intervals  # => ["1P", "2M", "3M", "4P", "5P", "6M", "7M"]

# Just the scale type
Harmony.Scale.get("major").aliases  # => ["ionian"]

# Two-argument form
Harmony.Scale.get("dorian", "D")  # => %Scale{name: "D dorian", ...}

# Find compatible chords
Harmony.Scale.chords("C major")
# => ["M", "M6", "M7", "m", "m7", ...]

# Get all modes
Harmony.Scale.modes("C major")
# => [["C", "major"], ["D", "dorian"], ["E", "phrygian"], ...]

# Scale ranges
range_fn = Harmony.Scale.range_of("C major")
range_fn.("C4", "C5")
# => ["C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5"]
```

### Working with Roman Numerals

```elixir
# Get a Roman numeral
rn = Harmony.RomanNumeral.get("V")
rn.interval  # => "5P"
rn.major     # => true

# Minor Roman numerals
Harmony.RomanNumeral.get("vi")  # => %RomanNumeral{major: false, ...}

# With accidentals
Harmony.RomanNumeral.get("bVII")  # => Flat VII chord
```

## Common Patterns

### Transposing a Chord Progression

```elixir
progression = ["C", "Am", "F", "G"]

# Transpose to D
transpose_to_d = Harmony.Transpose.transpose_by("2M")
progression |> Enum.map(transpose_to_d)
# => ["D", "Bm", "G", "A"]
```

### Finding Notes in a Chord

```elixir
Harmony.Chord.get("Dm7").notes
# => ["D", "F", "A", "C"]
```

### Building a Scale from Intervals

```elixir
scale = Harmony.Scale.get("phrygian", "E")
scale.notes
# => ["E", "F", "G", "A", "B", "C", "D"]
```

### Circle of Fifths

```elixir
# Generate circle of fifths
Enum.map(0..11, fn n ->
  Harmony.Transpose.transpose_fifths("C", n)
end)
# => ["C", "G", "D", "A", "E", "B", "F#", "Db", "Ab", "Eb", "Bb", "F"]
```

### Chord Progressions with Roman Numerals

```elixir
# I-IV-V-I in C major
numerals = ["I", "IV", "V", "I"]
Enum.map(numerals, fn rn ->
  interval = Harmony.RomanNumeral.get(rn).interval
  Harmony.Transpose.transpose("C", interval)
end)
# => ["C", "F", "G", "C"]
```

## Key Concepts

### Empty Values

When an invalid value is provided, most functions return an "empty" struct:

```elixir
Harmony.Note.get("invalid")  # => %Note{empty: true, ...}
Harmony.Chord.get("invalid") # => %Chord{empty: true, ...}
Harmony.Scale.get("invalid") # => %Scale{empty: true, ...}
```

### Pitch Classes vs. Notes with Octaves

Most functions work with both pitch classes (no octave) and notes (with octave):

```elixir
# Pitch classes
Harmony.Note.get("C").pc      # => "C"
Harmony.Chord.get("C").notes  # => ["C", "E", "G"]

# Notes with octaves
Harmony.Note.get("C4").oct      # => 4
Harmony.Chord.get("C4").notes   # => ["C4", "E4", "G4"]
```

### Idempotence

Most `get` functions are idempotent - passing a struct returns the same struct:

```elixir
note = Harmony.Note.get("C4")
Harmony.Note.get(note)  # => Returns the same note
```

## Module Overview

- **Harmony.Note** - Notes, pitch classes, MIDI, frequencies
- **Harmony.Interval** - Musical intervals, distances
- **Harmony.Transpose** - Transposing notes and intervals
- **Harmony.Chord** - Chord recognition, generation, analysis
- **Harmony.Scale** - Scale recognition, generation, modes
- **Harmony.RomanNumeral** - Roman numeral analysis
- **Harmony.Pitch** - Low-level pitch representation
- **Harmony.Key** - Key signatures and key-related operations

## Next Steps

- See detailed documentation for each module in the `/docs` folder
- Check out the test files for more usage examples
- Explore the source code for advanced functionality

## Comparison to Tonal.js

This library is a port of the JavaScript library [tonal.js](https://github.com/tonaljs/tonal) to Elixir. While it maintains the core concepts and algorithms, it adapts them to Elixir's functional programming paradigm:

- **Immutable data structures** - All operations return new values
- **Pattern matching** - Extensive use of Elixir's pattern matching
- **Compile-time generation** - Notes and intervals are generated at compile time using macros for performance
- **Functional composition** - Partial application and higher-order functions for composable music operations

## Contributing

This is an older library that's being revitalized with better documentation. Contributions are welcome!
