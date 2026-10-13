#!/usr/bin/env bash
# tools/skills-check.sh — Vérification honnête des mises à jour amont par SHA et chemin (Dexty 3.5.1)
# - Compare réellement le commit SHA verrouillé au dernier commit amont du chemin (AUD-009)
# - En cas d'erreur réseau / hors-ligne : statut UNKNOWN (jamais UP_TO_DATE ni faux remote_commit) et exit 2 (AUD-009, AUD-010)
# - Ne crashe jamais si le champ commit est absent ou null : statut UNPINNED et exit 2 (AUD-017)
# - Écrit atomiquement .agents/.last-check.json et .project-memory/SKILLS_UPDATE_REPORT.md (AUD-012, AUD-022)
# @hopsyder — Nexus Partners

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${1:-$(pwd)}"
OUTPUT_FILE="${2:-}"

PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

if [ -f "$PROJECT_DIR/.agents/skills.lock" ]; then
  LOCK_FILE="$PROJECT_DIR/.agents/skills.lock"
elif [ -f "$PROJECT_DIR/skills.lock" ]; then
  LOCK_FILE="$PROJECT_DIR/skills.lock"
else
  echo "✗ Erreur : aucun fichier skills.lock trouvé dans $PROJECT_DIR/.agents/ ni $PROJECT_DIR/" >&2
  exit 1
fi

export DEXTY_PROJECT_DIR="$PROJECT_DIR"
export DEXTY_LOCK_FILE="$LOCK_FILE"
export DEXTY_OUTPUT_FILE="$OUTPUT_FILE"

python3 - <<'PYEOF'
import json, os, re, subprocess, sys, tempfile
from datetime import datetime, timezone

project_dir = os.environ["DEXTY_PROJECT_DIR"]
lock_file   = os.environ["DEXTY_LOCK_FILE"]
output_file = os.environ.get("DEXTY_OUTPUT_FILE", "")

with open(lock_file, "r", encoding="utf-8") as f:
    lock = json.load(f)

raw_skills = lock.get("skills", [])
normalized = []
if isinstance(raw_skills, dict):
    for sid, meta in raw_skills.items():
        entry = dict(meta) if isinstance(meta, dict) else {}
        entry["id"] = sid
        normalized.append(entry)
elif isinstance(raw_skills, list):
    for item in raw_skills:
        if isinstance(item, dict):
            normalized.append(dict(item))

REPO_RE   = re.compile(r"^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$")
PATH_RE   = re.compile(r"^[A-Za-z0-9_.-]+(?:/[A-Za-z0-9_.-]+)*$")
COMMIT_RE = re.compile(r"^[0-9a-fA-F]{40}$")

up_to_date = 0
updates_available = 0
removed_upstream = 0
unknown_count = 0
unpinned_count = 0
results = []

print(f"◈ Vérification amont Dexty 3.5.1 ({len(normalized)} skill(s))")

for entry in normalized:
    sid  = str(entry.get("id", "unknown")).strip()
    repo = str(entry.get("repo", "")).strip()
    path = str(entry.get("path", "")).strip()
    locked_commit = entry.get("commit") or entry.get("sha")
    locked_commit = str(locked_commit).strip() if locked_commit and str(locked_commit).lower() not in ("none", "null", "pending") else None

    if not locked_commit or not COMMIT_RE.match(locked_commit):
        print(f"  [{sid:<30}] ⚠ NON VERROUILLÉ (commit absent ou invalide)")
        unpinned_count += 1
        results.append({
            "id": sid,
            "repo": repo,
            "path": path,
            "status": "UNPINNED",
            "local_sha": locked_commit,
            "upstream_sha": None,
            "message": "Commit SHA absent ou invalide dans skills.lock."
        })
        continue

    if not REPO_RE.match(repo) or not PATH_RE.match(path) or ".." in path:
        print(f"  [{sid:<30}] ✗ PARAMÈTRES INVALIDES")
        unknown_count += 1
        results.append({
            "id": sid,
            "repo": repo,
            "path": path,
            "status": "INVALID_METADATA",
            "local_sha": locked_commit,
            "upstream_sha": None,
            "message": "Métadonnées repo/path invalides."
        })
        continue

    api_url = f"https://api.github.com/repos/{repo}/commits?path={path}&per_page=1"
    proc = subprocess.run(
        [
            "curl", "-sS", "-f", "--max-time", "10",
            "-H", "Accept: application/vnd.github+json",
            api_url
        ],
        shell=False,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        check=False
    )

    if proc.returncode != 0 or not proc.stdout.strip():
        print(f"  [{sid:<30}] ⚠ UNKNOWN (erreur réseau / API injoignable)")
        unknown_count += 1
        results.append({
            "id": sid,
            "repo": repo,
            "path": path,
            "status": "UNKNOWN",
            "local_sha": locked_commit,
            "upstream_sha": None,
            "message": "Impossible de joindre l'API GitHub (vérification hors-ligne impossible)."
        })
        continue

    try:
        data = json.loads(proc.stdout)
    except Exception:
        print(f"  [{sid:<30}] ⚠ UNKNOWN (réponse API invalide)")
        unknown_count += 1
        results.append({
            "id": sid,
            "repo": repo,
            "path": path,
            "status": "UNKNOWN",
            "local_sha": locked_commit,
            "upstream_sha": None,
            "message": "Réponse JSON invalide depuis l'API GitHub."
        })
        continue

    if isinstance(data, list) and len(data) == 0:
        print(f"  [{sid:<30}] ✗ REMOVED_UPSTREAM (chemin introuvable)")
        removed_upstream += 1
        results.append({
            "id": sid,
            "repo": repo,
            "path": path,
            "status": "REMOVED_UPSTREAM",
            "local_sha": locked_commit,
            "upstream_sha": None,
            "message": "Aucun commit trouvé pour ce chemin sur le dépôt amont."
        })
        continue

    upstream_sha = None
    if isinstance(data, list) and len(data) > 0 and isinstance(data[0], dict):
        upstream_sha = data[0].get("sha")
    elif isinstance(data, dict) and "sha" in data:
        upstream_sha = data.get("sha")

    if not upstream_sha or not COMMIT_RE.match(str(upstream_sha)):
        print(f"  [{sid:<30}] ⚠ UNKNOWN (SHA amont illisible)")
        unknown_count += 1
        results.append({
            "id": sid,
            "repo": repo,
            "path": path,
            "status": "UNKNOWN",
            "local_sha": locked_commit,
            "upstream_sha": None,
            "message": "SHA amont absent de la réponse API."
        })
        continue

    if upstream_sha.lower() == locked_commit.lower():
        print(f"  [{sid:<30}] ✓ UP_TO_DATE ({locked_commit[:7]})")
        up_to_date += 1
        results.append({
            "id": sid,
            "repo": repo,
            "path": path,
            "status": "UP_TO_DATE",
            "local_sha": locked_commit,
            "upstream_sha": upstream_sha,
            "message": "Aligné sur le commit verrouillé."
        })
    else:
        print(f"  [{sid:<30}] ↻ UPDATE_AVAILABLE ({locked_commit[:7]} -> {upstream_sha[:7]})")
        updates_available += 1
        results.append({
            "id": sid,
            "repo": repo,
            "path": path,
            "status": "UPDATE_AVAILABLE",
            "local_sha": locked_commit,
            "upstream_sha": upstream_sha,
            "message": f"Mise à jour disponible ({locked_commit[:7]} -> {upstream_sha[:7]})."
        })

now_iso = datetime.now(timezone.utc).isoformat()
report = {
    "checked_at": now_iso,
    "orchestrator": "Dexty 3.5.1",
    "project_dir": project_dir,
    "summary": {
        "total": len(normalized),
        "up_to_date": up_to_date,
        "updates_available": updates_available,
        "updates": updates_available,
        "removed_upstream": removed_upstream,
        "unknown": unknown_count,
        "unpinned": unpinned_count,
        "errors": unknown_count + unpinned_count
    },
    "skills": results
}

def write_atomic(target_path, content_str):
    d = os.path.dirname(target_path)
    os.makedirs(d, exist_ok=True)
    fd, tmp_p = tempfile.mkstemp(dir=d, suffix=".tmp")
    with os.fdopen(fd, "w", encoding="utf-8") as tf:
        tf.write(content_str)
    os.replace(tmp_p, target_path)

report_json = json.dumps(report, ensure_ascii=False, indent=2)
write_atomic(os.path.join(project_dir, ".agents", ".last-check.json"), report_json)

if output_file:
    write_atomic(output_file, report_json)

md_lines = [
    "# Rapport de vérification amont des skills (Dexty 3.5.1)",
    f"- **Date de vérification (UTC)** : `{now_iso}`",
    f"- **Total inspecté** : {len(normalized)}",
    f"- **À jour (`UP_TO_DATE`)** : {up_to_date}",
    f"- **Mises à jour disponibles (`UPDATE_AVAILABLE`)** : {updates_available}",
    f"- **Supprimés amont (`REMOVED_UPSTREAM`)** : {removed_upstream}",
    f"- **Inconnus / Hors-ligne (`UNKNOWN`)** : {unknown_count}",
    f"- **Non verrouillés (`UNPINNED`)** : {unpinned_count}",
    "",
    "| Skill | Dépôt | Statut | SHA local | SHA amont | Détail |",
    "| :--- | :--- | :--- | :--- | :--- | :--- |"
]
for r in results:
    l_sha = r["local_sha"][:7] if r["local_sha"] else "none"
    u_sha = r["upstream_sha"][:7] if r["upstream_sha"] else "none"
    md_lines.append(f"| `{r['id']}` | `{r['repo']}` | **{r['status']}** | `{l_sha}` | `{u_sha}` | {r['message']} |")

write_atomic(os.path.join(project_dir, ".project-memory", "SKILLS_UPDATE_REPORT.md"), "\n".join(md_lines) + "\n")

print("─" * 60)
print(f"Résumé : {up_to_date} à jour, {updates_available} mise(s) à jour, {removed_upstream} supprimé(s), {unknown_count} inconnu(s)/hors-ligne, {unpinned_count} non verrouillé(s).")

if unknown_count > 0 or unpinned_count > 0:
    sys.exit(2)
if updates_available > 0 or removed_upstream > 0:
    sys.exit(1)
sys.exit(0)
PYEOF
