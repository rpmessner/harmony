# CLAUDE.md - Harmony

## Project Overview

**harmony** is a comprehensive music theory library for Elixir. Port of tonal.js with compile-time code generation for performance.

**Purpose:** Work with notes, intervals, chords, scales, and transposition.

**Version:** 0.1.2

**Status:** Stable - core theory complete

## Key Modules

| Module | Purpose |
|--------|---------|
| `Harmony.Note` | Note parsing, MIDI conversion |
| `Harmony.Interval` | Interval representation and math |
| `Harmony.Chord` | Chord detection and construction |
| `Harmony.Scale` | Scale types and note generation |
| `Harmony.Transpose` | Transposition operations |
| `Harmony.Key` | Key signatures |
| `Harmony.RomanNumeral` | Roman numeral analysis |
| `Harmony.Pitch` | Pitch class sets |

## Quick Reference

```elixir
# Notes
Harmony.Note.midi("C4")        # => 60
Harmony.Note.freq("A4")        # => 440.0
Harmony.Note.transpose("C4", "P5")  # => "G4"

# Intervals
Harmony.Interval.semitones("P5")   # => 7
Harmony.Interval.add("M3", "m3")   # => "P5"

# Chords
Harmony.Chord.get("Cmaj7")
# => %{name: "Cmaj7", notes: ["C", "E", "G", "B"], ...}

Harmony.Chord.detect(["C", "E", "G"])
# => ["C", "Cmaj", ...]

# Scales
Harmony.Scale.get("C major")
# => %{name: "C major", notes: ["C", "D", "E", "F", "G", "A", "B"], ...}

Harmony.Scale.names()  # All scale types

# Transposition
Harmony.Transpose.transpose("C4", "M3")  # => "E4"
Harmony.Transpose.transpose_by(["C", "E", "G"], "P5")  # => ["G", "B", "D"]
```

## Commands

```bash
mix test          # Run tests
mix compile       # Compile
mix dialyzer      # Type checking
```

## Dependencies

None (zero runtime dependencies)

## Integration

harmony is used by:
- `undertow_server` - Harmonic interpretation for jazz patterns

## Design Notes

- Compile-time code generation for performance
- Zero runtime dependencies
- 85%+ test coverage
- Based on tonal.js conventions

## Related Projects

- **undertow_server** - Uses Harmony for scale/chord resolution
- **uzu_parser** - Pattern parsing (separate concern)
- **waveform** - Audio output (separate concern)
