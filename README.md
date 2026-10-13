# Desty 3.5 — Agent Skills Registry for Fullstack Delivery (2026)

> **Super Agent Orchestrateur** : **Desty 3.5**  
> **Propulsé par** : [Nexus Partners](https://nexus-partners.xyz/) · Cotonou, Bénin  
> **Créateur & Auteur** : [@hopsyder (Hop-Syder)](https://github.com/Hop-Syder)  

---

## 🌟 Présentation de Desty 3.5

Un registre **multi-agents souverain et contextuel** pour emmener un projet fullstack de l'idée à la production : **build → test → prod**.
Desty 3.5 introduit **l'accueil interactif et la sélection intelligente** : au lieu de choisir des skills au hasard ou de charger l'intégralité du catalogue, **l'agent analyse le projet que vous lui décrivez via un questionnaire guidé (7 questions) et sélectionne sur mesure les compétences indispensables.**

---

## 🧭 Le Nouveau Flow en 6 Pièces

| Pièce | Rôle |
|---|---|
| **`tools/onboard.sh`** | **Le cœur de Desty 3.5.** Démarre dès la détection d'un nouveau projet. Pose 7 questions clés (nom, description, stack, features, horizon, app publique, données sensibles) et génère un `.agents/skills.lock` sur-mesure. |
| **`skills.catalog.json`** | **Le cerveau de la sélection.** Catalogue des 37 skills de référence avec leurs déclencheurs sémantiques (*triggers*). |
| **`tools/skills-sync.sh`** | **Installation propre.** Installe uniquement les skills du lock dans `.agents/skills/`. Soumet chaque skill au scanner `SkillSpector` et refuse les DNI. |
| **`tools/skills-check.sh`** | **Surveillance non intrusive.** Compare chaque skill par son SHA via l'API GitHub. Consigne le résultat dans `.agents/.last-check.json`. |
| **Workflow Hebdomadaire** (`workflows/skills-update.yml`) | Chaque lundi 08h UTC : vérification upstream + PR documentée avec diff et score de sécurité. Jamais de merge automatique. |
| **`memory-wake.sh`** | **Réveil intelligent.** Détecte 3 états : (a) mémoire absente (affiche les instructions d'install), (b) MAP vide/template (déclenche l'onboarding), (c) session normale (charge le contexte et alerte si des PRs sont en attente). |

---

## 🏛️ Les 8 Pôles d'Agents de Desty 3.5

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

## 🚀 Démarrer un projet avec Desty 3.5

```bash
# 1. Cloner le registre hôte
git clone https://github.com/Hop-Syder/fullstack-agent-skills-2026.git ~/fullstack-agent-skills-2026

# 2. Installer dans votre projet cible
~/fullstack-agent-skills-2026/install.sh /chemin/vers/mon-projet --onboard
```

L'onboarding interactif se lance immédiatement, analyse votre stack, configure `.agents/skills.lock`, remplit `MAP.md`, et lance la synchronisation locale.

---

## 🛡️ Règles de gouvernance strictes

- **Zéro mise à jour en douce** : rien n'est modifié sans votre accord explicite sur une PR.
- **Zéro composant non scanné** : tout skill tiers passe obligatoirement par SkillSpector.
- **Sélection contextuelle** : l'agent n'embarque que ce qui est utile à la mission.

---

*Maintenu par [@hopsyder](https://github.com/Hop-Syder) — Nexus Partners.*
