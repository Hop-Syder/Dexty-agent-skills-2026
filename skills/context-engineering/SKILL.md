---
name: context-engineering
description: "Ingénierie du contexte : garder la mémoire compacte et utile"
metadata:
  agent: project-memory
  upstream_author: addyosmani
  upstream_repo: https://github.com/addyosmani/agent-skills
  upstream_path: skills/context-engineering
  upstream_commit: 1be8e34187e34647bb83adc3a1323b26ae6f6abe
  adaptation: "Résumé opérationnel condensé pour Dexty 3.5.1 (Nexus Partners)"
---

# Context Engineering

## Objectif opérationnel
Ingénierie du contexte : garder la mémoire compacte et utile. Ce skill encadre l'intervention de l'agent `project-memory` avec des règles vérifiables avant toute validation.

## Protocole d'exécution
1. Analyser le contexte dans `.project-memory/MAP.md`, `REFUSALS.md` et `ERRORS.md` avant d'agir.
2. Appliquer les contrôles de qualité et de sûreté propres au domaine (memory, context, prompt, engineering).
3. Produire un livrable testable, sans secret en dur ni dépendance non vérifiée.
4. Documenter les arbitrages techniques pour revue par l'agent QA / Evaluator.
