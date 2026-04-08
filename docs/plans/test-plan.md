# omg — Comprehensive Test Plan

**Version:** 1.0
**Date:** 2026-04-07
**Scope:** 19 agents, 37 skills, orchestration workflows

---

## Test Levels

| Level | Type | Execution | Coverage |
|-------|------|-----------|----------|
| **L1** | Static Validation (vitest) | Automated, CI | Structure, content, cross-references |
| **L2** | Behavioral CLI | Semi-automated (requires Copilot CLI) | Agent/skill invocation, response quality |
| **L3** | Orchestration E2E | Manual/semi-automated | Multi-agent workflows, persistence, verification loops |

---

## L1: Static Validation Tests (vitest)

### L1.1 — Skill Structure Validation (37 skills)

Every skill MUST have:
- [ ] Valid YAML frontmatter with `name` and `description`
- [ ] `name` matches directory name
- [ ] Description is non-empty and < 200 chars
- [ ] Content length > 500 chars (meaningful instructions)
- [ ] No OMC tool names (`Read`, `Grep`, `Glob`, `Bash`, `Edit`, `Write`)
- [ ] No OMC XML tags (`<Agent_Prompt>`, `<Role>`, `<Tool_Usage>`)
- [ ] No `invoke_agent` references (must use `task()`)
- [ ] No dash-format model IDs (`claude-opus-4-6` → must be `claude-opus-4.6`)

### L1.2 — Skill Category Tests

#### Orchestration Skills (9 skills)
Skills: `autopilot`, `ralph`, `team`, `ultrawork`, `ralplan`, `sciomc`, `self-improve`, `research-to-pr`, `deep-dive`

| Test | What | Skills |
|------|------|--------|
| Has Plan Discovery | References `.omg/plans/` and `store_memory` for finding existing plans | autopilot, ralph, team |
| Has Phase Output Persistence | Writes intermediate results to `.omg/` | autopilot, ralph, deep-dive |
| Has Cycle State Tracking | Tracks iteration state in `.omg/qa-logs/` | ralph, ultraqa |
| Uses task() delegation | Contains `task(agent_type="omg:` calls | ALL orchestration |
| Has parallel execution | Contains `mode="background"` | autopilot, team, ultrawork, sciomc, research-to-pr |
| Has verification phase | References `@omg:verifier` or verify step | autopilot, ralph, team |
| Has exit conditions | Defines when to stop (max iterations, acceptance criteria) | ralph, ultraqa, autopilot |
| Has anti-patterns / "Don't use when" | Defines scope limits | autopilot, ralph, team, deep-interview |

#### Planning Skills (3 skills)
Skills: `plan`, `deep-interview`, `deepinit`

| Test | What |
|------|------|
| plan has 3 modes | Interview, Direct, Consensus sections |
| plan has analyst pre-flight | `task(agent_type="omg:analyst"` in Direct mode |
| deep-interview has ambiguity scoring | References clarity ≥ 80% threshold |
| deep-interview has brownfield detection | Spawns @omg:explore for existing codebases |
| deepinit generates docs | References documentation generation |

#### Analysis Skills (5 skills)
Skills: `trace`, `deep-analyze`, `deepsearch`, `ultrathink`, `ultraqa`

| Test | What |
|------|------|
| trace uses competing hypotheses | References "hypotheses" and evidence ranking |
| ultrathink uses opus model | References `claude-opus-4.6` |
| ultraqa has same-failure detection | References `.omg/qa-logs/` and cycle tracking |
| deepsearch uses multi-angle approach | Not just grep |

#### TDD Skill
| Test | What |
|------|------|
| Has RED phase | @omg:test-engineer writes failing test |
| Has GREEN phase | @omg:executor writes minimal code |
| Has REFACTOR phase | @omg:code-simplifier cleans up |
| Strict discipline | "MUST fail", "ONLY enough code" |

#### Utility Skills (15 skills)
Skills: `debug`, `verify`, `ask`, `ccg`, `external-context`, `ai-slop-cleaner`, `cancel`, `release`, `learner`, `skillify`, `remember`, `session-memory`, `ms-discover`, `configure-notifications`, `visual-verdict`

| Test | What | Skills |
|------|------|--------|
| debug delegates to debugger | References `@omg:debugger` | debug |
| verify has PASS/FAIL | Evidence-based verdict | verify |
| ccg uses 3 models | Claude + Codex + Gemini | ccg |
| cancel lists all modes | autopilot, ralph, ultrawork, team, ultraqa | cancel |
| ms-discover has plugin detection | `copilot plugin list` | ms-discover |
| ms-discover has install prompts | Offers installation commands | ms-discover |

#### Reference Skills (2 skills)
Skills: `agent-catalog`, `handoff-protocol`

| Test | What |
|------|------|
| agent-catalog lists all 19 agents | Every `omg:` agent mentioned |
| handoff-protocol documents all .omg/ dirs | plans/, research/, reviews/, qa-logs/ |

### L1.3 — Agent Deep Validation (19 agents)

#### Model ID Consistency
Every agent frontmatter model MUST match AGENTS.md Delegation Routing table.

| Agent | Expected Model |
|-------|---------------|
| explore | claude-haiku-4.5 |
| writer | claude-haiku-4.5 |
| executor | claude-sonnet-4.6 |
| debugger | claude-sonnet-4.6 |
| verifier | claude-sonnet-4.6 |
| test-engineer | claude-sonnet-4.6 |
| designer | claude-sonnet-4.6 |
| git-master | claude-sonnet-4.6 |
| scientist | claude-sonnet-4.6 |
| tracer | claude-sonnet-4.6 |
| document-specialist | claude-sonnet-4.6 |
| qa-tester | claude-sonnet-4.6 |
| architect | claude-opus-4.6 |
| analyst | claude-opus-4.6 |
| planner | claude-opus-4.6 |
| critic | claude-opus-4.6 |
| code-reviewer | claude-opus-4.6 |
| security-reviewer | claude-opus-4.6 |
| code-simplifier | claude-opus-4.6 |

#### Handoff Contracts
Producers MUST have `## Handoff Contract` with persistence path:

| Agent | Persistence Path | store_memory Key |
|-------|-----------------|------------------|
| planner | `.omg/plans/` | `omg:active-plan` |
| analyst | `.omg/research/` | — |
| architect | `.omg/research/` | — |
| critic | `.omg/reviews/` | `omg:last-review` |
| code-reviewer | `.omg/reviews/` | `omg:last-review` |
| security-reviewer | `.omg/reviews/` | — |
| verifier | `.omg/reviews/` | `omg:last-review` |
| debugger | `.omg/research/` | — |
| tracer | `.omg/research/` | — |

#### Feature Awareness
| Feature | Agents That MUST Have It |
|---------|------------------------|
| MS Skills Awareness | architect, executor, debugger, planner |
| MCP Server Awareness | architect, document-specialist, debugger, planner |

#### Cross-Reference Consistency
- AGENTS.md Delegation Routing lists all 19 agents
- Every agent in Delegation Routing has a matching `.agent.md` file
- Delegation Routing model matches frontmatter model
- Delegation Routing mode matches agent usage pattern

---

## L2: Behavioral CLI Tests

### L2.1 — Agent Invocation (19 tests)

Each agent is invoked with a role-appropriate prompt and validated:

| Agent | Prompt | Expected Response Pattern |
|-------|--------|--------------------------|
| explore | "Map the directory structure of this project" | File listing, directory tree |
| architect | "What architecture pattern does this codebase use?" | Architecture terms, trade-offs |
| executor | "Add a comment to the README" | File modification attempt |
| debugger | "Why might tests fail in src/pipeline/?" | Root cause analysis, file:line refs |
| verifier | "Verify that all tests pass" | PASS/FAIL verdict with evidence |
| planner | "Plan how to add input validation" | Structured plan with criteria |
| analyst | "What requirements are missing for auth?" | Gap analysis, edge cases |
| critic | "Review this plan: add caching to API" | Multi-perspective critique |
| code-reviewer | "Review src/cli.ts for quality" | Severity-rated findings |
| security-reviewer | "Security audit of src/config.ts" | OWASP references, severity |
| test-engineer | "Write tests for the merge function" | Test code with assertions |
| designer | "Design a dashboard layout" | UI/UX suggestions |
| git-master | "Create a commit for the current changes" | Git operations |
| tracer | "Why did the build fail yesterday?" | Competing hypotheses |
| scientist | "Analyze test coverage trends" | Statistical analysis |
| writer | "Document the pipeline architecture" | Documentation output |
| document-specialist | "How does vitest snapshot testing work?" | External docs reference |
| code-simplifier | "Simplify the merge function" | Refactoring suggestions |
| qa-tester | "Test the CLI commands interactively" | Test execution |

**Validation criteria per agent:**
1. Agent responds (non-empty output)
2. Response is role-appropriate (contains domain terms)
3. No error messages in output
4. Response references Copilot-native tools (not OMC tools)
5. Communication protocol visible (report_intent or phase announcement)

### L2.2 — Skill Activation (37 tests)

Each skill is triggered and validated for activation:

| Category | Skill | Trigger Prompt | Expected Activation Signal |
|----------|-------|---------------|---------------------------|
| Orchestration | autopilot | "autopilot: add input validation" | Phase 1 announcement, analyst spawn |
| Orchestration | ralph | "ralph: fix all lint errors" | Plan Discovery, iteration counter |
| Orchestration | team | "team 3: fix TypeScript errors" | Parallel agent spawn, worker count |
| Orchestration | ultrawork | "ulw: refactor utils" | Parallel execution |
| Orchestration | ralplan | "ralplan: design auth system" | Planner/Architect/Critic loop |
| Orchestration | research-to-pr | "research-to-pr: fix auth bug" | Research phase, /delegate |
| Orchestration | sciomc | "sciomc: analyze performance data" | Staged scientist spawns |
| Orchestration | self-improve | "self-improve: optimize pipeline" | Hypothesis generation |
| Orchestration | deep-dive | "deep-dive: investigate memory leak" | Trace then interview stages |
| Planning | plan | "plan: add caching layer" | Interview or Direct mode |
| Planning | deep-interview | "deep interview: new feature idea" | Ambiguity scoring, questions |
| Planning | deepinit | "deepinit" | Codebase scanning, doc generation |
| Analysis | trace | "trace: why did deploy fail?" | Hypotheses with evidence |
| Analysis | deep-analyze | "deep-analyze: auth subsystem" | Multi-agent investigation |
| Analysis | deepsearch | "deepsearch: find all API endpoints" | Multi-angle search |
| Analysis | ultrathink | "ultrathink: should we use microservices?" | Deep reasoning, opus model |
| Analysis | ultraqa | "ultraqa: improve test coverage" | QA cycle state |
| TDD | tdd | "tdd: add email validation" | RED phase (failing test first) |
| Utility | debug | "debug: tests failing in pipeline" | @debugger delegation |
| Utility | verify | "verify the implementation" | PASS/FAIL with evidence |
| Utility | ask | "ask claude: explain this pattern" | Model routing |
| Utility | ccg | "ccg: best approach for caching" | 3-model comparison |
| Utility | external-context | "external-context: vitest API" | document-specialist spawn |
| Utility | ai-slop-cleaner | "clean AI slop in src/" | Pattern detection |
| Utility | cancel | "cancelomc" | Clean shutdown |
| Utility | release | "release: prepare v0.3.0" | Version bump, changelog |
| Utility | learner | "learn from this conversation" | Skill extraction |
| Utility | skillify | "skillify this workflow" | SKILL.md generation |
| Utility | remember | "remember: we use vitest not jest" | store_memory call |
| Utility | session-memory | "session-memory: save context" | Cross-session persistence |
| Utility | ms-discover | "ms-discover" | Plugin detection |
| Utility | configure-notifications | "configure notifications" | Integration setup |
| Utility | visual-verdict | "visual-verdict: compare screenshots" | Screenshot analysis |
| Utility | writer-memory | "writer-memory: track character arcs" | Writer state persistence |
| Utility | project-session-manager | "new session for issue #42" | Branch isolation |
| Reference | agent-catalog | "agent-catalog" | Full agent listing |
| Reference | handoff-protocol | "handoff-protocol" | Persistence documentation |

---

## L3: Orchestration E2E Scenarios

### Scenario 1: Autopilot Full Lifecycle
**Repo:** Any TypeScript project with tests
**Prompt:** `autopilot: add a --verbose flag to the CLI`
**Expected Flow:**
1. Phase 1 (Expand): analyst extracts requirements
2. Phase 2 (Plan): architect creates plan, critic reviews
3. Phase 3 (Execute): executor implements, tests run
4. Phase 4 (QA): architect + security-reviewer + code-reviewer validate
5. Phase 5 (Validate): Re-validate ALL reviewers
**Validation:**
- [ ] All 5 phases complete
- [ ] `.omg/plans/` contains plan file
- [ ] `.omg/research/` contains analysis
- [ ] `.omg/reviews/` contains review verdicts
- [ ] Tests pass at end
- [ ] Communication protocol visible throughout

### Scenario 2: Ralph Persistence Loop
**Repo:** Project with known lint errors
**Prompt:** `ralph: fix all ESLint errors`
**Expected Flow:**
1. Plan Discovery (checks `.omg/plans/`)
2. Implementation iteration
3. Verification → FAIL → fix → re-verify
4. Repeat until PASS or max iterations
**Validation:**
- [ ] `.omg/qa-logs/ralph-progress.md` tracks iterations
- [ ] Iteration counter visible in communication
- [ ] Stops on PASS (not infinite loop)
- [ ] Max iteration guard works

### Scenario 3: Team Parallel Execution
**Repo:** Project with 3+ independent files needing fixes
**Prompt:** `team 3: fix TypeScript errors across src/`
**Expected Flow:**
1. Plan Discovery
2. Task decomposition into 3 independent subtasks
3. 3 parallel background executors
4. Verification of all 3 results
**Validation:**
- [ ] 3 agents spawned (visible in logs)
- [ ] Parallel execution (not sequential)
- [ ] Dependency/conflict management
- [ ] Combined verification at end

### Scenario 4: TDD Red-Green-Refactor
**Repo:** Any project with test framework
**Prompt:** `tdd: add email validation function`
**Expected Flow:**
1. RED: test-engineer writes failing test
2. Verify test fails
3. GREEN: executor writes minimal code
4. Verify test passes
5. REFACTOR: code-simplifier cleans up
6. Verify tests still pass
**Validation:**
- [ ] Test written BEFORE production code
- [ ] Test actually fails initially
- [ ] Minimal implementation (not over-engineered)
- [ ] Refactor doesn't break tests

### Scenario 5: Deep Interview → Plan → Execute
**Repo:** New/empty project
**Prompt:** `deep interview: I want to build a REST API`
**Expected Flow:**
1. Ambiguity scoring of initial request
2. Socratic questions (3-5 rounds)
3. Clarity reaches ≥ 80%
4. Spec generated in `.omg/research/`
5. Transition to plan/execute
**Validation:**
- [ ] Questions are specific, not generic
- [ ] Ambiguity score decreases over rounds
- [ ] Spec captures all requirements from answers
- [ ] `.omg/research/spec-*.md` created

### Scenario 6: Ralplan Consensus
**Prompt:** `ralplan: design authentication system`
**Expected Flow:**
1. Planner creates initial plan
2. Architect reviews (antithesis + trade-offs)
3. Critic evaluates
4. If not approved: iterate
5. Converge on consensus plan
**Validation:**
- [ ] Multiple iterations visible
- [ ] Review history in `.omg/reviews/`
- [ ] Final plan incorporates feedback
- [ ] Convergence (doesn't loop forever)

### Scenario 7: Research-to-PR (Copilot-Exclusive)
**Prompt:** `research-to-pr: fix the auth token expiry bug`
**Expected Flow:**
1. Parallel research: explore + tracer + web search
2. Research synthesis
3. Implementation plan
4. Code changes via executor
5. `/delegate` to cloud agent → automatic PR
**Validation:**
- [ ] Research phase runs parallel agents
- [ ] `.omg/research/` contains findings
- [ ] PR created automatically (cloud handoff)
- [ ] PR description references research

---

## Test Execution Matrix

### CI (every push)
- L1.1: All 37 skill structure tests
- L1.2: All skill category tests
- L1.3: All 19 agent deep validation tests
- Existing: 374 pipeline tests

### Manual (before release)
- L2.1: All 19 agent behavioral tests
- L2.2: All 37 skill activation tests
- L3: All 7 orchestration E2E scenarios

### Nightly (optional CI with Copilot token)
- L2.1: Smoke subset (explore, executor, debugger)
- L2.2: Smoke subset (autopilot, ralph, plan)

---

## Success Criteria

| Metric | Target |
|--------|--------|
| L1 test count | ≥ 150 tests |
| L1 pass rate | 100% |
| L2 agent response rate | 19/19 agents respond |
| L2 skill activation rate | 37/37 skills activate |
| L3 scenario completion | 7/7 scenarios complete |
| Communication protocol visible | 100% of L2/L3 tests |
| No OMC tool name leaks | 0 occurrences |
| No dash-format model IDs | 0 occurrences |
