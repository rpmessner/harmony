# Intervals

The `Harmony.Interval` module provides functionality for working with musical intervals.

## Overview

Intervals represent the distance between two notes. They are represented by the `%Harmony.Interval{}` struct and are specified using a combination of a number (1-14+) and a quality (P, M, m, d, A).

## Interval Notation

Intervals consist of:
- **Number**: 1-7 for simple intervals, 8+ for compound intervals, negative for descending
- **Quality**:
  - `P` (Perfect) - for unison, 4th, 5th, octave
  - `M` (Major) - for 2nd, 3rd, 6th, 7th
  - `m` (minor) - for 2nd, 3rd, 6th, 7th
  - `A` (Augmented) - one semitone larger
  - `d` (diminished) - one semitone smaller
  - Multiple: `AA`, `AAA`, `dd`, `ddd`, etc.

## Basic Usage

### Getting an Interval

```elixir
# Perfect fifth
interval = Harmony.Interval.get("5P")
# => %Harmony.Interval{
#   name: "5P",
#   num: 5,
#   q: "P",
#   step: 4,
#   alt: 0,
#   semitones: 7,
#   type: "perfectable",
#   ...
# }

# Major third
Harmony.Interval.get("3M")
# => %Interval{name: "3M", num: 3, q: "M", semitones: 4, ...}

# Minor seventh
Harmony.Interval.get("7m")
# => %Interval{name: "7m", num: 7, q: "m", semitones: 10, ...}
```

### Interval Properties

```elixir
interval = Harmony.Interval.get("5P")

interval.name        # => "5P"
interval.num         # => 5
interval.q           # => "P" (quality)
interval.semitones   # => 7
interval.step        # => 4 (0-6, C=0)
interval.alt         # => 0 (alteration)
interval.type        # => "perfectable" (or "majorable")
interval.simple      # => 5 (simple interval number)
interval.simplified  # => "5P" (simplified interval)
interval.chroma      # => 7 (0-11)
interval.dir         # => 1 (direction: 1=ascending, -1=descending)
interval.oct         # => 0 (octave displacement)

# Using convenience functions
Harmony.Interval.name("5P")       # => "5P"
Harmony.Interval.num("5P")        # => 5
Harmony.Interval.quality("5P")    # => "P"
Harmony.Interval.semitones("5P")  # => 7
```

## Common Intervals

### Perfect Intervals

```elixir
Harmony.Interval.get("1P")   # Perfect unison - 0 semitones
Harmony.Interval.get("4P")   # Perfect fourth - 5 semitones
Harmony.Interval.get("5P")   # Perfect fifth - 7 semitones
Harmony.Interval.get("8P")   # Perfect octave - 12 semitones
```

### Major Intervals

```elixir
Harmony.Interval.get("2M")   # Major second - 2 semitones
Harmony.Interval.get("3M")   # Major third - 4 semitones
Harmony.Interval.get("6M")   # Major sixth - 9 semitones
Harmony.Interval.get("7M")   # Major seventh - 11 semitones
```

### Minor Intervals

```elixir
Harmony.Interval.get("2m")   # Minor second - 1 semitone
Harmony.Interval.get("3m")   # Minor third - 3 semitones
Harmony.Interval.get("6m")   # Minor sixth - 8 semitones
Harmony.Interval.get("7m")   # Minor seventh - 10 semitones
```

### Augmented & Diminished

```elixir
Harmony.Interval.get("4A")   # Augmented fourth - 6 semitones
Harmony.Interval.get("5d")   # Diminished fifth - 6 semitones
Harmony.Interval.get("7d")   # Diminished seventh - 9 semitones
```

### Compound Intervals

```elixir
Harmony.Interval.get("9M")   # Major ninth - 14 semitones
Harmony.Interval.get("11P")  # Perfect eleventh - 17 semitones
Harmony.Interval.get("13M")  # Major thirteenth - 21 semitones
```

### Descending Intervals

```elixir
Harmony.Interval.get("-5P")  # Descending perfect fifth - -7 semitones
Harmony.Interval.get("-3M")  # Descending major third - -4 semitones
```

## Calculating Intervals

### Distance Between Notes

Calculate the interval between two notes:

```elixir
# Ascending
Harmony.Interval.distance("C4", "G4")  # => "5P"
Harmony.Interval.distance("C", "E")    # => "3M"
Harmony.Interval.distance("D", "F")    # => "3m"

# Descending
Harmony.Interval.distance("G4", "C4")  # => "-5P"
Harmony.Interval.distance("E", "C")    # => "-3M"

# Works with Note structs too
note1 = Harmony.Note.get("C4")
note2 = Harmony.Note.get("G4")
Harmony.Interval.distance(note1, note2)  # => "5P"
```

## Interval Operations

### Inverting Intervals

Flip an interval around:

```elixir
Harmony.Interval.invert("3M")   # => "6m"
Harmony.Interval.invert("5P")   # => "5P"
Harmony.Interval.invert("7m")   # => "2M"
Harmony.Interval.invert("4P")   # => "5P"
```

### Simplifying Intervals

Reduce compound intervals to their simple form:

```elixir
Harmony.Interval.simplify("9M")   # => "2M"
Harmony.Interval.simplify("11P")  # => "4P"
Harmony.Interval.simplify("13M")  # => "6M"
Harmony.Interval.simplify("15P")  # => "8P" (octave)
```

Using the convenience function:

```elixir
Harmony.Interval.simple("9M")   # => 2
```

### Adding Intervals

Combine two intervals:

```elixir
Harmony.Interval.add("3M", "3m")  # => "5P"
Harmony.Interval.add("4P", "5P")  # => "8P"
Harmony.Interval.add("2M", "2M")  # => "3M"

# Partially apply for use in pipelines
add_fifth = Harmony.Interval.add_to("5P")
add_fifth.("3M")  # => "7M"
add_fifth.("4P")  # => "8P"
```

### Subtracting Intervals

Calculate the difference between intervals:

```elixir
Harmony.Interval.subtract("5P", "3M")   # => "3m"
Harmony.Interval.subtract("8P", "5P")   # => "4P"
Harmony.Interval.subtract("7M", "5P")   # => "3M"
```

## Creating Intervals

### From Semitones

Create an interval from a number of semitones:

```elixir
# Ascending
Harmony.Interval.from_semitones(7)    # => "5P"
Harmony.Interval.from_semitones(4)    # => "3M"
Harmony.Interval.from_semitones(12)   # => "8P"

# Descending
Harmony.Interval.from_semitones(-7)   # => "-5P"
Harmony.Interval.from_semitones(-4)   # => "-3M"

# Explicit direction
Harmony.Interval.from_semitones(7, 1)   # => "5P" (ascending)
Harmony.Interval.from_semitones(7, -1)  # => "-5P" (descending)
```

### From Coordinates

Create intervals from pitch coordinates:

```elixir
# [fifths]
Harmony.Interval.from_coord([1])      # => "5P"
Harmony.Interval.from_coord([2])      # => "2M"
Harmony.Interval.from_coord([-1])     # => "4P"

# [fifths, octaves]
Harmony.Interval.from_coord([1, 0])   # => "5P"
Harmony.Interval.from_coord([1, -1])  # => "-4P"
```

## Standard Interval Names

Get common interval names:

```elixir
Harmony.Interval.names()
# => ["1P", "2M", "3M", "4P", "5P", "6m", "7m"]
```

## Alternate Notation

Intervals can be specified with quality first or number first:

```elixir
Harmony.Interval.get("5P")   # Standard
Harmony.Interval.get("P5")   # Also works

Harmony.Interval.get("3M")   # Standard
Harmony.Interval.get("M3")   # Also works
```

## Interval Types

Intervals are classified into two types:

### Perfectable
Perfect intervals (unison, 4th, 5th, octave):
- Perfect (P)
- Augmented (A, AA, etc.)
- Diminished (d, dd, etc.)

```elixir
Harmony.Interval.get("5P").type   # => "perfectable"
Harmony.Interval.get("5A").type   # => "perfectable"
Harmony.Interval.get("5d").type   # => "perfectable"
```

### Majorable
Major/minor intervals (2nd, 3rd, 6th, 7th):
- Major (M)
- Minor (m)
- Augmented (A, AA, etc.)
- Diminished (d, dd, etc.)

```elixir
Harmony.Interval.get("3M").type   # => "majorable"
Harmony.Interval.get("3m").type   # => "majorable"
Harmony.Interval.get("3A").type   # => "majorable"
```

## Empty Intervals

Invalid interval strings return an empty interval:

```elixir
Harmony.Interval.get("invalid")  # => %Interval{empty: true, ...}
Harmony.Interval.get("")         # => %Interval{empty: true, ...}
```

## Use with Other Modules

Intervals integrate with other Harmony modules:

```elixir
# Get interval from Roman numeral
rn = Harmony.RomanNumeral.get("V")
Harmony.Interval.get(rn)  # => %Interval{name: "5P", ...}

# Get interval from pitch
pitch = %Harmony.Pitch{step: 4, alt: 0, oct: 0, dir: 1}
Harmony.Interval.get(pitch)  # => %Interval{name: "5P", ...}
```
