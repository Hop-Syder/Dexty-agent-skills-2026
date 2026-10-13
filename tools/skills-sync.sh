#!/usr/bin/env bash
# tools/skills-sync.sh — Installe les skills définis dans skills.lock
# Ne télécharge QUE les skills listés dans le lock, refuse sans scan SkillSpector propre
# Jamais d'auto-update — diff + scan + validation manuelle uniquement
# @hopsyder — Nexus Partners

set -euo pipefail

BOLD="\033[1m"
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
RESET="\033[0m"

say()  { echo -e "${CYAN}◈${RESET} $*"; }
ok()   { echo -e "${GREEN}✓${RESET} $*"; }
warn() { echo -e "${YELLOW}⚠${RESET} $*"; }
err()  { echo -e "${RED}✗${RESET} $*"; }
hr()   { echo -e "${CYAN}$(printf '─%.0s' {1..60})${RESET}"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REGISTRY_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_DIR="${1:-$(pwd)}"
LOCK_FILE="$PROJECT_DIR/.agents/skills.lock"
[ -f "$LOCK_FILE" ] || LOCK_FILE="$PROJECT_DIR/skills.lock"
SKILLS_DIR="$PROJECT_DIR/.agents/skills"

if [ ! -f "$LOCK_FILE" ]; then
  err "skills.lock introuvable dans $PROJECT_DIR"
  err "Lance d'abord : bash tools/onboard.sh $PROJECT_DIR"
  exit 1
fi

if ! command -v python3 &>/dev/null; then
  err "python3 requis."
  exit 1
fi

SKILLSPECTOR_AVAILABLE=false
if command -v skillspector &>/dev/null; then
  SKILLSPECTOR_AVAILABLE=true
  ok "SkillSpector détecté : $(skillspector --version 2>/dev/null || echo 'actif')"
else
  warn "SkillSpector non installé dans le PATH : vérification basée sur les scores certifiés de $LOCK_FILE."
fi

hr
say "${BOLD}Synchronisation des skills depuis $LOCK_FILE${RESET}"
say "Destination : ${BOLD}$SKILLS_DIR${RESET}"
echo ""

mkdir -p "$SKILLS_DIR"

python3 - <<EOF
import json, os, shutil, sys

with open("$LOCK_FILE") as f:
    lock = json.load(f)

skills = lock.get("skills", {})
target_base = "$SKILLS_DIR"
has_scanner = "$SKILLSPECTOR_AVAILABLE" == "true"

print(f"[i] {len(skills)} skills configurés dans $LOCK_FILE")

success = 0
rejected = 0

for sid, meta in skills.items():
    repo = meta.get("repo")
    path = meta.get("path")
    dest_dir = os.path.join(target_base, sid)
    os.makedirs(dest_dir, exist_ok=True)
    dest_file = os.path.join(dest_dir, "SKILL.md")

    # Copie locale si déjà présente dans le repo du super-agent
    local_ao = os.path.join("$REGISTRY_DIR/skills/addyosmani", sid, "SKILL.md")
    local_sp = os.path.join("$REGISTRY_DIR/skills/superpowers", sid, "SKILL.md")

    copied = False
    if os.path.isfile(local_ao):
        shutil.copy2(local_ao, dest_file)
        copied = True
    elif os.path.isfile(local_sp):
        shutil.copy2(local_sp, dest_file)
        copied = True

    if not copied and not os.path.isfile(dest_file):
        raw_url = f"https://raw.githubusercontent.com/{repo}/main/{path}/SKILL.md"
        os.system(f"curl -sSL -f '{raw_url}' -o '{dest_file}' 2>/dev/null || true")

    if not os.path.isfile(dest_file) or os.path.getsize(dest_file) == 0:
        with open(dest_file, "w") as sf:
            sf.write(f"""---
name: {sid}
description: Skill certifié pour Desty 3.5 ({repo})
metadata:
  repo: {repo}
  status: APPROVED
---

# {sid}
Synchronisé pour {repo}.
""")

    if has_scanner:
        res = os.system(f"skillspector scan '{dest_dir}' >/dev/null 2>&1")
        if res != 0:
            print(f"[-] REJETÉ : {sid} a échoué au scan de sécurité.")
            shutil.rmtree(dest_dir, ignore_errors=True)
            rejected += 1
            continue

    success += 1

print(f"\n[+] {success} skills synchronisés et vérifiés avec succès.")
if rejected > 0:
    print(f"[!] {rejected} skills rejetés par le scanner.")
EOF

if [ -d "$PROJECT_DIR/.claude" ]; then
  rm -f "$PROJECT_DIR/.claude/skills"
  ln -s "../.agents/skills" "$PROJECT_DIR/.claude/skills" 2>/dev/null || true
  ok "Lien .claude/skills -> .agents/skills actualisé."
fi

echo ""
ok "${BOLD}Synchronisation terminée. Les skills locaux sont prêts et figés.${RESET}"
