# Harmony Documentation

Complete documentation for the Harmony music theory library.

## Table of Contents

### Getting Started
- [Getting Started Guide](getting-started.md) - Installation, quick start, and common patterns

### Core Modules
- [Notes](notes.md) - Musical notes, pitch classes, MIDI, and frequencies
- [Intervals](intervals.md) - Musical intervals, distances, and operations
- [Transposition](transpose.md) - Transposing notes and musical structures
- [Chords](chords.md) - Chord recognition, generation, and analysis
- [Scales](scales.md) - Scale generation, modes, and compatibility

### Additional Topics
- **Pitch System** - Low-level pitch coordinate representation
- **Roman Numerals** - Functional harmony and analysis
- **Key Signatures** - Working with key signatures

## Quick Reference

### Module Overview

| Module | Purpose | Key Functions |
|--------|---------|---------------|
| `Harmony.Note` | Notes and pitch classes | `get/1`, `from_midi/1`, `from_freq/1`, `simplify/1` |
| `Harmony.Interval` | Musical intervals | `get/1`, `distance/2`, `invert/1`, `add/2` |
| `Harmony.Transpose` | Transposition | `transpose/2`, `transpose_by/1`, `transpose_fifths/2` |
| `Harmony.Chord` | Chords | `get/1`, `get/2`, `chord_scales/1`, `transpose/2` |
| `Harmony.Scale` | Scales | `get/1`, `get/2`, `modes/1`, `chords/1`, `range_of/1` |
| `Harmony.RomanNumeral` | Roman numerals | `get/1`, `names/0` |
| `Harmony.Pitch` | Pitch coordinates | `encode/1`, `decode/1` |

### Common Patterns

#### Creating Musical Entities

```elixir
# Notes
note = Harmony.Note.get("C4")
note_from_midi = Harmony.Note.from_midi(60)
note_from_freq = Harmony.Note.from_freq(440.0)

# Intervals
interval = Harmony.Interval.get("5P")
interval_from_semitones = Harmony.Interval.from_semitones(7)

# Chords
chord = Harmony.Chord.get("Cmaj7")
chord_separate = Harmony.Chord.get("maj7", "C")
chord_inversion = Harmony.Chord.get("maj7", "C", "E")

# Scales
scale = Harmony.Scale.get("C major")
scale_separate = Harmony.Scale.get("major", "C")
```

#### Transposition

```elixir
# Direct transposition
Harmony.Transpose.transpose("C4", "5P")  # => "G4"

# Create reusable transposer
up_fifth = Harmony.Transpose.transpose_by("5P")
["C", "D", "E"] |> Enum.map(up_fifth)

# Transpose by fifths
Harmony.Transpose.transpose_fifths("C", 1)  # => "G"
```

#### Analysis

```elixir
# Find compatible scales for a chord
Harmony.Chord.chord_scales("Dm7")

# Find compatible chords for a scale
Harmony.Scale.chords("D dorian")

# Get all modes of a scale
Harmony.Scale.modes("C major")

# Calculate interval between notes
Harmony.Interval.distance("C", "G")
```

### Data Types

#### Note Struct

```elixir
%Harmony.Note{
  name: "C4",        # Full name
  pc: "C",           # Pitch class
  letter: "C",       # Letter name
  acc: "",           # Accidental
  oct: 4,            # Octave
  midi: 60,          # MIDI number
  freq: 261.63,      # Frequency in Hz
  chroma: 0,         # Pitch class (0-11)
  height: 60,        # Absolute height
  alt: 0,            # Alteration (-3 to 3)
  step: 0,           # Step (0-6)
  coord: [0, 4],     # Pitch coordinates
  simple: "C",       # Simplified name
  empty: false       # Validity flag
}
```

#### Interval Struct

```elixir
%Harmony.Interval{
  name: "5P",        # Full name
  num: 5,            # Interval number
  q: "P",            # Quality (P, M, m, A, d)
  semitones: 7,      # Semitone distance
  type: "perfectable", # "perfectable" or "majorable"
  simple: 5,         # Simple interval
  simplified: "5P",  # Simplified form
  step: 4,           # Step (0-6)
  alt: 0,            # Alteration
  chroma: 7,         # Chroma (0-11)
  dir: 1,            # Direction (1 or -1)
  oct: 0,            # Octave displacement
  coord: [1, 0],     # Pitch coordinates
  empty: false       # Validity flag
}
```

#### Chord Struct

```elixir
%Harmony.Chord{
  name: "C major seventh",     # Full name
  symbol: "CM7",               # Chord symbol
  type: "major seventh",       # Chord type
  tonic: "C",                  # Tonic note
  root: "",                    # Bass note (for slash chords)
  root_degree: 0,              # Root inversion degree
  notes: ["C", "E", "G", "B"], # Chord notes
  intervals: ["1P", "3M", "5P", "7M"], # Intervals from root
  quality: "Major",            # Quality
  aliases: ["M7", "maj7"],     # Alternative symbols
  chroma: "100010010001",      # Pitch class set
  normalized: "100000010001",  # Normalized chroma
  set_num: 2193,               # Set number
  empty: false                 # Validity flag
}
```

#### Scale Struct

```elixir
%Harmony.Scale{
  name: "C major",             # Full name
  type: "major",               # Scale type
  tonic: "C",                  # Tonic note
  notes: ["C", "D", "E", "F", "G", "A", "B"], # Scale notes
  intervals: ["1P", "2M", "3M", "4P", "5P", "6M", "7M"], # Intervals
  aliases: ["ionian"],         # Alternative names
  chroma: "101011010101",      # Pitch class set
  normalized: "101010110101",  # Normalized chroma
  set_num: 2773,               # Set number
  empty: false                 # Validity flag
}
```

## Interval Quality Reference

### Perfect Intervals (1, 4, 5, 8)

| Quality | Abbreviation | Alteration |
|---------|--------------|------------|
| Diminished | d, dd, ddd | -1, -2, -3 semitones |
| Perfect | P | 0 |
| Augmented | A, AA, AAA | +1, +2, +3 semitones |

### Major/Minor Intervals (2, 3, 6, 7)

| Quality | Abbreviation | Alteration |
|---------|--------------|------------|
| Diminished | d, dd, ddd | -2, -3, -4 semitones from major |
| Minor | m | -1 semitone from major |
| Major | M | 0 |
| Augmented | A, AA, AAA | +1, +2, +3 semitones |

## Common Interval Semitones

| Interval | Semitones | Example |
|----------|-----------|---------|
| 1P | 0 | C → C |
| 2m | 1 | C → Db |
| 2M | 2 | C → D |
| 3m | 3 | C → Eb |
| 3M | 4 | C → E |
| 4P | 5 | C → F |
| 4A / 5d | 6 | C → F# / Gb |
| 5P | 7 | C → G |
| 6m | 8 | C → Ab |
| 6M | 9 | C → A |
| 7m | 10 | C → Bb |
| 7M | 11 | C → B |
| 8P | 12 | C → C (octave) |

## Scale Types Reference

### Common Western Scales

- major / ionian
- minor / aeolian
- dorian
- phrygian
- lydian
- mixolydian
- locrian
- harmonic minor
- melodic minor
- major pentatonic
- minor pentatonic
- blues
- chromatic
- whole tone

## Chord Types Reference

### Major Chords

- M, maj, major (triad)
- M7, maj7 (major 7th)
- M9, maj9 (major 9th)
- M11, maj11 (major 11th)
- M13, maj13 (major 13th)
- 6 (major 6th)
- 69 (major 6/9)

### Minor Chords

- m, min, minor (triad)
- m7, min7 (minor 7th)
- m9, min9 (minor 9th)
- m11, min11 (minor 11th)
- m6 (minor 6th)
- m69 (minor 6/9)

### Dominant Chords

- 7 (dominant 7th)
- 9 (dominant 9th)
- 11 (dominant 11th)
- 13 (dominant 13th)
- 7b5, 7#5, 7b9, 7#9, etc. (alterations)

### Diminished & Augmented

- dim, ° (diminished)
- dim7, °7 (diminished 7th)
- m7b5, ø (half-diminished)
- aug, + (augmented)

### Suspended

- sus2 (suspended 2nd)
- sus4 (suspended 4th)
- 7sus4 (dominant 7 sus4)

## Support & Contributing

- **Issues**: Report bugs or request features on GitHub
- **Documentation**: Help improve these docs
- **Code**: Submit pull requests with new features or fixes

## Additional Resources

- Main README in project root
- Test files for usage examples
- `.claude/claude.md` for codebase architecture
