#!/usr/bin/env bash
# wake.sh — Commande de réveil universelle de Dexty 3.5.1
# Exécute le protocole de mémoire vive (compatible Claude Code, Antigravity, Cursor, Terminal)
# @hopsyder — Nexus Partners

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-.}"

if [ -f "$SCRIPT_DIR/.claude/hooks/memory-wake.sh" ]; then
  exec env CLAUDE_PROJECT_DIR="$TARGET_DIR" bash "$SCRIPT_DIR/.claude/hooks/memory-wake.sh"
elif [ -f "$TARGET_DIR/.claude/hooks/memory-wake.sh" ]; then
  exec env CLAUDE_PROJECT_DIR="$TARGET_DIR" bash "$TARGET_DIR/.claude/hooks/memory-wake.sh"
else
  echo "Erreur : hook memory-wake.sh introuvable." >&2
  exit 1
fi
