# Desty 3.2 — Agent Skills Registry for Fullstack Delivery (2026)

> **Super Agent Orchestrateur** : **Desty 3.2**  
> **Propulsé par** : [Nexus Partners](https://nexus-partners.xyz/) · Cotonou, Bénin  
> **Créateur & Auteur** : [@hopsyder (Hop-Syder)](https://github.com/Hop-Syder)  

---

## 🌟 Présentation de Desty 3.2

Un registre **multi-agents souverain et déterministe** pour emmener un projet fullstack de l'idée à la production : **build → test → prod**.
Il réunit l'excellence de l'orchestration multi-agents et la rigueur de la gestion des dépendances : **les skills sont installés en local, figés sur une version exacte dans `skills.lock`, audités par `SkillSpector`, et protégés contre toute mise à jour en douce.**

---

## 🔒 Le Système en 4 Pièces (Lock, Sync, Check & Watch)

| Pièce | Rôle |
|---|---|
| **`skills.lock`** | La liste des ~40 skills de `MAPPING.md`. Pour chacun : dépôt, commit exact (SHA) et score de sécurité. **Seule source de vérité.** |
| **`skills-sync.sh`** | **Remplace `--with-skills`.** Installe uniquement les skills du lock dans `.agents/skills/`. Valide chaque skill avec SkillSpector. |
| **`skills-check.sh`** | Compare le lock avec les dépôts GitHub : à jour (`UP_TO_DATE`), mise à jour disponible (`UPDATE_AVAILABLE`) ou supprimé (`DELETED`). |
| **Workflow Hebdomadaire** (`workflows/skills-watch.yml`) | Vérifie les dépôts amont chaque semaine. Ouvre une Pull Request documentée si un changement est détecté avec score de sécurité. |

> 🧠 **Au démarrage de chaque session**, l'agent **Project Memory** lit l'état de la veille :  
> *« 2 mises à jour de skills en attente de validation, voir PR #12 »*.

---

## 🏛️ Les 8 Agents de la Chaîne

| # | Agent Principal | Mission Principale | Fiche Détaillée |
|---|-----------------|-------------------|-----------------|
| ① | **Product Manager** | Le *quoi* et le *pourquoi* (spécifications, backlog, ADR) | [Fiche Agent](agents/01-product-manager.md) |
| ② | **Workflow / UX Owner** | Le fil rouge utilisateur (parcours, API front, UI tokens) | [Fiche Agent](agents/02-workflow-ux-owner.md) |
| ③ | **Security Lead** | La sûreté globale (modèle de menaces, audit, garde-fous) | [Fiche Agent](agents/03-security-lead.md) |
| ④ | **Build / Dev Lead** | Le code testé et fonctionnel (TDD, implémentation, debug) | [Fiche Agent](agents/04-build-dev-lead.md) |
| ⑤ | **DevOps / Release** | L'industrialisation (CI/CD, déploiement, observabilité SRE) | [Fiche Agent](agents/05-devops-release.md) |
| ⑥ | **QA / Evaluator** | La mesure : note les autres agents et le résultat (juge séparé) | [Fiche Agent](agents/06-qa-evaluator.md) |
| ⑦ | **Data / ML** | Les données et modèles (ML, NLP, pipelines) | [Fiche Agent](agents/07-data-ml.md) |
| ⑧ | **Project Memory** | La mémoire vive persistante + gardien de la vision | [Fiche Agent](agents/08-project-memory.md) |

---

## 🔄 Votre quotidien avec ce système

1. **Installation (une seule fois)** :
   ```bash
   ./install.sh /chemin/vers/mon-projet
   cd /chemin/vers/mon-projet && ./skills-sync.sh
   ```
2. **Au travail quotidien** :
   L'agent tourne 100% hors ligne sur les skills locaux scannés. Aucun appel réseau inutile, stabilité maximale.
3. **Chaque semaine (veille automatique)** :
   Une PR arrive en cas d'évolution amont. Vous examinez le diff et le score de sécurité, puis fusionnez ou refusez.
4. **Ajout d'un skill** :
   Déclaration dans `skills.lock` -> `./skills-sync.sh` (scan obligatoire avant adoption).

---

## 🛡️ Les Règles d'Or

- **Rien n'est mis à jour sans votre validation explicite.**
- **Aucun skill n'est installé sans scan réussi.**
- **Rien d'autre que ce qui est consigné dans `skills.lock`.**

---

## 📂 Structure du Répertoire

```text
fullstack-agent-skills-2026/
├── README.md                          # Guide central Desty 3.2
├── skills.lock                        # Source de vérité des versions figées et scores
├── skills-sync.sh                     # Script d'installation locale et audit sécurité
├── skills-check.sh                    # Audit de conformité face aux dépôts amont
├── install.sh                         # Script d'installation idempotent de projet
├── INSTALL.md                         # Guide d'installation pas-à-pas multi-outils
├── AGENTS.md                          # Instructions universelles de session
├── CLAUDE.md                          # Configuration Claude Code
├── workflows/
│   ├── skills-watch.yml               # Surveillance hebdomadaire & création de PR
│   └── sdlc-pipeline.yaml             # Pipeline d'orchestration SDLC multi-agents
├── .project-memory/                   # Mémoire vive (MAP, STATE, REFUSALS, DECISIONS...)
├── agents/                            # Fiches opérationnelles des 8 agents
├── docs/                              # MAPPING (cartographie), SOURCES, EVALUATION (89/100)
└── skills/                            # Registre de référence (Addy Osmani & Superpowers)
```

---

*Maintenu par [@hopsyder](https://github.com/Hop-Syder) — Nexus Partners.*
