<!--
  EVALUATION.md — Évaluer le super-agent Desty 3.5
  Nexus Partners · Cotonou, Bénin
  Créateur: @hopsyder (https://github.com/Hop-Syder)
-->

# Évaluer le super-agent Desty 3.5

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
actuelle (v0.2, cartographie), avec justification honnête.

| Axe | Ce qu'on vérifie | /20 | Justification |
|-----|------------------|-----|---------------|
| **Couverture** | Toutes les phases build→test→prod sont-elles couvertes ? | **20** | DEFINE→PLAN→BUILD→VERIFY→REVIEW→SHIP + Data/ML (⑦) + Project Memory (⑧). Couverture totale. |
| **Séparation des rôles** | Chaque agent a-t-il un périmètre net, sans chevauchement flou ? | **20** | Doublon résolu : QA garde `code-review-and-quality`, Build ne fait que `requesting-code-review`. Juge ≠ exécutant. |
| **Orchestration** | La délégation multi-agents est-elle réelle et cohérente ? | **17** | Ancrée sur obra/superpowers (dispatching, subagent-driven). −3 : l'ancre `using-superpowers` doit être présente pour que le reste s'active. |
| **Traçabilité des skills** | Chaque skill pointe-t-il vers une source réelle vérifiée ? | **18** | 6 dépôts vérifiés + dépôts douteux écartés. −2 : agent Data/ML a 2 skills marqués « à sourcer » (assumé, non inventé). |
| **Évaluabilité** | Peut-on mesurer la performance de l'agent plus tard ? | **14** | Ce document + agent QA le permettent. −6 : tant que les `SKILL.md` ne sont pas installés, aucune éval *en action* n'est possible. |

### Score total : **89 / 100** — « Architecture solide, prête à passer à l'implémentation »

> **Évolution** : v0.1 = 85 → v0.2 = 89 (doublon résolu +4, couverture Data/ML +2,
> traçabilité −2 pour les skills « à sourcer »). Le plafond réel tant qu'on reste
> en cartographie est ~89 : les 11 points restants (évaluabilité −6, orchestration −3,
> sourcing data −2) ne se gagnent qu'en **installant les vrais skills** et en montant l'agent.

---

## Niveau 2 — Kit d'éval réutilisable

Pour noter l'agent **à chaque version**, deux briques :

### a) La grille (ci-dessus) versionnée
Copier le tableau du Niveau 1 dans un fichier daté à chaque release.

### b) Le harness technique (voie officielle, fiable)
On s'appuie sur les outils **officiels** :
- `skill-creator` ([`anthropics/skills`](https://github.com/anthropics/skills))
- `claude plugin eval` (Claude Code)
- `subagent-driven-development` ([`obra/superpowers`](https://github.com/obra/superpowers))
- `SkillSpector` ([`NVIDIA/SkillSpector`](https://github.com/NVIDIA/SkillSpector))

---

## Niveau 3 — Super-agent en action (protocole)

Quand les skills seront installés et l'agent monté, on le note sur des **tâches réelles** :
1. **Petite feature** : ajouter un champ + sa validation + son test.
2. **Bug réel** : corriger un bug fourni, sans régression.
3. **Feature verticale** : de la spec au déploiement d'un endpoint complet.
4. **Épreuve sécurité** : détecter une vulnérabilité volontairement introduite.

Le **juge est un agent séparé** (QA / Evaluator) qui reçoit uniquement la spec
et le résultat — pas l'historique de production.
