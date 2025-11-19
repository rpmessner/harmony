# GitHub Repository Setup Guide

This guide will help you set up your GitHub repository with all the CI/CD features.

## Initial Repository Setup

### 1. Create GitHub Repository

```bash
# If not already created, create a new repository on GitHub
# Then initialize and push your code:

git init
git add .
git commit -m "Initial commit"
git branch -M master  # or main, depending on your preference
git remote add origin git@github.com:ryanmessner/harmony.git
git push -u origin master
```

### 2. Enable GitHub Actions

GitHub Actions are enabled by default for public repositories. For private repositories:
1. Go to Settings → Actions → General
2. Ensure "Allow all actions and reusable workflows" is selected

### 3. Configure GitHub Pages (Optional)

To enable automatic documentation deployment:

1. Go to repository Settings → Pages
2. Under "Build and deployment":
   - Source: Select **"GitHub Actions"**
3. After the first workflow run, your docs will be at:
   - `https://ryanmessner.github.io/harmony/`

### 4. Set Up Branch Protection (Recommended)

Protect your main branch to require CI checks:

1. Go to Settings → Branches
2. Add rule for `master` (or `main`)
3. Enable:
   - ✅ Require status checks to pass before merging
   - ✅ Require branches to be up to date before merging
   - Select status checks: `test`, `dialyzer`, `docs`, `coverage`
   - ✅ Require conversation resolution before merging

### 5. Configure Secrets (For Hex Publishing)

If you want automatic Hex.pm publishing on releases:

1. Generate a Hex API key:
   ```bash
   mix hex.user auth
   # This will create/update your Hex credentials
   # Get your key from ~/.hex/hex.config
   ```

2. Add to GitHub:
   - Go to Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `HEX_API_KEY`
   - Value: Your Hex API key
   - Click "Add secret"

3. Enable auto-publish:
   - Edit `.github/workflows/release.yml`
   - Remove or change `if: false` in the `hex-publish` job

## Workflow Features

### CI Workflow (`ci.yml`)

**Triggers:** Push and PR to master/main

**Matrix Testing:** Tests on multiple Elixir/OTP versions
- Elixir 1.17 / OTP 27.2
- Elixir 1.16 / OTP 26.2
- Elixir 1.12 / OTP 24.3 (minimum supported)

**Checks:**
- Compilation with warnings as errors
- Test suite
- Code formatting (on latest version only)
- Dialyzer type checking
- Documentation building
- Test coverage

### Documentation Workflow (`docs.yml`)

**Triggers:** Push to master/main, version tags, manual dispatch

**Features:**
- Builds ExDoc documentation
- Deploys to GitHub Pages
- Accessible at `https://[username].github.io/[repo]/`

### Release Workflow (`release.yml`)

**Triggers:** Push of version tags (v*)

**Features:**
- Creates GitHub release with changelog
- Optional Hex.pm publishing (disabled by default)

## Using the Workflows

### Running CI on Pull Requests

CI runs automatically on every PR. You'll see checks at the bottom of the PR.

### Creating a Release

```bash
# 1. Update version in mix.exs
# 2. Update CHANGELOG.md with new version details
# 3. Commit changes
git add mix.exs CHANGELOG.md
git commit -m "Bump version to 0.2.0"
git push

# 4. Create and push tag
git tag v0.2.0
git push origin v0.2.0

# This will trigger:
# - GitHub release creation
# - Documentation deployment
# - (Optional) Hex.pm publishing
```

### Manual Documentation Deployment

You can manually trigger documentation deployment:

1. Go to Actions tab
2. Click "Deploy Documentation"
3. Click "Run workflow"
4. Select branch and click "Run workflow"

## Troubleshooting

### CI Failing on Dialyzer

If Dialyzer is taking too long or failing:

**Option 1:** Increase timeout
```yaml
# In .github/workflows/ci.yml under dialyzer job
- name: Run Dialyzer
  run: mix dialyzer
  timeout-minutes: 30  # Add this
```

**Option 2:** Create PLT in project
```bash
# Locally create PLT
mix dialyzer --plt

# Commit the PLT files
git add priv/plts/
git commit -m "Add Dialyzer PLT"
```

### GitHub Pages Not Deploying

**Check permissions:**
1. Settings → Actions → General → Workflow permissions
2. Ensure "Read and write permissions" is selected
3. Or add explicit permissions in `docs.yml` (already configured)

**Check Pages settings:**
1. Settings → Pages
2. Source must be "GitHub Actions"
3. Not "Deploy from a branch"

### Hex Badge Showing "Not Found"

The Hex badge will show "not found" until you publish the package to Hex.pm for the first time. After publishing, it will automatically update.

## Monitoring

### Action Status

View workflow runs:
- Go to the "Actions" tab in your repository
- Click on specific workflows to see history
- Click on individual runs to see logs

### Notifications

Configure notifications:
1. GitHub profile → Settings → Notifications
2. Customize "Actions" notifications
3. Or watch the repository for all activity

## Best Practices

### Before Pushing

Run locally:
```bash
mix format
mix compile --warnings-as-errors
mix test
mix dialyzer
mix docs
```

### Commit Messages

Follow conventional commits for better changelog generation:
- `feat: add new chord type`
- `fix: resolve enharmonic spelling issue`
- `docs: update installation instructions`
- `chore: update dependencies`

### Version Bumping

Follow Semantic Versioning (SemVer):
- **Major** (1.0.0): Breaking changes
- **Minor** (0.1.0): New features, backward compatible
- **Patch** (0.0.1): Bug fixes, backward compatible

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Hex Publishing Guide](https://hex.pm/docs/publish)
- [Semantic Versioning](https://semver.org/)
