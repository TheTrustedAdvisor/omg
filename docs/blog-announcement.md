# Introducing omg — Multi-Agent Orchestration for GitHub Copilot

**25 AI agents. 43 skills. One `copilot plugin install`.**

I'm excited to share **omg**, a GitHub Copilot CLI plugin that turns your terminal into a multi-agent development platform. Instead of one AI assistant doing everything, omg gives you a team of specialists — an architect who analyzes code, a debugger who traces root causes, a security reviewer who audits for OWASP issues — all coordinating autonomously.

## Why I Built This

I started with [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) (OMC) for Claude Code and thought: why can't GitHub Copilot have this too? So I built omg — and it now **surpasses the original** at 111% parity across 5 benchmarks.

## What Makes omg Different

### 1. Real Multi-Agent Orchestration

Say `autopilot: build a REST API` and omg orchestrates 6 specialists: analyst → planner → executor → verifier → security-reviewer → code-reviewer. Each does what they do best.

### 2. Works In Any Language

```bash
copilot -i "omg prüfe die Sicherheit"          # German
copilot -i "omg vérifie la sécurité"            # French
copilot -i "omg このプロジェクトのセキュリティを確認して"  # Japanese
```

omg translates your intent and responds in your language.

### 3. Cloud Delegation (Copilot-Exclusive)

Investigate locally, then:
```
/delegate implement the fix and create a PR
```
The cloud agent creates a draft PR automatically. No other AI coding tool can do this.

### 4. btw — Side Questions Without Derailing

Mid-task, ask anything:
```
btw what's the difference between vitest and jest?
```
Get a brief answer, then your task continues uninterrupted.

## Quick Start

```bash
copilot plugin install TheTrustedAdvisor/omg
copilot -i "about omg"     # Meet the team
copilot -i "tutorial"       # Interactive walkthrough
copilot -i "help"           # Full catalog
```

## The Numbers

- **25 agents** (19 specialists + 6 orchestrators)
- **43 skills** (all with examples + quality contracts)
- **67 man-page docs** ([browse online](https://github.com/TheTrustedAdvisor/omg/tree/main/docs))
- **1,221 tests** (100% pass rate)
- **111% OMC parity** (5.0/5.0 vs OMC 4.50/5.0)
- **5 languages** confirmed (DE/FR/ES/IT/JP)

## Architecture

Agents orchestrate. Skills provide capabilities. The LLM decides.

- **Orchestrators:** autopilot, team, research-to-pr, sciomc, self-improve, deep-dive
- **Specialists:** architect, executor, debugger, planner, verifier, and 14 more

Submitted to the [awesome-copilot marketplace](https://github.com/github/awesome-copilot/pull/1330) — would be the first independent community plugin alongside Microsoft and Figma.

## Links

- **Install:** `copilot plugin install TheTrustedAdvisor/omg`
- **Repo:** [github.com/TheTrustedAdvisor/omg](https://github.com/TheTrustedAdvisor/omg)
- **Docs:** [Man pages for every agent and skill](https://github.com/TheTrustedAdvisor/omg/tree/main/docs)

---

*Built by [Matthias Falland](https://www.the-trusted-advisor.com), Microsoft Data Platform MVP. Inspired by oh-my-claudecode, extended for Copilot's native capabilities.*
