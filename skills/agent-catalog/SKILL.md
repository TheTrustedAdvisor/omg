---
name: agent-catalog
description: "Agent directory — lists all omg agents with their roles, models, and when to use each"
tags:
  - reference
  - delegation
---

## omg Agent Catalog

Use this catalog to decide which agent to spawn for a task. All agents are invoked via the `task` tool:

```
task(agent_type="omg:<name>", prompt="<task>", model="<model>", mode="background|sync")

# With effort control (Copilot CLI --effort flag):
copilot -p "<task>" --agent omg:<name> --effort <low|medium|high|xhigh> --yolo
```

### READ-ONLY Enforcement

READ-ONLY agents should be spawned with `--excluded-tools` to physically prevent file modifications:

```
# When spawning via copilot CLI (automation/CI):
copilot -p "..." --agent omg:architect --excluded-tools edit,create --yolo

# The task() tool does not support --excluded-tools directly,
# but the agent prompt enforces read-only behavior.
# For maximum security in CI, use copilot CLI with --excluded-tools.
```

### Deep Reasoning (opus-class)

| Agent | task() name | Purpose | Mode |
|-------|------------|---------|------|
| **architect** | `omg:architect` | Code analysis, root-cause diagnosis, architectural recommendations. READ-ONLY. | sync |
| **critic** | `omg:critic` | Final quality gate — multi-perspective review with severity ratings. READ-ONLY. | sync |
| **analyst** | `omg:analyst` | Requirements analysis — catches gaps, edge cases, undefined guardrails. READ-ONLY. | sync |
| **code-reviewer** | `omg:code-reviewer` | Severity-rated code review — spec compliance, security, SOLID, logic. READ-ONLY. | sync |
| **security-reviewer** | `omg:security-reviewer` | OWASP Top 10, secrets scanning, dependency audits. READ-ONLY. | sync |
| **code-simplifier** | `omg:code-simplifier` | Simplifies code for clarity without changing behavior. | sync |

### Balanced (sonnet-class)

| Agent | task() name | Purpose | Mode |
|-------|------------|---------|------|
| **executor** | `omg:executor` | Implements code changes — smallest viable diff, verified. | background |
| **debugger** | `omg:debugger` | Root-cause analysis, minimal fixes, build error resolution. | sync |
| **verifier** | `omg:verifier` | Evidence-based completion checks — fresh test output, PASS/FAIL. | sync |
| **test-engineer** | `omg:test-engineer` | Test strategy, TDD, flaky test hardening. | background |
| **designer** | `omg:designer` | UI/UX — stunning, production-grade interfaces. | background |
| **git-master** | `omg:git-master` | Atomic commits, style-matched messages, safe rebasing. | sync |
| **qa-tester** | `omg:qa-tester` | Interactive CLI testing via tmux sessions. | sync |
| **scientist** | `omg:scientist` | Data analysis with statistical rigor. READ-ONLY. | sync |
| **tracer** | `omg:tracer` | Evidence-driven causal tracing with competing hypotheses. READ-ONLY. | sync |
| **document-specialist** | `omg:document-specialist` | External docs, API references, version compatibility. READ-ONLY. | background |

### Fast (haiku-class)

| Agent | task() name | Purpose | Mode |
|-------|------------|---------|------|
| **explore** | `omg:explore` | Fast codebase search — finds files, patterns, relationships. READ-ONLY. | background |
| **writer** | `omg:writer` | Technical documentation with verified code examples. | background |

## Delegation Decision Tree

```
Need to find files/patterns?
  → omg:explore (haiku, background)

Need to understand architecture?
  → omg:architect (opus, sync)

Need to implement code?
  → omg:executor (sonnet, background)

Need to fix a bug?
  → omg:debugger (sonnet, sync)

Need to verify work is done?
  → omg:verifier (sonnet, sync)

Need a code review?
  → omg:code-reviewer (opus, sync)

Need a security audit?
  → omg:security-reviewer (opus, sync)

Need to plan before coding?
  → omg:analyst (opus, sync) then omg:planner (opus, sync)

Need a quality gate on a plan?
  → omg:critic (opus, sync)

Need tests written?
  → omg:test-engineer (sonnet, background)

Need external docs?
  → omg:document-specialist (sonnet, background)

Need clean git history?
  → omg:git-master (sonnet, sync)
```

## Example Delegation

```
# Fast codebase search
task(agent_type="omg:explore", prompt="find all auth-related files", model="claude-haiku-4.5", mode="background")

# Deep architecture review
task(agent_type="omg:architect", prompt="analyze the auth module design", model="claude-opus-4.6", mode="sync")

# Implementation
task(agent_type="omg:executor", prompt="add input validation to createUser()", model="claude-sonnet-4.6", mode="background")

# Verification
task(agent_type="omg:verifier", prompt="verify createUser validation works", model="claude-sonnet-4.6", mode="sync")
```
