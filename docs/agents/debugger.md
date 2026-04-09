# omg:debugger

Debug and FIX — find the root cause, apply the minimal fix, verify it works. Use when something is broken and needs to be working again.

## Synopsis

```bash
copilot --agent omg:debugger -p "describe your role in one sentence" -s --yolo
copilot -i "use omg:debugger to help with this"
```

## Description

```mermaid
graph LR
    Bug[Bug Report] --> DB[omg:debugger]
    DB -->|reproduce| R[Reproduction]
    R -->|diagnose| RC[Root Cause]
    RC -->|minimal fix| FIX[Fixed + Verified]
    DB -.->|3 failures| AR[omg:architect]
    
    style DB fill:#ff922b,color:#fff
    style FIX fill:#51cf66,color:#000
    style AR fill:#cc5de8,color:#fff
```

Debug and FIX — find the root cause, apply the minimal fix, verify it works. Use when something is broken and needs to be working again.

## Model

`claude-sonnet-4.6`

## Tools

`view,grep,glob,bash,edit,task`

## Example

```bash
copilot --agent omg:debugger -p "describe your role and primary value" -s --yolo
```

## Quality Contract

- Reproduces BEFORE investigating
- One hypothesis at a time (no bundled fixes)
- After 3 failed hypotheses → escalates to omg:architect

## Related

See [all agents](../readme.md) for the full catalog.

## See Also

- [All agents](../readme.md)
- [Best practices](../../best-practices.md)
