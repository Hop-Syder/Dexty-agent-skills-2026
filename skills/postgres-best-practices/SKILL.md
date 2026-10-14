---
name: postgres-best-practices
description: "Bonnes pratiques PostgreSQL : schéma, index, requêtes"
metadata:
  agent: data-ml
  upstream_author: supabase
  upstream_repo: https://github.com/supabase/agent-skills
  upstream_path: skills/postgres-best-practices
  upstream_commit: c47f63110a12e32a4980bb6e19c011e0ef821102
  adaptation: "Résumé opérationnel condensé pour Dexty 3.5.1 (Nexus Partners)"
---

# Postgres Best Practices

## Objectif opérationnel
Bonnes pratiques PostgreSQL : schéma, index, requêtes. Ce skill encadre l'intervention de l'agent `data-ml` avec des règles vérifiables avant toute validation.

## Protocole d'exécution
1. Analyser le contexte dans `.project-memory/MAP.md`, `REFUSALS.md` et `ERRORS.md` avant d'agir.
2. Appliquer les contrôles de qualité et de sûreté propres au domaine (database, postgres, sql, data).
3. Produire un livrable testable, sans secret en dur ni dépendance non vérifiée.
4. Documenter les arbitrages techniques pour revue par l'agent QA / Evaluator.
