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

Thoroughly map the entire project structure: all directories, entry points, config files, test structure, CI/CD. Report with absolute paths. @omg:explore can help with this.

### Phase 2: Analyze

Perform deep architectural analysis: identify (1) core data flow, (2) key abstractions, (3) dependency graph, (4) design patterns, (5) testing strategy. Cite file:line references. @omg:architect can help with this.

### Phase 3: Document

Generate structured documentation from the exploration and analysis findings. Include: overview, component map, data flow, entry points, conventions, how to contribute. @omg:writer can help with this.

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
