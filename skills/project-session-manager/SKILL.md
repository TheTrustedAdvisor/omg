---
name: project-session-manager
description: "Manage development sessions — branch isolation for issues, PRs, and features"
tags:
  - utility
  - git
  - workflow
---

## When to Use

- Starting work on a new issue or feature
- User says "new session", "start issue #X", "work on feature Y"
- Need branch isolation for parallel development
- Want to track which session is for which work item

## Operations

| Command | Description |
|---------|-------------|
| `start [issue/feature]` | Create branch + session |
| `switch [session]` | Checkout existing session branch |
| `list` | Show active sessions with branches |
| `close [session]` | Merge or cleanup completed session |
| `status` | Show current session details |

## Workflow

### Start Session

1. Parse the work item (issue #, feature name, PR #)
2. Create feature branch via `bash`:
   ```
   git checkout -b feature/{slug} main
   ```
3. Register session in `.omg/research/sessions.json`:
   ```json
   {
     "sessions": [
       {
         "id": "feature/add-validation",
         "workItem": "issue #42",
         "branch": "feature/add-validation",
         "created": "2026-04-06",
         "status": "active"
       }
     ]
   }
   ```
4. Index via `store_memory` key `omg:active-session`

### Switch Session

1. Stash current changes: `bash: git stash`
2. Checkout target branch: `bash: git checkout {branch}`
3. Update `omg:active-session` in `store_memory`

### List Sessions

Read `.omg/research/sessions.json`, show table:
```
| Session | Work Item | Branch | Status | Created |
|---------|-----------|--------|--------|---------|
| add-validation | issue #42 | feature/add-validation | active | 2026-04-06 |
```

### Close Session

1. Verify work is complete (run tests via `bash`)
2. Options: merge to main, create PR, or delete branch
3. Update session status to "closed" in sessions.json

## Checklist

- [ ] Session registered in `.omg/research/sessions.json`
- [ ] Branch created and checked out
- [ ] `store_memory` updated with active session
- [ ] Clean switch between sessions (stash/checkout)

## Git Integration

### Branch Naming Convention
```
feature/{slug}     — new features
fix/{slug}         — bug fixes  
chore/{slug}       — maintenance
docs/{slug}        — documentation
```

### PR Creation on Close

When closing a session, optionally create a PR:
```bash
git push origin feature/{slug}
gh pr create --title "{work item}" --body "## Changes\n{summary}\n\nCreated via omg project-session-manager"
```

### Stash Management

When switching sessions, stash is labeled:
```bash
git stash push -m "omg-session:{session-id}"
```

On resume:
```bash
git stash list | grep "omg-session:{session-id}"
git stash pop stash@{N}
```

## Multi-Session Dashboard

```
## Active Sessions

| # | Session | Branch | Work Item | Created | Stashed? |
|---|---------|--------|-----------|---------|----------|
| 1 | add-validation | feature/add-validation | issue #42 | 2026-04-06 | No |
| 2 | fix-auth-bug | fix/auth-bug | issue #15 | 2026-04-05 | Yes (2 files) |
```

## Trigger Keywords

new session, start issue, work on feature

## Example

```bash
copilot -i "new session for issue 42"
```

## Quality Contract

- Branch isolation, session tracking
