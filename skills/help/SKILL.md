---
name: help
description: "Quick reference — what omg agents and skills are available and how to use them"
tags:
  - discovery
  - meta
---

## When to Use

- User says "help", "omg help", "what can you do", "list agents", "list skills"

## Response

Display this quick reference:

### Top 5 Workflows

| Say this | What happens |
|----------|-------------|
| `autopilot: build a REST API` | Full lifecycle: plan → implement → test → verify |
| `ralph: fix all lint errors` | Keeps working until every acceptance criterion passes |
| `team 3: fix TypeScript errors` | 3 parallel agents, each on independent files |
| `deep interview: new feature idea` | Socratic Q&A → crystallize into spec |
| `research-to-pr: fix auth bug` | Investigate → implement → cloud agent creates PR |

### Orchestrators (9) — say the name to activate

| Agent | What it does |
|-------|-------------|
| **autopilot** | Full lifecycle from idea to working code |
| **ralph** | Persistence loop — don't stop until done |
| **team** | N parallel workers on independent tasks |
| **ralplan** | Consensus planning (planner + architect + critic) |
| **ultrawork** | Fire parallel tasks simultaneously |
| **research-to-pr** | Investigate → auto PR via cloud agent |
| **sciomc** | Parallel staged research |
| **self-improve** | Benchmark → tournament-select best approach |
| **deep-dive** | Trace root cause → crystallize into spec |

### Specialists (19) — invoked by orchestrators or directly

| Agent | Specialty |
|-------|----------|
| **architect** | Architecture analysis, trade-offs |
| **analyst** | Requirements gaps, edge cases |
| **planner** | Structured plans with criteria |
| **critic** | Multi-perspective quality gate |
| **executor** | Code implementation |
| **debugger** | Root cause analysis |
| **verifier** | Evidence-based PASS/FAIL |
| **code-reviewer** | Severity-rated code review |
| **security-reviewer** | OWASP Top 10, secrets |
| **test-engineer** | TDD, test strategy |
| **explore** | Fast codebase search |
| **designer** | Production-grade UI |
| **git-master** | Atomic commits |
| **tracer** | Competing hypotheses |
| **scientist** | Statistical analysis |
| **writer** | Technical documentation |
| **document-specialist** | External API docs |
| **code-simplifier** | Remove complexity |
| **qa-tester** | Interactive CLI testing |

### More Skills

| Category | Skills |
|----------|--------|
| Planning | plan, deep-interview, deepinit |
| Analysis | trace, deep-analyze, deepsearch, ultrathink, ultraqa |
| Development | tdd, debug, verify |
| Research | external-context, ccg, ask |
| Utility | release, cancel, remember, session-memory, ms-discover |
| Quality | ai-slop-cleaner, visual-verdict |
| Meta | about, help, agent-catalog, handoff-protocol |

### Quick Links

- "about" — what is omg, version, architecture
- "agent-catalog" — full agent directory with model/effort routing
- "handoff-protocol" — how agents share data via .omg/ directories

## Trigger Keywords

help, omg help, what can you do

## Example

```bash
copilot -i "help"
```

## Quality Contract

- Lists all 25 agents, 42 skills, and top 5 workflows
