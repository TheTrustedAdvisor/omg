# omg — Multi-Agent Orchestration for GitHub Copilot

**19 specialized AI agents. 36 workflow skills. One plugin.**

omg turns GitHub Copilot CLI into a multi-agent development platform. Instead of one AI assistant doing everything, omg gives you a team of specialists — an architect who analyzes code, a debugger who traces root causes, a critic who reviews plans, an executor who implements changes — all coordinating autonomously through structured workflows.

## Why omg?

| Without omg | With omg |
|------------|---------|
| One generalist AI | 19 specialists, each best at their job |
| Manual step-by-step prompting | Autonomous multi-phase workflows |
| Hope it works, check manually | Built-in verification with evidence |
| Forget context between sessions | Persistent memory across sessions |
| Single model for everything | Right model per task (haiku for speed, opus for depth) |

## Install

One command:
```bash
copilot plugin install git@github.com:TheTrustedAdvisor/omg.git
```

That's it. 19 agents + 37 skills, ready to use.

<details>
<summary>Alternative install methods</summary>

```bash
# From local clone (development)
git clone git@github.com:TheTrustedAdvisor/omg.git
cd omg
./install.sh              # Builds, tests, validates, installs plugin

# Direct from local directory
copilot plugin install ./plugin

# Temporary (no install, session only)
copilot --plugin-dir ./plugin
```
</details>

## Quick Start — Just Say What You Want

No special syntax needed. Describe what you want:

```bash
# Plan a feature with structured requirements
copilot -i "Plan how to add authentication to this project"

# Fix a bug — root cause analysis, not guesswork
copilot -i "Debug why the tests are failing in src/pipeline/"

# Security audit with severity ratings and fix suggestions
copilot -i "Review the security of src/config.ts"

# Build something from scratch — fully autonomous
copilot -i "autopilot: build a REST API for user management"

# Keep working until it's done — no "it should work"
copilot -i "ralph: add input validation to all CLI commands"

# 5 agents working in parallel on independent tasks
copilot -i "team 5: fix all TypeScript errors across src/"

# Investigate → implement → create PR (Copilot-exclusive)
copilot -i "research-to-pr: fix the auth token expiry bug"
```

Copilot picks the right agents and skills automatically.

### Workflows at a Glance

| Say this | What happens |
|----------|-------------|
| `plan...` | Structured interview → plan with testable acceptance criteria |
| `autopilot...` | Full lifecycle: plan → implement → test → validate |
| `ralph...` | Persistent loop until ALL acceptance criteria pass with evidence |
| `team N...` | N parallel agents, each on independent files, verified together |
| `trace...` | Competing hypotheses ranked by evidence strength |
| `deep interview...` | Socratic Q&A with ambiguity scoring — proceed when clarity ≥ 80% |
| `tdd...` | Red-green-refactor: failing test first, then minimal code |
| `research-to-pr...` | Investigate → implement → cloud agent creates PR automatically |
| `deepsearch...` | Multi-angle codebase exploration, not just grep |
| `ultrathink...` | Deep reasoning on complex architectural decisions |

## What Makes omg Different

### Real Multi-Agent Orchestration

Not just prompts — agents delegate to each other, persist handoffs to files, and verify each other's work:

```
Planner → creates plan → .omg/plans/
  Executor → reads plan → implements code
    Verifier → checks EVERY acceptance criterion with fresh test output
      Architect → reviews completeness → APPROVE or REQUEST CHANGES
```

### Verified Completion

Every claim is backed by evidence. "Tests pass" means the verifier ran `npm test` and saw green. No "it should work" — only "here's the proof."

### Cross-Session Memory

Decisions, plans, and review results survive across sessions:

| What | Where | Survives restart? |
|------|-------|-------------------|
| Plans | `.omg/plans/` | Yes (file) |
| Research | `.omg/research/` | Yes (file) |
| Reviews | `.omg/reviews/` | Yes (file) |
| Context index | `store_memory` | Yes (Copilot-native) |

### Copilot-Exclusive Capabilities

Features that only work on Copilot, not on other AI coding tools:

| Capability | What it enables |
|-----------|----------------|
| **Multi-model routing** | Haiku for speed, Sonnet for coding, Opus for architecture |
| **Parallel agents** | 5 workers on 5 files simultaneously (proven: 3s not 9s) |
| **Cloud handoff** | `/delegate` sends work to cloud agent → automatic PR |
| **GitHub integration** | Native MCP access to issues, PRs, code search |
| **Reasoning control** | `--effort low/xhigh` per task for cost optimization |

## The 19 Agents

| Agent | Specialty | When it's called |
|-------|----------|-----------------|
| **architect** | Architecture analysis, trade-offs | Plan review, design decisions |
| **critic** | Multi-perspective quality gate | Final approval before execution |
| **analyst** | Requirements gaps, edge cases | Before planning starts |
| **planner** | Structured plans with acceptance criteria | "plan", "how should we" |
| **executor** | Code implementation, smallest diff | Actual coding work |
| **debugger** | Root cause analysis, minimal fix | Bugs, build failures |
| **verifier** | Evidence-based PASS/FAIL | After every implementation |
| **code-reviewer** | Severity-rated review, SOLID | Code quality checks |
| **security-reviewer** | OWASP Top 10, secrets, deps | Security audits |
| **test-engineer** | TDD, test strategy, flaky tests | Test writing |
| **explore** | Fast codebase search | Finding files and patterns |
| **designer** | Production-grade UI | Frontend work |
| **git-master** | Atomic commits, style-matching | Git operations |
| **tracer** | Competing hypotheses with evidence | "Why did this happen?" |
| **scientist** | Statistical analysis with rigor | Data investigations |
| **writer** | Verified documentation | README, API docs |
| **document-specialist** | External API references | Library/framework questions |
| **code-simplifier** | Remove complexity, keep behavior | Refactoring |
| **qa-tester** | Interactive CLI testing | End-to-end validation |

## 36 Skills

**Execution:** autopilot, ralph, team, ultrawork
**Planning:** plan, ralplan, deep-interview, deep-dive
**Quality:** ultraqa, verify, tdd, ai-slop-cleaner
**Analysis:** trace, deep-analyze, deepsearch, ultrathink, sciomc
**Flagship:** research-to-pr (investigate → cloud agent → automatic PR)
**Utilities:** debug, release, cancel, session-memory, ask, ccg, deepinit, external-context, learner, skillify, self-improve, writer-memory, project-session-manager, configure-notifications, visual-verdict
**Reference:** agent-catalog, handoff-protocol

## Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) — How it works under the hood (14 Mermaid diagrams)
- [LIMITATIONS.md](LIMITATIONS.md) — Known gaps and when they'll be resolved
- [LESSONS-LEARNED.md](LESSONS-LEARNED.md) — Empirical findings from testing
- [BURNDOWN.md](BURNDOWN.md) — Feature coverage tracking

## Credits

omg's agent architecture is inspired by [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) (OMC), adapted and extended for GitHub Copilot's native capabilities. omg adds multi-model routing, parallel execution, cloud delegation, and GitHub-native integration that OMC's Claude Code platform cannot provide.

## License

MIT
