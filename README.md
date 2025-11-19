# Harmony

[![CI](https://github.com/ryanmessner/harmony/workflows/CI/badge.svg)](https://github.com/ryanmessner/harmony/actions/workflows/ci.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/harmony.svg)](https://hex.pm/packages/harmony)
[![Documentation](https://img.shields.io/badge/docs-hexpm-blue.svg)](https://hexdocs.pm/harmony/)
[![License](https://img.shields.io/hexpm/l/harmony.svg)](LICENSE)

A comprehensive music theory library for Elixir, ported from the popular [tonal.js](https://github.com/tonaljs/tonal) library. Harmony provides a complete set of tools for working with notes, intervals, chords, scales, and other music theory concepts.

## Features

- **Notes & Pitch Classes** - Work with musical notes, MIDI numbers, frequencies, and enharmonic equivalents
- **Intervals** - Calculate and manipulate musical intervals with proper enharmonic spelling
- **Chords** - Chord recognition, generation, analysis, and compatible scale finding
- **Scales** - Scale generation, mode calculation, and chord compatibility
- **Transposition** - Transpose notes and musical structures by intervals
- **Roman Numerals** - Roman numeral analysis for functional harmony
- **Circle of Fifths** - Navigate the circle of fifths and key relationships

## Installation

Add `harmony` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:harmony, "~> 0.1.0"}
  ]
end
```

## Quick Examples

### Notes

```elixir
# Get note information
note = Harmony.Note.get("C4")
note.midi    # => 60
note.freq    # => 261.63
note.pc      # => "C"

# Create from MIDI or frequency
Harmony.Note.from_midi(60)     # => %Note{name: "C4", ...}
Harmony.Note.from_freq(440.0)  # => %Note{name: "A4", ...}

# Simplify notes
Harmony.Note.simplify("B#4")   # => "C5"
Harmony.Note.simplify("C###")  # => "D#"
```

### Intervals

```elixir
# Get intervals
Harmony.Interval.get("5P")      # Perfect fifth
Harmony.Interval.get("5P").semitones  # => 7

# Calculate distance between notes
Harmony.Interval.distance("C", "G")   # => "5P"
Harmony.Interval.distance("C4", "E4") # => "3M"

# Operations
Harmony.Interval.invert("3M")   # => "6m"
Harmony.Interval.add("3M", "3m")  # => "5P"
```

### Transposition

```elixir
# Transpose notes
Harmony.Transpose.transpose("C4", "5P")   # => "G4"
Harmony.Transpose.transpose("D", "3M")    # => "F#"

# Create reusable transposers
up_fifth = Harmony.Transpose.transpose_by("5P")
["C", "D", "E"] |> Enum.map(up_fifth)
# => ["G", "A", "B"]
```

### Chords

```elixir
# Get chord information
chord = Harmony.Chord.get("Cmaj7")
chord.notes      # => ["C", "E", "G", "B"]
chord.intervals  # => ["1P", "3M", "5P", "7M"]

# Find compatible scales
Harmony.Chord.chord_scales("Cmaj7")
# => ["major", "lydian", "major pentatonic", ...]

# Transpose chords
Harmony.Chord.transpose("Dm7", "5P")  # => "Am7"
```

### Scales

```elixir
# Get scale information
scale = Harmony.Scale.get("C major")
scale.notes      # => ["C", "D", "E", "F", "G", "A", "B"]
scale.intervals  # => ["1P", "2M", "3M", "4P", "5P", "6M", "7M"]

# Get all modes
Harmony.Scale.modes("C major")
# => [["C", "major"], ["D", "dorian"], ["E", "phrygian"], ...]

# Find compatible chords
Harmony.Scale.chords("D dorian")
# => ["m", "m7", "m9", "m11", "sus4", "7sus4", ...]

# Generate scale ranges
range_fn = Harmony.Scale.range_of("C major")
range_fn.("C4", "C5")
# => ["C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5"]
```

### Roman Numerals

```elixir
# Get Roman numeral information
rn = Harmony.RomanNumeral.get("V")
rn.interval  # => "5P"
rn.major     # => true

# Build progressions
["I", "IV", "V", "I"]
|> Enum.map(fn numeral ->
  Harmony.RomanNumeral.get(numeral).interval
  |> (&Harmony.Transpose.transpose("C", &1)).()
end)
# => ["C", "F", "G", "C"]
```

## Documentation

Comprehensive documentation is available in the `/docs` folder:

- [Getting Started](docs/getting-started.md) - Installation and quick start guide
- [Notes](docs/notes.md) - Working with musical notes
- [Intervals](docs/intervals.md) - Musical intervals and distances
- [Transposition](docs/transpose.md) - Transposing notes and structures
- [Chords](docs/chords.md) - Chord recognition and analysis
- [Scales](docs/scales.md) - Scale generation and modes

## Module Overview

| Module | Description |
|--------|-------------|
| `Harmony.Note` | Musical notes, pitch classes, MIDI numbers, and frequencies |
| `Harmony.Interval` | Musical intervals and distance calculations |
| `Harmony.Transpose` | Transposition operations for notes and intervals |
| `Harmony.Chord` | Chord recognition, generation, and analysis |
| `Harmony.Scale` | Scale generation, modes, and compatibility |
| `Harmony.RomanNumeral` | Roman numeral analysis for functional harmony |
| `Harmony.Pitch` | Low-level pitch representation and coordinate system |
| `Harmony.Key` | Key signatures and key-related operations |

## Design Philosophy

Harmony is built with Elixir's functional programming paradigm in mind:

- **Immutable Data** - All operations return new values rather than modifying existing ones
- **Pattern Matching** - Extensive use of Elixir's pattern matching for clean, readable code
- **Compile-Time Generation** - Notes and intervals are generated at compile time using macros for optimal performance
- **Composability** - Functions support partial application and are designed to work well with `Enum` and `Stream`
- **Type Safety** - Comprehensive typespecs throughout the library

## Performance

The library uses compile-time macros to generate all possible notes and intervals, resulting in:

- **Zero runtime overhead** for note/interval lookups
- **Constant-time access** to note properties
- **Efficient pattern matching** for all operations

## Key Concepts

### Empty Values

When invalid input is provided, functions return "empty" structs rather than raising errors:

```elixir
Harmony.Note.get("invalid")  # => %Note{empty: true, ...}
Harmony.Chord.get("xyz")     # => %Chord{empty: true, ...}
```

### Pitch Classes vs Notes with Octaves

Functions work with both pitch classes (no octave) and specific notes (with octave):

```elixir
# Pitch classes
Harmony.Note.get("C").pc      # => "C"
Harmony.Chord.get("C").notes  # => ["C", "E", "G"]

# Notes with octaves
Harmony.Note.get("C4").oct      # => 4
Harmony.Chord.get("C4").notes   # => ["C4", "E4", "G4"]
```

### Enharmonic Spelling

The library maintains proper enharmonic spelling based on context:

```elixir
Harmony.Transpose.transpose("F#", "5P")  # => "C#" (not Db)
Harmony.Transpose.transpose("Gb", "5P")  # => "Db" (not C#)
```

## Comparison to Tonal.js

This library is an Elixir port of the popular JavaScript library [tonal.js](https://github.com/tonaljs/tonal). While maintaining the core algorithms and concepts, it adapts them to Elixir's strengths:

| Feature | tonal.js | Harmony |
|---------|----------|---------|
| Language | JavaScript | Elixir |
| Data Structure | Mutable Objects | Immutable Structs |
| Performance | Runtime computation | Compile-time generation |
| API Style | OOP/Functional hybrid | Pure Functional |
| Pattern Matching | Limited | Extensive |
| Type System | TypeScript (optional) | Dialyzer typespecs |

## Development

```bash
# Get dependencies
mix deps.get

# Run tests
mix test

# Run dialyzer for type checking
mix dialyzer

# Generate documentation
mix docs
```

## Examples & Use Cases

### Chord Progression Transposition

```elixir
progression = ["C", "Am", "F", "G"]
transpose_to_d = Harmony.Transpose.transpose_by("2M")

progression |> Enum.map(transpose_to_d)
# => ["D", "Bm", "G", "A"]
```

### Finding Scale Degrees

```elixir
scale = Harmony.Scale.get("C major")
scale.notes
|> Enum.with_index(1)
|> Enum.each(fn {note, degree} ->
  IO.puts("Degree #{degree}: #{note}")
end)
# Degree 1: C
# Degree 2: D
# ...
```

### Circle of Fifths

```elixir
Enum.map(0..11, fn n ->
  Harmony.Transpose.transpose_fifths("C", n)
end)
# => ["C", "G", "D", "A", "E", "B", "F#", "Db", "Ab", "Eb", "Bb", "F"]
```

### Jazz Chord Analysis

```elixir
# Find all scales that work over a ii-V-I progression
chords = ["Dm7", "G7", "Cmaj7"]

chords
|> Enum.map(&Harmony.Chord.chord_scales/1)
|> Enum.reduce(&MapSet.intersection(MapSet.new(&1), MapSet.new(&2)))
# => Common scales that work over all three chords
```

## Contributing

Contributions are welcome! This library is being actively maintained and improved. Please feel free to:

- Report bugs
- Suggest new features
- Submit pull requests
- Improve documentation

## License

This project is licensed under the MIT License.

## Credits

- Original [tonal.js](https://github.com/tonaljs/tonal) library by [@danigb](https://github.com/danigb)
- Elixir port and adaptation by Ryan Messner

## Acknowledgments

Special thanks to the tonal.js community for creating such a comprehensive music theory library that inspired this Elixir port.
