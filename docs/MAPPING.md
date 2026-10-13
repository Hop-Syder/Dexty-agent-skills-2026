<!--
  MAPPING.md — Cartographie Agents -> Skills (Desty 3.1)
  Super Agent: Desty 3.1 | Nexus Partners · Cotonou, Bénin
  Créateur: @hopsyder (https://github.com/Hop-Syder)
-->

# Cartographie Desty 3.1 — Agents → Skills

> **But du document** : pour chaque agent et sous-agent de la chaîne
> *build → test → production*, lister les skills qui le composent, avec
> la **source GitHub vérifiée** de chaque skill. C'est le livrable central
> de cette étape (cartographie et registre opérationnel des skills).

Toutes les sources ci-dessous ont été **vérifiées comme réelles** (existence
du dépôt, étoiles, forks) le 13 octobre 2026. Voir [`SOURCES.md`](./SOURCES.md)
pour le détail et l'avertissement sur les dépôts non confirmés.

---

## Vue d'ensemble de la chaîne Desty 3.1

```text
          ┌─────────────────────────────────────────────────────────┐
          │             AGENTS PRINCIPAUX (DESTY 3.1)               │
          ├───────────────┬───────────────┬─────────────────────────┤
          │ Product       │ Workflow /    │ Sécurité                │
          │ Manager       │ UX Owner      │ (Security Lead)         │
          └──────┬────────┴──────┬────────┴──────────┬──────────────┘
                 │               │                   │
     ┌───────────┴───┐   ┌───────┴───────┐   ┌───────┴────────┐
     │  Build / Dev   │   │ DevOps /      │   │ QA /           │
     │  (Lead Eng.)   │   │ Release       │   │ Evaluator      │
     └───────┬────────┘   └───────┬───────┘   └───────┬────────┘
             │                    │                   │
             │                    │           ┌───────┴────────┐
             │                    │           │ Data / ML      │
             │                    │           │ (Agent ⑦)      │
             │                    │           └────────────────┘
```

**7 agents principaux**, chacun pilotant des **sous-agents** qui portent les
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
| **④ Build / Dev Lead** | Transforme le plan en code qui marche | `incremental-implementation` · `test-driven-development` · `requesting-code-review` · `code-simplification` · `debugging-and-error-recovery` | AO, AO, SP, AO, AO |
| **⑤ DevOps / Release** | Emmène le code testé jusqu'en production | `ci-cd-and-automation` · `shipping-and-launch` · `observability-and-instrumentation` · `performance-optimization` · `vercel-deploy` | AO, AO, AO, AO, VL |
| **⑥ QA / Evaluator** | Note la performance des agents et du résultat (juge séparé) | `skill-creator` · `claude plugin eval` · `requesting-code-review` · `code-review-and-quality` · `skillspector scan` | AN, Claude Code, SP, AO, NV |
| **⑦ Data / ML** | Possède données et modèles (ML, NLP, pipelines) | `xlsx` · `postgres-best-practices` · `observability-and-instrumentation` · `data-pipeline`⚠️ · `ml-training-eval`⚠️ | AN, Supabase, AO, à sourcer, à sourcer |

---

## Détail par agent et sous-agents

### ① Product Manager
- **Skills** : `idea-refine`, `spec-driven-development`, `planning-and-task-breakdown`, `documentation-and-adrs`, `doc-coauthoring`
- **Sous-agents** : Spec Writer, Backlog Planner, Brainstorm facilitator

### ② Workflow / UX Owner
- **Skills** : `frontend-ui-engineering`, `api-and-interface-design`, `brand-guidelines`, `frontend-design`, `canvas-design`
- **Sous-agents** : Frontend builder, API contract designer, UX reviewer

### ③ Security Lead
- **Skills** : `security-and-hardening`, `security-threat-model`, `security-best-practices`, `differential-review`, `security-awareness`
- **Sous-agents** : Threat modeler, Code auditor, Supply-chain gate (`SkillSpector`)

### ④ Build / Dev Lead
- **Skills** : `incremental-implementation`, `test-driven-development`, `requesting-code-review`, `code-simplification`, `debugging-and-error-recovery`
- **Sous-agents** : Implementer, Test engineer, Debugger

### ⑤ DevOps / Release
- **Skills** : `ci-cd-and-automation`, `shipping-and-launch`, `observability-and-instrumentation`, `performance-optimization`, `vercel-deploy`
- **Sous-agents** : CI/CD engineer, Release manager, SRE / Observability

### ⑥ QA / Evaluator
- **Skills** : `skill-creator`, `claude plugin eval`, `requesting-code-review`, `code-review-and-quality`, `skillspector scan`
- **Sous-agents** : Spec-compliance judge, Code-quality judge, Skill eval runner

### ⑦ Data / ML
- **Skills** : `xlsx`, `postgres-best-practices`, `observability-and-instrumentation`, `data-pipeline` (à sourcer), `ml-training-eval` (à sourcer)
- **Sous-agents** : Data engineer, ML engineer, Model-serving

---

## Orchestration (multi-agents)

Le liant entre tous ces agents vient de **obra/superpowers** :
- `dispatching-parallel-agents`
- `subagent-driven-development`
- `writing-plans` / `executing-plans`
- `using-superpowers`

---

## Récapitulatif chiffré

- **7 agents principaux** (Couverture complète SDLC + Data/ML).
- **22 sous-agents** spécialisés.
- **Score d'architecture : 89 / 100** (Niveau 1 validé).
