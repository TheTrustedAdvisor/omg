# Konzeptionelle Review: Microsoft Skills in omg

**Date:** 2026-04-07
**Status:** Architectural assessment

## Zusammenfassung

Die Microsoft Skills Integration passt nicht mehr zur aktuellen omg-Architektur. Sie wurde für ein anderes Produkt-Konzept gebaut und sollte entweder fundamental überarbeitet oder entfernt werden.

## Das ursprüngliche Konzept (Ultraplan v1-v3)

omg war als **Multi-Source Aggregator** konzipiert:

```
OMC Agents ─────┐
Microsoft Skills ──┤──→ Pipeline ──→ Merged Plugin
Community Skills ──┘
```

Alle Quellen fließen durch dieselbe Pipeline, werden zu einer IR normalisiert, gemerged, und als ein Plugin exportiert. Microsoft Skills waren gleichberechtigte Bürger neben OMC.

## Was sich geändert hat (Ultraplan v4.1 + Implementierung)

omg ist jetzt ein **handgeschriebenes Plugin mit Pipeline als Build-Tool**:

```
OMC Source ──→ Pipeline (60%) ──→ Hand-Refined Plugin (40%)
                                   19 Agents + 36 Skills
                                   Copilot-native, tested
```

Microsoft Skills spielen in dieser Architektur keine Rolle mehr:

1. **Kein MS-Skill ist im Plugin.** `plugin/skills/` enthält 0 Microsoft-Skills.
2. **Die Pipeline generiert das Plugin nicht mehr.** Es wird manuell gepflegt.
3. **MS Skills sind bereits Copilot-nativ.** Sie kommen von Microsoft selbst — sie brauchen keine Übersetzung.

## Das Architektur-Problem

### 1. Doppelte Arbeit ohne Mehrwert

Microsoft veröffentlicht ihre Skills als offizielle Copilot Plugins:
```bash
copilot plugin marketplace browse copilot-plugins    # Microsoft's eigener Marketplace
copilot plugin install fabric@copilot-plugins        # Direkt installierbar
```

omg's Pipeline importiert dieselben Skills, normalisiert sie zu IR, und exportiert sie zurück als... dieselben SKILL.md Dateien. Das ist ein Roundtrip ohne Transformation.

### 2. Merge-Konflikte mit Hand-Refined Content

Wenn jemand `omg add azure` laufen lässt, produziert die Pipeline 132 Microsoft-Skills. Diese würden:
- Unser hand-verfeinertes Plugin überschreiben oder parallel existieren
- Merge-Priorität (OMC=0, MS=2) funktioniert nur für ID-Konflikte, nicht für Koexistenz
- Kein Match/Enhance für MS Skills (TF-IDF, Handoff-Injection sind OMC-spezifisch)

### 3. Falsches Abstraktionsniveau

Microsoft Skills sind fertige SKILL.md Dateien. omg's IR normalisiert sie zu `SkillDef`, um sie dann zurück zu SKILL.md zu exportieren. Die IR-Schicht bietet:
- `SourceRef` Provenance → nützlich, aber Copilot trackt das selbst
- `NormalizedEvent` Mapping → irrelevant für Skills (nur für Hooks)
- `TF-IDF Matching` → matcht MS-Skills zu OMC-Agents — aber unsere Agents sind handverdrahtet

### 4. Wartungslast

8 Microsoft-Quellrepos × regelmäßige Updates = erheblicher Monitor/Sync-Aufwand für Content der direkt von Microsoft installierbar ist.

## Was Microsoft Skills in omg leisten könnten

### Szenario A: "omg add fabric" als Convenience

User will Fabric-Skills. Statt `copilot plugin install fabric@copilot-plugins` kann er `omg add fabric` sagen. omg:
- Fetcht die Skills
- Merged sie ins Plugin
- Fügt omg-Agents als Enhancement hinzu (z.B. "Use @omg:architect for Fabric schema review")

**Problem:** Das ist ein Paketmanager, nicht Orchestrierung. Copilot CLI hat schon `copilot plugin install`.

### Szenario B: "omg enhance fabric" — Cross-Pollination

omg liest installierte MS-Skills und erweitert sie:
- Injiziert omg Agent-Delegation ("After using this Fabric skill, verify with @omg:verifier")
- Fügt Quality Gates hinzu ("Run @omg:security-reviewer after Fabric data access")
- Vernetzt MS-Skills mit omg-Workflows ("Plan Fabric migration with @omg:planner")

**Das wäre echter Mehrwert** — omg als Orchestrierungsschicht über Microsoft's Skills, nicht als Duplikat.

### Szenario C: Entfernen und auf Copilot-Native verweisen

omg konzentriert sich auf seine Stärke: Agent-Orchestrierung. MS-Skills installiert der User direkt:
```bash
copilot plugin install fabric@copilot-plugins
```

omg's Agents können mit installierten MS-Skills interagieren ohne sie zu importieren.

## Empfehlung

**Szenario C (Entfernen) für v0.1.0. Szenario B (Enhance) als v0.2.0 Feature.**

### Begründung

1. **omg's Stärke ist Orchestrierung, nicht Aggregation.** Die 19 Agents + 36 Skills + Handoff-Contracts + Verification — das ist der Wert. Microsoft Skills repackagen ist kein Wert.

2. **Copilot-Native-First.** Microsoft Skills SIND Copilot-native. Sie zu importieren und re-exportieren widerspricht dem Leitsatz.

3. **Weniger Surface, bessere Qualität.** 6 Importers (OMC sub-modules) + 2 externe (MS, Awesome) + Fetcher + Registry + Lockfile — das ist viel Code der aktuell nichts zum Plugin beiträgt.

4. **Szenario B ist die Zukunft.** "omg enhance" — das Konzept, installierte Skills mit omg-Agents zu vernetzen — ist strategisch wertvoller als sie zu kopieren. Aber das ist ein neues Feature, kein Refactor des bestehenden Importers.

### Was konkret entfernt werden könnte

| Modul | Zeilen (ca.) | Begründung |
|-------|-------------|------------|
| `src/importers/microsoft-skills.ts` | ~100 | Importiert MS Skills → IR (roundtrip) |
| `src/importers/awesome-copilot.ts` | ~85 | Community-Index → IR |
| `src/importers/copilot-native.ts` | ~70 | Pass-through (sinnlos in aktueller Arch) |
| `src/registry/fetcher.ts` | ~150 | GitHub API Fetcher für externe Repos |
| `src/registry/lockfile.ts` | ~50 | Commit SHA Pinning |
| `src/registry/packages.ts` | ~80 | 8 Package-Shortcuts |
| `src/commands/add.ts` | ~300 | `omg add` Pipeline-Steuerung |
| `src/commands/sync.ts` | ~80 | `omg sync` Re-Fetch |
| `test/importers/microsoft-skills.test.ts` | ~50 | Tests |
| `test/importers/awesome-copilot.test.ts` | ~50 | Tests |
| `test/registry/` (3 files) | ~150 | Tests |
| **Total** | **~1,200** | ~22% der Codebasis |

### Was behalten wird

| Modul | Begründung |
|-------|------------|
| `src/importers/omc/` | OMC Import bleibt — Pipeline regeneriert Plugin-Basis |
| `src/pipeline/` | Merge, Match, Enhance, Validate — Kern-Pipeline |
| `src/exporters/` | CLI + VS Code Export — produziert Plugin-Dateien |
| `src/mappings/` | Tool/Model/Event-Mappings |
| `src/commands/translate.ts` | `omg translate` — Kern-Command |

## Nächste Schritte

1. **Entscheidung:** Szenario C jetzt, Szenario B als #-Issue für v0.2.0
2. **Wenn C:** Entfernen der MS/Community Importers + Registry + Add/Sync Commands
3. **Dokumentieren:** ARCHITECTURE.md anpassen, "Equal Citizens" Philosophie durch "Orchestration-First" ersetzen
