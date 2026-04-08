# Copilot SDK Integration Guide

omg provides full integration with the [GitHub Copilot SDK](https://github.com/github/copilot-sdk) (`@github/copilot-sdk`).

## Two Ways to Use omg with the SDK

### 1. File-Based (Recommended for most users)

The SDK wraps Copilot CLI, which reads `.github/agents/` and `.github/skills/` from your project. Simply run `omg add omc` and the SDK picks up the agents automatically.

```bash
omg add omc --source-dir ./omc-repo
# Files are in .github/agents/, .github/skills/, etc.
# SDK reads them via Copilot CLI — no additional config needed
```

### 2. Programmatic (For embedding Copilot in your app)

Use `createOmgSession()` for full programmatic control:

```typescript
import { createOmgSession } from '@mfalland/omg/exporters/copilot-sdk/create-session';

const { client, session } = await createOmgSession({
  ir: pipelineResult.output,  // from runPipeline()
  agent: 'architect',          // start with this agent
  autoApprove: true,           // auto-approve tool permissions
});

const response = await session.sendAndWait('Review the architecture');

// Cleanup
session.destroy();
await client.stop();
```

## What `createOmgSession()` Configures

| SDK Feature | What omg provides |
|---|---|
| `customAgents[]` | All agents from pipeline with `infer: true` (auto-selection) |
| `skillDirectories[]` | Paths to all generated SKILL.md directories |
| `mcpServers{}` | All MCP server configs (local/stdio) |
| `hooks` | Translatable hooks as shell command callbacks |
| `infiniteSessions` | Enabled by default (automatic context compaction) |
| `onPermissionRequest` | `approveAll` when `autoApprove: true` |
| System prompt | Custom instructions injected from pipeline |

## Session Config Without Runtime

If you just need the config object (not a running session):

```typescript
import { toSdkSessionConfig, serializeSdkConfig } from '@mfalland/omg/exporters/copilot-sdk/session-config';

// Convert pipeline output to SDK config
const config = toSdkSessionConfig(pipelineResult.output, {
  byokProvider: 'anthropic',  // optional: use provider-native model IDs
  skillsBasePath: './skills',  // optional: custom skills path
});

// Generate importable TypeScript file
const tsModule = serializeSdkConfig(config);
// → export const sessionConfig = { customAgents: [...], ... } as const;
```

## BYOK (Bring Your Own Key)

With BYOK, omg uses provider-native model IDs instead of Copilot model IDs:

```json
// .omg.json
{
  "byok": {
    "provider": "anthropic",
    "envVar": "ANTHROPIC_API_KEY"
  }
}
```

| Provider | Copilot Model ID | BYOK Native ID |
|---|---|---|
| Anthropic | `claude-opus-4-6` | `claude-opus-4-20250415` |
| Anthropic | `claude-sonnet-4-6` | `claude-sonnet-4-20250514` |
| Anthropic | `claude-haiku-4-5` | `claude-haiku-4-5-20251001` |
| OpenAI | `gpt-4.1` | `gpt-4.1` (same) |
| Google | `gemini-2.5-pro` | `gemini-2.5-pro` (same) |

## Defining Custom Tools

Use `defineOmgTool()` to add tools to SDK sessions:

```typescript
import { defineOmgTool } from '@mfalland/omg/exporters/copilot-sdk/create-session';

const statusTool = defineOmgTool('status', 'Show omg project status', async () => {
  return JSON.stringify({ agents: 19, skills: 36 });
});
```

## Type Safety

All omg output types are verified at compile time against the real SDK types:
- `SdkCustomAgent` → assignable to `CustomAgentConfig`
- `SdkMcpServerConfig` → assignable to `MCPLocalServerConfig`
- `SdkSessionConfig` → compatible with `SessionConfig`

If the SDK changes its types in a future version, our tests break at compile time — not at runtime.

## SDK Version Compatibility

| omg version | SDK version | Status |
|---|---|---|
| 0.1.x | `@github/copilot-sdk@0.2.1` | Verified |

The SDK is in Public Preview. omg pins its devDependency to a specific version. When the SDK goes GA, we'll update and verify compatibility.
