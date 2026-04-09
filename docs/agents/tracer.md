# omg:tracer

Investigate WHY without fixing — generate competing hypotheses, rank by evidence, recommend next probe. Use when you need to UNDERSTAND a problem, not fix it yet.

## Synopsis

```bash
copilot --agent omg:tracer -p "describe your role in one sentence" -s --yolo
copilot -i "use omg:tracer to help with this"
```

## Description

```mermaid
graph TD
    OBS[Observation] --> TR[omg:tracer]
    TR --> H1[Hypothesis 1]
    TR --> H2[Hypothesis 2]
    TR --> H3[Hypothesis 3]
    H1 -->|evidence for/against| RANK[Rank by strength]
    H2 -->|evidence for/against| RANK
    H3 -->|evidence for/against| RANK
    RANK --> BEST[Best Explanation + Probe]
    
    style TR fill:#ff922b,color:#fff
    style RANK fill:#ffd43b,color:#000
```

Investigate WHY without fixing — generate competing hypotheses, rank by evidence, recommend next probe. Use when you need to UNDERSTAND a problem, not fix it yet.

## Model

`claude-sonnet-4.6`

## Tools

`view,grep,glob,bash`

## Example

```bash
copilot --agent omg:tracer -p "describe your role and primary value" -s --yolo
```

## Quality Contract

- At least 2 competing hypotheses
- Evidence ranked by strength (reproduction > inference > speculation)
- Pre-mortem on best explanation: assume it's wrong

## Related

See [all agents](../readme.md) for the full catalog.

## See Also

- [All agents](../readme.md)
- [Best practices](../../best-practices.md)
