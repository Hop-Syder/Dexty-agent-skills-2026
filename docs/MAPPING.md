<!--
  MAPPING.md — Cartographie Agents -> Skills (Desty 3.0)
  Super Agent: Desty 3.0 | Nexus Partners · Cotonou, Bénin
  Créateur: @hopsyder (https://github.com/Hop-Syder)
-->

# Cartographie Desty 3.0 — Agents → Skills

> **But du document** : pour chaque agent et sous-agent de la chaîne
> *build → test → production*, lister les skills qui le composent, avec
> la **source GitHub vérifiée** de chaque skill. C'est le livrable central
> de cette étape (cartographie et registre opérationnel des skills).

Toutes les sources ci-dessous ont été **vérifiées comme réelles** (existence
du dépôt, étoiles, forks) le 13 octobre 2026. Voir [`SOURCES.md`](./SOURCES.md)
pour le détail et l'avertissement sur les dépôts non confirmés.

---

## Vue d'ensemble de la chaîne Desty 3.0

```text
          ┌─────────────────────────────────────────────────────────┐
          │             AGENTS PRINCIPAUX (DESTY 3.0)               │
          ├───────────────┬───────────────┬─────────────────────────┤
          │ Product       │ Workflow /    │ Sécurité                │
          │ Manager       │ UX Owner      │ (Security Lead)         │
          └──────┬────────┴──────┬────────┴──────────┬──────────────┘
                 │               │                   │
     ┌───────────┴───┐   ┌───────┴───────┐   ┌───────┴────────┐
     │  Build / Dev   │   │ DevOps /      │   │ QA /           │
     │  (Lead Eng.)   │   │ Release       │   │ Evaluator      │
     └───────┬────────┘   └───────┬───────┘   └────────────────┘
             │                    │
   ┌─────────┴─────────┐  ┌───────┴─────────┐
   │ Sous-agents dev   │  │ Sous-agents ops │
   │ (frontend, api,   │  │ (ci/cd, deploy, │
   │  test, debug)     │  │  observability) │
   └───────────────────┘  └─────────────────┘
```

**6 agents principaux**, chacun pilotant des **sous-agents** qui portent les
skills d'exécution. Un agent principal porte des skills « de pilotage »
(cadrage, décision, revue, évaluation) ; ses sous-agents portent des skills « de
production » ou d'audit indépendant.

---

## Tableau maître (agent → skills)

Légende des sources :
`AO` = addyosmani/agent-skills · `AN` = anthropics/skills ·
`SP` = obra/superpowers · `TOB` = trailofbits/skills ·
`VL` = vercel-labs/agent-skills · `NV` = NVIDIA/SkillSpector (outil).

| Agent | Rôle en une ligne | Skills rattachés (≈5) | Source |
|-------|-------------------|------------------------|--------|
| **① Product Manager** | Possède le *quoi* et le *pourquoi* : besoin, périmètre, priorités | `idea-refine` · `spec-driven-development` · `planning-and-task-breakdown` · `documentation-and-adrs` · `doc-coauthoring` | AO, AO, AO, AO, AN |
| **② Workflow / UX Owner** | Possède le fil rouge utilisateur, les fonctionnalités, les parcours | `frontend-ui-engineering` · `api-and-interface-design` · `brand-guidelines` · `frontend-design` · `canvas-design` | AO, AO, AN, AN, AN |
| **③ Security Lead** | Possède la sûreté : menaces, revue, durcissement, conformité | `security-and-hardening` · `security-threat-model` · `security-best-practices` · `differential-review` · `security-awareness` | AO, TOB, TOB, TOB, TOB |
| **④ Build / Dev Lead** | Transforme le plan en code qui marche | `incremental-implementation` · `test-driven-development` · `code-review-and-quality` · `code-simplification` · `debugging-and-error-recovery` | AO, AO, AO, AO, AO |
| **⑤ DevOps / Release** | Emmène le code testé jusqu'en production | `ci-cd-and-automation` · `shipping-and-launch` · `observability-and-instrumentation` · `performance-optimization` · `vercel-deploy` | AO, AO, AO, AO, VL |
| **⑥ QA / Evaluator** | Note la performance des agents et du résultat (juge séparé) | `skill-creator` · `claude plugin eval` · `requesting-code-review` · `code-review-and-quality` · `skillspector scan` | AN, Claude Code, SP, AO, NV |

---

## Détail par agent et sous-agents

### ① Product Manager

**Mission** — Cadrer le projet : clarifier l'idée, écrire la spec, découper
en tâches, tracer les décisions. Rien ne part en build sans une spec validée.

| Niveau | Nom | Skills | Source |
|--------|-----|--------|--------|
| Agent | Product Manager | `idea-refine`, `spec-driven-development`, `planning-and-task-breakdown`, `documentation-and-adrs`, `doc-coauthoring` | AO ×4, AN ×1 |
| Sous-agent | Spec Writer | `spec-driven-development`, `constraint-driven-development` | AO, AO |
| Sous-agent | Backlog Planner | `planning-and-task-breakdown`, `incremental-implementation` | AO, AO |
| Sous-agent | Brainstorm facilitator | `brainstorming` (SP), `idea-refine` (AO) | SP, AO |

---

### ② Workflow / UX Owner

**Mission** — Garantir que ce qui est construit correspond au parcours
utilisateur attendu : fonctionnalités, écrans, API consommées par le front.

| Niveau | Nom | Skills | Source |
|--------|-----|--------|--------|
| Agent | Workflow / UX Owner | `frontend-ui-engineering`, `api-and-interface-design`, `brand-guidelines`, `frontend-design`, `canvas-design` | AO ×2, AN ×3 |
| Sous-agent | Frontend builder | `frontend-ui-engineering`, `react-best-practices` (VL), `composition-patterns` (VL) | AO, VL, VL |
| Sous-agent | API contract designer | `api-and-interface-design`, `context-engineering` | AO, AO |
| Sous-agent | UX reviewer | `browser-testing-with-devtools`, `webapp-testing` (AN) | AO, AN |

---

### ③ Security Lead

**Mission** — Rendre le projet défendable : modéliser les menaces, durcir,
auditer les diffs, sensibiliser. Travaille avec l'outil d'audit `SkillSpector`
(NVIDIA) en garde-fou CI sur **tout skill tiers** avant installation.

| Niveau | Nom | Skills / Outils | Source |
|--------|-----|-----------------|--------|
| Agent | Security Lead | `security-and-hardening`, `security-threat-model`, `security-best-practices`, `differential-review`, `security-awareness` | AO, TOB ×4 |
| Sous-agent | Threat modeler | `security-threat-model`, `security-ownership-map` | TOB, TOB |
| Sous-agent | Code auditor | `differential-review`, `security-best-practices` | TOB, TOB |
| Sous-agent | Supply-chain gate | **`SkillSpector` scan** (outil NVIDIA, Apache-2.0) | NV |

---

### ④ Build / Dev Lead

**Mission** — Écrire le code, le tester, le garder propre et débogable.
Collabore étroitement avec le PM (spec) et le Security Lead (revue).

| Niveau | Nom | Skills | Source |
|--------|-----|--------|--------|
| Agent | Build / Dev Lead | `incremental-implementation`, `test-driven-development`, `code-review-and-quality`, `code-simplification`, `debugging-and-error-recovery` | AO ×5 |
| Sous-agent | Implementer | `incremental-implementation`, `source-driven-development` | AO, AO |
| Sous-agent | Test engineer | `test-driven-development`, `webapp-testing` (AN) | AO, AN |
| Sous-agent | Debugger | `debugging-and-error-recovery` (AO), `systematic-debugging` (SP) | AO, SP |
| Sous-agent | Reviewer | `requesting-code-review` (SP), `code-review-and-quality` (AO) | SP, AO |

---

### ⑤ DevOps / Release

**Mission** — Industrialiser : CI/CD, observabilité, performance, et la mise
en production elle-même (incluant le déploiement Vercel pour les apps JS).

| Niveau | Nom | Skills | Source |
|--------|-----|--------|--------|
| Agent | DevOps / Release | `ci-cd-and-automation`, `shipping-and-launch`, `observability-and-instrumentation`, `performance-optimization`, `vercel-deploy` | AO ×4, VL ×1 |
| Sous-agent | CI/CD engineer | `ci-cd-and-automation`, `agentic-actions-auditor` (TOB) | AO, TOB |
| Sous-agent | Release manager | `shipping-and-launch`, `deprecation-and-migration` | AO, AO |
| Sous-agent | SRE / Observability | `observability-and-instrumentation`, `performance-optimization` | AO, AO |

---

### ⑥ QA / Evaluator

**Mission** — Possède la **mesure**. Évalue la conformité des livrables et la performance des autres agents sans jamais exécuter les tâches qu'il évalue (juge séparé).

| Niveau | Nom | Skills / Outils | Source |
|--------|-----|-----------------|--------|
| Agent | QA / Evaluator | `skill-creator`, `claude plugin eval`, `requesting-code-review`, `code-review-and-quality`, `skillspector scan` | AN, Claude Code, SP, AO, NV |
| Sous-agent | Spec-compliance judge | `requesting-code-review` | SP |
| Sous-agent | Code-quality judge | `code-review-and-quality` | AO |
| Sous-agent | Skill eval runner | `skill-creator`, `claude plugin eval` | AN, Claude Code |

---

## Orchestration (multi-agents)

Le liant entre tous ces agents vient de **obra/superpowers**, dont les skills
servent de « système nerveux » : lancer des sous-agents en parallèle et
déléguer proprement.

| Skill d'orchestration | Rôle | Source |
|-----------------------|------|--------|
| `dispatching-parallel-agents` | Lancer plusieurs sous-agents en parallèle | SP |
| `subagent-driven-development` | Déléguer l'implémentation à des sous-agents avec portes qualité | SP |
| `writing-plans` / `executing-plans` | Plan découpé en tâches, exécuté étape par étape | SP |
| `using-superpowers` | Ancre qui active les autres skills SP | SP |

---

## Récapitulatif chiffré

- **6 agents principaux**, **~5 skills chacun** = 30 rattachements de pilotage et d'évaluation.
- **19 sous-agents**, portant les skills d'exécution et de jugement.
- **6 dépôts sources vérifiés** + 1 outil de sécurité (SkillSpector).
- **~40 skills distincts** mobilisés, tous traçables à une source réelle.
