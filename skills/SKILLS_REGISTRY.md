# Registre Exhaustif des Skills d'Ingénierie pour Testy 3.0

Ce catalogue recense les fiches de compétences standardisées utilisées par **Testy 3.0**, le super agent conçu par **Nexus Partner** sous la direction de **[Hop-Syder](https://github.com/Hop-Syder)**.

---

## 1. Skills Produit & Planification (Product Management)

### `subagent-driven-development`
- **Source** : [obra/superpowers](https://github.com/obra/superpowers)
- **Objectif** : Piloter le développement logiciel par délégation descendante à des sous-agents autonomes éphémères spécialisés, avec barrières de validation strictes.
- **Entrées** : Objectif de sprint, critères d'acceptation.
- **Sorties** : Sous-tâches déléguées, retours d'exécution validés.

### `writing-plans`
- **Source** : [obra/superpowers](https://github.com/obra/superpowers)
- **Objectif** : Structurer des plans de projet exhaustifs en étapes vérifiables et non-ambiguës.
- **Entrées** : Spécifications initiales.
- **Sorties** : Fichier `plan.md` ordonnancé.

### `idea-refine`
- **Source** : [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
- **Objectif** : Transformer une idée brute en opportunité produit cadrée avec persona, problème et proposition de valeur.

### `executing-plans`
- **Source** : [obra/superpowers](https://github.com/obra/superpowers)
- **Objectif** : Exécuter méthodiquement chaque étape d'un plan sans sauter d'étape et avec vérification continue.

### `interview-me`
- **Source** : [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
- **Objectif** : Conduire une session interactive de questions-réponses avec le développeur pour clarifier les zones d'ombre.

---

## 2. Skills Workflow, Spécifications & ADR

### `planning-and-task-breakdown`
- **Source** : [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
- **Objectif** : Décomposer les modules complexes en tâches unitaires de moins de 2 heures avec tests associés.

### `dispatching-parallel-agents`
- **Source** : [obra/superpowers](https://github.com/obra/superpowers)
- **Objectif** : Lancer en parallèle plusieurs sous-agents sans dépendances mutuelles et agréger leurs résultats.

### `documentation-and-adrs`
- **Source** : [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
- **Objectif** : Rédiger des Architecture Decision Records (ADR) structurés selon le modèle Nygard (Contexte, Décision, Conséquences).

### `spec-driven-development`
- **Source** : [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
- **Objectif** : Interdire toute ligne de code tant qu'une spécification formalisée n'a pas été validée.

---

## 3. Skills UI/UX Design & Modélisation de Flux

### `open-design-prototype`
- **Source** : [nexu-io/open-design](https://github.com/nexu-io/open-design)
- **Objectif** : Générer des composants UI visuels complets et du code interactif (Tailwind, React, Figma tokens).

### `archify-diagrams`
- **Source** : [tt-a1i/archify](https://github.com/tt-a1i/archify)
- **Objectif** : Transformer du code ou une architecture en diagrammes Mermaid et schémas d'états dynamiques.

### `frontend-design`
- **Source** : [anthropics/skills](https://github.com/anthropics/skills)
- **Objectif** : Produire des interfaces utilisateur intuitives, modernes et esthétiquement soignées.

### `canvas-design` & `theme-factory`
- **Source** : [anthropics/skills](https://github.com/anthropics/skills)
- **Objectif** : Créer des palettes chromatiques harmonieuses, échelles typographiques et gabarits de présentation.

---

## 4. Skills Sécurité, Audit & Protection IA

### `security-and-hardening`
- **Source** : [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
- **Objectif** : Durcissement des headers HTTP, politiques CSP, assainissement des entrées/sorties et gestion des secrets.

### `rea-static-analysis`
- **Source** : [morluto/rea](https://github.com/morluto/rea)
- **Objectif** : Audit binaire, rétro-ingénierie et recherche de failles logiques dans les flux d'exécution.

### `skillspector-scan`
- **Source** : [NVIDIA/SkillSpector](https://github.com/NVIDIA/SkillSpector)
- **Objectif** : Détection des risques d'injection de prompt, d'exfiltration de données et de permissions abusives dans les outils/skills IA.

### `vulnerability-detection` & `audit-workflows`
- **Source** : [trailofbits/skills](https://github.com/trailofbits/skills)
- **Objectif** : Identification méthodique des failles de sécurité courantes (OWASP Top 10, CWE).

---

## 5. Skills Développement Full Stack & Qualité de Code

### `api-and-interface-design`
- **Source** : [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
- **Objectif** : Conception de contrats d'API stricts, typés et auto-documentés (OpenAPI, tRPC, Zod).

### `ponytail-yagni`
- **Source** : [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail)
- **Objectif** : Éliminer la sur-ingénierie ("You Aren't Gonna Need It"), simplifier l'architecture et privilégier la maintenabilité.

### `systematic-debugging`
- **Source** : [obra/superpowers](https://github.com/obra/superpowers)
- **Objectif** : Protocole strict en 4 phases : Reproduction -> Isolation -> Correction minimale -> Test de non-régression.

### `performance-optimization`
- **Source** : [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
- **Objectif** : Optimisation des métriques Web Vitals, tree-shaking, caching et réduction de la complexité algorithmique.

---

## 6. Skills QA, Déploiement & SRE

### `test-driven-development`
- **Source** : [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
- **Objectif** : Cycle Red-Green-Refactor rigoureux avant tout commit fonctionnel.

### `browser-testing-with-devtools`
- **Source** : [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
- **Objectif** : Pilotage automatisé du navigateur, inspection réseau et tests fonctionnels E2E.

### `ci-cd-and-automation` & `shipping-and-launch`
- **Source** : [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
- **Objectif** : Automatisation des pipelines GitHub Actions, tests de pré-livraison et publication sans interruption de service.

### `observability-and-instrumentation`
- **Source** : [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
- **Objectif** : Intégration d'OpenTelemetry, traçabilité distribuée, métriques Prometheus et journalisation structurée.
