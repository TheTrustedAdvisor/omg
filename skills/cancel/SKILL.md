---
name: cancel
description: "Cancel any active execution mode — stops autopilot, ralph, ultrawork, team, ultraqa cleanly"
tags:
  - utility
  - control
---

## When to Use

- User wants to stop an active execution mode
- User says "cancel", "stop", "abort", "cancelomc"
- Work is complete and mode needs clean exit
- Mode is stuck and needs forced termination

## What It Cancels

| Mode | Cancel Behavior | State Preserved |
|------|----------------|-----------------|
| **autopilot** | Stop current phase | `.omg/qa-logs/autopilot-*` |
| **ralph** | Stop persistence loop | `.omg/qa-logs/ralph-prd.json`, `ralph-progress.md` |
| **ultrawork** | Stop parallel execution | Wait for in-flight tasks |
| **ultraqa** | Stop QA cycling | `.omg/qa-logs/ultraqa-log.md` |
| **team** | Shutdown workers | `.omg/qa-logs/team-log.md` |

## Workflow

### 1. Detect Active Mode

Check for active state files:
```bash
ls .omg/qa-logs/*-prd.json .omg/qa-logs/*-state.json .omg/qa-logs/*-log.md 2>/dev/null
```

Also check `store_memory` for active mode keys (`omg:active-plan`, etc.).

### 2. Preserve State

Before cancelling, ensure current progress is saved:

| Mode | What to Save | Where |
|------|-------------|-------|
| Ralph | Current PRD (which stories passed) | `.omg/qa-logs/ralph-prd.json` |
| Autopilot | Current phase + completed phases | `.omg/qa-logs/autopilot-state.json` |
| Team | Subtask completion status | `.omg/qa-logs/team-log.md` |
| UltraQA | Cycle count + last error | `.omg/qa-logs/ultraqa-log.md` |

### 3. Clean Exit

- Wait for in-flight `task(background)` agents to complete (best effort, 30s timeout)
- Report what was completed and what remains
- State files preserved for resume (NOT deleted)

### 4. Report

```
## Cancel Report

Mode: {mode}
Status: CANCELLED

### Completed
- {what was done}

### Remaining
- {what's left}

### Resume
To resume: re-invoke the mode. It will read state from .omg/qa-logs/ and continue.
```

### 5. Force Cancel

If normal cancel fails (stuck agents, unresponsive):
```bash
# Remove state files to unblock
rm -f .omg/qa-logs/{mode}-state.json
```

Report force-cancel with warning about potential incomplete state.

## Resume After Cancel

Modes check `.omg/qa-logs/` on startup:
- **Ralph:** reads `ralph-prd.json`, skips completed stories
- **Autopilot:** reads phase state, resumes from last phase
- **Team:** reads team log, re-assigns incomplete subtasks
- **UltraQA:** reads cycle log, continues from last cycle

## Checklist

- [ ] Active mode detected
- [ ] Progress preserved before exit
- [ ] In-flight agents given time to complete
- [ ] Clean shutdown reported
- [ ] State preserved for resume

## Trigger Keywords

cancel, stop, abort, cancelomc

## Example

```bash
copilot -i "cancelomc"
```

## Quality Contract

- Clean shutdown, preserves state
