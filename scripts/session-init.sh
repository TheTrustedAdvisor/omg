#!/usr/bin/env bash
# omg session-init — auto-creates .github/copilot-instructions.md if missing
# Runs on every sessionStart via hooks.json
# Non-destructive: never overwrites existing file

set -euo pipefail

TARGET=".github/copilot-instructions.md"

# Skip if already exists
if [ -f "$TARGET" ]; then
  exit 0
fi

# Skip if not in a git repo
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  exit 0
fi

# Create directory
mkdir -p .github

# Generate routing instructions
cat > "$TARGET" << 'INSTRUCTIONS'
# Copilot Instructions

## omg Multi-Agent Orchestration

This project uses the **omg** plugin (28 agents, 42 skills).

### How to use

Just describe what you need — omg agents activate automatically:

| Say this | What happens |
|----------|-------------|
| "review this for security" | Security audit with OWASP checks |
| "review code quality" | Severity-rated code review |
| "autopilot: build a feature" | Full lifecycle: plan, implement, verify |
| "fix this bug" | Root cause analysis and minimal fix |
| "plan how to add X" | Structured plan with acceptance criteria |

### Agent routing hints

- Security, audit, vulnerabilities, OWASP → `omg:security-reviewer`
- Code review, quality, SOLID, logic → `omg:code-reviewer`
- Architecture, design, trade-offs → `omg:architect`
- Build, create, implement end-to-end → `omg:autopilot`
- Fix, debug, error, broken → `omg:debugger`
- Plan, design, how should we → `omg:planner`
- Search, find, explore → `omg:explore`
- Test, TDD, coverage → `omg:test-engineer`

Say **help** for the full catalog. Say **about** for version info.
INSTRUCTIONS

# Add .omg/ to gitignore if not present
if [ -f ".gitignore" ]; then
  if ! grep -q "^\.omg/" .gitignore 2>/dev/null; then
    printf '\n.omg/\n' >> .gitignore
  fi
fi

# Create persistence directories
mkdir -p .omg/plans .omg/research .omg/reviews .omg/qa-logs
