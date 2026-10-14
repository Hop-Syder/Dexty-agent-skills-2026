# Spec — Mini API Tâches (DextyDemoN3, Niveau 3)

## Objectif (Agent 01 — Product Manager)
Mini gestionnaire de tâches local : CRUD + validation, persistance SQLite stdlib uniquement, testable sans dépendance.

## Exigences
1. `tasks.py` : `create_task(title, priority)` avec validation stricte :
   - `title` : str non vide, ≤120 chars, strip obligatoire
   - `priority` : int 1..5, défaut 3
   - erreurs : `ValueError` avec message explicite
2. `get_task(id)`, `list_tasks()`, `complete_task(id)`, `delete_task(id)` fonctionnels.
3. Persistance SQLite fichier (stdlib `sqlite3`), schéma créé au premier usage.
4. Zéro secret, zéro `os.system`/`eval`/`exec`, requêtes paramétrées uniquement (règle ERRORS.md).
5. `test_tasks.py` : ≥8 tests couvrant création valide, rejets invalides, CRUD, persistance.

## Critères d'acceptation (juge 06)
- Tous les tests passent (`python3 -m pytest` ou `unittest`).
- Injection SQL impossible (requêtes paramétrées vérifiées par lecture).
- Validation exhaustive des entrées.
- Score motivé rendu par QA séparé.
