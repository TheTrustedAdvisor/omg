# omg Documentation

```mermaid
graph TD
    subgraph User["For Users"]
        README["plugin/README.md<br/>Install + Quick Start"]
        EXAMPLES["plugin/EXAMPLES.md<br/>10 Copy-Paste Demos"]
        BEST["plugin/BEST-PRACTICES.md<br/>Dos & Don'ts"]
        SAMPLE["plugin/SAMPLE.md<br/>Fabric + Power BI Walkthrough"]
    end

    subgraph Architecture["Architecture"]
        PLUGIN["architecture/plugin.md<br/>Plugin Structure + Findings"]
        PIPELINE["architecture/pipeline.md<br/>IR Pipeline Data Flow"]
        COPILOT["architecture/copilot-capabilities.md<br/>Copilot Features Used"]
    end

    subgraph Guides["Guides"]
        GETTING["guides/getting-started.md<br/>Setup + First Steps"]
        CONTRIB["guides/contributing.md<br/>Dev Setup + PR Process"]
        TESTING["guides/testing.md<br/>Test Strategy"]
        COPTESTING["guides/copilot-testing.md<br/>Copilot CLI Test Scripts"]
        SDK["guides/sdk.md<br/>SDK Integration"]
        PLUGINS["guides/plugins-and-agents.md<br/>Plugin System"]
    end

    subgraph Reviews["Reviews & Findings"]
        COMPARE["reviews/comparison-baseline.md<br/>111% OMC Parity"]
        LESSONS["reviews/lessons-learned.md<br/>Empirical Findings"]
        LIMITS["reviews/limitations.md<br/>Known Gaps"]
        BURN["reviews/burndown.md<br/>Feature Coverage"]
    end

    subgraph Plans["Plans (Historical)"]
        MIGRATE["plans/migration-v03.md<br/>Skills → Agents"]
        MODEL["plans/model-routing.md<br/>Multi-Provider Routing"]
        ADAPT["plans/adaptation-rules.md<br/>OMC → Copilot"]
        MSREV["plans/microsoft-skills-review.md"]
        TESTPLAN["plans/test-plan.md<br/>L1-L3 Test Framework"]
    end

    style User fill:rgba(74,158,255,0.15),stroke:#4a9eff
    style Architecture fill:rgba(204,93,232,0.15),stroke:#cc5de8
    style Guides fill:rgba(81,207,102,0.15),stroke:#51cf66
    style Reviews fill:rgba(255,146,43,0.15),stroke:#ff922b
    style Plans fill:rgba(134,142,150,0.15),stroke:#868e96
```

---

## For Users

| Document | What you'll learn |
|----------|------------------|
| [README](../README.md) | Install omg, see agents, quick start |
| [Examples](../EXAMPLES.md) | 10 copy-paste demos with expected output |
| [Best Practices](../BEST-PRACTICES.md) | Dos, don'ts, architecture principles |
| [Fabric Sample](../SAMPLE.md) | End-to-end Fabric Lakehouse + Power BI |

## Architecture

| Document | What you'll learn |
|----------|------------------|
| [Plugin Architecture](architecture/plugin.md) | Agent model, skill system, 10+ empirical findings |
| [Pipeline Architecture](architecture/pipeline.md) | IR pipeline: importers → stages → exporters |
| [Copilot Capabilities](architecture/copilot-capabilities.md) | Every Copilot feature omg uses + dependency matrix |

## Guides

| Document | What you'll learn |
|----------|------------------|
| [Getting Started](guides/getting-started.md) | Setup, prerequisites, first run |
| [Contributing](guides/contributing.md) | Dev setup, testing, PR process |
| [Testing](guides/testing.md) | Test strategy (L1-L3) |
| [Copilot Testing](guides/copilot-testing.md) | CLI test scripts, JSONL analysis |
| [SDK Guide](guides/sdk.md) | SDK integration |
| [Plugins & Agents](guides/plugins-and-agents.md) | Plugin system deep-dive |

## Reviews & Findings

| Document | What you'll learn |
|----------|------------------|
| [Comparison Baseline](reviews/comparison-baseline.md) | 111% OMC parity across 3 benchmark runs |
| [Lessons Learned](reviews/lessons-learned.md) | Empirical findings from building omg |
| [Limitations](reviews/limitations.md) | Known gaps and platform limitations |
| [Burndown](reviews/burndown.md) | Feature coverage tracking |

## Plans (Historical)

| Document | What you'll learn |
|----------|------------------|
| [Migration v0.3](plans/migration-v03.md) | Skills → Agents architecture migration |
| [Model Routing](plans/model-routing.md) | Multi-provider routing design |
| [Adaptation Rules](plans/adaptation-rules.md) | OMC → Copilot translation rules |
| [Test Plan](plans/test-plan.md) | L1-L3 test framework design |
