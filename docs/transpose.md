# Transposition

The `Harmony.Transpose` module provides functionality for transposing notes and intervals.

## Overview

Transposition moves a note up or down by a specified interval, maintaining the proper enharmonic spelling.

## Basic Usage

### Transposing Notes

```elixir
# Transpose note by interval
Harmony.Transpose.transpose("C4", "5P")   # => "G4"
Harmony.Transpose.transpose("D", "3M")    # => "F#"
Harmony.Transpose.transpose("E4", "-2M")  # => "D4"

# Works with flats and sharps
Harmony.Transpose.transpose("Bb", "5P")   # => "F"
Harmony.Transpose.transpose("F#4", "4P")  # => "B4"
```

### Using Note and Interval Structs

```elixir
note = Harmony.Note.get("C4")
interval = Harmony.Interval.get("5P")

Harmony.Transpose.transpose(note, interval)  # => "G4"

# Works with any combination of strings and structs
Harmony.Transpose.transpose(note, "5P")      # => "G4"
Harmony.Transpose.transpose("C4", interval)  # => "G4"
```

## Transposition Patterns

### Ascending

```elixir
Harmony.Transpose.transpose("C", "2M")   # => "D"  (major second up)
Harmony.Transpose.transpose("C", "3M")   # => "E"  (major third up)
Harmony.Transpose.transpose("C", "4P")   # => "F"  (perfect fourth up)
Harmony.Transpose.transpose("C", "5P")   # => "G"  (perfect fifth up)
Harmony.Transpose.transpose("C", "8P")   # => "C"  (octave up)
```

### Descending

Use negative intervals for descending transposition:

```elixir
Harmony.Transpose.transpose("C", "-2M")  # => "Bb" (major second down)
Harmony.Transpose.transpose("C", "-3M")  # => "Ab" (major third down)
Harmony.Transpose.transpose("C", "-5P")  # => "F"  (perfect fifth down)
Harmony.Transpose.transpose("C4", "-8P") # => "C3" (octave down)
```

### Chromatic Transposition

```elixir
# Up by semitones
Harmony.Transpose.transpose("C", "2m")   # => "Db" (1 semitone)
Harmony.Transpose.transpose("C", "2M")   # => "D"  (2 semitones)
Harmony.Transpose.transpose("C", "2A")   # => "D#" (3 semitones)

# Down by semitones
Harmony.Transpose.transpose("C", "-2m")  # => "B"  (1 semitone down)
```

## Partial Application

Create transpose functions for repeated use:

### Transpose From a Note

Create a function that transposes from a specific note:

```elixir
# Create a transposer from C
from_c = Harmony.Transpose.transpose_from("C")

from_c.("5P")   # => "G"
from_c.("3M")   # => "E"
from_c.("4P")   # => "F"

# From a different note
from_d = Harmony.Transpose.transpose_from("D4")
from_d.("5P")   # => "A4"
from_d.("3M")   # => "F#4"
```

### Transpose By an Interval

Create a function that applies a specific interval:

```elixir
# Create a transposer that goes up a fifth
up_fifth = Harmony.Transpose.transpose_by("5P")

up_fifth.("C")   # => "G"
up_fifth.("D")   # => "A"
up_fifth.("E")   # => "B"

# Down a major third
down_third = Harmony.Transpose.transpose_by("-3M")
down_third.("C")  # => "Ab"
down_third.("E")  # => "C"
```

These partial application functions are useful in `Enum.map` and pipelines:

```elixir
# Transpose a chord
["C", "E", "G"]
|> Enum.map(Harmony.Transpose.transpose_by("2M"))
# => ["D", "F#", "A"]

# Create a scale degree transposer
to_dominant = Harmony.Transpose.transpose_by("5P")
["C", "F", "G"] |> Enum.map(to_dominant)
# => ["G", "C", "D"]
```

## Transposing by Fifths

A specialized function for transposing by fifths (circle of fifths):

```elixir
# Transpose up by fifths (positive numbers)
Harmony.Transpose.transpose_fifths("C", 1)   # => "G"  (1 fifth up)
Harmony.Transpose.transpose_fifths("C", 2)   # => "D"  (2 fifths up)
Harmony.Transpose.transpose_fifths("C4", 1)  # => "G4" (with octave)

# Transpose down by fifths (negative numbers)
Harmony.Transpose.transpose_fifths("C", -1)  # => "F"  (1 fifth down)
Harmony.Transpose.transpose_fifths("C", -2)  # => "Bb" (2 fifths down)

# Works with intervals too
Harmony.Transpose.transpose_fifths("5P", 1)   # => "2M"
Harmony.Transpose.transpose_fifths("3M", -1)  # => "6m"
```

## Enharmonic Spelling

Transposition maintains proper enharmonic spelling based on the interval:

```elixir
# Proper sharps and flats
Harmony.Transpose.transpose("C", "2M")   # => "D"  (not Ebb)
Harmony.Transpose.transpose("C", "2A")   # => "D#" (not Eb)
Harmony.Transpose.transpose("C", "3m")   # => "Eb" (not D#)

# Maintains context
Harmony.Transpose.transpose("F#", "5P")  # => "C#" (not Db)
Harmony.Transpose.transpose("Gb", "5P")  # => "Db" (not C#)
```

## Octave Handling

### With Pitch Classes

When transposing pitch classes (no octave), the result is also a pitch class:

```elixir
Harmony.Transpose.transpose("C", "5P")   # => "G"  (no octave)
Harmony.Transpose.transpose("D", "3M")   # => "F#" (no octave)
```

### With Specific Octaves

When transposing notes with octaves, octaves are preserved/adjusted:

```elixir
Harmony.Transpose.transpose("C4", "5P")   # => "G4"  (same octave)
Harmony.Transpose.transpose("G4", "5P")   # => "D5"  (wraps to next octave)
Harmony.Transpose.transpose("C4", "8P")   # => "C5"  (up one octave)
Harmony.Transpose.transpose("C4", "-8P")  # => "C3"  (down one octave)
```

### Large Intervals

```elixir
Harmony.Transpose.transpose("C4", "15P")  # => "C6"  (2 octaves)
Harmony.Transpose.transpose("C4", "9M")   # => "D5"  (octave + major second)
Harmony.Transpose.transpose("C4", "11P")  # => "F5"  (octave + perfect fourth)
```

## Empty Notes/Intervals

Transposing with empty notes or intervals returns an empty string:

```elixir
Harmony.Transpose.transpose("", "5P")        # => ""
Harmony.Transpose.transpose("C", "")         # => ""
Harmony.Transpose.transpose("invalid", "5P") # => ""
```

## Practical Examples

### Transposing Chords

```elixir
# Define a C major chord
c_major = ["C4", "E4", "G4"]

# Transpose to G major
transpose_to_g = Harmony.Transpose.transpose_by("5P")
c_major |> Enum.map(transpose_to_g)
# => ["G4", "B4", "D5"]

# Transpose to F major
transpose_to_f = Harmony.Transpose.transpose_by("4P")
c_major |> Enum.map(transpose_to_f)
# => ["F4", "A4", "C5"]
```

### Transposing Melodies

```elixir
melody = ["C4", "D4", "E4", "F4", "G4"]

# Up a major third
melody |> Enum.map(Harmony.Transpose.transpose_by("3M"))
# => ["E4", "F#4", "G#4", "A4", "B4"]

# Down a minor third
melody |> Enum.map(Harmony.Transpose.transpose_by("-3m"))
# => ["A3", "B3", "C#4", "D4", "E4"]
```

### Creating Scale Degrees

```elixir
tonic = "D"

# Generate scale degrees using transposition
subdominant = Harmony.Transpose.transpose(tonic, "4P")  # => "G"
dominant = Harmony.Transpose.transpose(tonic, "5P")     # => "A"
mediant = Harmony.Transpose.transpose(tonic, "3M")      # => "F#"
```

### Circle of Fifths

```elixir
# Generate the circle of fifths from C
tonic = "C"
0..11
|> Enum.map(&Harmony.Transpose.transpose_fifths(tonic, &1))
# => ["C", "G", "D", "A", "E", "B", "F#", "Db", "Ab", "Eb", "Bb", "F"]
```
