# Scales

The `Harmony.Scale` module provides comprehensive scale generation, recognition, and analysis functionality.

## Overview

Scales are represented by the `%Harmony.Scale{}` struct and can be created from scale names or by specifying a scale type and tonic note.

## Basic Usage

### Getting a Scale

```elixir
# Just the scale type (no tonic)
scale = Harmony.Scale.get("major")
# => %Harmony.Scale{
#   name: "major",
#   type: "major",
#   intervals: ["1P", "2M", "3M", "4P", "5P", "6M", "7M"],
#   aliases: ["ionian"],
#   notes: [],
#   ...
# }

# With a tonic note
scale = Harmony.Scale.get("C major")
# => %Harmony.Scale{
#   name: "C major",
#   type: "major",
#   tonic: "C",
#   notes: ["C", "D", "E", "F", "G", "A", "B"],
#   intervals: ["1P", "2M", "3M", "4P", "5P", "6M", "7M"],
#   ...
# }
```

### Two-Argument Form

You can also specify the type and tonic separately:

```elixir
# get(type, tonic)
Harmony.Scale.get("major", "G")
# => %Harmony.Scale{name: "G major", notes: ["G", "A", "B", "C", "D", "E", "F#"], ...}

Harmony.Scale.get("minor", "D")
# => %Harmony.Scale{name: "D minor", notes: ["D", "E", "F", "G", "A", "Bb", "C"], ...}
```

## Scale Properties

```elixir
scale = Harmony.Scale.get("D dorian")

scale.name       # => "D dorian"
scale.type       # => "dorian"
scale.tonic      # => "D"
scale.notes      # => ["D", "E", "F", "G", "A", "B", "C"]
scale.intervals  # => ["1P", "2M", "3m", "4P", "5P", "6M", "7m"]
scale.aliases    # => []
scale.chroma     # => "101101010110"
```

## Scale Tokenization

Break scale names into tonic and type:

```elixir
Harmony.Scale.tokenize("C major")           # => ["C", "major"]
Harmony.Scale.tokenize("Cb3 major")         # => ["Cb3", "major"]
Harmony.Scale.tokenize("melodic minor")     # => ["", "melodic minor"]
Harmony.Scale.tokenize("dorian")            # => ["", "dorian"]
```

## Common Scale Types

### Major Scales

```elixir
Harmony.Scale.get("C major")
# => ["C", "D", "E", "F", "G", "A", "B"]

Harmony.Scale.get("C ionian")  # Same as major
# => ["C", "D", "E", "F", "G", "A", "B"]
```

### Natural Minor

```elixir
Harmony.Scale.get("A minor")
# => ["A", "B", "C", "D", "E", "F", "G"]

Harmony.Scale.get("A aeolian")  # Same as natural minor
# => ["A", "B", "C", "D", "E", "F", "G"]
```

### Modal Scales

```elixir
Harmony.Scale.get("D dorian")       # => ["D", "E", "F", "G", "A", "B", "C"]
Harmony.Scale.get("E phrygian")     # => ["E", "F", "G", "A", "B", "C", "D"]
Harmony.Scale.get("F lydian")       # => ["F", "G", "A", "B", "C", "D", "E"]
Harmony.Scale.get("G mixolydian")   # => ["G", "A", "B", "C", "D", "E", "F"]
Harmony.Scale.get("B locrian")      # => ["B", "C", "D", "E", "F", "G", "A"]
```

### Pentatonic Scales

```elixir
Harmony.Scale.get("C major pentatonic")
# => ["C", "D", "E", "G", "A"]

Harmony.Scale.get("A minor pentatonic")
# => ["A", "C", "D", "E", "G"]
```

### Melodic & Harmonic Minor

```elixir
Harmony.Scale.get("C melodic minor")
# => ["C", "D", "Eb", "F", "G", "A", "B"]

Harmony.Scale.get("C harmonic minor")
# => ["C", "D", "Eb", "F", "G", "Ab", "B"]
```

### Blues Scales

```elixir
Harmony.Scale.get("C blues")
# => ["C", "Eb", "F", "Gb", "G", "Bb"]
```

### Exotic Scales

```elixir
Harmony.Scale.get("C chromatic")
Harmony.Scale.get("C whole tone")
Harmony.Scale.get("C augmented")
Harmony.Scale.get("C diminished")
Harmony.Scale.get("C bebop")
```

## Scale Analysis

### Finding Compatible Chords

Get all chords whose notes are contained within the scale:

```elixir
Harmony.Scale.chords("C major")
# => ["5", "M", "M6", "M7", "M9", "M11", "M13", "m", "m7", "m9", ...]

Harmony.Scale.chords("D dorian")
# => ["m", "m7", "m9", "m11", "sus4", "7sus4", ...]
```

### Extended Scales

Find all scales that contain all notes of the given scale:

```elixir
Harmony.Scale.extended("C major pentatonic")
# => ["major", "lydian", "major pentatonic", ...]
```

### Reduced Scales

Find all scales that are subsets of the given scale:

```elixir
Harmony.Scale.reduced("C major")
# => ["major", "major pentatonic", "ionian pentatonic", ...]
```

## Scale Modes

Get all modes of a scale:

```elixir
Harmony.Scale.modes("C major")
# => [
#   ["C", "major"],          # Ionian
#   ["D", "dorian"],
#   ["E", "phrygian"],
#   ["F", "lydian"],
#   ["G", "mixolydian"],
#   ["A", "aeolian"],
#   ["B", "locrian"]
# ]

# Without a tonic, returns intervals instead of notes
Harmony.Scale.modes("major")
# => [
#   ["1P", "major"],
#   ["2M", "dorian"],
#   ["3M", "phrygian"],
#   ...
# ]
```

## Creating Scales from Notes

Create a scale from a collection of notes:

```elixir
Harmony.Scale.notes(["C", "D", "E", "F", "G", "A", "B"])
# => ["C", "D", "E", "F", "G", "A", "B"]

# Automatically rotates to start from the first note
Harmony.Scale.notes(["E", "F", "G", "A", "B", "C", "D"])
# => ["E", "F", "G", "A", "B", "C", "D"]
```

## Scale Ranges

Generate a range of notes within a scale between two notes:

```elixir
range_fn = Harmony.Scale.range_of("C major")
range_fn.("C4", "C5")
# => ["C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5"]

range_fn.("E4", "G4")
# => ["E4", "F4", "G4"]

# Works with any scale
range_fn = Harmony.Scale.range_of("D dorian")
range_fn.("D4", "D5")
# => ["D4", "E4", "F4", "G4", "A4", "B4", "C5", "D5"]
```

This function returns a function that:
- Takes two notes (from and to)
- Returns all scale notes within that range
- Handles enharmonic spelling based on the scale
- Returns an empty list if the notes are not in the scale

## Working with Octaves

Specify octaves for precise note generation:

```elixir
# Pitch classes only (no octave)
Harmony.Scale.get("C major").notes
# => ["C", "D", "E", "F", "G", "A", "B"]

# With specific octave
Harmony.Scale.get("C5 major pentatonic").notes
# => ["C5", "D5", "E5", "G5", "A5"]
```

## Scale Chroma

Each scale has a chroma representation (12-bit binary string representing pitch classes):

```elixir
Harmony.Scale.get("major").chroma
# => "101011010101"
# This represents: C, D, E, F, G, A, B (1s at positions 0,2,4,5,7,9,11)

# You can query scales by chroma
Harmony.Scale.get("101011010101")
# => %Scale{name: "major", ...}
```

## Empty Scales

Invalid scale names return an empty scale:

```elixir
Harmony.Scale.get("invalid")  # => %Scale{empty: true, ...}
Harmony.Scale.get("")         # => %Scale{empty: true, ...}
```
