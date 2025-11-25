# Jazz Harmony Module - Development Roadmap

**Status**: Planning Phase
**Target Module**: `Harmony.Jazz`
**Purpose**: Add jazz harmony transformations, voice leading, and reharmonization to the Harmony library

---

## Overview

The Jazz module will extend the Harmony library with advanced jazz harmony techniques: chord substitutions, voice leading, bebop scales, and reharmonization patterns. All functions will be pure, stateless transformations that work with the existing `Harmony.Chord`, `Harmony.Scale`, and `Harmony.Key` modules.

**Note**: The existing `Harmony.Key` module already includes secondary dominants and substitute dominants, providing an excellent foundation for jazz harmony work.

---

## Design Principles

1. **Pure Functional** - All functions are stateless transformations
2. **Composable** - Work with pipe operator and existing Harmony modules
3. **Polymorphic** - Accept strings or structs, return same format
4. **Musical Correctness** - Preserve voice leading and enharmonic spelling
5. **Well-Documented** - Include music theory explanations and examples

---

## Module Structure

```
lib/harmony/jazz/
├── jazz.ex                    # Namespace module
├── substitutions.ex           # Phase 1: Tritone subs, secondary dominants
├── modal_interchange.ex       # Phase 2: Borrowed chords
├── voice_leading.ex           # Phase 3: Chromatic approaches, guide tones
├── bebop.ex                   # Phase 4: Bebop scales and line generation
└── reharmonization.ex         # Phase 5: Coltrane/Parker changes, turnarounds
```

---

## Phase 1: Chord Substitutions (Est. 6-7 hours)

**Goal**: Core jazz substitution techniques

### 1.1 Tritone Substitution
- [ ] `tritone_substitute/2` - Replace V7 with bII7
- [ ] Detect dominant 7th chords
- [ ] Transpose by tritone (6 semitones)
- [ ] Preserve chord extensions (9th, 11th, 13th)
- [ ] Tests with ii-V-I progressions

### 1.2 Secondary Dominants (Already in Harmony.Key!)
- [ ] `secondary_dominant/2` - Wrap existing `Harmony.Key.secondary_dominants`
- [ ] Support major and minor keys
- [ ] Generate V7/x for scale degrees 2-6
- [ ] Tests for all scale degrees

### 1.3 Diminished Passing Chords
- [ ] `diminished_passing/2` - Default (halfway between chords)
- [ ] `diminished_passing/3` - Custom position
- [ ] Calculate chromatic passing note
- [ ] Build dim7 chord at passing note
- [ ] Tests for various intervals

### 1.4 Related Dominants (Substitute Dominants)
- [ ] `related_dominant/2` - Wrap existing `Harmony.Key.substitute_dominants`
- [ ] Or compose: secondary dominant + tritone sub
- [ ] Tests for subV7/x chords

**Milestone**: Can apply standard jazz substitutions to chord progressions

---

## Phase 2: Modal Interchange (Est. 4-5 hours)

**Goal**: Borrowed chords and modal mixture

### 2.1 Modal Borrowing
- [ ] `borrow_from/3` - Borrow chords from parallel modes
- [ ] Support major → minor (most common: bVI, bVII, iv)
- [ ] Support minor → major
- [ ] Use `Harmony.Scale` for modal analysis
- [ ] Tests for common borrowings

### 2.2 Modal Substitution
- [ ] `modal_substitute/2` - Replace with modal equivalent
- [ ] Maintain harmonic function
- [ ] Tests for Dorian/Mixolydian substitutions

### 2.3 Negroponte (Parallel Major/Minor)
- [ ] `negroponte/1` - Mix major and minor in same progression
- [ ] Generate parallel chord options
- [ ] Tests for C/Cm mixture

**Milestone**: Can borrow chords from parallel modes

---

## Phase 3: Voice Leading (Est. 5-6 hours)

**Goal**: Chromatic voice leading and smooth motion

### 3.1 Chromatic Approaches
- [ ] `chromatic_approach/2` - Half-step approach to target
- [ ] Support ascending and descending
- [ ] Calculate approach note (±1 semitone)
- [ ] Tests for various target notes

### 3.2 Enclosures
- [ ] `enclosure/2` - Surround target from above/below
- [ ] Support diatonic and chromatic enclosures
- [ ] Common patterns: D4-F4-E4, F4-D4-E4
- [ ] Tests for bebop enclosure patterns

### 3.3 Passing Tones
- [ ] `passing_seventh/1` - Add 7th as passing tone
- [ ] Calculate chromatic passing between chord tones
- [ ] Tests for scalar and chromatic passing

### 3.4 Guide Tone Lines
- [ ] `guide_tones/1` - Extract 3rd and 7th from progression
- [ ] Calculate smooth voice leading (minimal motion)
- [ ] Tests for ii-V-I voice leading

**Milestone**: Can generate chromatic voice leading

---

## Phase 4: Bebop Scales & Lines (Est. 6-7 hours)

**Goal**: Bebop scale generation and melodic line creation

### 4.1 Bebop Scales
- [ ] `bebop_scale/2` - Generate bebop scales
- [ ] Major bebop (chromatic between 5-6)
- [ ] Dominant bebop (chromatic between b7-R)
- [ ] Minor bebop (chromatic between 3-4)
- [ ] Dorian bebop (chromatic between 3-4)
- [ ] Tests for all bebop scale types

### 4.2 Bebop Line Generation
- [ ] `bebop_line/2` - Generate melodic line over progression
- [ ] Use bebop scales for chord/scale matching
- [ ] Add chromatic approaches and enclosures
- [ ] Control density (0.0 to 1.0)
- [ ] Tests for ii-V-I bebop lines

### 4.3 Bebop Patterns
- [ ] Common bebop licks and patterns
- [ ] Pattern transposition
- [ ] Pattern variations

**Milestone**: Can generate bebop solos over chord progressions

---

## Phase 5: Advanced Reharmonization (Est. 6-7 hours)

**Goal**: Complex reharmonization techniques

### 5.1 Coltrane Changes
- [ ] `coltrane_changes/1` - Coltrane substitution patterns
- [ ] Major third cycles
- [ ] ii-V chains
- [ ] Tests for "Giant Steps" patterns

### 5.2 Parker Changes
- [ ] `parker_changes/1` - Parker blues substitutions
- [ ] Blues with passing chords
- [ ] Chromatic approaches
- [ ] Tests for bebop blues

### 5.3 Turnarounds
- [ ] `turnaround/2` - Common turnarounds
- [ ] I-vi-ii-V (diatonic)
- [ ] I-VI-ii-V (with secondary dominant)
- [ ] I-bVI-ii-V (with tritone sub)
- [ ] I-#Idim-ii-V (with passing chord)
- [ ] Tests for all turnaround types

### 5.4 Contrafact Generation
- [ ] `contrafact/2` - Generate new chord changes over melody
- [ ] Analyze melody notes
- [ ] Generate compatible chord progression
- [ ] Tests with standard melodies

**Milestone**: Can apply advanced reharmonization techniques

---

## Phase 6: Extended Harmony (Est. 4-5 hours)

**Goal**: Modern jazz harmony extensions

### 6.1 Chord Extensions
- [ ] `add_extension/2` - Add 9th, 11th, 13th
- [ ] `alter_dominant/2` - Altered dominants (b9, #9, #11, b13)
- [ ] `upper_structure/2` - Upper structure triads
- [ ] `polychord/2` - Polychords (C/Bb)
- [ ] Tests for extended chords

### 6.2 Quartal/Quintal Harmony
- [ ] `quartal_voicing/1` - Stack in 4ths (McCoy Tyner)
- [ ] `quintal_voicing/1` - Stack in 5ths
- [ ] `cluster_chord/2` - Tone clusters
- [ ] Tests for modern jazz voicings

### 6.3 Negative Harmony
- [ ] `negative_harmony/2` - Apply negative harmony transformation
- [ ] `axis/1` - Set axis point
- [ ] `reflect_chord/2` - Reflect across axis
- [ ] Tests for negative harmony examples

**Milestone**: Complete jazz harmony toolkit

---

## Testing Strategy

### Unit Tests
- Each function: 5-10 tests
- Edge cases: empty progressions, invalid chords, out of bounds
- Multiple keys: C, F, G, D, Bb, Eb
- Both string and struct inputs

### Integration Tests
- Real jazz progressions (ii-V-I, rhythm changes, blues)
- Chained transformations
- Musical correctness validation

### Documentation Tests
- All @doc examples as doctests
- Verify examples produce correct output

**Total Test Goal**: 200+ tests across all modules

---

## Usage Examples

### Tritone Substitution
```elixir
progression = ["Dm7", "G7", "Cmaj7"]
Harmony.Jazz.Substitutions.tritone_substitute(progression, 1)
# => ["Dm7", "Db7", "Cmaj7"]
```

### Secondary Dominants
```elixir
Harmony.Jazz.Substitutions.secondary_dominant("C", 5)
# => "D7" (V7/V)

progression = ["Dm7", "D7", "G7", "Cmaj7"]  # ii - V7/V - V - I
```

### Diminished Passing
```elixir
Harmony.Jazz.Substitutions.diminished_passing("Cmaj7", "Dm7")
# => "C#dim7"

progression = ["Cmaj7", "C#dim7", "Dm7", "G7"]
```

### Bebop Line Generation
```elixir
progression = ["Dm7", "G7", "Cmaj7"]
Harmony.Jazz.Bebop.bebop_line(progression, density: 0.8, range: {"C4", "C5"})
# => [list of notes forming bebop solo over progression]
```

### Coltrane Changes
```elixir
simple = ["Cmaj7", "Ebmaj7", "Cmaj7"]
Harmony.Jazz.Reharmonization.coltrane_changes(simple)
# => ["Cmaj7", "Eb7", "Abmaj7", "B7", "Emaj7", "G7", "Cmaj7"]
```

---

## Integration with Existing Harmony Modules

### Leveraging Existing Features

**Harmony.Key** - Already has:
- `secondary_dominants` - Array of V7/x chords
- `substitute_dominants` - Array of subV7/x chords
- Perfect foundation for jazz substitutions!

**Harmony.Chord** - Use for:
- Chord parsing and analysis
- Transposition
- Compatible scale finding

**Harmony.Scale** - Use for:
- Modal analysis (for modal interchange)
- Bebop scale construction (add chromatic passing)
- Chord/scale matching

**Harmony.Transpose** - Use for:
- All interval-based operations
- Circle of fifths navigation

**Harmony.Interval** - Use for:
- Calculating distances between notes
- Building chords from intervals

---

## API Design Principles

### Function Signatures

**Substitutions**:
```elixir
@spec tritone_substitute(list(String.t() | Chord.t()), non_neg_integer()) ::
        list(String.t() | Chord.t())
@spec secondary_dominant(String.t(), 1..7) :: String.t() | nil
@spec diminished_passing(Chord.t(), Chord.t(), float()) :: Chord.t()
```

**Modal Interchange**:
```elixir
@spec borrow_from(String.t(), String.t(), non_neg_integer()) :: String.t()
@spec modal_substitute(String.t(), String.t()) :: String.t()
```

**Voice Leading**:
```elixir
@spec chromatic_approach(String.t(), :ascending | :descending) :: String.t()
@spec guide_tones(list(Chord.t())) :: list({String.t(), String.t()})
```

**Bebop**:
```elixir
@spec bebop_scale(String.t(), atom()) :: list(String.t())
@spec bebop_line(list(Chord.t()), keyword()) :: list(String.t())
```

### Polymorphic Input/Output

Functions should accept:
- Strings: `"Cmaj7"`, `"G7"`
- Chord structs: `%Harmony.Chord{}`

And return the same format:
```elixir
# String in, string out
tritone_substitute(["Dm7", "G7", "Cmaj7"], 1)
# => ["Dm7", "Db7", "Cmaj7"]

# Struct in, struct out
chords = Enum.map(["Dm7", "G7", "Cmaj7"], &Harmony.Chord.get/1)
tritone_substitute(chords, 1)
# => [%Chord{symbol: "Dm7"}, %Chord{symbol: "Db7"}, %Chord{symbol: "Cmaj7"}]
```

---

## Documentation Requirements

### Module Documentation
- Explanation of jazz harmony concepts
- Music theory background
- Voice leading principles
- References to jazz musicians/theorists

### Function Documentation
- Clear description
- Parameters with types
- Return values
- Musical examples
- Voice leading diagrams (in comments)
- References to jazz standards

### Guides (in /docs)
- [ ] `docs/jazz-harmony.md` - Overview and getting started
- [ ] `docs/substitutions.md` - Chord substitution techniques
- [ ] `docs/voice-leading.md` - Voice leading and chromatic approaches
- [ ] `docs/bebop.md` - Bebop scales and line generation
- [ ] `docs/reharmonization.md` - Advanced reharmonization

---

## Success Criteria

### Functional
- ✅ All jazz substitution techniques implemented
- ✅ Voice leading algorithms work correctly
- ✅ Bebop line generation produces musical results
- ✅ Reharmonization preserves melody compatibility

### Code Quality
- ✅ 200+ tests, all passing
- ✅ Comprehensive documentation
- ✅ No compiler warnings
- ✅ Dialyzer passes
- ✅ All functions have typespecs

### Musical Correctness
- ✅ Tritone subs share tritone interval
- ✅ Voice leading is smooth (minimal motion)
- ✅ Bebop lines sound idiomatic
- ✅ Reharmonizations preserve harmonic function
- ✅ Enharmonic spelling is contextually appropriate

---

## Dependencies

**Internal** (Harmony library modules):
- `Harmony.Chord` - Chord operations
- `Harmony.Scale` - Scale operations
- `Harmony.Key` - Key signatures, secondary/substitute dominants
- `Harmony.Transpose` - Transposition
- `Harmony.Interval` - Interval calculations
- `Harmony.Note` - Note operations

**External**:
- None! Pure Elixir, no external dependencies

---

## Deployment

### Version Planning
- **v0.2.0** - Add `Harmony.Jazz.Substitutions` (Phase 1)
- **v0.3.0** - Add `Harmony.Jazz.ModalInterchange` (Phase 2)
- **v0.4.0** - Add `Harmony.Jazz.VoiceLeading` (Phase 3)
- **v0.5.0** - Add `Harmony.Jazz.Bebop` (Phase 4)
- **v0.6.0** - Add `Harmony.Jazz.Reharmonization` (Phase 5)
- **v0.7.0** - Add extended harmony features (Phase 6)

### Breaking Changes
- None expected (pure additions to existing library)
- All new functionality in `Harmony.Jazz` namespace

---

## Future Extensions (Post-v1.0)

- **Harmony.Jazz.Analysis** - Analyze existing chord progressions
- **Harmony.Jazz.Voicings** - Generate chord voicings (drop-2, drop-3, etc.)
- **Harmony.Jazz.Comping** - Generate comping patterns
- **Harmony.Jazz.Walking** - Generate walking bass lines
- **Harmony.Jazz.Standards** - Library of common jazz standards

---

## References & Resources

### Books
- Mark Levine - "The Jazz Theory Book"
- Jerry Coker - "The Jazz Keyboard Book"
- Bert Ligon - "Jazz Theory Resources"
- George Russell - "Lydian Chromatic Concept"

### Musicians (Concept Origins)
- Charlie Parker - Bebop, blues substitutions
- John Coltrane - Coltrane changes, advanced harmony
- Bill Evans - Reharmonization, modal interchange
- McCoy Tyner - Quartal harmony
- Herbie Hancock - Modern voicings

### Online Resources
- Jazz Standards website
- iRealPro chord charts
- OpenMusicTheory.com

---

**Total Estimated Time**: 32-37 hours (human time), ~12-15 hours (Claude time)

**Status**: Ready for implementation once approved

---

_This roadmap is a living document. Update as implementation progresses._
