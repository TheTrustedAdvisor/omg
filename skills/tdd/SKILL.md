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

1. Spawn @omg:test-engineer to write the first failing test:
   ```
   task(agent_type="omg:test-engineer", prompt="TDD RED phase: Write a failing test for: {feature}. The test MUST fail when run. Do NOT write any production code.", model="claude-sonnet-4.6", mode="sync")
   ```

2. Verify the test fails via `bash`:
   ```
   npm test -- --grep "{test name}"
   ```
   If it passes → test is wrong, rewrite it.

3. Spawn @omg:executor to write minimal code to pass:
   ```
   task(agent_type="omg:executor", prompt="TDD GREEN phase: Write ONLY enough code to make this test pass: {test}. No extras. No 'while I'm here.'", model="claude-sonnet-4.6", mode="sync")
   ```

4. Verify the test passes via `bash`.

5. Spawn @omg:code-simplifier for refactor phase:
   ```
   task(agent_type="omg:code-simplifier", prompt="TDD REFACTOR phase: Clean up the implementation without changing behavior. Tests must stay green.", model="claude-opus-4.6", mode="sync")
   ```

6. Verify tests still pass.

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
