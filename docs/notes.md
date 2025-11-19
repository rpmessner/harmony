# Notes

The `Harmony.Note` module provides comprehensive functionality for working with musical notes.

## Overview

Notes are represented by the `%Harmony.Note{}` struct and include properties like pitch class, octave, MIDI number, frequency, and more.

## Basic Usage

### Getting a Note

```elixir
# Get a note by name
note = Harmony.Note.get("C4")
# => %Harmony.Note{
#   name: "C4",
#   pc: "C",
#   oct: 4,
#   midi: 60,
#   freq: 261.63,
#   chroma: 0,
#   height: 60,
#   ...
# }

# Case insensitive
Harmony.Note.get("c4") # same as above
Harmony.Note.get(:C4)  # also works with atoms
```

### Note Properties

Access note properties directly or using convenience functions:

```elixir
note = Harmony.Note.get("Db4")

# Direct access
note.name      # => "Db4"
note.pc        # => "Db" (pitch class)
note.oct       # => 4
note.midi      # => 61
note.freq      # => 277.18
note.chroma    # => 1 (0-11, C=0)
note.height    # => 61
note.letter    # => "D"
note.acc       # => "b"
note.alt       # => -1 (alteration: sharps=positive, flats=negative)

# Using convenience functions
Harmony.Note.name("Db4")         # => "Db4"
Harmony.Note.pitch_class("Db4")  # => "Db"
Harmony.Note.octave("Db4")       # => 4
Harmony.Note.chroma("Db4")       # => 1
Harmony.Note.midi("Db4")         # => 61
Harmony.Note.freq("Db4")         # => 277.18
```

## Creating Notes

### From MIDI Numbers

```elixir
# Flat preference (default)
Harmony.Note.from_midi(60)  # => %Note{name: "C4", ...}
Harmony.Note.from_midi(61)  # => %Note{name: "Db4", ...}

# Sharp preference
Harmony.Note.from_midi_sharp(61)  # => %Note{name: "C#4", ...}
```

### From Frequencies

```elixir
# A4 = 440 Hz
Harmony.Note.from_freq(440.0)  # => %Note{name: "A4", ...}

# Sharp preference
Harmony.Note.from_freq_sharp(466.16)  # => %Note{name: "A#4", ...}
```

### From Coordinates

Notes can be created from pitch coordinates (fifth circle representation):

```elixir
# [fifths, octaves]
Harmony.Note.from_coord([0, 4])   # => %Note{name: "C4", ...}
Harmony.Note.from_coord([1, 4])   # => %Note{name: "G4", ...}
Harmony.Note.from_coord([-1, 4])  # => %Note{name: "F4", ...}
```

## Note Operations

### Simplifying Notes

Converts notes with multiple accidentals to their simpler enharmonic equivalents:

```elixir
Harmony.Note.simplify("C##")    # => "D"
Harmony.Note.simplify("C###")   # => "D#"
Harmony.Note.simplify("B#4")    # => "C5"
Harmony.Note.simplify("Cbb4")   # => "Bb3"
Harmony.Note.simplify("Gbbb5")  # => "E5"
```

### Enharmonic Equivalents

Find enharmonic equivalents (same pitch, different spelling):

```elixir
# Simple enharmonic swap
Harmony.Note.enharmonic("C#4")  # => "Db4"
Harmony.Note.enharmonic("Db4")  # => "C#4"

# Specific target enharmonic
Harmony.Note.enharmonic("C#4", "Db")  # => "Db4"
Harmony.Note.enharmonic("C#", "Db")   # => "Db" (pitch classes)
```

## Working with Note Collections

### Getting Note Names

```elixir
# Get names from a list of note-like values
notes = ["C4", "E4", "G4"]
Harmony.Note.names(notes)  # => ["C4", "E4", "G4"]

# Built-in note names (natural notes)
Harmony.Note.names()  # => ["C", "D", "E", "F", "G", "A", "B"]
```

### Sorting Notes

```elixir
notes = ["G4", "C4", "E4"]

# Sort by height (ascending)
Harmony.Note.sorted_names(notes)  # => ["C4", "E4", "G4"]

# Sort descending
Harmony.Note.sorted_names(notes, :desc)  # => ["G4", "E4", "C4"]

# Sorted and unique
Harmony.Note.sorted_uniq_names(["C4", "E4", "C4", "G4"])  # => ["C4", "E4", "G4"]
```

## Advanced: Note Tokenization

Break down a note string into its components:

```elixir
Harmony.Note.tokenize("Db4")  # => ["D", "b", "4", ""]
Harmony.Note.tokenize("C##")  # => ["C", "##", "", ""]
Harmony.Note.tokenize("A-1")  # => ["A", "", "-1", ""]
```

## Note Ranges

Notes support a wide range of octaves from -1 to 10:

```elixir
Harmony.Note.get("C-1")  # => Lowest C (MIDI 0)
Harmony.Note.get("C0")   # => %Note{midi: 12, ...}
Harmony.Note.get("C4")   # => Middle C (MIDI 60)
Harmony.Note.get("C10")  # => %Note{midi: 132, ...}
```

## Accidentals

Supported accidentals (up to triple):

- Flats: `b`, `bb`, `bbb`
- Sharps: `#`, `##`, `###`
- Double sharp: `x` (equivalent to `##`)

```elixir
Harmony.Note.get("C###4")  # => %Note{name: "C###4", alt: 3, ...}
Harmony.Note.get("Dbbb4")  # => %Note{name: "Dbbb4", alt: -3, ...}
Harmony.Note.get("Cx4")    # => %Note{name: "C##4", alt: 2, ...} # normalized
```

## Empty Notes

Invalid note strings return an empty note:

```elixir
Harmony.Note.get("invalid")  # => %Note{empty: true, name: "", ...}
Harmony.Note.get("")         # => %Note{empty: true, ...}
```
