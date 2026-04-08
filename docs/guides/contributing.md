# Contributing to omg

## Prerequisites

- Node.js 20 or 22 (both are tested in CI)
- npm (comes with Node.js)
- Git

## Development Setup

```bash
git clone https://github.com/TheTrustedAdvisor/omg.git
cd omg
npm ci
```

Run the full validation suite to confirm your environment is working:

```bash
npm run validate   # typecheck + lint + test
```

## Project Structure

```
src/
├── cli.ts                    # CLI entry point (translate, validate, report commands)
├── pipeline.ts               # Orchestrator: runs importers → stages → exporters
├── types/
│   ├── ir.ts                 # IR type definitions (AgentDef, SkillDef, etc.)
│   ├── pipeline.ts           # PipelineConfig, PipelineOutput, ImportResult, etc.
│   └── sources.ts            # Source registry types
├── importers/
│   ├── base.ts               # Importer interface
│   ├── omc/                  # OMC importer (7 sub-modules)
│   ├── microsoft-skills.ts   # Microsoft repos importer
│   ├── awesome-copilot.ts    # awesome-copilot README importer
│   └── copilot-native.ts     # Pass-through importer
├── pipeline/
│   ├── merge.ts              # Dedup + conflict resolution
│   ├── match.ts              # TF-IDF cross-source matching
│   ├── enhance.ts            # tmux→/fleet, handoff injection
│   └── validate.ts           # IR completeness check
├── exporters/
│   ├── base.ts               # Exporter interface
│   ├── copilot-cli/          # CLI exporter (5 hook events)
│   └── copilot-vscode/       # VS Code exporter (8 hook events)
├── mappings/                 # Normalization tables (tool names, model names, events)
├── schemas/                  # AJV schemas for output validation
├── validators/               # Output validator (runs after export)
├── reporters/                # Translation report generator
└── registry/                 # Skill registry lockfile and fetcher

test/
├── fixtures/omc/             # Minimal OMC fixture repo for unit/integration tests
│   ├── agents/               # architect.md, debugger.md, executor.md
│   ├── skills/               # autopilot.md, ralph.md
│   ├── rules/                # typescript.md, testing.md
│   └── CLAUDE.md
└── manual/
    ├── expected-results.md   # Copilot integration test reference
    ├── run-copilot-test.sh   # Structural output checks (no Copilot token needed)
    └── copilot-cli-integration.sh  # Live Copilot CLI tests (requires COPILOT_TOKEN)
```

## Development Workflow

### Build and watch

```bash
npm run build      # One-shot TypeScript compile via tsup
npm run dev        # Watch mode — recompiles on file changes
```

The compiled output goes to `dist/`. The CLI entry point is `dist/cli.js`.

### Running the CLI locally

```bash
# After build:
node dist/cli.js translate test/fixtures/omc ./output --dry-run
node dist/cli.js translate test/fixtures/omc ./output --target both
node dist/cli.js validate ./output
node dist/cli.js report test/fixtures/omc
```

## Testing

### Test levels

| Level | Command | What it tests |
|-------|---------|---------------|
| Unit | `npm test` | Importers, exporters, pipeline stages against fixtures |
| Schema validation | `npm test` | AJV output validation in integration tests |
| Integration | `npm test` | Full pipeline: import → merge → export against fixtures |
| Smoke | CI only | `run-copilot-test.sh` + optional Copilot CLI live tests |

All tests use [Vitest](https://vitest.dev/) with file snapshots.

### Running tests

```bash
npm test              # Run all tests once
npm run test:watch    # Watch mode
npm run test:snapshots  # Update vitest file snapshots
```

### Updating fixtures

If you change importer behavior or add new fixture files, update the snapshots:

```bash
npm run test:snapshots
```

If you need to regenerate fixtures from a live OMC repo:

```bash
npm run fixtures:update -- /path/to/omc-repo
```

### Writing a unit test

Tests live alongside source files or in a `__tests__/` subdirectory. Follow the existing pattern: use fixture input, assert on output structure, use vitest `toMatchFileSnapshot` for file content.

```typescript
import { describe, it, expect } from 'vitest';
import { myImporter } from '../src/importers/my-importer.js';

describe('myImporter', () => {
  it('produces SkillDef from fixture', async () => {
    const result = await myImporter.import({ ... });
    expect(result.skills).toHaveLength(1);
    expect(result.skills[0].id).toBe('my/skill');
  });
});
```

## Code Style

### TypeScript

- Strict mode is enabled (`tsconfig.json` — `strict: true`)
- No `any` types; use `unknown` + type guards where needed
- Prefer `interface` for IR types, `type` for aliases and unions
- Use `.js` extensions in imports (ESM with tsup)

### ESLint

The project uses ESLint with a flat config (`eslint.config.js`). Run the linter:

```bash
npm run lint
```

Rules of note:
- No unused variables or imports
- Consistent type imports (`import type { ... }`)
- No floating promises

### General conventions

- Pipeline stages are pure functions where possible: they receive `PipelineOutput` and return a new `PipelineOutput`
- Importers and exporters are async and may do I/O
- All IR types carry a `source: SourceRef` — never strip provenance
- The `translatable` flag on `HookDef` is the correct way to handle unsupported events — do not add special-case logic in exporters

## Adding a New Importer

1. Create `src/importers/my-source.ts`
2. Implement the `Importer` interface:

```typescript
import type { Importer } from './base.js';
import type { ImportResult } from '../types/pipeline.js';

export const mySourceImporter: Importer = {
  name: 'my-source',
  async import(config): Promise<ImportResult> {
    // Fetch / parse your source
    // Map to IR types (AgentDef, SkillDef, etc.)
    return {
      agents: [],
      skills: [...],
      hooks: [],
      instructions: [],
      mcpConfigs: [],
      warnings: [],
    };
  },
};
```

3. Register it in `src/cli.ts` where importers are assembled based on `--sources`
4. Add fixture files in `test/fixtures/my-source/`
5. Write unit tests

## Adding a New Exporter

1. Create `src/exporters/my-target/index.ts`
2. Implement the `Exporter` interface:

```typescript
import type { Exporter } from '../base.js';
import type { ExportResult } from '../../types/pipeline.js';

export const myTargetExporter: Exporter = {
  name: 'my-target',
  async export(output, config): Promise<ExportResult> {
    // Write files to config.outputDir
    return { files: [...], warnings: [] };
  },
};
```

3. Register it in `src/cli.ts` under the `--target` option
4. Add schema validation in `src/schemas/` if the target has a fixed format
5. Write integration tests using fixtures

## PR Process

1. Create a branch from `main`
2. Make your changes
3. Run `npm run validate` — this runs typecheck + lint + test
4. Open a PR against `main`
5. CI runs on Node 20 and 22 — both must pass

### Commit messages

Use conventional commit format:
- `feat:` — new importer, exporter, pipeline stage, or CLI command
- `fix:` — bug fix
- `chore:` — dependency updates, CI changes, fixture regeneration
- `docs:` — documentation only
- `refactor:` — internal restructuring without behavior change
- `test:` — test additions or fixes

### What gets reviewed

- Does the change adhere to Copilot-Native-First? (No compat wrappers, no hacks)
- Does the IR type change break existing importers or exporters?
- Are new untranslatable features documented in the report rather than silently dropped?
- Are fixture snapshots updated?
