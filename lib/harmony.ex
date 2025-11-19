defmodule Harmony do
  @moduledoc """
  A comprehensive music theory library for Elixir.

  Harmony is an Elixir port of the popular [tonal.js](https://github.com/tonaljs/tonal) library,
  providing a complete set of tools for working with musical concepts including notes, intervals,
  chords, scales, and transposition.

  ## Features

  - **Notes & Pitch Classes** - Work with musical notes, MIDI numbers, frequencies
  - **Intervals** - Calculate and manipulate musical intervals
  - **Chords** - Chord recognition, generation, and analysis
  - **Scales** - Scale generation, modes, and compatibility
  - **Transposition** - Transpose notes and musical structures
  - **Roman Numerals** - Functional harmony analysis

  ## Quick Examples

      # Working with notes
      note = Harmony.Note.get("C4")
      note.midi    # => 60
      note.freq    # => 261.63

      # Working with intervals
      Harmony.Interval.distance("C", "G")   # => "5P"

      # Transposition
      Harmony.Transpose.transpose("C4", "5P")   # => "G4"

      # Working with chords
      chord = Harmony.Chord.get("Cmaj7")
      chord.notes   # => ["C", "E", "G", "B"]

      # Working with scales
      scale = Harmony.Scale.get("C major")
      scale.notes   # => ["C", "D", "E", "F", "G", "A", "B"]

  ## Design Philosophy

  Harmony is built with functional programming in mind:

  - **Immutable Data** - All operations return new values
  - **Compile-Time Generation** - Notes and intervals generated at compile time for performance
  - **Pattern Matching** - Clean, idiomatic Elixir code
  - **Composability** - Functions designed to work well with `Enum` and `Stream`

  See the module documentation for detailed usage information.
  """
end
