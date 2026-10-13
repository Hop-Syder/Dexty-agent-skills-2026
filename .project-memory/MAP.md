# Carte mentale du projet (MAP)
*Relu à chaque réveil. Doit rester compact (≤ 150 lignes).*

## 1. Vision
- **Projet** : Dexty Agent Skills
- **Ce que c'est en une phrase** : Un framework open source d'agents de code à mémoire persistante, avec sélection contextuelle des skills, verrouillage déterministe et évaluation QA indépendante.
- **La cible (utilisateurs)** : Développeurs et équipes techniques qui utilisent des agents de code (Claude Code, Codex, Cursor, VS Code…) sur des projets réels.
- **La finalité (le problème résolu)** : Résoudre les 4 défauts majeurs des agents de code — amnésie de session, gaspillage de tokens, mises à jour sauvages et auto-évaluation — pour qu'un agent reste aligné sur la vision du projet dans la durée.

## 2. Périmètre
- **Dans le périmètre (MVP)** :
  - 8 agents spécialisés couvrant tout le cycle (PM → UX → Sécurité → Dev → DevOps → QA → Data/ML → Mémoire)
  - Onboarding en 7 questions pour sélectionner les skills pertinents
  - `skills.lock` : verrouillage de chaque skill sur un commit SHA exact
  - `skills-sync.sh` / `skills-check.sh` : installation locale + scan sécurité (SkillSpector)
  - `.project-memory/` : mémoire persistante relue à chaque session (MAP, STATE, REFUSALS, ERRORS, DECISIONS)
  - Pipeline CI/CD multi-agents (`sdlc-pipeline.yaml`)
  - Veille hebdomadaire automatique avec PR de mise à jour (`skills-update.yml`)
  - Licence AGPL-3.0 pour protéger l'investissement
- **Hors périmètre (ce qu'on refuse de faire maintenant)** :
  - Interface graphique / dashboard web
  - Marketplace de skills tiers
  - Support d'agents non-LLM (règles statiques)
  - Monétisation ou système de paiement intégré

## 3. Architecture choisie
- **Front** : Aucun (CLI-first, intégration dans les éditeurs existants)
- **Back / API** : Scripts Bash (`install.sh`, `onboard.sh`, `skills-sync.sh`, `skills-check.sh`) + GitHub Actions
- **Base** : Fichiers Markdown/JSON dans `.project-memory/` et `skills.lock` (flat-file, pas de BDD)
- **Déploiement** : GitHub comme plateforme (dépôt clonable, GitHub Actions pour la veille)

## 4. Où on en est
- **Étape courante** : configuration initiale terminée, MAP rempli
- **Dernier jalon validé** : cartographie, mémoire, licence AGPL-3.0
- **Prochain jalon** : installer les skills dans `skills.lock` et lancer le premier scan de sécurité

## 5. Principes non négociables
1. Zéro mise à jour silencieuse — tout passe par une PR validée
2. Le juge (QA) ne code pas, le codeur ne se juge pas
3. La mémoire est relue à chaque session, sans exception
4. Tout skill tiers est scanné (SkillSpector) avant installation
5. L'utilisateur a le dernier mot — l'agent argumente mais n'impose pas
