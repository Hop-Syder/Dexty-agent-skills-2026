---
name: skill-creator
description: "Créer et évaluer de nouveaux skills d'agent"
metadata:
  agent: qa-evaluator
  upstream_author: anthropics
  upstream_repo: https://github.com/anthropics/skills
  upstream_path: skills/skill-creator
  upstream_commit: 9fa6b21c43141f22b79a83832c32cf976eef57d6
  adaptation: "Résumé opérationnel condensé pour Dexty 3.5.1 (Nexus Partners)"
---

# Skill Creator

## Objectif opérationnel
Créer et évaluer de nouveaux skills d'agent. Ce skill encadre l'intervention de l'agent `qa-evaluator` avec des règles vérifiables avant toute validation.

## Protocole d'exécution
1. Analyser le contexte dans `.project-memory/MAP.md`, `REFUSALS.md` et `ERRORS.md` avant d'agir.
2. Appliquer les contrôles de qualité et de sûreté propres au domaine (skills, eval, meta, creation).
3. Produire un livrable testable, sans secret en dur ni dépendance non vérifiée.
4. Documenter les arbitrages techniques pour revue par l'agent QA / Evaluator.
