---
name: release
description: "Automated release workflow — version bump, changelog, tag, validation"
tags:
  - utility
  - release
---

## When to Use

- Ready to cut a new release
- User says "release" or wants to publish a new version

## Usage

```
release patch    # 0.1.0 → 0.1.1
release minor    # 0.1.0 → 0.2.0
release major    # 0.1.0 → 1.0.0
release 1.2.3    # Explicit version
```

## Release Checklist

Execute steps in order. Stop on any failure.

### 1. Pre-flight Checks

```bash
# Clean working tree
git status --porcelain  # Must be empty

# On main branch
git branch --show-current  # Must be "main"

# Tests pass
npm run typecheck && npm run lint && npm test
```

**ABORT if any check fails.**

### 2. Run Quality Gate

Run the quality gate checks against `plugin/`. If `dev-agents/quality-gate.agent.md` exists, follow its checklist. Otherwise run: agent count, skill count, model ID format, tool names, frontmatter validation.

**ABORT if quality gate fails.**

### 3. Version Bump

Determine version from argument or commits:
```bash
# If arg is patch/minor/major:
npm version {arg} --no-git-tag-version

# If arg is explicit version:
npm version {arg} --no-git-tag-version
```

Update `plugin/plugin.json` version to match:
```bash
NEW_VERSION=$(node -p "require('./package.json').version")
```

### 4. Generate Changelog

Analyze commits since last tag:
```bash
git log $(git describe --tags --abbrev=0 2>/dev/null || echo "HEAD~20")..HEAD --oneline
```

Group by type (feat:, fix:, chore:, docs:) and prepend to CHANGELOG.md:
```markdown
## v{version} (YYYY-MM-DD)

### Features
- {feat commits}

### Fixes
- {fix commits}

### Other
- {other commits}
```

### 5. Commit + Tag

```bash
git add package.json plugin/plugin.json CHANGELOG.md
git commit -m "release: v{version}"
git tag -a v{version} -m "v{version}"
```

### 6. Report

```
## Release v{version}

- Quality gate: PASS
- Tests: {N} passed
- Commits since last release: {N}
- Changelog: {summary}

Next: git push origin main --tags
```

**Do NOT push automatically** — let the user decide.

## Checklist

- [ ] Working tree clean, on main
- [ ] Typecheck + lint + test pass
- [ ] Quality gate pass
- [ ] Version bumped in package.json + plugin.json
- [ ] Changelog generated
- [ ] Commit + tag created
- [ ] User informed (push is manual)

## Trigger Keywords

release, version bump, publish

## Example

```bash
copilot -i "release: prepare v1.0.0"
```

## Quality Contract

- Pre-flight checks, quality gate, changelog generated, user decides push
