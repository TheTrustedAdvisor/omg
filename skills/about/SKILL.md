---
name: about
description: "About omg — version, architecture, capabilities, and credits"
tags:
  - discovery
  - meta
---

## When to Use

- User says "about omg", "what is omg", "omg version", or asks about the plugin

## Response

Display the following information:

```
╔═══════════════════════════════════════════════════════╗
║  omg — Multi-Agent Orchestration for GitHub Copilot   ║
╚═══════════════════════════════════════════════════════╝

Version:      0.3.0
Agents:       28 (19 specialists + 9 orchestrators)
Skills:       38 (capability triggers + discovery)
Architecture: Agents orchestrate, skills provide capabilities

Orchestrators:  autopilot · ralph · team · ralplan · ultrawork
                research-to-pr · sciomc · self-improve · deep-dive

Specialists:    architect · analyst · planner · critic · executor
                debugger · verifier · code-reviewer · security-reviewer
                test-engineer · explore · designer · git-master · tracer
                scientist · writer · document-specialist · code-simplifier
                qa-tester

Copilot Capabilities Used:
  ✓ Multi-model routing (haiku/sonnet/opus)
  ✓ Parallel sub-agents via task()
  ✓ Cloud delegation via /delegate
  ✓ Cross-session persistence via store_memory + .omg/
  ✓ Auto-routing (agents match by description)
  ✓ Microsoft Skills integration (Fabric, Azure SQL, DevOps)

Persistence:    .omg/plans/ · .omg/research/ · .omg/reviews/ · .omg/qa-logs/

Credits:        Inspired by oh-my-claudecode (OMC), adapted and extended
                for GitHub Copilot's native capabilities.

Repository:     github.com/TheTrustedAdvisor/omg
License:        MIT
```

## Quick Links

- "help" — see what you can do
- "tutorial" — interactive walkthrough
- "agent-catalog" — full agent directory with routing
