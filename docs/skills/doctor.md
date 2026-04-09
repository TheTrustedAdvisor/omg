# doctor

Health check — verifies omg plugin is correctly installed and working.

## Synopsis

```bash
copilot -i "doctor"
copilot -i "is omg working?"
copilot -i "health check"
```

## Description

Runs 7 diagnostic checks and reports a HEALTHY/UNHEALTHY verdict. Use after installing omg or when something seems off.

## Trigger Keywords

doctor, health check, check omg, is omg working, diagnose

## Example

```bash
copilot -i "doctor"
```

**Expected output:**
```
╔═════════════════════════════════════╗
║       omg Health Check Report       ║
╚═════════════════════════════════════╝

Plugin:       ✓ omg installed (v0.5.4)
CLI:          ✓ Copilot CLI v1.0.21
Agents:       ✓ 25 agents loaded
Skills:       ✓ 43 skills loaded
AGENTS.md:    ✓ Routing table active
Persistence:  ✓ .omg/ directories ready
Model:        ⚠ model: field not yet enforced

Status: HEALTHY
```

## Quality Contract

- All 7 checks run with evidence
- Clear verdict: HEALTHY or UNHEALTHY
- Fix commands for any failures

## Related

- [about](about.md) — version + architecture info
- [help](help.md) — agent + skill catalog
- [tutorial](tutorial.md) — interactive walkthrough

## See Also

- [All skills](../readme.md)
