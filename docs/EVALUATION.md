<!--
  EVALUATION.md — Évaluer le super-agent Desty 3.0
  Nexus Partners · Cotonou, Bénin
  Créateur: @hopsyder (https://github.com/Hop-Syder)
-->

# Évaluer le super-agent Desty 3.0

Ce document couvre les **trois niveaux d'évaluation** du super-agent conçu
dans ce registre, du plus immédiat au plus exigeant :

1. **Niveau 1 — Architecture (sur le papier)** : noter la conception. *Fait ici, maintenant.*
2. **Niveau 2 — Kit d'éval réutilisable** : grille + harness pour noter l'agent à chaque version.
3. **Niveau 3 — Super-agent en action** : lui donner une tâche réelle et noter le résultat. *Prérequis : skills installés + agent monté.*

> **Principe non négociable** : un agent ne se note jamais lui-même. L'évaluation
> est portée par l'**agent QA / Evaluator** (voir [`agents/06-qa-evaluator.md`](../agents/06-qa-evaluator.md)),
> un évaluateur **séparé** qui n'a pas participé au travail — sinon le travail corrige sa propre copie.

---

## Niveau 1 — Évaluation de l'architecture (notée)

Grille sur **100 points**, 5 axes de 20. Notes attribuées à l'architecture
actuelle (v0.1, cartographie), avec justification honnête.

| Axe | Ce qu'on vérifie | /20 | Justification |
|-----|------------------|-----|---------------|
| **Couverture** | Toutes les phases build→test→prod sont-elles couvertes ? | **18** | DEFINE→PLAN→BUILD→VERIFY→REVIEW→SHIP couverts. −2 : pas d'agent data/ML explicite (pertinent vu votre profil). |
| **Séparation des rôles** | Chaque agent a-t-il un périmètre net, sans chevauchement flou ? | **16** | Rôles distincts et handoffs définis. −4 : `code-review-and-quality` apparaît chez Build **et** QA → risque de doublon à arbitrer. |
| **Orchestration** | La délégation multi-agents est-elle réelle et cohérente ? | **17** | Ancrée sur obra/superpowers (dispatching, subagent-driven). −3 : l'ancre `using-superpowers` doit être présente pour que le reste s'active. |
| **Traçabilité des skills** | Chaque skill pointe-t-il vers une source réelle vérifiée ? | **20** | 6 dépôts vérifiés, dépôts douteux écartés et documentés. Point fort du repo. |
| **Évaluabilité** | Peut-on mesurer la performance de l'agent plus tard ? | **14** | Ce document + agent QA le permettent. −6 : tant que les `SKILL.md` ne sont pas installés, aucune éval *en action* n'est possible. |

### Score total : **85 / 100** — « Architecture solide, prête à passer à l'implémentation »

**Lecture du score :**
- **90–100** : prêt à industrialiser.
- **75–89** : solide, corriger 1–2 points avant d'implémenter. ← *nous sommes ici*
- **60–74** : des trous à combler.
- **< 60** : re-concevoir.

### Actions correctives recommandées (pour viser 90+)
1. Trancher le doublon `code-review-and-quality` : il reste chez **QA**, Build garde seulement `requesting-code-review`.
2. Ajouter (optionnel, vu votre profil data) un agent **Data/ML** ou un sous-agent dédié.
3. Installer l'ancre `using-superpowers` dès le départ.

---

## Niveau 2 — Kit d'éval réutilisable

Pour noter l'agent **à chaque version**, deux briques :

### a) La grille (ci-dessus) versionnée
Copier le tableau du Niveau 1 dans un fichier daté à chaque release :
`docs/evals/2026-10-13-v0.1.md`, etc. On suit l'évolution du score dans le temps.

### b) Le harness technique (voie officielle, fiable)
On s'appuie sur les outils **officiels**, pas sur un harness tiers non vérifié :

| Outil | Rôle | Source |
|-------|------|--------|
| `skill-creator` | Tester / mesurer / affiner chaque skill (evals) | [anthropics/skills](https://github.com/anthropics/skills) |
| `claude plugin eval` | Lancer une suite de tests sur le plugin/agent, sortir un rapport chiffré | Claude Code (intégré) |
| `subagent-driven-development` | Revue par un sous-agent frais (juge ≠ exécutant) | [obra/superpowers](https://github.com/obra/superpowers) |
| `SkillSpector` | Noter la sûreté de chaque skill (0–100) | [NVIDIA/SkillSpector](https://github.com/NVIDIA/SkillSpector) |

---

## Niveau 3 — Super-agent en action (protocole)

Quand les skills seront installés et l'agent monté, on le note sur des **tâches réelles**.

### Jeu de tâches d'épreuve (à adapter à vos projets, ex. Wilinwi / EmiID)
1. **Petite feature** : ajouter un champ + sa validation + son test.
2. **Bug réel** : corriger un bug fourni, sans régression.
3. **Feature verticale** : de la spec au déploiement d'un endpoint complet.
4. **Épreuve sécurité** : détecter une vulnérabilité volontairement introduite.

### Barème par tâche (/100)
| Critère | Poids | Mesuré par |
|---------|-------|-----------|
| Spec respectée (fait ce qui était demandé) | 30 | Juge QA vs spec |
| Tests présents et verts | 20 | CI |
| Sécurité (aucune régression, diff auditée) | 20 | SkillSpector + Security Lead |
| Qualité du code (lisible, maintenable) | 15 | Juge QA |
| Autonomie (peu de corrections humaines) | 15 | Nb d'interventions |

### Règle d'or du protocole
Le **juge est un agent séparé** (QA / Evaluator) qui reçoit uniquement la spec
et le résultat — pas l'historique de production. Deux passes : conformité à la
spec, **puis** qualité du code.

---

## Suivi des scores dans le temps

| Date | Version | Niveau | Score | Note |
|------|---------|--------|-------|------|
| 2026-10-13 | v0.1 | Architecture | 85/100 | Cartographie validée |
| … | … | … | … | (à compléter) |
