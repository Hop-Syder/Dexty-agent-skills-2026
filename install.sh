#!/usr/bin/env bash
# install.sh — Installe le super-agent Desty 3.2 dans un projet existant
# Usage : ./install.sh /chemin/vers/projet
set -euo pipefail

TARGET="${1:-}"

if [[ -z "$TARGET" || "$TARGET" == "--help" || "$TARGET" == "-h" ]]; then
  echo "Usage: $0 /chemin/vers/projet"
  echo "  Installe le super-agent Desty 3.2 sans écraser la configuration existante."
  echo "  Pour synchroniser ensuite les skills verrouillés, lancez ./skills-sync.sh dans votre projet."
  exit 1
fi

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd)"

echo "==> Installation du super-agent Desty 3.2 dans : $TARGET"

# 1. Dossiers de base
mkdir -p "$TARGET/docs/super-agent"
mkdir -p "$TARGET/agents"
mkdir -p "$TARGET/.project-memory/db"
mkdir -p "$TARGET/.claude/hooks"
mkdir -p "$TARGET/.claude/commands"
mkdir -p "$TARGET/.agents/skills"
mkdir -p "$TARGET/workflows"

# 2. Copie non-destructrice des fiches, docs et scripts de synchronisation
cp -rn "$SRC_DIR/agents/"* "$TARGET/agents/" 2>/dev/null || true
cp -n "$SRC_DIR/docs/"*.md "$TARGET/docs/super-agent/" 2>/dev/null || true
cp -rn "$SRC_DIR/.project-memory/"* "$TARGET/.project-memory/" 2>/dev/null || true
cp -n "$SRC_DIR/.claude/commands/"* "$TARGET/.claude/commands/" 2>/dev/null || true
cp -n "$SRC_DIR/.claude/hooks/"* "$TARGET/.claude/hooks/" 2>/dev/null || true
chmod +x "$TARGET/.claude/hooks/"*.sh 2>/dev/null || true

# Copie du système de verrouillage (skills.lock, skills-sync.sh, skills-check.sh)
cp -n "$SRC_DIR/skills.lock" "$TARGET/skills.lock" 2>/dev/null || true
cp -n "$SRC_DIR/skills-sync.sh" "$TARGET/skills-sync.sh" 2>/dev/null || true
cp -n "$SRC_DIR/skills-check.sh" "$TARGET/skills-check.sh" 2>/dev/null || true
chmod +x "$TARGET/skills-sync.sh" "$TARGET/skills-check.sh" 2>/dev/null || true

# Copie du workflow de surveillance
if [[ -f "$SRC_DIR/workflows/skills-watch.yml" ]]; then
  cp -n "$SRC_DIR/workflows/skills-watch.yml" "$TARGET/workflows/skills-watch.yml" 2>/dev/null || true
fi

# 3. Lien symbolique vers les skills pour Claude Code
if [[ ! -e "$TARGET/.claude/skills" ]]; then
  ln -s ../.agents/skills "$TARGET/.claude/skills"
fi

# 4. Compléter AGENTS.md (sans écraser)
if [[ ! -f "$TARGET/AGENTS.md" ]]; then
  cp "$SRC_DIR/AGENTS.md" "$TARGET/AGENTS.md"
elif ! grep -q "Super-agent : instructions de session" "$TARGET/AGENTS.md"; then
  echo "" >> "$TARGET/AGENTS.md"
  cat "$SRC_DIR/AGENTS.md" >> "$TARGET/AGENTS.md"
fi

# 5. Compléter CLAUDE.md
if [[ ! -f "$TARGET/CLAUDE.md" ]]; then
  cp "$SRC_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"
elif ! grep -q "@AGENTS.md" "$TARGET/CLAUDE.md"; then
  echo "" >> "$TARGET/CLAUDE.md"
  echo "# Instructions du super-agent : lis @AGENTS.md" >> "$TARGET/CLAUDE.md"
fi

echo "==> Installation des fichiers de base terminée !"
echo "==> Pour installer vos skills locaux verrouillés et scannés, exécutez :"
echo "    cd '$TARGET' && ./skills-sync.sh"
