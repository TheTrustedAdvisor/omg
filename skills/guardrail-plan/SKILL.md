---
name: guardrail-plan
description: "Write a plan with explicit must-have / must-not-have guardrails before implementation — prevents scope creep and clarifies intent"
tags:
  - planning
  - discipline
  - scope
---

## When to Use

- Before implementing a feature that touches a stable, well-tested interface
- When "just a small change" carries hidden blast radius
- When stakeholders or agents might gold-plate beyond the stated goal
- When backwards compatibility is a hard constraint
- When multiple valid implementation strategies exist and you need to rule some out explicitly

## When NOT to Use

- Greenfield work with no existing contract (write the design doc instead)
- Pure bug fixes where the expected behaviour is already defined by the failing test
- Trivial one-liner changes with no surface area

## The Guardrail Structure

Every plan gets two guard sections **before** the task breakdown:

```markdown
## Guardrails

**Must Have:**
- <Concrete, testable acceptance criterion>
- <Another criterion>

**Must NOT Have:**
- <Explicit out-of-scope item — name it so agents don't build it>
- <Another exclusion>
```

The "Must NOT Have" section is the key differentiator. It forces you to articulate what you are *not* building, which eliminates an entire class of scope creep and prevents agents from implementing plausible-but-wrong extensions.

## Proven Example

**Task:** Add `--json` flag to `omg validate`

```markdown
## Guardrails

**Must Have:**
- `--json` is a no-op on the data path — same validation logic, different output format
- When `--json` is set, stdout contains **only** the JSON object (no mixed text)
- Exit codes preserved: 0 = valid, 1 = errors found
- Exit code 2 introduced for infrastructure failures when `--json` is set
- Backwards compatibility: output without `--json` is **unchanged**

**Must NOT Have:**
- SARIF output (future concern, separate flag)
- Auto-detection of TTY to switch format (explicit flag only)
- New validation logic (this is presentation-only)
```

The "Must NOT Have" list prevented three plausible but out-of-scope extensions from being built.

## Full Plan Template

```markdown
# Plan: {Title}

**Created:** {date}
**Complexity:** LOW | MEDIUM | HIGH

## Context
{1-3 sentences: what exists today and why this change is needed}

**Precedent:** {link to existing similar pattern in the codebase}

## Guardrails

**Must Have:**
- {testable criterion}

**Must NOT Have:**
- {explicit exclusion}

## Output Schema (if applicable)
{JSON or TypeScript type for new structured output}

## Task Flow

### Step 1 — {Component}
**Files:** `{path}`
- {what to change}

**Acceptance Criteria:**
- {command} → {expected output}, exit {code}
```

## Workflow

1. **Write context first** — one sentence describing what exists today
2. **Find the precedent** — locate the existing similar pattern to follow
3. **Draft Must Have** — write 3–6 concrete, testable criteria
4. **Draft Must NOT Have** — name at least 2 explicit exclusions (the things someone might plausibly add)
5. **Add schema** — if the change produces structured output, define the TypeScript type before writing code
6. **Break into steps** — each step = one file group + one set of acceptance criteria
7. **Hand to executor** — share the plan file path, not the contents

## Checklist

- [ ] "Must NOT Have" section has ≥ 2 items
- [ ] Every "Must Have" item is verifiable with a command
- [ ] A precedent is cited (prevents reinventing patterns)
- [ ] Schema is defined before implementation (if applicable)
- [ ] Backwards compatibility is addressed explicitly
