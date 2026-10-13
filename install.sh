#!/usr/bin/env bash
# install.sh — Installe le super-agent Desty 3.2 dans un projet existant
# Usage : ./install.sh /chemin/vers/projet [--with-skills]
set -euo pipefail

TARGET="${1:-}"
WITH_SKILLS="${2:-}"

if [[ -z "$TARGET" || "$TARGET" == "--help" || "$TARGET" == "-h" ]]; then
  echo "Usage: $0 /chemin/vers/projet [--with-skills]"
  echo "  Installe le super-agent sans écraser la configuration existante."
  echo "  --with-skills : télécharge aussi les skills vérifiés (demande npx)"
  exit 1
fi

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd)"

echo "==> Installation du super-agent dans : $TARGET"

# 1. Dossiers de base
mkdir -p "$TARGET/docs/super-agent"
mkdir -p "$TARGET/agents"
mkdir -p "$TARGET/.project-memory/db"
mkdir -p "$TARGET/.claude/hooks"
mkdir -p "$TARGET/.claude/commands"
mkdir -p "$TARGET/.agents/skills"

# 2. Copie non-destructrice des fiches et docs
cp -rn "$SRC_DIR/agents/"* "$TARGET/agents/" 2>/dev/null || true
cp -n "$SRC_DIR/docs/"*.md "$TARGET/docs/super-agent/" 2>/dev/null || true
cp -rn "$SRC_DIR/.project-memory/"* "$TARGET/.project-memory/" 2>/dev/null || true
cp -n "$SRC_DIR/.claude/commands/"* "$TARGET/.claude/commands/" 2>/dev/null || true
cp -n "$SRC_DIR/.claude/hooks/"* "$TARGET/.claude/hooks/" 2>/dev/null || true
chmod +x "$TARGET/.claude/hooks/"*.sh 2>/dev/null || true

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

echo "==> Installation terminée !"
