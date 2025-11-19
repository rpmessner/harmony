# GitHub Actions Workflows

This directory contains GitHub Actions workflows for continuous integration, documentation deployment, and releases.

## Workflows

### CI (`ci.yml`)

Runs on every push and pull request to main/master branches.

**Jobs:**
- **Test** - Runs test suite on multiple Elixir/OTP versions:
  - Elixir 1.17 / OTP 27.2 (current)
  - Elixir 1.16 / OTP 26.2 (previous stable)
  - Elixir 1.12 / OTP 24.3 (minimum supported)
- **Dialyzer** - Type checking with Dialyzer
- **Docs** - Builds documentation and uploads as artifact
- **Coverage** - Runs tests with coverage reporting
- **All Checks** - Summary job that requires all others to pass

**Features:**
- Caching of dependencies and build artifacts
- Caching of Dialyzer PLT files
- Code formatting verification
- Compilation with warnings as errors

### Documentation (`docs.yml`)

Deploys documentation to GitHub Pages on:
- Pushes to main/master
- Version tags (v*)
- Manual workflow dispatch

**Setup Required:**
1. Go to repository Settings → Pages
2. Set Source to "GitHub Actions"
3. Documentation will be available at: `https://[username].github.io/[repo]/`

### Release (`release.yml`)

Triggered on version tags (v*).

**Jobs:**
- **GitHub Release** - Creates GitHub release with changelog
- **Hex Publish** - (Disabled by default) Publishes to Hex.pm

**Creating a Release:**
```bash
# Update version in mix.exs
# Update CHANGELOG.md with new version

# Commit changes
git add mix.exs CHANGELOG.md
git commit -m "Bump version to 0.2.0"

# Create and push tag
git tag v0.2.0
git push origin v0.2.0
```

**Enabling Hex Publishing:**
1. Generate a Hex API key: `mix hex.user auth`
2. Add key to GitHub repository secrets as `HEX_API_KEY`
3. Remove `if: false` from the hex-publish job in `release.yml`

## Status Badges

Add these to your README.md:

```markdown
[![CI](https://github.com/ryanmessner/harmony/workflows/CI/badge.svg)](https://github.com/ryanmessner/harmony/actions/workflows/ci.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/harmony.svg)](https://hex.pm/packages/harmony)
[![Documentation](https://img.shields.io/badge/docs-hexpm-blue.svg)](https://hexdocs.pm/harmony/)
[![License](https://img.shields.io/hexpm/l/harmony.svg)](LICENSE)
```

## Dependabot

The `dependabot.yml` configuration automatically:
- Checks for Mix dependency updates weekly
- Checks for GitHub Actions updates weekly
- Groups updates for easier review

## Troubleshooting

### Dialyzer Takes Too Long
If Dialyzer is timing out:
1. Add `timeout-minutes: 30` to the Dialyzer job
2. Consider excluding certain apps from analysis in `mix.exs`

### Tests Failing in CI but Passing Locally
- Check Elixir/OTP version compatibility
- Verify all dependencies are committed to `mix.lock`
- Consider time-zone or timing-related issues

### GitHub Pages Not Working
1. Ensure Pages is enabled in repository settings
2. Check that source is set to "GitHub Actions"
3. Verify the workflow has proper permissions

## Local Testing

Test workflows locally using [act](https://github.com/nektos/act):

```bash
# Install act
brew install act

# Run CI workflow
act -j test

# Run specific job
act -j dialyzer
```
