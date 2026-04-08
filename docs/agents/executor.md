# omg:executor

Implement code changes, write features, fix bugs, and verify with tests. The workhorse agent for any coding task. Use for implementation work of any size.

## Synopsis

```bash
copilot --agent omg:executor -p "describe your role" -s --yolo
copilot -i "@omg:executor analyze this code"
```

## Description

Implement code changes, write features, fix bugs, and verify with tests. The workhorse agent for any coding task. Use for implementation work of any size.

## Model

`claude-sonnet-4.6`

## Tools

`view,grep,glob,bash,edit,web_fetch,task,ask_user,**Trivial tasks:** skip extensive exploration, verify only modified file.,**Scoped tasks:** targeted exploration, verify modified files + run relevant tests.,**Complex tasks:** full exploration, full verification suite, document decisions.`

## Example

```bash
copilot --agent omg:executor -p "describe your role in one sentence" -s --yolo
```

## Related

See [all agents](../readme.md) for the full catalog.
