# Chords

The `Harmony.Chord` module provides comprehensive chord recognition, generation, and analysis functionality.

## Overview

Chords are represented by the `%Harmony.Chord{}` struct and can be created from chord symbols or by specifying a chord type and tonic note.

## Basic Usage

### Getting a Chord

```elixir
# Just the chord type (no tonic)
chord = Harmony.Chord.get("maj7")
# => %Harmony.Chord{
#   name: "major seventh",
#   type: "major seventh",
#   symbol: "M7",
#   intervals: ["1P", "3M", "5P", "7M"],
#   aliases: ["M7", "Maj7", "^7"],
#   quality: "Major",
#   ...
# }

# With a tonic note
chord = Harmony.Chord.get("Cmaj7")
# => %Harmony.Chord{
#   name: "C major seventh",
#   symbol: "CM7",
#   tonic: "C",
#   notes: ["C", "E", "G", "B"],
#   intervals: ["1P", "3M", "5P", "7M"],
#   ...
# }
```

### Two-Argument Form

You can also specify the type and tonic separately:

```elixir
# get(type, tonic)
Harmony.Chord.get("maj7", "G")
# => %Harmony.Chord{name: "G major seventh", notes: ["G", "B", "D", "F#"], ...}

Harmony.Chord.get("m7", "D")
# => %Harmony.Chord{name: "D minor seventh", notes: ["D", "F", "A", "C"], ...}
```

### Slash Chords (Inversions)

Create chords with a different bass note:

```elixir
# get(type, tonic, bass)
Harmony.Chord.get("maj7", "C", "E")
# => %Harmony.Chord{
#   name: "C major seventh over E",
#   symbol: "CM7/E",
#   tonic: "C",
#   root: "E",
#   root_degree: 2,  # E is the 2nd note in the chord
#   notes: ["E", "G", "B", "C"],
#   ...
# }
```

## Chord Properties

```elixir
chord = Harmony.Chord.get("Dm7")

chord.name          # => "D minor seventh"
chord.symbol        # => "Dm7"
chord.tonic         # => "D"
chord.type          # => "minor seventh"
chord.notes         # => ["D", "F", "A", "C"]
chord.intervals     # => ["1P", "3m", "5P", "7m"]
chord.quality       # => "Minor"
chord.aliases       # => ["m7", "-7"]
chord.chroma        # => "101010110000"
chord.root_degree   # => 0 (or position of bass note)
```

## Chord Tokenization

Break chord symbols into tonic and type:

```elixir
Harmony.Chord.tokenize("Cmaj7")      # => ["C", "maj7"]
Harmony.Chord.tokenize("c7")         # => ["C", "7"]
Harmony.Chord.tokenize("C#4m7b5")    # => ["C#4", "m7b5"]
Harmony.Chord.tokenize("maj7")       # => ["", "maj7"]
Harmony.Chord.tokenize("aug")        # => ["", "aug"]
```

## Common Chord Types

### Major Chords

```elixir
Harmony.Chord.get("C")        # Major triad: ["C", "E", "G"]
Harmony.Chord.get("CM7")      # Major 7th: ["C", "E", "G", "B"]
Harmony.Chord.get("C6")       # Major 6th: ["C", "E", "G", "A"]
Harmony.Chord.get("C9")       # Major 9th
Harmony.Chord.get("C11")      # Major 11th
Harmony.Chord.get("C13")      # Major 13th
```

### Minor Chords

```elixir
Harmony.Chord.get("Cm")       # Minor triad: ["C", "Eb", "G"]
Harmony.Chord.get("Cm7")      # Minor 7th: ["C", "Eb", "G", "Bb"]
Harmony.Chord.get("Cm6")      # Minor 6th
Harmony.Chord.get("Cm9")      # Minor 9th
```

### Dominant Chords

```elixir
Harmony.Chord.get("C7")       # Dominant 7th: ["C", "E", "G", "Bb"]
Harmony.Chord.get("C9")       # Dominant 9th
Harmony.Chord.get("C7b9")     # Dominant 7 flat 9
Harmony.Chord.get("C7#9")     # Dominant 7 sharp 9
Harmony.Chord.get("C13")      # Dominant 13th
```

### Diminished & Augmented

```elixir
Harmony.Chord.get("Cdim")     # Diminished: ["C", "Eb", "Gb"]
Harmony.Chord.get("Cdim7")    # Diminished 7th: ["C", "Eb", "Gb", "Bbb"]
Harmony.Chord.get("Caug")     # Augmented: ["C", "E", "G#"]
Harmony.Chord.get("Cm7b5")    # Half-diminished: ["C", "Eb", "Gb", "Bb"]
```

### Suspended Chords

```elixir
Harmony.Chord.get("Csus2")    # Suspended 2nd: ["C", "D", "G"]
Harmony.Chord.get("Csus4")    # Suspended 4th: ["C", "F", "G"]
Harmony.Chord.get("C7sus4")   # Dominant 7 suspended 4
```

## Chord Analysis

### Finding Compatible Scales

Get scales that contain all notes of a chord:

```elixir
Harmony.Chord.chord_scales("Cmaj7")
# => ["major", "lydian", "major pentatonic", ...]

Harmony.Chord.chord_scales("Dm7")
# => ["dorian", "minor", "minor pentatonic", ...]
```

### Extended Chords

Find all chords that contain all notes of the given chord:

```elixir
Harmony.Chord.extended("Cmaj7")
# => ["CM7", "CM9", "CM11", "CM13", ...]
```

### Reduced Chords

Find all chords that are subsets of the given chord:

```elixir
Harmony.Chord.reduced("Cmaj7")
# => ["C", "CM7", "C6", ...]
```

## Chord Transposition

Transpose a chord by an interval:

```elixir
Harmony.Chord.transpose("Cmaj7", "5P")  # => "Gmaj7"
Harmony.Chord.transpose("Dm7", "3M")    # => "F#m7"
Harmony.Chord.transpose("Caug", "2M")   # => "Daug"
```

## Chord Symbols & Aliases

Many chord types have multiple valid symbols:

```elixir
# All represent major 7th chords:
Harmony.Chord.get("CM7")
Harmony.Chord.get("Cmaj7")
Harmony.Chord.get("CMaj7")
Harmony.Chord.get("C^7")

# All represent minor 7th chords:
Harmony.Chord.get("Cm7")
Harmony.Chord.get("Cmin7")
Harmony.Chord.get("C-7")
```

The `aliases` field shows all valid symbols for a chord type:

```elixir
Harmony.Chord.get("maj7").aliases
# => ["M7", "Maj7", "^7"]
```

## Advanced Features

### Chord Numbers (6, 64, 7, 9, 11, 13)

Special handling for chords that could be confused with octaves:

```elixir
Harmony.Chord.get("C6")    # Major 6th chord
Harmony.Chord.get("C64")   # Second inversion triad
Harmony.Chord.get("C7")    # Dominant 7th
Harmony.Chord.get("C4")    # Sus4 chord (not C in octave 4)
```

### Empty Chords

Invalid chord symbols return an empty chord:

```elixir
Harmony.Chord.get("invalid")  # => %Chord{empty: true, ...}
Harmony.Chord.get("")         # => %Chord{empty: true, ...}
```

## Chord Voicings

The library focuses on the abstract representation of chords. The `notes` field returns notes in root position as pitch classes. For specific voicings with octaves, specify the tonic with an octave:

```elixir
# Pitch classes only
Harmony.Chord.get("Cmaj7").notes
# => ["C", "E", "G", "B"]

# With specific octave (still root position)
Harmony.Chord.get("C4maj7").notes
# => ["C4", "E4", "G4", "B4"]

# Inversion (different bass note)
Harmony.Chord.get("maj7", "C4", "E4").notes
# => ["E4", "G4", "B4", "C5"]
```
