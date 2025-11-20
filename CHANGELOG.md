# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2] - 2025-01-19

### Fixed
- Corrected GitHub repository URL in package metadata (rpmessner/harmony)

## [0.1.1] - 2025-01-19

### Fixed
- Fixed Dialyzer type specifications for `Note.t()` to properly allow nil values for optional fields
- Fixed `Scale` nil checks to use empty field instead of height field
- Fixed Elixir 1.17 range syntax deprecation warnings

### Changed
- Configured test coverage to exclude macro modules (Harmony.Note.Macros, Harmony.Interval.Macros, etc.) and internal GenServer state modules from coverage reports

## [0.1.0] - 2025-01-19

### Added
- Initial release of Harmony music theory library
- `Harmony.Note` module for working with musical notes
  - Note creation from strings, MIDI numbers, and frequencies
  - Note simplification and enharmonic equivalents
  - Comprehensive note properties (MIDI, frequency, chroma, etc.)
- `Harmony.Interval` module for musical intervals
  - Interval creation and manipulation
  - Distance calculations between notes
  - Interval inversion, addition, and subtraction
- `Harmony.Transpose` module for transposition
  - Note transposition by intervals
  - Partial application support for functional composition
  - Circle of fifths transposition
- `Harmony.Chord` module for chord operations
  - Chord recognition from symbols
  - Chord note generation
  - Slash chord (inversion) support
  - Compatible scale finding
  - Chord extension and reduction analysis
- `Harmony.Scale` module for scale operations
  - Scale generation from types and tonics
  - Mode calculation
  - Compatible chord finding
  - Scale range generation with proper enharmonics
- `Harmony.RomanNumeral` module for functional harmony
- `Harmony.Pitch` module for low-level pitch coordinate system
- `Harmony.Key` module for key signatures
- Comprehensive documentation in `/docs` folder
- Full test suite with 129 tests
- Compile-time code generation for optimal performance

### Documentation
- Complete README with examples and quick start
- Detailed guides for all major modules
- API reference documentation
- Getting Started guide
- Claude Code context file for AI assistance

### Performance
- Zero runtime overhead for note/interval lookups through compile-time macro generation
- Constant-time (O(1)) access to note and interval properties
- Efficient pattern matching for all operations

## [Unreleased]

### Added
- Comprehensive `@spec` type annotations for all public API functions (61 specs total)
  - `Harmony.Note` - 16 function specs including get, from_midi, from_freq, enharmonic
  - `Harmony.Interval` - 13 function specs including get, distance, invert, add
  - `Harmony.Transpose` - 3 function specs for transpose operations
  - `Harmony.Chord` - 7 function specs including get, chord_scales, transpose
  - `Harmony.Scale` - 6 function specs including get, chords, modes
- Type definitions (`@type t`) for Interval, Chord, and Scale modules
- Macro performance benchmark script (`benchmark_macro_vs_runtime.exs`)
- Macro performance analysis documentation (`MACRO_ANALYSIS.md`)

### Documentation
- Detailed macro vs runtime performance analysis showing 242x speedup
- Benchmark results demonstrating compile-time generation benefits
- Trade-off analysis for macro-based architecture
- Recommendations for type system adoption strategy

### Fixed
- Dialyzer type checking errors (6 issues resolved):
  - Added RomanNumeral.t() type definition
  - Removed unreachable pattern in Interval.invert/1
  - Fixed Note.t() to allow nil for midi, freq, and oct fields
  - Fixed Scale nil checks to use empty field instead of height
- All Dialyzer checks now pass cleanly

### Improved
- Better IDE support through type annotations
- Enhanced Dialyzer type checking capabilities
- Improved API documentation through specs
- More accurate type definitions matching runtime behavior

### Future Enhancements
- Voice leading algorithms
- Chord voicing generation
- Scale fingering patterns
- More exotic scales and chords
- MIDI library integrations

[0.1.0]: https://github.com/ryanmessner/harmony/releases/tag/v0.1.0
