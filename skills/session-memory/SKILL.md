---
name: session-memory
description: "Cross-session persistent context — remember project decisions, architecture choices, and team conventions"
tags:
  - persistence
  - context
  - utility
---

## When to Use

- User wants to save context that should persist across sessions
- User says "remember this", "save for next time", "session memory"
- Important decisions, architecture choices, or conventions should survive session restarts
- Building up a project knowledge base over time

## How It Works

Uses Copilot's native `store_memory` (confirmed cross-session persistent) plus `.omg/` files for structured data.

### Memory Types

| Type | store_memory Key | File | Example |
|------|-----------------|------|---------|
| **Project context** | `omg:project` | `.omg/research/project-context.md` | "This is a TypeScript CLI tool using tsup + vitest" |
| **Architecture decisions** | `omg:decisions` | `.omg/research/decisions.md` | "We chose TF-IDF over embeddings because..." |
| **Team conventions** | `omg:conventions` | `.omg/research/conventions.md` | "Always use function keyword, not arrow" |
| **Active work** | `omg:active-plan` | `.omg/plans/*.md` | Current plan being executed |
| **Active spec** | `omg:active-spec` | `.omg/research/spec-*.md` | Current spec from deep-interview |
| **Last review** | `omg:last-review` | `.omg/reviews/*.md` | Most recent review verdict |

## Operations

### Save Context

```
"Remember: we decided to use PostgreSQL instead of MongoDB because the team has more SQL experience"
```

→ Appends to `.omg/research/decisions.md`:
```markdown
## 2026-04-07: Database Choice
**Decision:** PostgreSQL over MongoDB
**Reason:** Team SQL experience
```

→ Updates `store_memory` key `omg:decisions` with latest entry summary.

### Recall Context

```
"What architecture decisions have we made?"
```

→ Reads `store_memory` key `omg:decisions` for quick summary
→ Reads `.omg/research/decisions.md` for full history

### List All Memory

```
"What do you remember about this project?"
```

→ Reads all `omg:*` keys from `store_memory`
→ Lists `.omg/research/` files

### Forget

```
"Forget the database decision"
```

→ Removes entry from `.omg/research/decisions.md`
→ Updates `store_memory` key

## Auto-Memory

Skills automatically save key context:
- **planner** saves active plan to `omg:active-plan`
- **deep-interview** saves spec to `omg:active-spec`
- **critic/verifier** save review to `omg:last-review`
- **team** saves log to `.omg/qa-logs/`

## Persistence Strategy

- **`store_memory`:** quick discovery, auto-loaded by Copilot, survives sessions
- **`.omg/` files:** full data, git-trackable, human-readable, auditable
- **Both together:** memory points to file, file has the detail

## Examples

**Good:** "Remember that src/auth/ uses JWT with 15-minute expiry and refresh tokens stored in httpOnly cookies"
→ Saves specific, actionable context that future agents can use.

**Bad:** "Remember everything"
→ Too vague. What specifically should persist?

## Checklist

- [ ] Context saved to appropriate `.omg/research/` file
- [ ] `store_memory` indexed for quick discovery
- [ ] Recall works in new session (verified)

## Trigger Keywords

session memory, save context, what do you remember

## Quality Contract

- Cross-session persistence via store_memory
