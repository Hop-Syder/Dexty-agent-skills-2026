# Agent ⑥ — QA / Evaluator

<!--
  06-qa-evaluator.md — Agent QA / Evaluator (Desty 3.5)
  Super Agent: Desty 3.5 | Nexus Partners · Cotonou, Bénin
  Créateur: @hopsyder (https://github.com/Hop-Syder)
-->

> Possède la **mesure**. Note la performance des autres agents et du résultat produit. N'exécute pas le travail qu'il évalue.

## Pourquoi un agent séparé
Un agent ne doit **jamais se noter lui-même** : il corrigerait sa propre copie.
Le QA / Evaluator reçoit la spec et le résultat, pas l'historique de
production, et rend un score motivé. C'est le porteur de [`docs/EVALUATION.md`](../docs/EVALUATION.md).

## Skills / outils de l'agent
| Skill / Outil | Rôle | Source |
|---------------|------|--------|
| `skill-creator` | Tester, mesurer, affiner les skills (evals) | [anthropics/skills](https://github.com/anthropics/skills) |
| `claude plugin eval` | Suite de tests → rapport chiffré | Claude Code (intégré) |
| `requesting-code-review` | Revue par un juge frais (≠ exécutant) | [obra/superpowers](https://github.com/obra/superpowers) |
| `code-review-and-quality` | Grille de qualité du code | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) |
| `skillspector scan` | Noter la sûreté d'un skill (0–100) | [NVIDIA/SkillSpector](https://github.com/NVIDIA/SkillSpector) |
