---
name: subagent-driven-development
description: "Déléguer l'implémentation à des sous-agents avec portes qualité"
metadata:
  agent: orchestration
  upstream_author: obra
  upstream_repo: https://github.com/obra/superpowers
  upstream_path: skills/subagent-driven-development
  upstream_commit: bb92a77741419a4ab5f06e711a283343f1ada0c3
  adaptation: "Résumé opérationnel condensé pour Dexty 3.5.1 (Nexus Partners)"
---

# Subagent Driven Development

## Objectif opérationnel
Déléguer l'implémentation à des sous-agents avec portes qualité. Ce skill encadre l'intervention de l'agent `orchestration` avec des règles vérifiables avant toute validation.

## Protocole d'exécution
1. Analyser le contexte dans `.project-memory/MAP.md`, `REFUSALS.md` et `ERRORS.md` avant d'agir.
2. Appliquer les contrôles de qualité et de sûreté propres au domaine (orchestration, subagent, delegation, workflow).
3. Produire un livrable testable, sans secret en dur ni dépendance non vérifiée.
4. Documenter les arbitrages techniques pour revue par l'agent QA / Evaluator.
