<!--
  MAPPING.md — Cartographie Agents -> Skills (Desty 3.2)
  Super Agent: Desty 3.2 | Nexus Partners · Cotonou, Bénin
  Créateur: @hopsyder (https://github.com/Hop-Syder)
-->

# Cartographie Desty 3.2 — Agents → Skills

> **But du document** : pour chaque agent et sous-agent de la chaîne
> *build → test → production*, lister les skills qui le composent, avec
> la **source GitHub vérifiée** de chaque skill. C'est le livrable central
> de cette étape (cartographie et registre opérationnel des skills).

Toutes les sources ci-dessous ont été **vérifiées comme réelles** (existence
du dépôt, étoiles, forks) le 13 octobre 2026. Voir [`SOURCES.md`](./SOURCES.md)
pour le détail et l'avertissement sur les dépôts non confirmés.

---

## Vue d'ensemble de la chaîne Desty 3.2

```text
          ┌─────────────────────────────────────────────────────────┐
          │             AGENTS PRINCIPAUX (DESTY 3.2)               │
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
             │                    │           └───────┬────────┘
             │                    │                   │
             └────────────────────┴───────────────────┴────────┐
                                                               │
                                                    ┌──────────▼──────────┐
                                                    │ ⑧ Project Memory    │
                                                    │ (Gardien de vision) │
                                                    └─────────────────────┘
```

**8 agents principaux**, chacun pilotant des **sous-agents** qui portent les
skills d'exécution.

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
| **⑧ Project Memory** | Mémoire vive du projet + gardien de la vision | `documentation-and-adrs` · `context-engineering` · `doubt-driven-development` · Hook `SessionStart` · `postgres-best-practices` | AO, AO, AO, Claude Code, Supabase |

---

## Détail des 8 Agents

Consultez les fiches détaillées sous `agents/` :
- `01-product-manager.md`
- `02-workflow-ux-owner.md`
- `03-security-lead.md`
- `04-build-dev-lead.md`
- `05-devops-release.md`
- `06-qa-evaluator.md`
- `07-data-ml.md`
- `08-project-memory.md`
