# Spec verticale — Endpoint HTTP /tasks (DextyDemoN3)
Agent 01 PM · 2026-10-14 · Périmètre : api taches tests validation ci (MAP.md)

## Objectif
Exposer le CRUD `tasks.py` via HTTP stdlib (`http.server`, zéro dépendance), déployable localement en 1 commande, testé E2E sans framework.

## Endpoints
- `GET /health` → `{"status":"ok"}` (200)
- `GET /tasks` → liste JSON (200)
- `POST /tasks` body `{"title": str, "priority": int?}` → tâche créée (201) ; 400 si validation KO
- `POST /tasks/<id>/complete` → `{"done": true}` (200) ; 404 si inconnu
- `DELETE /tasks/<id>` → (204) ; 404 si inconnu
- Toute autre route → 404 JSON

## Contraintes (ERRORS.md)
- JSON validé strictement (content-type, taille ≤64Ko, title/priority comme tasks.py).
- Requêtes paramétrées héritées de tasks.py (déjà prouvé).
- Zéro secret, zéro shell, pas de `eval`. Binding `127.0.0.1` par défaut.
- Tests E2E : ≥6 scénarios via http.client stdlib (health, CRUD, 400, 404, injection bloquée).

## Deploy
- `python3 server.py --port 8471` (ou `$PORT`), testé par `test_server.py`.
