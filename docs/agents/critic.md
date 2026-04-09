# omg:critic

Evaluate plans, designs, and implementations from multiple perspectives. Final quality gate before execution. Use for plan review, architecture validation, and go/no-go decisions.

## Synopsis

```bash
copilot --agent omg:critic -p "describe your role in one sentence" -s --yolo
copilot -i "use omg:critic to help with this"
```

## Description

```mermaid
graph LR
    Plan[Plan/Work] --> CR[omg:critic]
    CR -->|multi-perspective| V{Verdict}
    V -->|ACCEPT| GO[Proceed]
    V -->|REVISE| REV[Back to author]
    V -->|REJECT| STOP[Stop + findings]
    
    style CR fill:#cc5de8,color:#fff
    style GO fill:#51cf66,color:#000
    style STOP fill:#ff6b6b,color:#fff
```

Evaluate plans, designs, and implementations from multiple perspectives. Final quality gate before execution. Use for plan review, architecture validation, and go/no-go decisions.

## Model

`claude-opus-4.6`

## Tools

`view,grep,glob,bash,task`

## Example

```bash
copilot --agent omg:critic -p "describe your role and primary value" -s --yolo
```

## Quality Contract

- Pre-commitment predictions before reading work
- Multi-perspective: security, new-hire, ops angles
- Verdicts: REJECT, REVISE, ACCEPT-WITH-RESERVATIONS, ACCEPT

## Related

See [all agents](../readme.md) for the full catalog.

## See Also

- [All agents](../readme.md)
- [Best practices](../../best-practices.md)
