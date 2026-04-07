---
name: init
description: "Initialize omg in a project — generates .github/copilot-instructions.md with agent routing rules"
tags:
  - setup
  - meta
---

## When to Use

- First time using omg in a new project
- User says "init", "setup omg", "initialize omg", "configure omg"
- No `.github/copilot-instructions.md` exists yet

## Workflow

### 1. Check if already initialized

```bash
ls .github/copilot-instructions.md 2>/dev/null
```

If file exists, ask user if they want to overwrite or append.

### 2. Detect project context

Explore the project to detect:
- Language/framework (from package.json, Cargo.toml, go.mod, requirements.txt, etc.)
- Test framework (vitest, jest, pytest, etc.)
- Build tool (npm, cargo, make, etc.)
- Existing `.github/` configuration

### 3. Generate copilot-instructions.md

Create `.github/copilot-instructions.md` with project-specific content:

```markdown
# Copilot Instructions

## omg Agent Routing

When working in this project, use these specialized agents:

### Code Changes
- Say **autopilot** for full lifecycle (plan → implement → verify)
- Say **ralph** to keep working until all criteria pass with proof
- Say **team N** for parallel execution across independent files

### Reviews
- For security audits: use the `omg:security-reviewer` agent
- For code quality reviews: use the `omg:code-reviewer` agent
- For architecture analysis: use the `omg:architect` agent

### Investigation
- Say **trace** to investigate root causes with competing hypotheses
- Say **deep-dive** to investigate then define requirements
- Say **deepsearch** for thorough multi-angle codebase search

### Planning
- Say **plan** for structured planning with acceptance criteria
- Say **ralplan** for multi-perspective consensus planning
- Say **deep interview** to crystallize vague ideas into specs

### Quick Reference
- Say **help** for the full agent and skill catalog
- Say **about** for omg version and architecture info
- Say **tutorial** for an interactive walkthrough

## Project Conventions

{Auto-detected from project exploration — language, test framework, build commands}
```

### 4. Also create .omg/ directory

```bash
mkdir -p .omg/plans .omg/research .omg/reviews .omg/qa-logs
```

### 5. Confirm

Tell the user what was created and suggest:
- "Try: **about omg** to see your agent roster"
- "Try: **tutorial** for a guided walkthrough"
- "Try: **deepsearch: find all API endpoints** to see agents in action"

## Rules

- Detect project language/framework automatically — don't ask
- Keep the instructions concise — Copilot loads this into every session
- Never overwrite existing copilot-instructions.md without asking
- Add `.omg/` to .gitignore if not already present
