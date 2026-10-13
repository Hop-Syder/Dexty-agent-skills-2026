---
name: security-threat-model
description: "Modéliser les menaces (STRIDE, arbres d'attaque)"
metadata:
  agent: security-lead
  upstream_author: trailofbits
  upstream_repo: https://github.com/trailofbits/skills
  upstream_path: skills/security-threat-model
  upstream_commit: 5a47e1992014bcf088a209867909ebdf7a5223c9
  adaptation: "Résumé opérationnel condensé pour Dexty 3.5.1 (Nexus Partners)"
---

# Security Threat Model

## Objectif opérationnel
Modéliser les menaces (STRIDE, arbres d'attaque). Ce skill encadre l'intervention de l'agent `security-lead` avec des règles vérifiables avant toute validation.

## Protocole d'exécution
1. Analyser le contexte dans `.project-memory/MAP.md`, `REFUSALS.md` et `ERRORS.md` avant d'agir.
2. Appliquer les contrôles de qualité et de sûreté propres au domaine (security, threat, risk, model).
3. Produire un livrable testable, sans secret en dur ni dépendance non vérifiée.
4. Documenter les arbitrages techniques pour revue par l'agent QA / Evaluator.
