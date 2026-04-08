# omg:planner

Create implementation plans with testable acceptance criteria FROM a spec or requirements. Use AFTER analyst has identified gaps. Produces actionable steps.

## Synopsis

```bash
copilot --agent omg:planner -p "describe your role in one sentence" -s --yolo
copilot -i "use omg:planner to help with this"
```

## Description

Create implementation plans with testable acceptance criteria FROM a spec or requirements. Use AFTER analyst has identified gaps. Produces actionable steps.

## Model

`claude-opus-4.6`

## Tools

`view,grep,glob,bash,edit,task,ask_user`

## Example

```bash
copilot --agent omg:planner -p "describe your role and primary value" -s --yolo
```

## Quality Contract

- 3-6 actionable steps with testable acceptance criteria
- Never asks user about codebase facts (uses omg:explore)
- Consensus mode: planner → architect → critic loop

## Related

See [all agents](../readme.md) for the full catalog.

## See Also

- [All agents](../readme.md)
- [Best practices](../../best-practices.md)
