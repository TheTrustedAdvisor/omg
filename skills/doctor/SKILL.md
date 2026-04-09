---
name: doctor
description: "Health check — verifies omg plugin is correctly installed and working"
tags:
  - utility
  - diagnostic
---

## When to Use

- First time after installing omg
- Something doesn't seem to work
- User says "doctor", "health check", "check omg", "is omg working?"

## Workflow

Run these checks in order and report results:

### 1. Plugin Installed

```bash
copilot plugin list
```

Expected: `omg` appears in the list.

### 2. Version Check

```bash
copilot --version
```

Report the Copilot CLI version. Note if < v1.0.18 (missing features).

### 3. Agent Count

Count agents in `.github/agents/` or the plugin agent directory.
Expected: 25 agents.

### 4. Skill Count

Count skills in the plugin skill directory.
Expected: 42 skills.

### 5. AGENTS.md Loaded

Verify AGENTS.md is in the session context by checking if you know about the Agent Routing table.

### 6. Persistence Ready

```bash
ls -d .omg/plans .omg/research .omg/reviews .omg/qa-logs 2>/dev/null
```

If directories don't exist, create them:
```bash
mkdir -p .omg/plans .omg/research .omg/reviews .omg/qa-logs
```

### 7. Report

```
╔═════════════════════════════════════╗
║       omg Health Check Report       ║
╚═════════════════════════════════════╝

Plugin:       ✓ omg installed (v0.5.4)
CLI:          ✓ Copilot CLI v1.0.21
Agents:       ✓ 25 agents loaded
Skills:       ✓ 42 skills loaded
AGENTS.md:    ✓ Routing table active
Persistence:  ✓ .omg/ directories ready
Model:        ⚠ model: field not yet enforced (fix pending)

Status: HEALTHY
```

If any check fails, provide the fix command.

## Trigger Keywords

doctor, health check, check omg, is omg working, diagnose

## Example

```bash
copilot -i "doctor"
```

## Quality Contract

- All 7 checks run with evidence
- Clear HEALTHY/UNHEALTHY verdict
- Fix commands provided for any failures
