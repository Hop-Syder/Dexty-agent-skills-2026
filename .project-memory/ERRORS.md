<!-- ERRORS.md — Anti-patterns interdits & Règles de sécurité · Desty 3.5 · @hopsyder — Nexus Partners -->
# Registre des Anti-Patterns & Erreurs Critiques Interdites

Ce journal consigne les anti-patterns et erreurs critiques que les agents de **Desty 3.5** ont l'interdiction formelle de commettre. Tout code comportant l'une de ces failles déclenche un **veto bloquant immédiat** de l'agent **Security Lead** (③) et du juge **QA / Evaluator** (⑥).

---

## 1. Fuite de Clés API & Secrets (Hardcoded Secrets / CWE-798)
- **Anti-pattern** : Écrire des clés API, tokens de session, mots de passe de base de données ou certificats privés en clair dans le code source.
- **Cause racine** : Raccourci temporaire lors du prototypage, oubli de configuration d'environnement.
- **Règle d'or absolue** :
  - Tout secret doit transiter **exclusivement** par des variables d'environnement (`process.env.API_KEY`, `os.getenv()`).
  - Les fichiers contenant des valeurs réelles (`.env`, `.env.local`, `.pem`) doivent figurer obligatoirement dans `.gitignore`.
  - Le dépôt ne doit exposer qu'un fichier modèle `.env.example` avec des valeurs factices ou vides.
  - Vérification obligatoire via `security-and-hardening` et `differential-review` avant tout commit.

---

## 2. Injections SQL (SQLi / OWASP A03 / CWE-89)
- **Anti-pattern** : Concaténer des variables utilisateur non échappées dans des requêtes SQL (`SELECT * FROM users WHERE email = ' + email`).
- **Cause racine** : Concaténation de chaînes au lieu d'utiliser des requêtes préparées.
- **Règle d'or absolue** :
  - **Interdiction formelle de toute concaténation de chaîne dans les requêtes de base de données.**
  - Utilisation obligatoire de **requêtes paramétrées** (Prepared Statements avec placeholders `$1`, `?`) ou d'un ORM/Query Builder typé (Prisma, Drizzle, SQLAlchemy).
  - Validation et assainissement systématiques de tous les payloads entrants à l'entrée de l'API via des schémas stricts (Zod, Pydantic, Zod schemas).
  - Contrôlé en amont par `postgres-best-practices` ([supabase/agent-skills](https://github.com/supabase/agent-skills)).

---

## 3. Injections Cross-Site Scripting (XSS / CWE-79)
- **Anti-pattern** : Rendu direct de contenu utilisateur dans le DOM via `dangerouslySetInnerHTML`, `innerHTML` ou interpolation brute non échappée.
- **Règle d'or absolue** :
  - Échappement contextuel automatique assuré par le framework de rendu (React, Next.js, Vue).
  - En cas d'obligation de rendu HTML riche, assainissement obligatoire via `DOMPurify` ou `sanitize-html`.
  - Configuration de headers de sécurité `Content-Security-Policy` (CSP) stricts.

---

## 4. Injections de Prompt & Vulnérabilités IA (OWASP Top 10 for LLM)
- **Anti-pattern** : Injection directe d'entrées non fiables dans les prompts système sans délimiteurs stricts, ou chargement d'outils MCP non vérifiés.
- **Règle d'or absolue** :
  - Tout skill externe doit passer par l'audit `SkillSpector` (score ≥ 85/100, interdiction de tout profil DNI).
  - Les entrées utilisateurs sont isolées dans des balises XML/Markdown hermétiques pour prévenir la manipulation du contexte système.
  - Confinement strict des permissions d'exécution des outils.

---

## 5. Divulgation d'Informations & Traitement des Exceptions (CWE-209)
- **Anti-pattern** : Renvoyer des stack traces complètes, versions internes de bibliothèques ou requêtes SQL échouées dans les réponses HTTP clientes.
- **Règle d'or absolue** :
  - Les routes API interceptent toutes les exceptions (`try/catch`) et renvoient des messages génériques normalisés (`{ error: "Internal Server Error", code: 500 }`).
  - Les détails techniques et stack traces sont consignés exclusivement dans des logs d'observabilité internes (`observability-and-instrumentation`).
