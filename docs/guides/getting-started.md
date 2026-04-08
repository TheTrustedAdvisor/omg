# Getting Started with omg

> **omg is to GitHub Copilot what OMC is to Claude Code — you install it and everything works better.**

## Quick Start (2 minutes)

```bash
# Install omg
npm install -g @mfalland/omg

# Initialize in your project
cd your-project
omg init

# That's it. Your Copilot now has:
# - Optimized agents with smart model selection
# - Skills from the best sources
# - MCP server for in-chat management
# - Quality gate hooks
```

## What `omg init` Does

1. **Detects Copilot CLI** — verifies your installation
2. **Scans your project** — identifies Azure, Node.js, Python, etc.
3. **Creates `.omg.json`** — your project's omg configuration
4. **Writes output** — Copilot plugin files ready for `copilot plugin install`

## Adding Packages

```bash
# Add OMC agents (19 agents, 36+ skills)
omg add omc --source-dir /path/to/omc-repo

# Add Microsoft Fabric skills
omg add fabric

# Add Azure SQL skills
omg add azure-sql

# See all available packages
omg add --help
```

Available packages: `omc`, `fabric`, `azure-sql`, `azure`, `devops`, `power-platform`, `copilot-studio`, `community`

## Installing as a Copilot Plugin

omg's output is a native Copilot plugin:

```bash
# Install omg directly as a Copilot plugin
copilot plugin install TheTrustedAdvisor/omg
```

Or install generated output:

```bash
omg add omc --source-dir ./omc-repo --output ./my-plugin
copilot plugin install ./my-plugin
```

## Syncing Updates

```bash
# Re-fetch all configured packages
omg sync

# Sync a specific package
omg sync --source fabric
```

## Using omg in Copilot Chat

After `omg init`, the MCP server is registered. In Copilot Chat:

```
You: "Add Fabric skills to this project"
Copilot: [calls omg_add] → installs Fabric skills

You: "What packages do I have?"
Copilot: [calls omg_status] → shows installed packages, tier, counts

You: "Search for Kubernetes skills"
Copilot: [calls omg_search] → finds matching packages
```

## Configuration (`.omg.json`)

```json
{
  "tier": "business",
  "sources": ["omc", "fabric"],
  "target": "both",
  "modelStrategy": "auto-only",
  "mcpServers": { "obs": true },
  "byok": {
    "provider": "anthropic",
    "envVar": "ANTHROPIC_API_KEY"
  }
}
```

| Field | Description | Default |
|---|---|---|
| `tier` | Copilot subscription: individual, business, enterprise | — |
| `sources` | Installed packages | `["omc"]` |
| `target` | Export target: cli, vscode, both | `cli` |
| `modelStrategy` | auto-only or override-all | `auto-only` |
| `mcpServers` | Enable/disable MCP servers | `{}` |
| `byok` | Bring Your Own Key config | — |

## BYOK (Bring Your Own Key)

Use your own API keys instead of Copilot's model access:

```json
{
  "byok": {
    "provider": "anthropic",
    "envVar": "ANTHROPIC_API_KEY"
  }
}
```

Supported providers: `anthropic`, `openai`, `azure`, `google`

With BYOK, model IDs in exported agents use provider-native format (e.g., `claude-opus-4-20250415` instead of `claude-opus-4-6`).

## What Gets Generated

```
.github/
├── agents/
│   ├── architect.agent.md      # Architecture advisor (read-only)
│   ├── executor.agent.md       # Task executor (full tools)
│   └── debugger.agent.md       # Root-cause analyst
├── skills/
│   ├── autopilot/SKILL.md      # Autonomous execution
│   └── ralph/SKILL.md          # Sequential + verified execution
├── hooks/
│   └── hooks.json              # Quality gates
├── copilot-instructions.md     # Project-wide instructions
└── instructions/               # Contextual rules
.copilot/
└── mcp-config.json             # MCP server configuration
plugin.json                     # Copilot plugin manifest
```

## Project Status

Check your omg setup at any time:

```bash
omg status
```

Shows: config, tier, installed packages, agent/skill counts, Copilot CLI version, plugin install status, memory/notepad state.

## Next Steps

- [Plugins and Agents](./PLUGINS-AND-AGENTS.md) — Agent format, delegation, skills, hooks, plugin format
- ~~MCP Server~~ — Removed (Copilot-native `store_memory` + `.omg/` files replaced all MCP tools)
- [SDK Integration](./SDK-GUIDE.md) — `createOmgSession()` for programmatic Copilot SDK usage
- [Architecture](./ARCHITECTURE.md) — Pipeline, IR types, importers, exporters
- [Contributing](./CONTRIBUTING.md) — How to contribute
- [Copilot Testing](./COPILOT-TESTING.md) — Testing with real Copilot CLI
