<!--
  06-qa-evaluator.md — Agent QA / Evaluator (Desty 3.0)
  Super Agent: Desty 3.0 | Nexus Partners · Cotonou, Bénin
  Créateur: @hopsyder (https://github.com/Hop-Syder)
-->

# Agent ⑥ — QA / Evaluator

> Possède la **mesure**. Note la performance des autres agents et du résultat produit. N'exécute pas le travail qu'il évalue.

## Pourquoi un agent séparé
Un agent ne doit **jamais se noter lui-même** : il corrigerait sa propre copie.
Le QA / Evaluator reçoit la spec et le résultat, pas l'historique de
production, et rend un score motivé. C'est le porteur de [`docs/EVALUATION.md`](../docs/EVALUATION.md).

## Responsabilités
- Évaluer l'architecture (grille sur 100).
- Évaluer chaque skill (evals, A/B).
- Évaluer le super-agent en action sur des tâches d'épreuve.
- Tenir le suivi des scores dans le temps.

## Skills / outils de l'agent

| Skill / Outil | Rôle | Source |
|---------------|------|--------|
| `skill-creator` | Tester, mesurer, affiner les skills (evals) | [anthropics/skills](https://github.com/anthropics/skills) |
| `claude plugin eval` | Suite de tests → rapport chiffré | Claude Code (intégré) |
| `requesting-code-review` | Revue par un juge frais (≠ exécutant) | [obra/superpowers](https://github.com/obra/superpowers) |
| `code-review-and-quality` | Grille de qualité du code | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) |
| `skillspector scan` | Noter la sûreté d'un skill (0–100) | [NVIDIA/SkillSpector](https://github.com/NVIDIA/SkillSpector) |

## Sous-agents

| Sous-agent | Rôle | Skills |
|------------|------|--------|
| Spec-compliance judge | Vérifie que le résultat = la spec | `requesting-code-review` |
| Code-quality judge | Note lisibilité / maintenabilité | `code-review-and-quality` |
| Skill eval runner | Fait tourner les evals de skills | `skill-creator`, `claude plugin eval` |

## Handoffs
- **← tous les agents** : reçoit specs + résultats à noter.
- **→ Product Manager** : remonte les scores et les correctifs prioritaires.
- **→ tous** : publie la grille et le barème que chacun doit viser.

## ⚠️ Limite honnête
L'éval *en action* (Niveau 3) suppose les skills installés et l'agent monté.
Tant qu'on est en cartographie, seul le **Niveau 1 (architecture)** est mesurable.
