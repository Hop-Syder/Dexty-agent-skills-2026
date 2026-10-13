# Desty 3.1 — Agent Skills Registry for Fullstack Delivery (2026)

> **Super Agent Orchestrateur** : **Desty 3.1**  
> **Propulsé par** : [Nexus Partners](https://nexus-partners.xyz/) · Cotonou, Bénin  
> **Créateur & Auteur** : [@hopsyder (Hop-Syder)](https://github.com/Hop-Syder)  

---

## 🌟 Présentation de Desty 3.1

Un registre **multi-agents** pour emmener un projet fullstack de l'idée à la
production : **build → test → prod**. Chaque agent possède un rôle clair et
porte un jeu de *skills* réels, issus de dépôts GitHub publics **vérifiés**.

> **État actuel : cartographie.** Ce dépôt contient l'architecture et le
> tableau agent → skills, avec la source exacte de chaque skill. Le **contenu**
> des skills (dossiers `SKILL.md`) est disponible sous `skills/`.

## La chaîne en un coup d'œil

| # | Agent | Possède… | Fiche |
|---|-------|----------|-------|
| ① | **Product Manager** | le *quoi* et le *pourquoi* (spec, backlog) | [fiche](agents/01-product-manager.md) |
| ② | **Workflow / UX Owner** | le fil rouge utilisateur (parcours, API, UI) | [fiche](agents/02-workflow-ux-owner.md) |
| ③ | **Security Lead** | la sûreté (menaces, revue, durcissement) | [fiche](agents/03-security-lead.md) |
| ④ | **Build / Dev Lead** | le code qui marche (impl, tests, debug) | [fiche](agents/04-build-dev-lead.md) |
| ⑤ | **DevOps / Release** | la mise en prod (CI/CD, observabilité) | [fiche](agents/05-devops-release.md) |
| ⑥ | **QA / Evaluator** | la mesure : note les autres agents et le résultat | [fiche](agents/06-qa-evaluator.md) |
| ⑦ | **Data / ML** | les données et modèles (ML, NLP, pipelines) | [fiche](agents/07-data-ml.md) |

Chaque agent principal porte **~5 skills de pilotage** et délègue à des
**sous-agents** qui portent les skills d'exécution. L'orchestration
(délégation, parallélisme) vient de `obra/superpowers`.

➡️ **Le livrable central est le tableau complet : [`docs/MAPPING.md`](docs/MAPPING.md).**  
➡️ **Le cadre d'évaluation (score : 89/100) : [`docs/EVALUATION.md`](docs/EVALUATION.md).**

## Sources vérifiées

6 dépôts confirmés réels (étoiles/forks vérifiés le 13/10/2026) :
`addyosmani/agent-skills` · `anthropics/skills` · `obra/superpowers` ·
`trailofbits/skills` · `vercel-labs/agent-skills` · `NVIDIA/SkillSpector` (outil).

Détail et avertissement sur les dépôts non confirmés : [`docs/SOURCES.md`](docs/SOURCES.md).

## Sécurité de la supply-chain

En 2026, une part notable des skills publics contient des vulnérabilités.
**Règle du registre** : tout skill tiers passe `skillspector scan` (NVIDIA)
avant d'être adopté. C'est le rôle du sous-agent *Supply-chain gate*.

## Structure du dépôt

```
fullstack-agent-skills-2026/
├── README.md
├── agents/
│   ├── 01-product-manager.md
│   ├── 02-workflow-ux-owner.md
│   ├── 03-security-lead.md
│   ├── 04-build-dev-lead.md
│   ├── 05-devops-release.md
│   ├── 06-qa-evaluator.md   ← note la performance des agents
│   └── 07-data-ml.md        ← données & modèles (ML, NLP)
├── docs/
│   ├── MAPPING.md      ← tableau maître agent → skills
│   ├── SOURCES.md      ← dépôts vérifiés + vérifications
│   └── EVALUATION.md   ← grille + protocole d'évaluation du super-agent
└── skills/             ← registre opérationnel des skills (Addy Osmani & Superpowers)
```

---

*Maintenu par [@hopsyder](https://github.com/Hop-Syder) — Nexus Partners.*
