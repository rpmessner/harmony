# Harmony - Context for Claude

This document provides context about the Harmony library for Claude Code to understand the codebase structure, design patterns, and key concepts.

## Project Overview

Harmony is an Elixir port of the tonal.js JavaScript library. It provides comprehensive music theory functionality including notes, intervals, chords, scales, transposition, and Roman numeral analysis.

**Key Philosophy:**
- Pure functional programming
- Immutable data structures
- Compile-time code generation using macros for performance
- Pattern matching for clean API
- No runtime errors - invalid input returns "empty" structs

## Codebase Structure

```
lib/harmony/
├── application.ex           # OTP application
├── chord/
│   ├── data.ex             # Chord type definitions (compile-time data)
│   └── name.ex             # Chord name resolution
├── scale/
│   ├── data.ex             # Scale type definitions (compile-time data)
│   └── name.ex             # Scale name resolution
├── pitch/
│   └── class_set.ex        # Pitch class set operations
├── note.ex                 # Note representation and operations
├── chord.ex                # Chord recognition and generation
├── scale.ex                # Scale generation and analysis
├── interval.ex             # Interval calculations
├── transpose.ex            # Transposition operations
├── pitch.ex                # Low-level pitch coordinate system
├── roman_numeral.ex        # Roman numeral analysis
├── key.ex                  # Key signatures
├── collection.ex           # Collection utilities
└── util.ex                 # Utility functions

test/harmony/               # Mirror structure for tests
```

## Key Design Patterns

### 1. Compile-Time Macro Generation

Both `Harmony.Note` and `Harmony.Interval` use macros to generate all possible values at compile time:

```elixir
# In note.ex
defmodule Harmony.Note.Macros do
  @notes # All possible note combinations

  defmacro note_defs() do
    # Generates get/1 functions for every possible note
    # at compile time
  end
end

require Macros
Macros.note_defs()  # Expands to thousands of function clauses
```

**Why:** Zero runtime overhead for note/interval lookups. O(1) pattern matching.

### 2. Coordinate System (Pitch Class)

The library uses a "fifths and octaves" coordinate system internally:

```elixir
# C is [0, 4] - 0 fifths from F, octave 4
# G is [1, 4] - 1 fifth from F, octave 4
# F is [-1, 4] - -1 fifth from F, octave 4
```

This makes transposition and interval calculations mathematical operations on coordinates.

### 3. Empty Struct Pattern

Instead of raising errors, the library returns "empty" structs for invalid input:

```elixir
defstruct(
  empty: true,
  name: "",
  # ... other fields
)

def get(""), do: %Note{} # empty: true
def get(invalid), do: %Note{} # empty: true
```

**Why:** Allows pipeline-safe operations without error handling.

### 4. Two-Argument Get Functions

Most modules follow this pattern:

```elixir
# Just the type
Chord.get("maj7")  # => %Chord{name: "major seventh", notes: [], ...}

# Type with tonic
Chord.get("Cmaj7")  # => %Chord{name: "C major seventh", notes: ["C", "E", "G", "B"], ...}

# Or explicit two-argument form
Chord.get("maj7", "C")  # Same as above
```

### 5. Partial Application Pattern

Functions that return functions for partial application:

```elixir
# Returns a function
transpose_by("5P") # => fn note -> ... end

# Usage
["C", "D", "E"] |> Enum.map(transpose_by("5P"))
```

## Module Responsibilities

### Harmony.Note
- Note representation with all properties (MIDI, frequency, chroma, etc.)
- Creating notes from strings, MIDI numbers, frequencies
- Enharmonic equivalents
- Note simplification

### Harmony.Interval
- Interval representation (number + quality)
- Distance calculations between notes
- Interval inversion, addition, subtraction
- Creating intervals from semitones

### Harmony.Transpose
- Transposing notes by intervals
- Transposing by circle of fifths
- Partial application for transposition

### Harmony.Chord
- Chord recognition from symbols
- Generating chord notes from type + tonic
- Slash chords (inversions)
- Finding compatible scales
- Chord extensions and reductions

### Harmony.Scale
- Scale generation from type + tonic
- Mode calculations
- Finding compatible chords
- Scale ranges with proper enharmonics

### Harmony.Pitch
- Low-level pitch coordinate system
- Encoding/decoding between note names and coordinates
- MIDI/chroma calculations

### Harmony.RomanNumeral
- Roman numeral parsing
- Conversion to intervals
- Major/minor detection

## Important Concepts

### Chroma
A 12-bit binary string representing which pitch classes are present:
```elixir
"101011010101" # Major scale: C D E F G A B
# Positions:     C C# D D# E F F# G G# A A# B
```

### Pitch Class vs Note with Octave
- Pitch class: "C", "Db", "F#" (no octave)
- Note with octave: "C4", "Db5", "F#3"

Most functions work with both.

### Alteration (alt)
Represents sharps/flats as integers:
- `alt: 0` - Natural
- `alt: 1` - Sharp (#)
- `alt: 2` - Double sharp (##)
- `alt: -1` - Flat (b)
- `alt: -2` - Double flat (bb)

### Interval Types
- **Perfectable**: 1, 4, 5, 8 (Perfect, Augmented, Diminished)
- **Majorable**: 2, 3, 6, 7 (Major, Minor, Augmented, Diminished)

## Data Files

### Chord.Data and Scale.Data
These modules contain compile-time data structures with all chord/scale definitions:

```elixir
# Chord definitions include:
# - aliases (symbols)
# - intervals
# - chroma
# - quality
# - set_num

# Scale definitions include similar properties
```

## Common Patterns in Tests

Tests provide excellent examples of usage:

```elixir
# Getting entities
note = Note.get("C4")
chord = Chord.get("Cmaj7")
scale = Scale.get("C major")

# Tokenization
Chord.tokenize("Cmaj7") # => ["C", "maj7"]
Scale.tokenize("C major") # => ["C", "major"]

# Properties
note.midi  # Direct access
Note.midi("C4")  # Via function

# Transformations
Note.simplify("B#4")  # => "C5"
Interval.invert("3M")  # => "6m"
Transpose.transpose("C4", "5P")  # => "G4"
```

## Working with the Codebase

### Adding New Chord Types
1. Add to `Chord.Data.all()` list
2. Include intervals, aliases, chroma
3. Tests will automatically pick it up

### Adding New Scale Types
1. Add to `Scale.Data.all()` list
2. Include intervals, aliases, chroma
3. Tests will automatically pick it up

### Debugging Coordinates
The coordinate system can be confusing. Use:
```elixir
Pitch.encode(pitch)  # Convert pitch to coordinates
Pitch.decode(coords)  # Convert coordinates to pitch
```

### Understanding Tokenization
Tokenization splits input into components:
- Notes: letter, accidental, octave, extra
- Chords: tonic, type
- Scales: tonic, type

## Performance Considerations

1. **Compile-time generation**: Notes and intervals are pre-computed
2. **Pattern matching**: All `get` functions use pattern matching on pre-computed clauses
3. **No dynamic computation**: Most calculations happen at compile time
4. **Immutable**: All data structures are immutable (no copying overhead in BEAM)

## Testing Strategy

- Unit tests for each module
- Property-based testing for mathematical properties (e.g., interval addition)
- Comparison tests against expected results from tonal.js
- Tests serve as documentation

## Common Gotchas

1. **Octave wrapping**: Notes like "G4" transposed up a fifth become "D5", not "D4"
2. **Empty structs**: Always check `empty: true` field for invalid results
3. **Enharmonic context**: Transposition maintains enharmonic spelling (F# → C#, not Db)
4. **Tokenization edge cases**: "C4" is a note, but "C64" is a chord type
5. **Roman numerals**: Must use proper case (I vs i for major vs minor)

## Future Enhancement Ideas

- Add Key.transpose for key signature transposition
- Voice leading algorithms
- Chord voicing generation
- Scale fingering patterns
- More exotic scales and chords
- Integration with MIDI libraries

## Related Resources

- [tonal.js documentation](https://github.com/tonaljs/tonal)
- [Music theory primer](https://www.musictheory.net)
- Test files in `test/harmony/` for usage examples
