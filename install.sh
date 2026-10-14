#!/usr/bin/env bash
# install.sh — Installe Dexty 3.5.1 dans un projet cible (sans écraser l'existant)
# Usage : ./install.sh /chemin/vers/mon-projet [--onboard|--skip-onboard]
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
err()  { echo -e "${RED}✗${RESET} $*" >&2; }

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION_STR="3.5.1"
[ -f "$KIT_DIR/VERSION" ] && VERSION_STR="$(tr -d '[:space:]' < "$KIT_DIR/VERSION")"

if ! command -v python3 &>/dev/null; then
  err "Erreur : python3 est requis pour installer Dexty $VERSION_STR."
  exit 1
fi

TARGET="${1:-}"
FLAG="${2:-}"

if [ -z "$TARGET" ]; then
  err "Usage : ./install.sh /chemin/vers/mon-projet [--onboard|--skip-onboard]"
  exit 1
fi

if [ ! -d "$TARGET" ]; then
  mkdir -p "$TARGET"
fi

TARGET_ABS="$(cd "$TARGET" && pwd)"
cd "$TARGET_ABS"

say "Installation de ${BOLD}Dexty $VERSION_STR${RESET} dans : ${BOLD}$TARGET_ABS${RESET}"
echo ""

copy_safe() {
  local src="$1" dst="$2"
  if [ ! -e "$src" ]; then
    err "Fichier source manquant dans le kit : $src"
    exit 1
  fi
  if [ -e "$dst" ]; then
    echo "  = $dst (déjà présent, conservé)"
  else
    mkdir -p "$(dirname "$dst")"
    cp -R "$src" "$dst"
    ok "$dst"
  fi
}

copy_safe "$KIT_DIR/VERSION"                          "VERSION"

# Copie uniquement les 8 fiches d'agents canoniques (01 à 08, AUD-019)
mkdir -p "agents"
for f in "$KIT_DIR"/agents/0[1-8]-*.md; do
  [ -f "$f" ] && copy_safe "$f" "agents/$(basename "$f")"
done

copy_safe "$KIT_DIR/docs/MAPPING.md"                  "docs/super-agent/MAPPING.md"
copy_safe "$KIT_DIR/docs/SOURCES.md"                  "docs/super-agent/SOURCES.md"
copy_safe "$KIT_DIR/docs/EVALUATION.md"               "docs/super-agent/EVALUATION.md"
copy_safe "$KIT_DIR/.project-memory"                  ".project-memory"
copy_safe "$KIT_DIR/.claude/hooks/memory-wake.sh"     ".claude/hooks/memory-wake.sh"
copy_safe "$KIT_DIR/.claude/commands/resume.md"       ".claude/commands/resume.md"
copy_safe "$KIT_DIR/tools"                            "tools"
copy_safe "$KIT_DIR/skills"                           "skills"
copy_safe "$KIT_DIR/skills.catalog.json"              "skills.catalog.json"
copy_safe "$KIT_DIR/skills.catalog.json"              ".agents/skills.catalog.json"

if [ ! -e "skills-sync.sh" ]; then
  cat > "skills-sync.sh" <<'EOF'
#!/usr/bin/env bash
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/tools/skills-sync.sh" "$@"
EOF
  chmod +x "skills-sync.sh"
  ok "skills-sync.sh (délégateur → tools/skills-sync.sh)"
fi

if [ ! -e "skills-check.sh" ]; then
  cat > "skills-check.sh" <<'EOF'
#!/usr/bin/env bash
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/tools/skills-check.sh" "$@"
EOF
  chmod +x "skills-check.sh"
  ok "skills-check.sh (délégateur → tools/skills-check.sh)"
fi

if [ -f "AGENTS.md" ]; then
  if grep -qE "(DEXTY_AGENTS_SESSION_RULES|Super-agent.*instructions de session)" "AGENTS.md"; then
    echo "  = AGENTS.md (instructions Dexty déjà présentes, aucune duplication)"
  else
    printf '\n' >> "AGENTS.md"
    cat "$KIT_DIR/AGENTS.md" >> "AGENTS.md"
    ok "AGENTS.md (complété avec les instructions Dexty)"
  fi
else
  copy_safe "$KIT_DIR/AGENTS.md" "AGENTS.md"
fi

if [ -f "CLAUDE.md" ]; then
  if ! grep -q '^@AGENTS.md' "CLAUDE.md"; then
    echo '@AGENTS.md' >> "CLAUDE.md"
    ok "CLAUDE.md (complété)"
  else
    echo "  = CLAUDE.md (déjà configuré)"
  fi
else
  copy_safe "$KIT_DIR/CLAUDE.md" "CLAUDE.md"
fi

mkdir -p ".claude"
if [ ! -f ".claude/settings.json" ]; then
  copy_safe "$KIT_DIR/.claude/settings.json" ".claude/settings.json"
fi

KIT_DIR_ENV="$KIT_DIR" python3 - <<'PY'
import json, os, tempfile

p = ".claude/settings.json"
with open(p, "r", encoding="utf-8") as f:
    s = json.load(f)

hook = {"type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/memory-wake.sh"}
starts = s.setdefault("hooks", {}).setdefault("SessionStart", [])
if not any(hook in g.get("hooks", []) for g in starts):
    starts.append({"hooks": [hook]})

env = s.setdefault("env", {})
env["AGENT_SKILLS_REGISTRY"] = os.environ["KIT_DIR_ENV"]

fd, tmp_path = tempfile.mkstemp(dir=".claude", suffix=".tmp")
with os.fdopen(fd, "w", encoding="utf-8") as tf:
    json.dump(s, tf, indent=2, ensure_ascii=False)
os.replace(tmp_path, p)
PY
ok ".claude/settings.json (hook SessionStart enregistré)"

chmod +x ".claude/hooks/memory-wake.sh" "tools/onboard.sh" "tools/skills-sync.sh" "tools/skills-check.sh"

mkdir -p ".agents/skills"
if [ ! -e ".claude/skills" ] && [ ! -L ".claude/skills" ]; then
  ln -s "../.agents/skills" ".claude/skills"
  ok ".agents/skills ← .claude/skills (lien créé)"
else
  echo "  = .claude/skills (lien déjà présent)"
fi

echo ""
say "Structure Dexty $VERSION_STR installée."

case "$FLAG" in
  --onboard)
    say "Lancement de l'onboarding (--onboard)…"
    echo ""
    bash "$TARGET_ABS/tools/onboard.sh" "$TARGET_ABS"
    ;;
  --skip-onboard)
    warn "Onboarding reporté (--skip-onboard)."
    echo "   Pour configurer le projet : bash tools/onboard.sh $TARGET_ABS"
    ;;
  *)
    if [ -t 0 ]; then
      echo ""
      read -rp "Lancer l'onboarding interactif maintenant (7 questions) ? [O/n] " LAUNCH_ONBOARD
      LAUNCH_ONBOARD="${LAUNCH_ONBOARD:-O}"
      if [[ "$LAUNCH_ONBOARD" =~ ^[OoYy] ]]; then
        bash "$TARGET_ABS/tools/onboard.sh" "$TARGET_ABS"
      else
        warn "Onboarding reporté. Lance : bash tools/onboard.sh $TARGET_ABS"
      fi
    else
      say "Mode non-interactif détecté : lance 'install.sh $TARGET_ABS --onboard' ou 'bash tools/onboard.sh $TARGET_ABS' pour configurer le projet."
    fi
    ;;
esac
