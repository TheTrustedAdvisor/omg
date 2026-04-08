# omg Plugin — Burndown: OMC v4.10.1 Parity

Last updated: 2026-04-06 (post P0+P1 expansion)

## Agents: 19/19 (100%)

All OMC agents translated to Copilot-native format. Full parity.

## Skills: 34 total (28 ported + 6 omg-only) | 8 OMC-internal dropped

### Coverage by Content Depth

| Skill | OMC | Ours | Cov% | Status |
|-------|-----|------|------|--------|
| **autopilot** | 8,809 | 6,632 | 75% | Done |
| **skillify** | 1,172 | 817 | 69% | Done |
| **debug** | 1,135 | 735 | 64% | Done |
| **ask** | 1,404 | 827 | 58% | Done |
| **ralph** | 12,232 | 6,653 | 54% | Done |
| **ai-slop-cleaner** | 6,156 | 2,615 | 42% | OK |
| **verify** | 1,109 | 469 | 42% | Done |
| **remember** | 1,432 | 587 | 40% | OK |
| **learner** | 5,535 | 2,206 | 39% | OK |
| **ultraqa** | 4,365 | 1,535 | 35% | OK |
| **trace** | 9,690 | 3,292 | 33% | OK |
| **ultrawork** | 5,765 | 1,886 | 32% | OK |
| **ccg** | 2,786 | 841 | 30% | OK |
| **plan** | 20,108 | 5,866 | 29% | OK |
| **deep-interview** | 31,936 | 8,930 | 27% | OK |
| **deepinit** | 8,340 | 1,954 | 23% | P2 |
| **external-context** | 2,178 | 505 | 23% | P2 |
| **visual-verdict** | 2,433 | 568 | 23% | P2 |
| **sciomc** | 13,323 | 3,057 | 22% | OK |
| **self-improve** | 19,849 | 4,193 | 21% | OK |
| **ralplan** | 8,452 | 1,743 | 20% | P2 |
| **release** | 2,206 | 435 | 19% | P2 |
| **writer-memory** | 16,154 | 2,878 | 17% | OK |
| **team** | 44,454 | 7,117 | 16% | OK |
| **project-session-manager** | 13,962 | 2,085 | 14% | OK |
| **deep-dive** | 24,564 | 3,632 | 14% | P2 |
| **cancel** | 17,865 | 2,098 | 11% | OK |
| **configure-notifications** | 36,070 | 753 | 2% | P2 |

### omg-Only Skills (not in OMC)

| Skill | Size | Purpose |
|-------|------|---------|
| `agent-catalog` | 3,100 | Agent discovery directory |
| `handoff-protocol` | 1,800 | Persistence convention |
| `deepsearch` | 750 | Keyword: thorough codebase search |
| `ultrathink` | 700 | Keyword: deep reasoning mode |
| `tdd` | 1,800 | Keyword: TDD red-green-refactor |
| `deep-analyze` | 900 | Keyword: multi-perspective analysis |

### Dropped (OMC-internal, not portable)

| Skill | OMC Size | Reason |
|-------|----------|--------|
| `omc-setup` | 7,507 | OMC installation |
| `omc-doctor` | 8,372 | OMC diagnostics |
| `omc-reference` | 5,639 | → replaced by `agent-catalog` |
| `omc-teams` | 6,966 | → replaced by `team` |
| `mcp-setup` | 5,673 | MCP removed |
| `hud` | 12,880 | No Copilot equivalent |
| `setup` | 1,467 | OMC install routing |
| `skill` | 21,818 | OMC skill management |

## Progress Summary

| Tier | Count | Coverage Range | Status |
|------|-------|---------------|--------|
| Done (>50%) | 5 | 54-75% | Ship-ready |
| OK (20-50%) | 16 | 20-42% | Functional, core concepts covered |
| P2 (<20%) | 7 | 2-23% | Thin — expand when prioritized |

**Average coverage across 28 ported skills: ~30%**

Note: OMC skills contain extensive OMC-specific state management, hook enforcement, and tool references that don't translate to Copilot. The effective functional coverage is higher than the raw byte percentage suggests.

## Keyword Triggers

| OMC Keyword | omg Skill | Status |
|-------------|-----------|--------|
| autopilot | autopilot | HAVE |
| ralph | ralph | HAVE |
| ulw | ultrawork | HAVE |
| ccg | ccg | HAVE |
| ralplan | ralplan | HAVE |
| deep interview | deep-interview | HAVE |
| deslop/anti-slop | ai-slop-cleaner | HAVE |
| deep-analyze | deep-analyze | HAVE |
| tdd | tdd | HAVE |
| deepsearch | deepsearch | HAVE |
| ultrathink | ultrathink | HAVE |
| cancelomc | cancel | HAVE |

**12/12 keyword triggers covered.**
