---
name: ms-discover
description: "Auto-detect and install Microsoft Copilot Skills — Fabric, Azure SQL, DevOps, Power Platform"
tags:
  - microsoft
  - integration
  - setup
---

## When to Use

- User says "microsoft skills", "ms-discover", "add fabric", "add azure"
- After `omg init` or first project setup
- When working with Azure, Fabric, DevOps, or Power Platform
- Periodically to check for new Microsoft plugins

## Available Microsoft Plugins

| Plugin | Install Command | Skills | Best For |
|--------|----------------|--------|---------|
| **fabric** | `copilot plugin install fabric@copilot-plugins` | Lakehouse query, warehouse management | Data engineering |
| **azure-sql** | `copilot plugin install azure-sql@copilot-plugins` | Database query, schema management | Backend development |
| **devops** | `copilot plugin install azure-devops@copilot-plugins` | Pipelines, repos, work items | CI/CD |
| **power-platform** | `copilot plugin install power-platform@copilot-plugins` | Power Apps, Power Automate | Low-code |

## Workflow

### 1. Detect Installed Plugins

```bash
copilot plugin list
```

Parse output to identify which Microsoft plugins are already installed.

### 2. Detect Project Type

Scan the current project for indicators:

| File/Pattern | Suggests |
|-------------|----------|
| `fabric-config.json`, `*.lakehouse` | Fabric |
| `.azure/`, `azure-pipelines.yml`, `bicep` | Azure |
| `*.sql`, `prisma/`, `drizzle/` | Azure SQL |
| `azure-pipelines.yml`, `.azuredevops/` | DevOps |
| `*.msapp`, `*.json` (Power Apps) | Power Platform |

### 3. Recommend + Install

For each detected-but-not-installed plugin, offer installation:

```
I detected Azure configuration in your project but the Azure SQL plugin isn't installed.

Install it now?
1. Yes — install azure-sql@copilot-plugins (recommended)
2. Yes — install all Microsoft plugins for this project
3. No — skip for now
```

If user says yes:
```bash
copilot plugin install azure-sql@copilot-plugins
```

### 4. Verify Installation

After installing, verify:
```bash
copilot plugin list | grep azure-sql
```

### 5. Save Discovery Results

Write to `.omg/research/installed-plugins.json`:
```json
{
  "discovered": "2026-04-07",
  "projectIndicators": ["azure", "sql"],
  "plugins": {
    "fabric": { "installed": false, "recommended": false },
    "azure-sql": { "installed": true, "recommended": true, "installedAt": "2026-04-07" },
    "devops": { "installed": false, "recommended": true },
    "power-platform": { "installed": false, "recommended": false }
  }
}
```

Index via `store_memory` key `omg:installed-plugins`.

### 6. Report

```
## Microsoft Skills Status

| Plugin | Status | Project Match |
|--------|--------|--------------|
| fabric | ❌ Not installed | No indicators found |
| azure-sql | ✅ Installed | .azure/ detected |
| devops | ⚡ Recommended | azure-pipelines.yml found |
| power-platform | ❌ Not installed | No indicators found |

### What This Unlocks

With azure-sql installed, omg agents can now:
- @omg:architect: query database schemas during architecture review
- @omg:debugger: inspect production data during root cause analysis
- @omg:executor: run migrations with verification
- @omg:verifier: check database state after changes

### Suggested Next
Install devops plugin for CI/CD integration:
  copilot plugin install azure-devops@copilot-plugins
```

## Batch Install

For full Microsoft integration:
```bash
copilot plugin install fabric@copilot-plugins
copilot plugin install azure-sql@copilot-plugins
copilot plugin install azure-devops@copilot-plugins
copilot plugin install power-platform@copilot-plugins
```

Or via omg:
```
"Install all recommended Microsoft plugins for this project"
```

## Integration with omg Agents

After MS plugins are installed, omg agents automatically gain access to their skills (Copilot CLI routes by skill description). No configuration needed.

Key enhanced workflows:
- **Plan + Fabric:** @omg:planner queries lakehouse schema before planning data changes
- **Debug + Azure SQL:** @omg:debugger queries production DB during root cause analysis
- **Deploy + DevOps:** @omg:executor triggers pipeline after code changes, @omg:verifier checks results
- **Review + All:** @omg:security-reviewer audits data access, @omg:code-reviewer checks IaC

## Checklist

- [ ] Installed plugins detected via `copilot plugin list`
- [ ] Project indicators scanned
- [ ] Missing-but-recommended plugins offered for installation
- [ ] Installations verified
- [ ] Results saved to `.omg/research/installed-plugins.json`
- [ ] `store_memory` indexed
