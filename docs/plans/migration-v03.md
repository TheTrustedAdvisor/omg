# Migration Plan: Orchestration Skills → Agents (v0.3)

**Issue:** #39
**Status:** Planning
**Goal:** Align omg plugin with Copilot-native architecture where Agents orchestrate and Skills provide capabilities.

---

## Principle

> "Agents are built ON TOP OF skills." — microsoft/skills-for-fabric

- **Agents** = WHO (persona + tools + orchestration decisions)
- **Skills** = WHAT (focused capability, auto-loaded, 1 skill = 1 workflow)
- **task()** = Agent's decision to delegate, not a prescribed sequence

---

## Phase 1: Prototype — Autopilot as Agent

### 1.1 Create `agents/autopilot.agent.md`

```yaml
---
name: autopilot
description: "Full autonomous execution — from idea to working, verified code. Expands requirements, plans, implements, reviews, and verifies."
model: claude-sonnet-4.6
tools:
  - bash
  - view
  - edit
  - create
  - grep
  - glob
  - task
  - web_fetch
  - store_memory
  - report_intent
---
```

Body: Autopilot persona + quality standards + outcome description.
NOT: prescriptive task() sequences.

Key instructions:
- "You are Autopilot. Your mission is to take a user request from idea to working code."
- "Break complex work into phases: understand → plan → implement → verify"
- "Delegate specialized work via task(): architecture analysis, security review, code review"
- "Persist plans to .omg/plans/, research to .omg/research/, reviews to .omg/reviews/"
- "Verify with fresh evidence before claiming done"

### 1.2 Convert `skills/autopilot/` to a capability skill

The skill becomes a lightweight trigger/context that auto-loads:

```yaml
---
name: autopilot
description: "Activates full autonomous execution mode — plan, implement, verify"
---

When this skill activates, the autopilot agent handles the full lifecycle.
The agent will:
- Expand vague requirements into concrete acceptance criteria
- Create a structured plan with testable criteria
- Implement code changes (parallel when possible)
- Run build, typecheck, tests as verification
- Review for security and code quality
- Persist all artifacts to .omg/ directories

Quality standards:
- Every claim backed by evidence (fresh test output, not assumptions)
- Smallest viable change (no scope creep)
- All acceptance criteria verified before completion
```

### 1.3 Test

1. `npm test` — L1 static validation
2. `copilot plugin install ./plugin` — reinstall
3. `copilot -p "autopilot: add a --json flag to report" --autopilot --yolo -s --output-format json`
4. Analyze JSONL: which agents were spawned? Was task() used?
5. Check .omg/ for persistence artifacts

### 1.4 Success Criteria

- [ ] Autopilot agent auto-routes when user says "autopilot: ..."
- [ ] Agent spawns sub-agents via task() for specialized work
- [ ] Persistence artifacts created in .omg/
- [ ] L1 tests pass (adjusted counts)

---

## Phase 2: Migrate Remaining Orchestrators

After Phase 1 validates the pattern, migrate:

| Orchestrator | Agent Model | Key Behavior |
|-------------|-------------|-------------|
| ralph | sonnet | Persistence loop: implement → verify → fix → repeat until criteria pass |
| team | sonnet | Decompose → spawn N parallel executors → verify combined result |
| ralplan | opus | Seek architectural consensus: plan → review → critique → iterate |
| ultrawork | sonnet | Fire independent tasks in parallel via task(mode=background) |

Each follows the same pattern:
1. Create `agents/{name}.agent.md` with persona + tools + outcome description
2. Convert `skills/{name}/SKILL.md` to lightweight trigger/context
3. Test with Copilot CLI
4. Analyze JSONL for task() delegation

### Candidates for evaluation (Phase 2b)

| Skill | Promote to Agent? | Reasoning |
|-------|-------------------|-----------|
| sciomc | Maybe | Orchestrates parallel scientists — agent-like |
| self-improve | Maybe | Multi-phase autonomous loop — agent-like |
| research-to-pr | Yes | Multi-phase + /delegate cloud handoff — agent-like |
| deep-dive | Maybe | 2-stage pipeline (trace → interview) |

---

## Phase 3: Remove Prescriptive task() from Skills

For all remaining skills, replace:
```
task(agent_type="omg:executor", model="claude-sonnet-4.6", mode="sync",
  prompt="Implement the fix")
```

With outcome descriptions:
```
The agent should implement the fix, then verify with fresh test output.
```

This affects 22 skills with 81 task() calls.

### Skills that keep task() references (as examples, not prescriptions)

- `agent-catalog` — reference documentation, shows task() syntax for users
- `handoff-protocol` — reference documentation

---

## Phase 4: Update Infrastructure

### 4.1 AGENTS.md

- Add orchestration agents to Delegation Routing table
- Update Workflow Selection matrix:

| User intent | Agent | Why |
|------------|-------|-----|
| Full lifecycle | autopilot | Autonomous pipeline |
| Must complete with proof | ralph | Persistence + verification loop |
| Multiple independent files | team | Parallel execution |
| Needs consensus | ralplan | Multi-perspective planning |
| Parallel tasks | ultrawork | Fire-and-forget parallelism |

### 4.2 plugin.json

No changes needed — `agents/` directory already scanned.

### 4.3 Tests

| Test File | Changes |
|-----------|---------|
| `skills-validation.test.ts` | Adjust skill count (37 → ~29), remove orchestration skill tests |
| `agents-validation.test.ts` | Add orchestration agent tests (model, tools, persona) |
| `handoff-contracts.test.ts` | Move orchestration persistence tests to agent section |
| `run-agent-tests.sh` | Add autopilot, ralph, team, ralplan, ultrawork behavioral tests |
| `run-skill-tests.sh` | Remove orchestration skills, keep capability skills |
| `run-e2e-scenarios.sh` | Update to invoke via --agent instead of skill keywords |

### 4.4 Documentation

- `ARCHITECTURE.md` — Update Section 5 (Skill Orchestration → Agent Orchestration)
- `README.md` — Update workflow table
- `COPILOT.md` — Update agent/skill counts

---

## Phase 5: Validate

1. Full L1 test suite (adjusted counts)
2. L2 behavioral: all agents respond and are role-appropriate
3. L3 E2E: autopilot, ralph, team, ralplan — verify task() delegation in JSONL
4. Regression: capability skills still activate correctly

---

## Migration Order

```
Phase 1: autopilot (prototype, validate pattern)
  ↓ test + iterate
Phase 2a: ralph, team (most used orchestrators)
  ↓ test
Phase 2b: ralplan, ultrawork (consensus + parallel)
  ↓ test
Phase 2c: evaluate sciomc, self-improve, research-to-pr, deep-dive
  ↓ test
Phase 3: clean task() from all remaining skills
  ↓ test
Phase 4: update infrastructure (AGENTS.md, tests, docs)
  ↓ final test
Phase 5: validate everything, cut v0.3
```

---

## Risk Assessment

| Risk | Mitigation |
|------|-----------|
| Agent doesn't auto-route to autopilot | Tune description keywords, test auto-routing |
| Agent still doesn't delegate via task() | Accept as platform behavior, focus on outcome quality |
| Skill removal breaks keyword activation | Keep skills as lightweight triggers that reference agents |
| Test count regression | Track in CI, adjust thresholds |

---

## Success Metrics

| Metric | v0.2 (current) | v0.3 (target) |
|--------|----------------|---------------|
| Orchestration compliance | ~0% (agents ignore skill task() prescriptions) | N/A (agents decide themselves) |
| Sub-agent delegation rate | Low (agent prefers to work alone) | Higher (agent persona encourages delegation) |
| Persistence artifact creation | Unreliable | Reliable (agent persona includes persistence) |
| Architecture alignment | Misaligned (orchestration in skills) | Aligned (orchestration in agents, capabilities in skills) |
