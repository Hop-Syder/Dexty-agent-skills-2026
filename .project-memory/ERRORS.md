<!-- ERRORS.md — Garde-fous de sécurité et erreurs à ne jamais reproduire · Dexty 3.5.1 -->
<!-- Format : - AAAA-MM-JJ | catégorie | interdit | règle obligatoire -->
# Erreurs & Garde-fous de sécurité pré-intégrés

## Règles de sécurité applicative (actives dès l'initialisation)
- 2026-10-13 | Secrets & Clés API | Interdiction absolue d'écrire des clés API, tokens JWT, mots de passe ou credentials en dur dans le code source ou les scripts | Toujours utiliser des variables d'environnement (`.env` ignoré par Git + `.env.example` documenté) et vérifier l'absence de secrets avant chaque commit.
- 2026-10-13 | Injections SQL | Interdiction de concaténer ou d'interpoler des entrées utilisateur dans des requêtes SQL (`f"SELECT ... {user_input}"`) | Toujours utiliser des requêtes préparées / paramétrées ou un ORM typé, et activer le Row-Level Security (RLS) sur PostgreSQL/Supabase.
- 2026-10-13 | Injections Shell & Code | Interdiction d'utiliser `os.system`, `eval`, `exec` ou des heredocs non quotés avec des variables externes | Toujours utiliser `subprocess.run([...], shell=False)` avec validation stricte par liste blanche et passage par variables d'environnement (`os.environ`).
- 2026-10-13 | XSS & Validation d'entrées | Interdiction de rendre du HTML non échappé (`dangerouslySetInnerHTML`) ou d'accepter des payloads réseau non validés | Valider systématiquement les schémas d'entrée côté serveur (Zod / Pydantic) et échapper toutes les sorties.
- 2026-10-13 | Supply Chain Skills | Interdiction de générer un faux fichier `SKILL.md` en cas d'erreur réseau ou d'installer un skill sans vérification d'empreinte SHA-256 | Échouer de manière explicite (`exit 1`) si le téléchargement, le contrôle SHA-256 ou le scan de sécurité échoue.
