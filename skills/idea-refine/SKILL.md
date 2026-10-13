---
name: idea-refine
description: "Raffiner et clarifier une idée de projet avant de la spécifier"
metadata:
  agent: product-manager
  upstream_author: addyosmani
  upstream_repo: https://github.com/addyosmani/agent-skills
  upstream_path: skills/idea-refine
  upstream_commit: 1be8e34187e34647bb83adc3a1323b26ae6f6abe
  adaptation: "Résumé opérationnel condensé pour Dexty 3.5.1 (Nexus Partners)"
---

# Idea Refine

## Objectif opérationnel
Raffiner et clarifier une idée de projet avant de la spécifier. Ce skill encadre l'intervention de l'agent `product-manager` avec des règles vérifiables avant toute validation.

## Protocole d'exécution
1. Analyser le contexte dans `.project-memory/MAP.md`, `REFUSALS.md` et `ERRORS.md` avant d'agir.
2. Appliquer les contrôles de qualité et de sûreté propres au domaine (planning, product, ideation, spec).
3. Produire un livrable testable, sans secret en dur ni dépendance non vérifiée.
4. Documenter les arbitrages techniques pour revue par l'agent QA / Evaluator.
