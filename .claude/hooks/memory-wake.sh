#!/usr/bin/env bash
# memory-wake.sh — Hook SessionStart pour Claude Code
# Injecte le réveil de la mémoire et le statut de veille des skills au démarrage

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

# Vérification de l'état des skills verrouillés
if [[ -f "$MEM_DIR/SKILLS_STATUS.json" ]]; then
  UPDATES=$(python3 -c "import json; d=json.load(open('$MEM_DIR/SKILLS_STATUS.json')); print(d.get('updates_available', 0))" 2>/dev/null || echo "0")
  if [[ "$UPDATES" -gt 0 ]]; then
    echo "⚠️ ALERTE SKILLS WATCH : $UPDATES mise(s) à jour de skills disponible(s) en attente de validation."
    echo "   Consultez .project-memory/SKILLS_UPDATE_REPORT.md ou la PR GitHub pour examiner le diff."
    echo ""
  fi
fi

echo "=== FIN DU RÉVEIL — Prêt à démarrer ==="
