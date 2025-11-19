# Publishing to Hex - Checklist & Instructions

This document outlines what has been completed and what remains before publishing to Hex.

## ✅ Completed

### Documentation
- [x] Comprehensive README.md with examples and quick start
- [x] Complete `/docs` folder with guides for all major modules:
  - getting-started.md
  - notes.md
  - intervals.md
  - transpose.md
  - chords.md
  - scales.md
  - README.md (documentation index)
- [x] `.claude/claude.md` for AI context
- [x] `@moduledoc` added to all main modules:
  - Harmony (main module)
  - Harmony.Note
  - Harmony.Interval
  - Harmony.Transpose
  - Harmony.Chord
  - Harmony.Scale

### Package Metadata
- [x] LICENSE file (MIT License)
- [x] CHANGELOG.md with version 0.1.0 details
- [x] `mix.exs` updated with:
  - Package description
  - Package metadata (licenses, links, maintainers)
  - Documentation configuration
  - ex_doc dependency added
  - Proper file inclusion list

### Build & Verification
- [x] Package name "harmony" is available on Hex
- [x] Documentation builds successfully (`mix docs`)
- [x] Package builds successfully (`mix hex.build`)
- [x] All dependencies fetched

## ⚠️ Known Issues

### Test Failures (Intermittent)
There are 1-2 tests that fail intermittently with ordering issues:

1. **Scale.reduced test** - Sometimes returns extra "quinta" entries
2. **Chord.reduced test** - Sometimes returns extra "quinta" entries

These appear to be:
- Non-deterministic (pass when run individually, fail in full suite sometimes)
- Related to duplicate data or ordering in scale/chord definitions
- Not critical to core functionality

**Recommended Actions:**
1. Investigate `quinta` scale/chord definition in data files
2. Check for duplicates in Scale.Data and Chord.Data modules
3. Consider using `Enum.uniq()` in the `reduced` functions
4. Or mark these as known issues in CHANGELOG

## 📋 Pre-Publish Checklist

Before running `mix hex.publish`, verify:

### Required
- [ ] All tests passing consistently (`mix test`)
- [ ] Dialyzer passes without errors (`mix dialyzer`)
- [ ] GitHub repository created and code pushed
- [ ] Hex account created at https://hex.pm
- [ ] Hex API key configured (`mix hex.user auth`)

### Recommended
- [ ] Version number is correct (currently 0.1.0)
- [ ] CHANGELOG.md is up to date
- [ ] README examples work as shown
- [ ] Documentation looks good in preview (`open doc/index.html`)
- [ ] All links in documentation are valid

### Optional but Good Practice
- [ ] Create GitHub release with tag v0.1.0
- [ ] Add topics/tags to GitHub repo (elixir, music, music-theory, tonal)
- [ ] Consider adding badges to README (Hex version, docs, license)
- [ ] Set up CI/CD (GitHub Actions for automated testing)

## 🚀 Publishing Steps

Once everything above is complete:

```bash
# 1. Ensure you're logged in to Hex
mix hex.user auth

# 2. Build and verify the package
mix hex.build

# 3. Publish (this will prompt for confirmation)
mix hex.publish

# 4. Tag the release in git
git tag v0.1.0
git push origin v0.1.0

# 5. Create GitHub release (optional but recommended)
# Go to GitHub releases and create release from tag
```

## 🔧 Fixing the Test Issues

To investigate the intermittent test failures:

```bash
# Run tests multiple times to reproduce
for i in {1..10}; do
  echo "Run $i"
  mix test --seed $i test/harmony/scale_test.exs:95 test/harmony/chord_test.exs:217
done
```

Look for:
1. Duplicate "quinta" definitions in:
   - `lib/harmony/scale/data.ex`
   - `lib/harmony/chord/data.ex`

2. If found, either remove duplicates or update the functions:
   ```elixir
   # In scale.ex reduced_from_chroma function
   Name.all()
   |> Enum.filter(&is_subset.(&1.chroma))
   |> Enum.map(& &1.name)
   |> Enum.uniq()  # Add this
   ```

## 📝 Post-Publication

After publishing to Hex:

1. Update documentation to mention Hex availability
2. Add Hex badge to README
3. Announce on Elixir Forum / Twitter / etc.
4. Monitor for issues and feedback
5. Consider setting up automated documentation updates

## 🆘 Support

If you encounter issues during publishing:

- Hex Publishing Guide: https://hex.pm/docs/publish
- Hex Docs: https://hexdocs.pm/
- Elixir Forum: https://elixirforum.com/

## 📊 Package Health Indicators

Good signs your package is ready:

- ✅ Documentation is comprehensive and clear
- ✅ All public functions have examples
- ✅ Tests cover main functionality
- ✅ README has quick start guide
- ✅ License is included
- ✅ Changelog documents changes
- ✅ Package builds without warnings

Current Status: **Ready for publishing** (pending test issue resolution)

## 🎯 Next Version Ideas

For version 0.2.0 or later:

- Voice leading algorithms
- Chord voicing generation
- Scale fingering patterns
- Integration with MIDI libraries
- More exotic scales and chords
- Performance optimizations
- Additional language support (pitch names in different languages)
