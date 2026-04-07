---
name: research-to-pr
description: "Flagship skill — deep investigation then cloud agent creates PR automatically. OMC cannot do this."
tags:
  - strategic
  - differentiator
  - autonomous
---

## Why This Is Unique

**OMC cannot replicate this.** Claude Code has no cloud handoff, no `/delegate`, no async PR creation. This skill combines three Copilot-exclusive capabilities:

1. **`task` subagents** — parallel deep investigation
2. **GitHub MCP tools** — search code, read issues, understand PRs
3. **`/delegate`** — hand off to cloud agent → automatic PR

## When to Use

- User says "research and fix", "investigate and PR", "find the bug and send a PR"
- Complex problem needing investigation before implementation
- User wants a PR without babysitting the implementation
- Long-running task that should continue in the cloud

## When NOT to Use

- Quick fix → just use @omg:executor
- Need user input during implementation → use ralph
- Want to review code before PR → use plan + executor locally

## Workflow

### Phase 1: Research (Local, Parallel)

Deep investigation using multiple agents:

```
# Explore the area
task(agent_type="omg:explore", model="claude-haiku-4.5", mode="background",
  prompt="Find all files related to: {topic}")

# Trace the root cause (if bug)
task(agent_type="omg:tracer", model="claude-sonnet-4.6", mode="background",
  prompt="Trace: {observation}. Generate competing hypotheses.")

# Check existing issues/PRs (GitHub MCP)
task(agent_type="general-purpose", model="claude-sonnet-4.6", mode="background",
  prompt="Search GitHub issues and PRs related to: {topic}. Use github-mcp-server tools.")
```

Wait for all 3 to complete (use `--autopilot` for automatic continuation).

### Phase 2: Synthesize Findings

Combine results into a clear implementation spec:

```markdown
## Research Summary

### Root Cause
{tracer's best explanation with file:line}

### Affected Files
{explore's file list with relationships}

### Related Issues/PRs
{GitHub search results}

### Proposed Fix
{concrete implementation plan: what to change, where, acceptance criteria}
```

Save to `.omg/research/research-to-pr-{slug}.md`.

### Phase 3: Confirm with User

Present findings via `ask_user`:

```
Research complete. Here's what I found:

Root cause: {summary}
Proposed fix: {summary}
Files to change: {count}

Options:
1. Delegate to cloud → automatic PR (recommended)
2. Implement locally first, then PR
3. Refine the research
4. Cancel
```

### Phase 4: Delegate to Cloud

If user chooses option 1:

1. **Prepare context** — ensure the research summary and proposed fix are in the conversation
2. **Invoke `/delegate`** — hands off the session to GitHub's cloud Copilot agent
3. **Cloud agent** — reads the research, implements the fix, creates a PR

The PR will include:
- Implementation based on research findings
- Reference to root cause analysis
- Acceptance criteria from the research spec

### Phase 4b: Local Implementation (if user chose option 2)

```
task(agent_type="omg:executor", model="claude-sonnet-4.6", mode="sync",
  prompt="Implement fix based on research: {.omg/research/research-to-pr-{slug}.md}")
```

Then create PR manually:
```bash
git checkout -b fix/{slug}
git add -A && git commit -m "fix: {description}"
git push origin fix/{slug}
gh pr create --title "fix: {description}" --body "{research summary}"
```

## GitHub MCP Integration

This skill leverages GitHub MCP tools (use `--enable-all-github-mcp-tools`):

| Tool | Used For |
|------|---------|
| `github-mcp-server-search_code` | Find related code across repos |
| `github-mcp-server-search_issues` | Find related issues |
| `github-mcp-server-list_pull_requests` | Check existing PRs |
| `github-mcp-server-issue_read` | Read issue details for context |

## Prerequisites

- GitHub authentication: `copilot login` or `GITHUB_TOKEN` set
- For `/delegate`: Copilot cloud agent enabled in org settings
- For GitHub MCP: `--enable-all-github-mcp-tools` flag

## Persistence

- Research saved to `.omg/research/research-to-pr-{slug}.md`
- Index via `store_memory` key `omg:research-{slug}`
- PR URL saved to `.omg/reviews/pr-{slug}.md` on completion

## Examples

**Good:** "research-to-pr: The auth token expiry is wrong in production. Investigate why and send a fix PR."
→ Trace finds off-by-one in refresh logic. Explore maps auth files. GitHub MCP finds related issue #42. User confirms. /delegate creates PR.

**Bad:** "research-to-pr: make the app better"
→ Too vague. Use deep-interview first to crystallize what "better" means.

## Comparison with OMC

| Capability | OMC | omg (this skill) |
|-----------|-----|-------------------|
| Deep investigation | ✅ trace + explore | ✅ trace + explore |
| GitHub issue/PR search | ❌ gh CLI only | ✅ Native MCP |
| Cloud handoff | ❌ Not possible | ✅ `/delegate` |
| Automatic PR | ❌ Not possible | ✅ Cloud agent |
| Cross-repo search | ❌ Local only | ✅ GitHub MCP |

## Checklist

- [ ] Research phase: explore + trace + GitHub search completed
- [ ] Findings synthesized with root cause + proposed fix
- [ ] User confirmed approach
- [ ] Either: `/delegate` invoked → cloud PR, or local implementation + manual PR
- [ ] Research saved to `.omg/research/`
- [ ] PR URL documented
