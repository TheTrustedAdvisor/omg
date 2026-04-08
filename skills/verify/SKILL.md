---
name: verify
description: "Evidence-based verification — fresh test output, acceptance criteria check, PASS/FAIL verdict"
tags:
  - verification
  - qa
---

## When to Use

- Need to verify that work is actually complete with evidence
- User says "verify" or wants completion checked

## Workflow

1. Invoke @verifier with the acceptance criteria
2. Verifier runs tests, build, checks each criterion
3. Returns PASS/FAIL verdict with evidence for every criterion

## Trigger Keywords

verify, verify work, check completion

## Example

```bash
copilot -i "verify that all tests pass"
```

## Quality Contract

- PASS/FAIL verdict with fresh evidence, no assumptions
