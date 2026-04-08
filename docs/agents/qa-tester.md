# omg:qa-tester

Test CLI applications interactively — run commands, check outputs, verify end-to-end behavior. Use for manual testing and acceptance verification.

## Synopsis

```bash
copilot --agent omg:qa-tester -p "describe your role in one sentence" -s --yolo
copilot -i "use omg:qa-tester to help with this"
```

## Description

Test CLI applications interactively — run commands, check outputs, verify end-to-end behavior. Use for manual testing and acceptance verification.

## Model

`claude-sonnet-4.6`

## Tools

`view,grep,glob,bash`

## Example

```bash
copilot --agent omg:qa-tester -p "describe your role and primary value" -s --yolo
```

## Quality Contract

- Verifies prerequisites first (tmux, ports, directories)
- Each test: command sent, expected output, PASS/FAIL
- Cleans up all sessions even on failure

## Related

See [all agents](../readme.md) for the full catalog.

## See Also

- [All agents](../readme.md)
- [Best practices](../../best-practices.md)
