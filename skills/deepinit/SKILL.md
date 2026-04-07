---
name: deepinit
description: "Deep codebase initialization — generate comprehensive documentation for unfamiliar codebases"
tags:
  - documentation
  - onboarding
---

## When to Use

- Starting work on an unfamiliar codebase
- User says "deepinit" or wants codebase docs generated
- Need architecture overview, component map, or dependency analysis
- Onboarding a new team member

## Workflow

### Phase 1: Explore

Map the entire project structure:
```
task(agent_type="omg:explore", prompt="THOROUGH exploration: map all directories, entry points, config files, test structure, CI/CD. Report with absolute paths.", model="claude-haiku-4.5", mode="sync")
```

### Phase 2: Analyze

Invoke @omg:architect for deep analysis:
```
task(agent_type="omg:architect", prompt="Analyze codebase architecture. Identify: (1) core data flow, (2) key abstractions, (3) dependency graph, (4) design patterns, (5) testing strategy. Cite file:line.", model="claude-opus-4.6", mode="sync")
```

### Phase 3: Document

Invoke @omg:writer to produce structured documentation:
```
task(agent_type="omg:writer", prompt="Generate ARCHITECTURE.md from these findings: {explore + architect output}. Include: overview, component map, data flow, entry points, conventions, how to contribute.", model="claude-haiku-4.5", mode="sync")
```

### Phase 4: Output

Generate documentation set:
- `ARCHITECTURE.md` — system overview, component relationships
- `CONVENTIONS.md` — coding patterns, naming, testing approach
- `GETTING-STARTED.md` — setup, build, test, deploy

Save all to `.omg/research/deepinit/`:
```
.omg/research/deepinit/
├── ARCHITECTURE.md
├── CONVENTIONS.md
└── GETTING-STARTED.md
```

## Checklist

- [ ] Full project structure mapped
- [ ] Architecture patterns identified with file:line
- [ ] Data flow documented
- [ ] Entry points listed
- [ ] Conventions extracted from existing code
- [ ] Docs saved to `.omg/research/deepinit/`
