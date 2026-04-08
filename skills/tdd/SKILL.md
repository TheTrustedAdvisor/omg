---
name: tdd
description: "Test-Driven Development mode — strict red-green-refactor discipline"
tags:
  - testing
  - tdd
  - development
---

## When to Use

- User says "tdd" or wants test-driven development
- New feature that should be built test-first
- User wants strict red-green-refactor discipline

## The Iron Law

**NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST.**

## Workflow

1. **RED:** Write a failing test for the feature. The test MUST fail when run. Do NOT write production code yet. Delegate to @omg:test-engineer if available.

2. **Verify RED:** Run the test via `bash`. If it passes → the test is wrong, rewrite it.

3. **GREEN:** Write ONLY enough production code to make the test pass. No extras. No "while I'm here." Delegate to @omg:executor if available.

4. **Verify GREEN:** Run the test via `bash`. Must pass now.

5. **REFACTOR:** Clean up the implementation without changing behavior. Tests must stay green. Delegate to @omg:code-simplifier if available.

6. **Verify REFACTOR:** Run all tests via `bash`. Must still pass.

7. **Repeat** from step 1 for the next feature increment.

## Enforcement

| If You See | Action |
|------------|--------|
| Code written before test | STOP. Delete code. Write test first. |
| Test passes on first run | Test is wrong. Fix it to fail first. |
| Multiple features in one cycle | STOP. One test, one feature. |
| Skipping refactor | Go back. Clean up before next feature. |

## Checklist

- [ ] Every production code change has a prior failing test
- [ ] Tests run after every change (red → green → refactor)
- [ ] Each cycle addresses exactly one behavior
- [ ] Refactor phase completed before moving on

## Trigger Keywords

tdd, test-driven, red green refactor

## Example

```bash
copilot -i "tdd: add email validation function"
```

## Quality Contract

- Failing test FIRST, then minimal code, then refactor
