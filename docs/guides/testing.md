# Testing Strategy

omg uses a 5-level testing strategy covering pipeline code, plugin conformity,
behavioral E2E, and cross-platform parity.

## Level 1: Unit Tests (`npm test`)

- **Location:** `test/` (mirrors `src/` structure)
- **Framework:** Vitest
- **Count:** 428+ tests
- **What:** Pipeline stages, importers, exporters, mappings, config, CLI commands
- **Fixtures:** `test/fixtures/omc/` (3 sample agents, 2 skills, hooks, rules)

```bash
npm test              # Run all
npm run test:watch    # Watch mode
npm run test:coverage # Coverage report
```

## Level 2: Plugin Conformity Tests (`test/plugin/`)

- **File:** `test/plugin/handoff-contracts.test.ts`
- **Count:** 34 tests
- **What:** Validates plugin agents and skills meet conformity standards:
  - Handoff contracts present on all producer agents
  - Plan persistence chain (planner → autopilot/ralph/team)
  - Review persistence chain (critic → code-reviewer → security-reviewer)
  - Research persistence chain (analyst → architect → debugger → tracer)
  - Cycle state tracking (ultraqa, ralph, autopilot, ralplan)
  - Copilot-native tool names (no OMC tool names)
  - No `invoke_agent` (must use `task`)
  - Delegation routing table with `model=` in all delegating agents
  - Agent-catalog completeness (all 19 agents listed)
  - Plugin structure (plugin.json, frontmatter, instruction length, no XML)

```bash
npx vitest run test/plugin/handoff-contracts.test.ts
```

## Level 3: Construction Agent Validation

Dev-agents that validate the plugin interactively via Copilot CLI.

| Agent | What it checks |
|-------|---------------|
| `quality-gate` | 10 standards: tool names, model routing, handoffs, XML, length |
| `parity-tracker` | OMC vs omg coverage comparison, BURNDOWN update |
| `e2e-validator` | 10 behavioral tests against installed plugin |

```bash
copilot -p "Read dev-agents/quality-gate.agent.md. Run all checks." --add-dir . --yolo -s
```

## Level 4: Behavioral E2E Tests

Test real agent behavior via Copilot CLI.

| Test | Agent | What it verifies |
|------|-------|-----------------|
| Explore | omg:explore | Finds files with paths + relationships |
| Architect | omg:architect | Analyzes code with file:line + trade-offs |
| Verifier | omg:verifier | Runs build/tests, PASS/FAIL with evidence |
| Executor | omg:executor | Modifies files on disk |
| Planner | omg:planner | Creates plan with persistence |
| Deep-interview | omg:deep-interview | Brownfield detection, Socratic questioning |
| TDD | tdd skill | Red phase: failing test, no production code |
| Agent-catalog | agent-catalog | Catalog-driven delegation to correct agent |
| Plan persistence | Cross-session | File written in session A, read in session B |
| store_memory | Cross-session | Memory written in session A, read in session B |

## Level 5: Cross-Platform Comparison (OMC vs omg)

Runs identical prompts on both Claude Code and Copilot CLI, scores against rubric.

- **Script:** `scripts/cross-platform-e2e.sh`
- **Judge:** `dev-agents/comparison-judge.agent.md`
- **Test:** `test/e2e/cross-platform.test.ts`

### Scenarios

| # | Scenario | Rubric Dimensions |
|---|----------|------------------|
| S1 | Explore | Completeness, accuracy, relationships, format, actionability |
| S2 | Architect | Algorithm ID, function list, trade-off, evidence, specificity |
| S3 | Verifier | Fresh evidence, verdict clarity, coverage, format, regression |
| S4 | Planner | Step count, acceptance criteria, codebase awareness, feasibility |
| S5 | Security | Findings, severity, evidence, remediation, coverage |

```bash
# Run one scenario
bash scripts/cross-platform-e2e.sh s1

# Run all scenarios
bash scripts/cross-platform-e2e.sh all

# Score outputs
copilot -p "Read dev-agents/comparison-judge.agent.md. Score the outputs in .omg/reviews/comparison/." --add-dir . --yolo -s
```

### Parity Target

**omg ≥ 80% of OMC quality** on the weighted rubric before release.

## CI Integration

- **Level 1+2:** Run on every push via `.github/workflows/ci.yml`
- **Level 3-5:** Manual or pre-release (require CLIs + API tokens)

### Skipped Tests

- `test/importers/microsoft-skills.test.ts` — requires `GITHUB_TOKEN` (real API)
- `test/registry/fetcher.test.ts` (8 tests) — requires `GITHUB_TOKEN`
- `test/e2e/cross-platform.test.ts` — requires both `claude` and `copilot` CLIs

## CI Security

Always use `--secret-env-vars` to protect sensitive environment variables:
```bash
copilot -p "..." --secret-env-vars=GITHUB_TOKEN,API_KEY --yolo -s
```
This strips values from shell environments and redacts from output.
