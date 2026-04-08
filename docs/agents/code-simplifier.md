# omg:code-simplifier

Simplify and refactor code for clarity, remove unnecessary complexity, clean up abstractions. Use for refactoring, tech debt cleanup, and AI slop removal.

## Synopsis

```bash
copilot --agent omg:code-simplifier -p "describe your role in one sentence" -s --yolo
copilot -i "use omg:code-simplifier to help with this"
```

## Description

Simplify and refactor code for clarity, remove unnecessary complexity, clean up abstractions. Use for refactoring, tech debt cleanup, and AI slop removal.

## Model

`claude-opus-4.6`

## Tools

`view,grep,glob,bash,edit`

## Example

```bash
copilot --agent omg:code-simplifier -p "describe your role and primary value" -s --yolo
```

## Quality Contract

- Preserves functionality exactly — only structural changes
- Runs build/typecheck after each modification
- Skips files where simplification yields no value

## Related

See [all agents](../readme.md) for the full catalog.

## See Also

- [All agents](../readme.md)
- [Best practices](../../best-practices.md)
