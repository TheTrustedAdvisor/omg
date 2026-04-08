# omg Examples — Try These Now

Copy-paste these commands to see omg in action. Each example shows the command and what to expect.

---

## 1. Meet the Team

```bash
copilot -i "about omg"
```

**Expected output:**
```
╔═══════════════════════════════════════════════════════╗
║  omg — Multi-Agent Orchestration for GitHub Copilot   ║
╚═══════════════════════════════════════════════════════╝

Version:      0.4.14
Agents:       25 (19 specialists + 6 orchestrators)
Skills:       42 (capability triggers + discovery)
Architecture: Agents orchestrate, skills provide capabilities

Orchestrators:  autopilot · team · research-to-pr
                sciomc · self-improve · deep-dive

Specialists:    architect · analyst · planner · critic · executor
                debugger · verifier · code-reviewer · security-reviewer
                ...
```

---

## 2. Quick Side-Question (btw)

```bash
copilot -i "btw what is the difference between vitest and jest?"
```

**Expected output:**
```
Vitest is built on Vite with native ESM support — no transpilation
overhead, near-instant startup. Jest uses a custom transform pipeline
and is slower for TypeScript/ESM projects. Both have nearly identical
APIs, so most Jest tests run in Vitest with minimal changes.

(btw answered — continuing with your task)
```

Works in any language:
```bash
copilot -i "btw was ist TF-IDF?"
```
```
TF-IDF (Term Frequency–Inverse Document Frequency) gewichtet Wörter
nach Häufigkeit im Dokument vs. Seltenheit im Gesamtkorpus.

(btw beantwortet — weiter mit deiner Aufgabe)
```

---

## 3. Explore a Codebase

```bash
copilot -i "find all test files" --agent omg:explore
```

**Expected output:**
```
## Findings

45 test files across 3 types:

| Group | Files |
|-------|-------|
| CLI | cli/translate.test.ts, cli/validate.test.ts, cli/report.test.ts |
| Pipeline | pipeline/merge.test.ts, pipeline/match.test.ts, ... (8) |
| Importers | importers/omc/agents.test.ts, ... (6) |
| Exporters | exporters/copilot-cli/agents.test.ts, ... (5) |
...
```

---

## 4. Security Audit

```bash
copilot -i "review src/exporters/ for security issues" --agent omg:security-reviewer
```

**Expected output:**
```
# Security Review Report

Scope: src/exporters/
Risk Level: HIGH

## Summary
- Critical Issues: 0
- High Issues: 2
- Medium Issues: 1
- Low Issues: 4

## High Issues

### H1: SAFE_COMMAND_PATTERN allows ${} variable expansion
File: src/exporters/copilot-cli/hooks.ts:22
...
```

---

## 5. Plan Before Building

```bash
copilot -i "plan: add input validation to CLI commands"
```

**Expected output:**
```
Gap analysis:
- init.ts: --sources has zero validation
- status.ts: config load errors silently swallowed

## Work Plan: Input Validation

Step 1 — Validate --sources in init.ts
  Acceptance: empty/whitespace strings rejected with error message

Step 2 — Guard JSON.parse in status.ts
  Acceptance: corrupt .omg.json shows user-friendly error

Step 3 — Add tests
  Acceptance: npm test passes with new validation tests
```

---

## 6. Full Autopilot

```bash
copilot -i "autopilot: add a --version flag to the CLI"
```

**Expected output:**
```
[omg] autopilot: Analyzing requirements
  → exploring codebase for CLI structure
  → found src/cli.ts (entry point)

[omg] autopilot: Creating implementation plan
  → 3 steps with acceptance criteria

[omg] autopilot: Implementing story 1/3
  → task(omg:executor) adding --version flag

[omg] autopilot: Verifying
  → npm test: 541 passed
  → build: success

Done. 2 files modified, tests pass.
```

---

## 7. Multi-Language

```bash
# German
copilot -i "omg prüfe die Sicherheit dieses Projekts"

# French
copilot -i "omg vérifie la sécurité de ce projet"

# Japanese
copilot -i "omg このプロジェクトのセキュリティを確認して"
```

**Expected:** Each routes to the security-reviewer agent and responds in the user's language.

---

## 8. Parallel Team Execution

```bash
copilot -i "team 3: add JSDoc to src/mappings/ — one file per worker"
```

**Expected output:**
```
[omg] team: 3 workers dispatched
  → worker-1 (sonnet, bg) — omc-tool-names.ts
  → worker-2 (sonnet, bg) — omc-model-names.ts
  → worker-3 (sonnet, bg) — omc-event-names.ts

[omg] team: all workers complete
  → verifying combined result
  → npm test: pass
```

---

## 9. Cloud Delegation (PR)

```bash
copilot -i "research-to-pr: fix the auth token expiry bug"
```

**Expected output:**
```
[omg] research-to-pr: Phase 1 — Research
  → exploring auth-related files
  → tracing token lifecycle
  → finding: token refresh missing in middleware

[omg] research-to-pr: Phase 2 — Synthesize
  → root cause: refreshToken() not called on 401

Want me to /delegate this to create a PR? (y/n)
```

---

## 10. Help & Tutorial

```bash
copilot -i "help"          # Quick reference
copilot -i "tutorial"      # Interactive walkthrough
copilot -i "agent-catalog" # Full agent directory
```

---

## Documentation Standard

Every omg skill and agent should include:

1. **Copy-paste command** — ready to run
2. **Expected output** — what the user will see
3. **Works in any language** — note if multi-language tested
4. **Trigger keywords** — what activates it
