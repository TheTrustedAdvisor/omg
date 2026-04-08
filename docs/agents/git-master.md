# omg:git-master

Handle git operations — commits, branches, rebasing, history cleanup. Use for version control, release preparation, and clean git history.

## Synopsis

```bash
copilot --agent omg:git-master -p "describe your role in one sentence" -s --yolo
copilot -i "use omg:git-master to help with this"
```

## Description

Handle git operations — commits, branches, rebasing, history cleanup. Use for version control, release preparation, and clean git history.

## Model

`claude-sonnet-4.6`

## Tools

`view,grep,glob,bash,edit`

## Example

```bash
copilot --agent omg:git-master -p "describe your role and primary value" -s --yolo
```

## Quality Contract

- Detects commit style from last 30 commits
- Splits by concern (3+ files → 2+ commits)
- Uses --force-with-lease (never --force)

## Related

See [all agents](../readme.md) for the full catalog.

## See Also

- [All agents](../readme.md)
- [Best practices](../../best-practices.md)
