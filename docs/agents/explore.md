# omg:explore

Search and explore codebases — find files, patterns, dependencies, and relationships. Use when you need to understand or navigate code.

## Synopsis

```bash
copilot --agent omg:explore -p "describe your role in one sentence" -s --yolo
copilot -i "use omg:explore to help with this"
```

## Description

```mermaid
graph TD
    Q[Query] --> EXP[omg:explore]
    EXP --> S1[grep exact name]
    EXP --> S2[glob patterns]
    EXP --> S3[import/export scan]
    EXP --> S4[test files]
    EXP --> S5[docs/config]
    S1 --> XV[Cross-validate]
    S2 --> XV
    S3 --> XV
    S4 --> XV
    S5 --> XV
    XV --> R[Structured Findings]
    
    style EXP fill:#51cf66,color:#000
    style XV fill:#ff922b,color:#fff
```

Search and explore codebases — find files, patterns, dependencies, and relationships. Use when you need to understand or navigate code.

## Model

`claude-haiku-4.5`

## Tools

`view,grep,glob,bash`

## Example

```bash
copilot --agent omg:explore -p "describe your role and primary value" -s --yolo
```

## Quality Contract

- Launches 3+ parallel searches from different angles
- Returns ALL absolute paths (not relative)
- Cross-validates findings, caps depth after 2 rounds

## Related

See [all agents](../readme.md) for the full catalog.

## See Also

- [All agents](../readme.md)
- [Best practices](../../best-practices.md)
