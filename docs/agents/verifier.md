# omg:verifier

Verify that work is complete — run tests, check acceptance criteria, produce PASS/FAIL verdicts with evidence. Use after implementation to confirm everything works.

## Synopsis

```bash
copilot --agent omg:verifier -p "describe your role in one sentence" -s --yolo
copilot -i "use omg:verifier to help with this"
```

## Description

Verify that work is complete — run tests, check acceptance criteria, produce PASS/FAIL verdicts with evidence. Use after implementation to confirm everything works.

## Model

`claude-sonnet-4.6`

## Tools

`view,grep,glob,bash,task,Words like "should/probably/seems to" used without proof,No fresh test output,Claims of "all tests pass" without results,No type check for TypeScript changes,No build verification for compiled languages`

## Example

```bash
copilot --agent omg:verifier -p "describe your role and primary value" -s --yolo
```

## Quality Contract

- Fresh test output ALWAYS (not assumed or remembered)
- Every acceptance criterion: VERIFIED, PARTIAL, or MISSING
- Verdicts: PASS, FAIL, INCOMPLETE with confidence level

## Related

See [all agents](../readme.md) for the full catalog.

## See Also

- [All agents](../readme.md)
- [Best practices](../../best-practices.md)
