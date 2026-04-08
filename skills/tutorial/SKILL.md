---
name: tutorial
description: "Interactive guided tour of omg — progressive walkthrough from discovery to full orchestration"
tags:
  - discovery
  - meta
  - onboarding
---

## When to Use

- New user says "tutorial", "show me how", "how does omg work", "getting started"
- User wants to understand omg's capabilities hands-on

## Tutorial Flow

Guide the user through 5 progressive steps. After each step, explain what happened under the hood and ask if they want to continue.

---

### Step 1: Discovery — "Meet the team"

**Say to the user:**

> Welcome to omg! You have 28 specialized AI agents and 40 skills at your disposal. Let's start by meeting the team.
>
> Try this:
> ```
> about omg
> ```
> This shows your agent roster, architecture, and what Copilot capabilities omg uses.

**What happens:** The `about` skill activates and displays the omg overview.

**Explain:** "omg has two types of agents: **Orchestrators** (9) that coordinate work, and **Specialists** (19) that do focused tasks. The orchestrators delegate to specialists — like a project manager coordinating a team."

---

### Step 2: Search — "Explore a codebase"

**Say to the user:**

> Now let's try a specialist. The **explore** agent maps codebases fast.
>
> Try this:
> ```
> deepsearch: find all configuration files in this project
> ```

**What happens:** The `deepsearch` skill activates, the explore agent searches from multiple angles.

**Explain:** "The explore agent used 5+ search strategies (exact name, glob patterns, imports, tests, docs) and cross-validated findings. This is more thorough than a single grep."

---

### Step 3: Planning — "Think before coding"

**Say to the user:**

> Before building anything, omg can help you plan. The **plan** skill creates structured plans with testable acceptance criteria.
>
> Try this:
> ```
> plan: add a health check endpoint to this project
> ```

**What happens:** The `plan` skill activates. The agent interviews the user, explores the codebase, and creates a structured plan.

**Explain:** "The plan includes acceptance criteria that are testable (pass/fail, not subjective). When you're ready to execute, omg agents can use this plan as input — plans persist in `.omg/plans/` across sessions."

---

### Step 4: Execution — "Let the team work"

**Say to the user:**

> Now the main event — let omg's **autopilot** orchestrate a full implementation.
>
> Try this (on a small task to see it in action):
> ```
> autopilot: add a --version flag to the CLI that prints the package version
> ```

**What happens:** The autopilot agent coordinates the full lifecycle:
1. Analyzes requirements
2. Creates an implementation plan
3. Implements the code (delegates to executor)
4. Runs tests and verification
5. Reports results with evidence

**Explain:** "Autopilot is one of 9 orchestrator agents. It coordinates specialists — it reads code (via explore), implements (via executor), and verifies (via verifier). Everything is persisted to `.omg/` for cross-session continuity."

---

### Step 5: Power Features — "Go deeper"

**Say to the user:**

> You've seen the basics. Here are the power workflows:
>
> | Command | What it does |
> |---------|-------------|
> | `ralph: fix all lint errors` | Keeps working until EVERY error is fixed with proof |
> | `team 3: add tests for src/` | 3 agents work in parallel on independent files |
> | `trace: why did the build break?` | Competing hypotheses ranked by evidence |
> | `deep interview: I want to build...` | Socratic Q&A → crystallizes vague ideas into specs |
> | `research-to-pr: fix auth bug` | Investigates → cloud agent creates PR automatically |
> | `tdd: add email validation` | Strict red-green-refactor discipline |
>
> For the full reference: say **"help"** anytime.
>
> **Power tip (interactive mode only):**
> ```
> /fleet review src/ for security, code quality, and architecture in parallel
> ```
> `/fleet` dispatches multiple agents simultaneously — like having 3 reviewers working at once.

---

## After Tutorial

Remind the user:
- **"help"** — quick reference of all agents and skills
- **"about"** — version, architecture, capabilities
- **"agent-catalog"** — full agent directory with routing
- Plans and research persist in `.omg/` — resume anytime

## Rules

- Keep each step brief and interactive
- Wait for user to try each command before explaining
- If user says "skip" — jump to the next step
- If user says "done" — end with the quick reference links

## Trigger Keywords

tutorial, show me how, getting started

## Example

```bash
copilot -i "tutorial"
```

## Quality Contract

- 5-step progressive walkthrough, interactive, skip/done supported
