#!/usr/bin/env bash
# tools/skills-sync.sh — Synchronisation déterministe et sécurisée des skills (Dexty 3.5.1)
# - Aucun os.system : subprocess.run(..., shell=False) + validation stricte par liste blanche (AUD-003)
# - Zéro faux SKILL.md en cas d'échec réseau/téléchargement : échoue explicitement avec exit 1 (AUD-001)
# - Vérification obligatoire de l'empreinte SHA-256 ou scan SkillSpector réel avec score >= min_security_score (AUD-002, AUD-011, AUD-013)
# - Codes de sortie et messages stricts : exit 1 dès le moindre refus ou échec (AUD-016)
# @hopsyder — Nexus Partners

set -euo pipefail

BOLD="\033[1m"
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
RESET="\033[0m"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REGISTRY_DIR="$(dirname "$SCRIPT_DIR")"

PROJECT_DIR="."
NO_VENDOR="0"

for arg in "$@"; do
  case "$arg" in
    --no-vendor|--remote-only)
      NO_VENDOR="1"
      ;;
    *)
      PROJECT_DIR="$arg"
      ;;
  esac
done

PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

if [ -f "$PROJECT_DIR/.agents/skills.lock" ]; then
  LOCK_FILE="$PROJECT_DIR/.agents/skills.lock"
elif [ -f "$PROJECT_DIR/skills.lock" ]; then
  LOCK_FILE="$PROJECT_DIR/skills.lock"
else
  echo -e "${RED}✗${RESET} Erreur : aucun fichier skills.lock trouvé dans $PROJECT_DIR/.agents/ ni $PROJECT_DIR/" >&2
  exit 1
fi

if [ -f "$PROJECT_DIR/skills.catalog.json" ]; then
  CATALOG_FILE="$PROJECT_DIR/skills.catalog.json"
elif [ -f "$PROJECT_DIR/.agents/skills.catalog.json" ]; then
  CATALOG_FILE="$PROJECT_DIR/.agents/skills.catalog.json"
else
  CATALOG_FILE="$REGISTRY_DIR/skills.catalog.json"
fi

export DEXTY_PROJECT_DIR="$PROJECT_DIR"
export DEXTY_REGISTRY_DIR="$REGISTRY_DIR"
export DEXTY_LOCK_FILE="$LOCK_FILE"
export DEXTY_CATALOG_FILE="$CATALOG_FILE"
export DEXTY_NO_VENDOR="$NO_VENDOR"

python3 - <<'PYEOF'
import hashlib, json, os, re, shutil, subprocess, sys, tempfile, fcntl
from datetime import datetime, timezone

project_dir  = os.environ["DEXTY_PROJECT_DIR"]
registry_dir = os.environ["DEXTY_REGISTRY_DIR"]
lock_file    = os.environ["DEXTY_LOCK_FILE"]
catalog_file = os.environ["DEXTY_CATALOG_FILE"]
no_vendor    = os.environ.get("DEXTY_NO_VENDOR", "0") == "1"

os.makedirs(os.path.join(project_dir, ".agents"), exist_ok=True)
flock_path = os.path.join(project_dir, ".agents", ".sync.flock")
flock_fd = open(flock_path, "w")
try:
    fcntl.flock(flock_fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
except IOError:
    print("✗ Une autre synchronisation est déjà en cours sur ce projet.", file=sys.stderr)
    sys.exit(1)

with open(lock_file, "r", encoding="utf-8") as f:
    lock = json.load(f)

policy = lock.get("policy", {})
min_score = int(policy.get("min_security_score", 85))
skills_dir = os.path.join(project_dir, policy.get("target_directory", ".agents/skills"))
os.makedirs(skills_dir, exist_ok=True)

trusted_catalog = {}
if os.path.isfile(catalog_file):
    try:
        with open(catalog_file, "r", encoding="utf-8") as cf:
            cat_data = json.load(cf)
        for cs in cat_data.get("skills", []):
            if "id" in cs and "sha256" in cs and "repo" in cs:
                trusted_catalog[cs["id"]] = cs
    except Exception:
        pass

raw_skills = lock.get("skills", [])
normalized = []
if isinstance(raw_skills, dict):
    for sid, meta in raw_skills.items():
        entry = dict(meta)
        entry["id"] = sid
        normalized.append(entry)
elif isinstance(raw_skills, list):
    for item in raw_skills:
        normalized.append(dict(item))
else:
    print("✗ Format skills.lock invalide.", file=sys.stderr)
    sys.exit(1)

ID_RE     = re.compile(r"^[a-zA-Z0-9][a-zA-Z0-9_-]{0,63}$")
REPO_RE   = re.compile(r"^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$")
PATH_RE   = re.compile(r"^[A-Za-z0-9_.-]+(?:/[A-Za-z0-9_.-]+)*$")
COMMIT_RE = re.compile(r"^[0-9a-fA-F]{40}$")

scanner_path = shutil.which("skillspector")

print(f"◈ Synchronisation Dexty 3.5.1 depuis {os.path.relpath(lock_file, project_dir)} ({len(normalized)} skill(s))")

installed = 0
failed = 0
blocked = 0
today = datetime.now(timezone.utc).strftime("%Y-%m-%d")

for entry in normalized:
    sid  = str(entry.get("id", "")).strip()
    repo = str(entry.get("repo", "")).strip()
    path = str(entry.get("path", "")).strip()
    commit = entry.get("commit") or entry.get("sha")
    commit = str(commit).strip() if commit else ""

    if (not ID_RE.match(sid)
        or not REPO_RE.match(repo)
        or not PATH_RE.match(path)
        or ".." in path
        or path.startswith("/")):
        print(f"✗ [{sid or 'INCONNU'}] REFUS SÉCURITÉ : paramètres repo/path/id invalides ou suspects ({repo!r}, {path!r}).", file=sys.stderr)
        entry["scan_status"] = "REJECTED_INVALID_INPUT"
        blocked += 1
        continue

    declared_score = entry.get("scan_score")
    if declared_score is None:
        declared_score = entry.get("skillspector_score")
    if declared_score is not None:
        try:
            if int(declared_score) < min_score:
                print(f"✗ [{sid}] REFUSÉ par la politique de sécurité : score {declared_score}/100 < seuil requis ({min_score}/100).", file=sys.stderr)
                entry["scan_status"] = "REJECTED_LOW_SCORE"
                blocked += 1
                continue
        except (ValueError, TypeError):
            print(f"✗ [{sid}] REFUSÉ : score de sécurité invalide ({declared_score!r}).", file=sys.stderr)
            blocked += 1
            continue

    if str(entry.get("scan_status", "")).upper() in ("REJECTED", "DNI", "BLOCKED"):
        print(f"✗ [{sid}] REFUSÉ : statut de sécurité {entry.get('scan_status')}.", file=sys.stderr)
        blocked += 1
        continue

    dest_dir = os.path.join(skills_dir, sid)
    dest_file = os.path.join(dest_dir, "SKILL.md")

    cat_entry = trusted_catalog.get(sid)
    used_vendor = False
    skill_bytes = None

    if not no_vendor and cat_entry and cat_entry.get("repo") == repo:
        for base_dir in (project_dir, registry_dir):
            cand = os.path.join(base_dir, "skills", sid, "SKILL.md")
            if os.path.isfile(cand):
                with open(cand, "rb") as vf:
                    data = vf.read()
                actual_sha256 = hashlib.sha256(data).hexdigest()
                expected_sha256 = entry.get("sha256") or cat_entry.get("sha256")
                if expected_sha256 and actual_sha256 == expected_sha256:
                    skill_bytes = data
                    used_vendor = True
                    commit = cat_entry.get("commit", commit)
                    break

    if not used_vendor:
        if not COMMIT_RE.match(commit):
            print(f"✗ [{sid}] ÉCHEC : commit SHA déterministe (40 hex) requis pour télécharger depuis {repo} (reçu : {commit!r}).", file=sys.stderr)
            entry["scan_status"] = "FAILED_UNPINNED_COMMIT"
            failed += 1
            continue

        raw_url = f"https://raw.githubusercontent.com/{repo}/{commit}/{path}/SKILL.md"
        fd, tmp_dl = tempfile.mkstemp(prefix=f"dexty_{sid}_", suffix=".md")
        os.close(fd)
        try:
            proc = subprocess.run(
                ["curl", "-sSL", "-f", "--max-time", "15", raw_url, "-o", tmp_dl],
                shell=False,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                check=False
            )
            if proc.returncode != 0 or not os.path.isfile(tmp_dl) or os.path.getsize(tmp_dl) == 0:
                print(f"✗ [{sid}] ÉCHEC de téléchargement depuis {raw_url} (code {proc.returncode}). Aucun fichier factice généré.", file=sys.stderr)
                entry["scan_status"] = "DOWNLOAD_FAILED"
                failed += 1
                if os.path.exists(dest_dir) and not os.path.isfile(dest_file):
                    shutil.rmtree(dest_dir, ignore_errors=True)
                continue

            with open(tmp_dl, "rb") as df:
                skill_bytes = df.read()
        finally:
            if os.path.exists(tmp_dl):
                os.remove(tmp_dl)

        actual_sha256 = hashlib.sha256(skill_bytes).hexdigest()
        expected_sha256 = entry.get("sha256")
        if expected_sha256 and actual_sha256 != expected_sha256:
            print(f"✗ [{sid}] REFUS SÉCURITÉ : empreinte SHA-256 non conforme (attendu {expected_sha256[:12]}…, reçu {actual_sha256[:12]}…).", file=sys.stderr)
            entry["scan_status"] = "REJECTED_HASH_MISMATCH"
            blocked += 1
            continue

        if not scanner_path:
            print(f"✗ [{sid}] REFUS SÉCURITÉ : dépôt externe non vérifié ({repo}) et scanner 'skillspector' absent. Auto-déclaration du lock ignorée.", file=sys.stderr)
            entry["scan_status"] = "REJECTED_UNSCANNED"
            blocked += 1
            continue

    if scanner_path:
        fd, tmp_scan = tempfile.mkstemp(prefix=f"scan_{sid}_", suffix=".md")
        with os.fdopen(fd, "wb") as sf:
            sf.write(skill_bytes)
        try:
            sproc = subprocess.run(
                [scanner_path, "scan", tmp_scan],
                shell=False,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                check=False
            )
            if sproc.returncode != 0 or "DO NOT INSTALL" in sproc.stdout.upper():
                print(f"✗ [{sid}] REFUSÉ par SkillSpector.", file=sys.stderr)
                entry["scan_status"] = "REJECTED_BY_SCANNER"
                blocked += 1
                continue
        finally:
            if os.path.exists(tmp_scan):
                os.remove(tmp_scan)

    os.makedirs(dest_dir, exist_ok=True)
    fd, tmp_dest = tempfile.mkstemp(dir=dest_dir, suffix=".tmp")
    with os.fdopen(fd, "wb") as out_f:
        out_f.write(skill_bytes)
    os.replace(tmp_dest, dest_file)

    actual_sha256 = hashlib.sha256(skill_bytes).hexdigest()
    entry["commit"] = commit
    entry["sha256"] = actual_sha256
    entry["installed_at"] = today
    entry["scan_status"] = "VERIFIED_SHA256" if used_vendor and not scanner_path else "SCANNED_OK"
    print(f"✓ [{sid}] installé et vérifié (SHA-256 : {actual_sha256[:12]}…)")
    installed += 1

if isinstance(raw_skills, dict):
    for item in normalized:
        sid = item.pop("id")
        raw_skills[sid] = item
else:
    lock["skills"] = normalized

fd, tmp_lock = tempfile.mkstemp(dir=os.path.dirname(lock_file), suffix=".tmp")
with os.fdopen(fd, "w", encoding="utf-8") as tf:
    json.dump(lock, tf, ensure_ascii=False, indent=2)
os.replace(tmp_lock, lock_file)

print("─" * 60)
if failed > 0 or blocked > 0:
    print(f"✗ Synchronisation EN ÉCHEC : {installed} installé(s), {failed} erreur(s), {blocked} refus de sécurité.", file=sys.stderr)
    sys.exit(1)

print(f"✓ Synchronisation terminée : {installed}/{len(normalized)} skill(s) vérifiés et installés.")
sys.exit(0)
PYEOF
