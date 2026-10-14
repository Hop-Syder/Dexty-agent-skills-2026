---
name: vercel-deploy
description: "Déployer sur Vercel (Next.js, React, serverless functions)"
metadata:
  agent: devops-release
  upstream_author: vercel-labs
  upstream_repo: https://github.com/vercel-labs/agent-skills
  upstream_path: skills/vercel-deploy
  upstream_commit: 812b9c3f1917b204e1281fa02c89281e09dfa981
  adaptation: "Résumé opérationnel condensé pour Dexty 3.5.1 (Nexus Partners)"
---

# Vercel Deploy

## Objectif opérationnel
Déployer sur Vercel (Next.js, React, serverless functions). Ce skill encadre l'intervention de l'agent `devops-release` avec des règles vérifiables avant toute validation.

## Protocole d'exécution
1. Analyser le contexte dans `.project-memory/MAP.md`, `REFUSALS.md` et `ERRORS.md` avant d'agir.
2. Appliquer les contrôles de qualité et de sûreté propres au domaine (deploy, vercel, hosting, serverless).
3. Produire un livrable testable, sans secret en dur ni dépendance non vérifiée.
4. Documenter les arbitrages techniques pour revue par l'agent QA / Evaluator.
