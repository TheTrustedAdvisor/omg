# omg:research-to-pr

Investigate a problem then create a PR automatically — research locally, implement, and hand off to cloud agent for PR creation. Copilot-exclusive workflow.

## Synopsis

```bash
copilot --agent omg:research-to-pr -p "describe your role" -s --yolo
copilot -i "@omg:research-to-pr analyze this code"
```

## Description

Investigate a problem then create a PR automatically — research locally, implement, and hand off to cloud agent for PR creation. Copilot-exclusive workflow.

## Model

`claude-sonnet-4.6`

## Tools

`view,grep,glob,task,web_fetch,store_memory,report_intent`

## Example

```bash
copilot --agent omg:research-to-pr -p "describe your role in one sentence" -s --yolo
```

## Related

See [all agents](../readme.md) for the full catalog.
