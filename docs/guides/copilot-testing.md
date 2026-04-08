# Copilot Testing Guide

## Overview

omg output can be tested at three levels:

| Level | Tool | Requires token |
|-------|------|----------------|
| Structural checks | `run-copilot-test.sh` | No |
| CLI integration | `copilot-cli-integration.sh` | Yes (`COPILOT_TOKEN`) |
| VS Code manual | VS Code + Copilot extension | Yes |

All scripts accept the output directory as their first argument.

## Setup

### 1. Generate output from fixtures

```bash
npm run build
node dist/cli.js translate test/fixtures/omc .copilot-output --target both
```

For VS Code only:
```bash
node dist/cli.js translate test/fixtures/omc .copilot-output --target vscode
```

### 2. Validate the output

```bash
node dist/cli.js validate .copilot-output
```

A clean run prints no errors. Warnings are informational.

### 3. Set up COPILOT_TOKEN (for CLI integration tests)

The `COPILOT_GITHUB_TOKEN` environment variable must be a GitHub token with Copilot access.

Precedence order: `COPILOT_GITHUB_TOKEN` > `GH_TOKEN` > `GITHUB_TOKEN`

For local testing:
```bash
export COPILOT_GITHUB_TOKEN=ghp_your_token_here
```

For CI, add `COPILOT_TOKEN` as a repository secret. The workflow reads it as:
```yaml
env:
  COPILOT_GITHUB_TOKEN: ${{ secrets.COPILOT_TOKEN }}
```

> **Note:** `COPILOT_TOKEN` is the GitHub Actions repository secret name. `COPILOT_GITHUB_TOKEN` is the environment variable that the Copilot CLI reads at runtime. The workflow maps one to the other via the `env:` block above.

## Manual Test Scripts

### run-copilot-test.sh — Structural checks

Validates output structure without needing a Copilot token. Checks:
- Required files exist (agents, skills, hooks, MCP config)
- Agent files have valid YAML frontmatter
- hooks.json contains only supported events
- Tool names are Copilot aliases (not OMC names like `Read`, `Grep`, `Bash`)
- No `tmux` references in agent/skill instructions (must be replaced with `/fleet`)

```bash
./test/manual/run-copilot-test.sh .copilot-output
```

Exit code 0 = all checks passed.

### copilot-cli-integration.sh — Live CLI tests

Invokes the `copilot` binary with each generated agent and asserts on the response. Requires `COPILOT_GITHUB_TOKEN`.

```bash
COPILOT_GITHUB_TOKEN=ghp_... ./test/manual/copilot-cli-integration.sh .copilot-output
```

What it tests:
- Each `.agent.md` file can be invoked without errors
- Responses contain domain-appropriate content
- `--agent nonexistent` returns a proper error

## Expected Output Structure

A successful `omg translate test/fixtures/omc .copilot-output --target both` produces:

```
.copilot-output/
├── .github/
│   ├── agents/
│   │   ├── architect.agent.md
│   │   ├── debugger.agent.md
│   │   └── executor.agent.md
│   ├── copilot-instructions.md
│   ├── hooks/
│   │   └── hooks.json
│   ├── instructions/
│   │   ├── testing-rules.instructions.md
│   │   └── typescript-conventions.instructions.md
│   └── skills/
│       ├── autopilot/
│       │   └── SKILL.md
│       └── ralph/
│           └── SKILL.md
└── .copilot/
    └── mcp-config.json
```

**10 files total.** See `test/manual/expected-results.md` for detailed per-file content assertions.

## Copilot CLI Key Flags

| Flag | Description |
|------|-------------|
| `-p "..."` / `--prompt "..."` | Non-interactive single-shot prompt |
| `-s` | Suppress decoration — clean stdout only |
| `--yolo` | Auto-approve all tool permission prompts |
| `--agent NAME` | Invoke a specific custom agent by name |
| `--output-format json` | Emit structured JSONL (one JSON object per line) |

### Example test commands

```bash
# Basic agent invocation
copilot -p "Describe your role" --agent architect -s --output-format json

# Debugging agent
copilot -p "hello" --agent debugger -s --output-format json

# Expected error case
copilot -p "hello" --agent nonexistent -s

# Auto-approve tools (for smoke tests)
copilot -p "List files in the current directory" --agent executor -s --yolo
```

### Agent file locations

| Scope | Location |
|-------|----------|
| GitHub (cloud) | `.github/agents/*.agent.md` on default branch |
| Local CLI | `~/.copilot/agents/*.agent.md` |

For local testing, copy the generated agents to `~/.copilot/agents/`:
```bash
cp .copilot-output/.github/agents/*.agent.md ~/.copilot/agents/
```

## CI Workflow

The smoke test runs automatically on every push to `main` via `.github/workflows/copilot-smoke-test.yml`.

### What the workflow does

1. Build the project
2. Run `omg translate test/fixtures/omc .copilot-output --target both`
3. Run `omg validate .copilot-output`
4. Run `run-copilot-test.sh` (structural checks — always runs)
5. Run `copilot-cli-integration.sh` (only if `COPILOT_TOKEN` secret is set)
6. Upload test logs as artifacts (retained 7 days)
7. Deploy output to the `copilot-test` branch (orphan, force-pushed)

### Triggering manually

```bash
gh workflow run copilot-smoke-test.yml
```

Or via the GitHub Actions UI: **Actions → Copilot Smoke Test → Run workflow**.

### Reading test logs

Test logs are uploaded as the `copilot-test-logs` artifact. Download via:
```bash
gh run download --name copilot-test-logs
```

## Logging and Debugging

### Copilot CLI log level

Set in `~/.copilot/config.json` — there is no environment variable for log level:

```json
{
  "log_level": "debug"
}
```

Valid levels: `none`, `error`, `warning`, `info`, `debug`, `all`, `default`

### JSONL output parsing

```bash
copilot -p "Describe your role" --agent architect -s --output-format json > architect.jsonl

# Each line is a JSON object — parse with jq:
cat architect.jsonl | jq '.content'
cat architect.jsonl | jq 'select(.type == "error")'
```

Assert:
- No objects with `"type": "error"` in the output
- Response content contains domain-relevant terms
- Agent name in response matches the invoked agent

### VS Code debugging

**Output panel:** View → Output → GitHub Copilot Chat

**Trace-level logs:** Command Palette → Developer: Set Log Level → GitHub Copilot → Trace

**Agent debug logs:** Copilot Chat ellipsis menu → Show Agent Debug Logs
(or Command Palette → Developer: Open Agent Debug Logs)

Note: agent debug logs are in-memory only and not persisted across sessions.

**OpenTelemetry JSONL export:**
```bash
COPILOT_OTEL_FILE_EXPORTER_PATH=/tmp/copilot-traces.jsonl code .
```

Captures tool calls, agent spans, and LLM calls as JSONL.

### VS Code manual checks

| Action | Expected result |
|--------|----------------|
| Open Copilot Chat | No errors in output panel |
| Type `@` | Autocomplete shows: architect, debugger, executor |
| `@architect hello` | Architecture-focused response |
| `@debugger hello` | Debugging-focused response |
| Settings → Copilot → MCP | MCP servers from `.copilot/mcp-config.json` are listed |

## Expected Output Formats

### Agent frontmatter

```yaml
---
name: architect
description: "Strategic Architecture & Debugging Advisor (Opus, READ-ONLY)"
model: claude-opus-4-6
tools:
  - read_file        # NOT "Read" (OMC name)
  - search_files     # NOT "Grep" or "Glob"
  - run_in_terminal  # NOT "Bash"
---
```

Tool names must be Copilot aliases. The OMC names (`Read`, `Grep`, `Bash`) must not appear.

### hooks.json

```json
{
  "hooks": [
    {
      "event": "sessionStart",
      "steps": [{ "run": "echo session started" }]
    }
  ]
}
```

**Valid CLI events:** `sessionStart`, `sessionEnd`, `userPromptSubmitted`, `preToolUse`, `postToolUse`

**Additional VS Code events:** `subagentStart`, `subagentStop`, `errorOccurred`

**Must NOT appear:** `PreCompact`, `PostCompact`, `Notification`, `ConfigChange`, `WorktreeCreate`, `WorktreeRemove`, `FileChanged`, `CwdChanged`

### mcp-config.json

```json
{
  "mcpServers": {
    "my-server": {
      "command": "npx",
      "args": ["-y", "my-mcp-server"]
    }
  }
}
```

Top-level key is `mcpServers` (not `servers`).

## Untranslatable Features

These OMC features are intentionally absent from the output. Do not add them as workarounds.

| Feature | Reason |
|---------|--------|
| PreCompact / PostCompact hooks | No Copilot equivalent for context compaction events |
| Notification hook | No Copilot notification system |
| ConfigChange hook | No Copilot config change events |
| WorktreeCreate / WorktreeRemove | No Copilot git worktree events |
| FileChanged / CwdChanged | No Copilot filesystem watch events |
| Task orchestration hooks | OMC-specific team/task lifecycle |
| StopContinuation | OMC persistent mode concept |

These are documented by `omg report` — not hacked into the output.
