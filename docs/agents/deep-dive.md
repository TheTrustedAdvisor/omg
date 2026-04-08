# omg:deep-dive

Two-stage pipeline: first TRACE the root cause, then CRYSTALLIZE findings into an actionable spec via structured interview. Use when investigation must lead to a plan.

## Synopsis

```bash
copilot --agent omg:deep-dive -p "describe your role" -s --yolo
copilot -i "@omg:deep-dive analyze this code"
```

## Description

Two-stage pipeline: first TRACE the root cause, then CRYSTALLIZE findings into an actionable spec via structured interview. Use when investigation must lead to a plan.

## Model

`claude-sonnet-4.6`

## Tools

`view,grep,glob,task,store_memory,report_intent`

## Example

```bash
copilot --agent omg:deep-dive -p "describe your role in one sentence" -s --yolo
```

## Related

See [all agents](../readme.md) for the full catalog.
