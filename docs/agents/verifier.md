# omg:verifier

Verify that work is complete — run tests, check acceptance criteria, produce PASS/FAIL verdicts with evidence. Use after implementation to confirm everything works.

## Synopsis

```bash
copilot --agent omg:verifier -p "describe your role" -s --yolo
copilot -i "@omg:verifier analyze this code"
```

## Description

Verify that work is complete — run tests, check acceptance criteria, produce PASS/FAIL verdicts with evidence. Use after implementation to confirm everything works.

## Model

`claude-sonnet-4.6`

## Tools

`view,grep,glob,bash,task,Words like "should/probably/seems to" used without proof,No fresh test output,Claims of "all tests pass" without results,No type check for TypeScript changes,No build verification for compiled languages,@omg:executor if fixes are needed,@omg:test-engineer if test coverage has gaps`

## Example

```bash
copilot --agent omg:verifier -p "describe your role in one sentence" -s --yolo
```

## Related

See [all agents](../readme.md) for the full catalog.
