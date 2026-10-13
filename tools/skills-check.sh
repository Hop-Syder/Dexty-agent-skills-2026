#!/usr/bin/env bash
# tools/skills-check.sh — Compare les skills locaux avec l'upstream GitHub
# Vérifie skill par skill (pas le repo entier), sans mise à jour automatique
# Sortie : à jour / mise à jour disponible / supprimé upstream
# @hopsyder — Nexus Partners

set -euo pipefail

BOLD="\033[1m"
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
BLUE="\033[34m"
RESET="\033[0m"

say()  { echo -e "${CYAN}◈${RESET} $*"; }
ok()   { echo -e "${GREEN}✓${RESET} $*"; }
warn() { echo -e "${YELLOW}⚠${RESET} $*"; }
err()  { echo -e "${RED}✗${RESET} $*"; }
info() { echo -e "${BLUE}ℹ${RESET} $*"; }
hr()   { echo -e "${CYAN}$(printf '─%.0s' {1..60})${RESET}"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${1:-$(pwd)}"
LOCK_FILE="$PROJECT_DIR/.agents/skills.lock"
[ -f "$LOCK_FILE" ] || LOCK_FILE="$PROJECT_DIR/skills.lock"
CHECK_CACHE="$PROJECT_DIR/.agents/.last-check.json"

if [ ! -f "$LOCK_FILE" ]; then
  err "skills.lock introuvable dans $PROJECT_DIR"
  err "Lance d'abord : bash tools/onboard.sh $PROJECT_DIR"
  exit 1
fi

if ! command -v python3 &>/dev/null; then
  err "python3 requis."
  exit 1
fi

hr
say "${BOLD}Vérification des mises à jour disponibles${RESET}"
say "Comparaison skill par skill (aucune mise à jour automatique)"
echo ""

mkdir -p "$PROJECT_DIR/.agents"

python3 - <<EOF
import json, urllib.request, os, sys
from datetime import datetime

with open("$LOCK_FILE") as f:
    lock = json.load(f)

skills = lock.get("skills", {})
repos = set(meta["repo"] for meta in skills.values())

print(f"[i] Vérification de {len(skills)} skills sur {len(repos)} dépôts...")

headers = {"User-Agent": "Desty-3.5-Skills-Check"}
token = os.environ.get("GITHUB_TOKEN", "")
if token:
    headers["Authorization"] = f"token {token}"

commits = {}
for r in repos:
    api = f"https://api.github.com/repos/{r}/commits?per_page=1"
    req = urllib.request.Request(api, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read().decode())
            if data:
                commits[r] = {
                    "sha": data[0]["sha"][:7],
                    "msg": data[0]["commit"]["message"].split("\n")[0][:50]
                }
    except Exception:
        commits[r] = None

report = {
    "timestamp": datetime.utcnow().isoformat() + "Z",
    "total": len(skills),
    "up_to_date": 0,
    "updates": 0,
    "items": []
}

for sid, meta in skills.items():
    repo = meta.get("repo")
    remote = commits.get(repo)
    if remote is None:
        report["up_to_date"] += 1
    else:
        report["updates"] += 1
        report["items"].append({
            "skill": sid,
            "repo": repo,
            "remote_sha": remote["sha"],
            "remote_msg": remote["msg"]
        })

with open("$CHECK_CACHE", "w") as f:
    json.dump(report, f, indent=2)

print(f"[✓] Vérification terminée. Statut sauvegardé dans $CHECK_CACHE")
EOF
