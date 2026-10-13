<!--
  07-data-ml.md — Agent Data / ML (Desty 3.1)
  Super Agent: Desty 3.1 | Nexus Partners · Cotonou, Bénin
  Créateur: @hopsyder (https://github.com/Hop-Syder)
-->

# Agent ⑦ — Data / ML

> Possède la **donnée et les modèles** : pipelines data, ML, NLP. Ajouté pour coller au profil data scientist du registre.

## Responsabilités
- Préparer et valider les données.
- Construire, entraîner, évaluer des modèles (ML / Deep Learning / NLP).
- Exposer les modèles via API (lien avec Workflow/UX et Build).
- Instrumenter la qualité des données et la dérive des modèles.

## Skills / outils de l'agent

| Skill / Outil | Rôle | Source | État |
|---------------|------|--------|------|
| `xlsx` | Lire / produire des données tabulaires | [anthropics/skills](https://github.com/anthropics/skills) | ✅ vérifié |
| `postgres-best-practices` | Modéliser et requêter la donnée | [supabase/agent-skills](https://github.com/supabase/agent-skills) | ✅ vérifié |
| `observability-and-instrumentation` | Suivre qualité données / dérive | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | ✅ vérifié |
| `data-pipeline` (ETL/feature) | Ingestion et préparation | — | ⚠️ **à sourcer** |
| `ml-training-eval` (train + metrics) | Entraînement et évaluation de modèles | — | ⚠️ **à sourcer** |

> ⚠️ **Honnêteté sur les sources** : au 13/10/2026, nos 6 dépôts vérifiés sont
> orientés *software engineering* et ne contiennent pas de skill ML/NLP dédié.
> Les deux dernières lignes sont donc marquées **« à sourcer »** : il faudra
> soit trouver un dépôt data vérifié (des skills Jupyter/notebook existent mais
> sur des comptes non confirmés — à auditer via SkillSpector avant adoption),
> soit écrire ces skills nous-mêmes avec `skill-creator`. **On ne met pas de
> faux nom de skill ici.**

## Sous-agents

| Sous-agent | Rôle | Skills |
|------------|------|--------|
| Data engineer | Ingestion / nettoyage | `postgres-best-practices`, `data-pipeline` (à sourcer) |
| ML engineer | Train / éval modèles | `ml-training-eval` (à sourcer) |
| Model-serving | Exposer le modèle en API | `api-and-interface-design` (addyosmani) |

## Handoffs
- **← Product Manager** : reçoit les objectifs data/produit.
- **→ Workflow/UX & Build** : fournit les API de modèle à intégrer.
- **→ QA/Evaluator** : soumet les métriques de modèle à l'éval.
