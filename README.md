# Desty 3.2 — Agent Skills Registry for Fullstack Delivery (2026)

> **Super Agent Orchestrateur** : **Desty 3.2**  
> **Propulsé par** : [Nexus Partners](https://nexus-partners.xyz/) · Cotonou, Bénin  
> **Créateur & Auteur** : [@hopsyder (Hop-Syder)](https://github.com/Hop-Syder)  

---

## 🌟 Présentation de Desty 3.2

Un registre **multi-agents** pour emmener un projet fullstack de l'idée à la
production : **build → test → prod**. Chaque agent possède un rôle clair et
porte un jeu de *skills* réels, issus de dépôts GitHub publics **vérifiés**.

> **État actuel : cartographie & mémoire active.** Ce dépôt contient l'architecture,
> le tableau agent → skills, les outils d'installation universels et le système de mémoire vive.

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
| ⑧ | **Project Memory** | la mémoire vive + gardien de la vision | [fiche](agents/08-project-memory.md) |

Chaque agent principal porte **~5 skills de pilotage** et délègue à des
**sous-agents** qui portent les skills d'exécution. L'orchestration
(délégation, parallélisme) vient de `obra/superpowers`.

➡️ **Le livrable central est le tableau complet : [`docs/MAPPING.md`](docs/MAPPING.md).**  
➡️ **Le cadre d'évaluation (score : 89/100) : [`docs/EVALUATION.md`](docs/EVALUATION.md).**  
➡️ **Installer le kit dans n'importe quel projet : [`INSTALL.md`](INSTALL.md) ou `./install.sh <projet>`.**

## Installer dans un projet

```bash
git clone https://github.com/Hop-Syder/fullstack-agent-skills-2026.git ~/fullstack-agent-skills-2026
~/fullstack-agent-skills-2026/install.sh /chemin/vers/mon-projet
```
Fonctionne avec **Claude Code, Codex, Cursor, VS Code (Copilot), OpenClaw**.

## Sources vérifiées

6 dépôts confirmés réels (étoiles/forks vérifiés le 13/10/2026) :
`addyosmani/agent-skills` · `anthropics/skills` · `obra/superpowers` ·
`trailofbits/skills` · `vercel-labs/agent-skills` · `NVIDIA/SkillSpector` (outil).

## Sécurité de la supply-chain

En 2026, une part notable des skills publics contient des vulnérabilités.
**Règle du registre** : tout skill tiers passe `skillspector scan` (NVIDIA)
avant d'être adopté. C'est le rôle du sous-agent *Supply-chain gate*.

## Structure du dépôt

```
fullstack-agent-skills-2026/
├── README.md
├── AGENTS.md           ← point d'entrée universel multi-outils
├── CLAUDE.md           ← configuration Claude Code
├── INSTALL.md          ← guide complet d'installation
├── install.sh          ← script d'installation idempotent
├── .project-memory/    ← mémoire persistante (MAP, STATE, REFUSALS…)
├── agents/             ← 8 fiches d'agents spécialisés
├── docs/               ← MAPPING, SOURCES, EVALUATION
└── skills/             ← registre opérationnel des skills (Addy Osmani & Superpowers)
```

---

*Maintenu par [@hopsyder](https://github.com/Hop-Syder) — Nexus Partners.*
