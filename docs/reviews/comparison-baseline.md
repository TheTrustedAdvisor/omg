## Cross-Platform Comparison Report

### Run 1 (2026-04-06) — Pre-fixes

| Scenario | OMC | omg | Winner |
|----------|-----|-----|--------|
| S1 Explore | 4.70 | 5.00 | omg |
| S2 Architect | 4.75 | 5.00 | omg |
| S3 Verifier | 5.00 | 0.00 | OMC (API failure) |
| S4 Planner | 5.00 | 4.15 | OMC |
| S5 Security | 5.00 | 4.20 | OMC |
| **Average** | **4.89** | **3.67 (75%)** | **OMC** |

### Run 2 (2026-04-07) — Post-fixes (#14 verifier retry, #16 analyst pre-flight, model ID fix)

| Scenario | OMC | omg | Winner |
|----------|-----|-----|--------|
| S1 Explore | 4.30 | 4.55 | omg |
| S2 Architect | 5.00 | 4.05 | OMC |
| S3 Verifier | 4.45 | 5.00 | **omg** (was 0.00!) |
| S4 Planner | 4.25 | 4.75 | **omg** (was 4.15) |
| S5 Security | — | — | (omg API timeout, skipped) |
| **Average (4 scenarios)** | **4.50** | **4.59 (102%)** | **omg** |

### Progress: 75% → 102%

| Fix | Impact |
|-----|--------|
| #14 Verifier retry/fallback | S3: 0.00 → 5.00 (+5.00) |
| #16 Analyst pre-flight in Direct mode | S4: 4.15 → 4.75 (+0.60) |
| Model ID dash→dot fix | Eliminated retry overhead on every task() call |

### Remaining Gap (Run 2)

S2 Architect: omg scored 4.05 vs OMC 5.00. omg listed only exported functions; OMC listed all internal helpers too. Fix: update architect prompt to always list both exported and internal symbols.

---

### Run 3 (2026-04-08) — v0.4.4 (25 agents, simplified architecture, Copilot CLI v1.0.21)

| Scenario | OMC Baseline | omg v0.4 | Winner |
|----------|-------------|----------|--------|
| S1 Explore | 4.30 | 5.00 (3.9 KB, tables, entry points, all dirs) | **omg** |
| S2 Architect | 5.00 | 5.00 (5.9 KB, pipeline pattern, 103 lines) | **tie** |
| S3 Verifier | 4.45 | 5.00 (PASS verdict with evidence table, proactively found stale test) | **omg** |
| S4 Planner | 4.25 | 5.00 (gap analysis BEFORE plan, 3 steps with acceptance criteria) | **omg** |
| S5 Security | — | 5.00 (structured report: 0 CRITICAL, 2 HIGH, 1 MEDIUM, 4 LOW) | **omg** (was timeout in Run 2) |
| **Average** | **4.50** | **5.00 (111%)** | **omg** |

### Progress: 75% → 102% → 111%

| Version | Average | vs OMC |
|---------|---------|--------|
| v0.1 (Run 1) | 3.67 | 75% |
| v0.2 (Run 2) | 4.59 | 102% |
| **v0.4 (Run 3)** | **5.00** | **111%** |

### What Changed (v0.2 → v0.4)

| Change | Impact |
|--------|--------|
| Architecture: Skills→Agents for orchestrators | Cleaner routing, less confusion |
| Agent simplification: 28→25 (merged ralph, ultrawork, ralplan) | Sharper descriptions, less overlap |
| AGENTS.md routing table at top | Better auto-routing for all scenarios |
| Action-oriented descriptions | Copilot picks the right agent more reliably |
| Planner has Consensus Protocol + analyst pre-flight | S4 now includes gap analysis automatically |
| Security-reviewer broader description | S5 finally completes (was timeout in v0.2) |
| Copilot CLI v1.0.21 tool enforcement | 20% delegation rate (was 5%) |
