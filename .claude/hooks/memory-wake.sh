#!/usr/bin/env bash
# memory-wake.sh — Hook SessionStart pour Claude Code
# Injecte le réveil de la mémoire au démarrage de chaque session

set -euo pipefail
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
MEM_DIR="$PROJECT_DIR/.project-memory"

if [[ ! -d "$MEM_DIR" ]]; then
  exit 0
fi

echo "=== MÉMOIRE DU PROJET (RÉVEIL) ==="
if [[ -f "$MEM_DIR/MAP.md" ]]; then
  echo "--- MAP (vision & état) ---"
  cat "$MEM_DIR/MAP.md"
  echo ""
fi

if [[ -f "$MEM_DIR/STATE.md" ]]; then
  echo "--- STATE (dernière session) ---"
  cat "$MEM_DIR/STATE.md"
  echo ""
fi

if [[ -f "$MEM_DIR/REFUSALS.md" ]]; then
  echo "--- REFUSALS (ce que l'utilisateur a refusé) ---"
  cat "$MEM_DIR/REFUSALS.md"
  echo ""
fi
echo "=== FIN DU RÉVEIL — Prêt à démarrer ==="
