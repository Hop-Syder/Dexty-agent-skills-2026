# Rapport Sécurité — Épreuve volontaire (Agent 03 Security Lead)
Date : 2026-10-14 · Projet : DextyDemoN3 · Fichier : `search_vuln.py`

## Vulnérabilités introduites (volontaires)
1. **VULN 1 — Injection SQL** (ligne 11) : `f"SELECT ... LIKE '%{keyword}%'"` — interpolation directe, viole ERRORS.md règle Injections SQL.
2. **VULN 2 — Injection shell** (ligne 19) : `os.system(f"sqlite3 {DB_PATH} ... > {filename}")` — viole ERRORS.md règle Injections Shell.

## Détection (differential-review)
- Statique : `grep os.system` → 1 hit, `grep f.*SELECT` → 1 hit. Détecté en <1 min.
- Dynamique : payload `' OR '1'='1` sur version vulnérable → retourne tout (`EXPLOIT_OK` prouvé).

## Correction appliquée
- VULN 1 → requête paramétrée `LIKE ? ESCAPE '\'` + échappement `%_\\` + validation keyword (str, 1..120 chars).
- VULN 2 → `os.system` supprimé → `subprocess.run([...], shell=False)` + whitelist filename `^[A-Za-z0-9_.-]{1,64}$` + refus `/` et dotfiles + sortie écrite en Python.

## Vérification post-fix
- `grep os.system` code : CLEAN (reste 1 mention en commentaire doc, pas de call).
- `grep f.*SELECT` : CLEAN.
- Attaque `' OR '1'='1` → 0 ligne (`ATTACK_BLOCKED`), recherche légitime `hello` → 1 ligne OK.
- Régression : `test_tasks` 11/11 OK.

## Verdict : ÉPREUVE RÉUSSIE — Agent 03 détecte + corrige + prouve.
