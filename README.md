# Desty 3.0 — Agent Skills Registry for Fullstack Delivery (2026)

> **Super Agent Orchestrateur** : **Desty 3.0**  
> **Propulsé par** : [Nexus Partners](https://nexus-partners.xyz/) · Cotonou, Bénin  
> **Créateur & Auteur** : [@hopsyder (Hop-Syder)](https://github.com/Hop-Syder)  

---

## 🌟 Présentation de Desty 3.0

**Desty 3.0** est un super agent d'orchestration multi-agents conçu pour emmener un projet fullstack de l'idée à la production : **build → test → prod**.
Chaque pôle possède un rôle clair et porte un jeu de compétences réelles (*skills*), issues des registres GitHub publics **officiellement vérifiés**.

---

## 🏛️ La chaîne de délégation en un coup d'œil

| # | Agent Principal | Mission Principale | Fiche Détaillée |
|---|-----------------|-------------------|-----------------|
| ① | **Product Manager** | Le *quoi* et le *pourquoi* (spécifications, backlog, ADR) | [Fiche Agent](agents/01-product-manager.md) |
| ② | **Workflow / UX Owner** | Le fil rouge utilisateur (parcours, API front, UI tokens) | [Fiche Agent](agents/02-workflow-ux-owner.md) |
| ③ | **Security Lead** | La sûreté globale (modèle de menaces, audit, garde-fous) | [Fiche Agent](agents/03-security-lead.md) |
| ④ | **Build / Dev Lead** | Le code testé et fonctionnel (TDD, implémentation, debug) | [Fiche Agent](agents/04-build-dev-lead.md) |
| ⑤ | **DevOps / Release** | L'industrialisation (CI/CD, déploiement, observabilité SRE) | [Fiche Agent](agents/05-devops-release.md) |
| ⑥ | **QA / Evaluator** | La mesure : note les agents et les livrables (juge séparé) | [Fiche Agent](agents/06-qa-evaluator.md) |

Chaque agent principal porte **~5 skills de pilotage** et délègue à des **sous-agents** qui portent les skills d'exécution technique. L'orchestration multi-agents (délégation, worktrees, parallélisme) est motorisée par les patterns de `obra/superpowers`.

➡️ **Le livrable central d'architecture est le tableau maître : [`docs/MAPPING.md`](docs/MAPPING.md).**  
➡️ **Le cadre d'évaluation et de notation (85/100) : [`docs/EVALUATION.md`](docs/EVALUATION.md).**

---

## 📚 Dépôts sources vérifiés

Le registre s'appuie sur 6 sources institutionnelles confirmées :
- [`addyosmani/agent-skills`](https://github.com/addyosmani/agent-skills) — Colonne vertébrale du cycle DEFINE→SHIP (25 skills)
- [`anthropics/skills`](https://github.com/anthropics/skills) — Registre officiel Anthropic (spec SKILL.md, design, doc, test)
- [`obra/superpowers`](https://github.com/obra/superpowers) — Framework d'orchestration par sous-agents
- [`trailofbits/skills`](https://github.com/trailofbits/skills) — Skills de sécurité applicative et d'audit
- [`vercel-labs/agent-skills`](https://github.com/vercel-labs/agent-skills) — Skills officiels Vercel pour Next.js/React et déploiement
- [`NVIDIA/SkillSpector`](https://github.com/NVIDIA/SkillSpector) — Outil CLI de sécurité & audit des skills IA

Consultez le détail des vérifications et des métriques dans [`docs/SOURCES.md`](docs/SOURCES.md).

---

## 🛡️ Sécurité de la supply-chain IA

Conformément aux standards de 2026, **tout skill tiers adopté dans ce registre doit passer `skillspector scan` (NVIDIA)** avant utilisation pour éliminer les risques d'exfiltration de secrets ou d'injection de prompt. C'est le rôle attribué au sous-agent *Supply-chain gate*.

---

## 📂 Structure du dépôt

```text
fullstack-agent-skills-2026/
├── README.md                          # Guide central Desty 3.0 & Nexus Partners
├── docs/
│   ├── MAPPING.md                     # Tableau maître Agents → Sous-Agents → Skills
│   ├── SOURCES.md                     # Traçabilité des dépôts vérifiés
│   └── EVALUATION.md                  # Grille (85/100) et protocole d'évaluation
├── agents/                            # Fiches de mission et directives opérationnelles
│   ├── 01-product-manager.md
│   ├── 02-workflow-ux-owner.md
│   ├── 03-security-lead.md
│   ├── 04-build-dev-lead.md
│   ├── 05-devops-release.md
│   └── 06-qa-evaluator.md             # Évaluation et notation de conformité
└── skills/                            # Registre opérationnel des fichiers SKILL.md
    ├── addyosmani/                    # Les 25 skills du cycle DEFINE → SHIP
    └── superpowers/                   # Les skills d'orchestration multi-agents
```

---

*Maintenu par [@hopsyder](https://github.com/Hop-Syder) — Nexus Partners.*
