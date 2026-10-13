#!/usr/bin/env bash
# memory-wake.sh — Réveil de l'agent Project Memory au démarrage de session
# Détecte un nouveau projet et déclenche l'onboarding interactif si nécessaire.
# @hopsyder — Nexus Partners

set -euo pipefail

MEM_DIR="${CLAUDE_PROJECT_DIR:-.}/.project-memory"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
LOCK_FILE="$PROJECT_DIR/.agents/skills.lock"
CHECK_CACHE="$PROJECT_DIR/.agents/.last-check.json"
REGISTRY_DIR="${AGENT_SKILLS_REGISTRY:-$PROJECT_DIR}"

if [ ! -d "$MEM_DIR" ]; then
  echo "=== SUPER-AGENT : nouveau projet non installé ==="
  echo "Exécutez : bash install.sh $PROJECT_DIR"
  exit 0
fi

MAP_FILE="$MEM_DIR/MAP.md"
IS_NEW_PROJECT=false
if [ ! -f "$MAP_FILE" ] || grep -q "^\*À compléter" "$MAP_FILE" 2>/dev/null || grep -q "^> \*Une phrase" "$MAP_FILE" 2>/dev/null; then
  IS_NEW_PROJECT=true
fi

if [ "$IS_NEW_PROJECT" = true ]; then
  echo "=== SUPER-AGENT Desty 3.5 : Onboarding Requis ==="
  echo "Veuillez lancer l'accueil interactif pour sélectionner vos skills :"
  echo "   bash tools/onboard.sh $PROJECT_DIR"
  echo ""
  exit 0
fi

echo "=== MÉMOIRE DU PROJET (DESTY 3.5) ==="
if [ -f "$MAP_FILE" ]; then
  echo "--- MAP (Vision) ---"
  cat "$MAP_FILE"
  echo ""
fi

if [ -f "$CHECK_CACHE" ]; then
  UPDATES=$(python3 -c "import json; d=json.load(open('$CHECK_CACHE')); print(d.get('updates', 0))" 2>/dev/null || echo "0")
  if [ "$UPDATES" -gt 0 ]; then
    echo "⚠️ ALERTE : $UPDATES mise(s) à jour de skills disponible(s) en amont."
    echo "   Consultez vos PRs GitHub ou relancez tools/skills-check.sh."
    echo ""
  fi
fi

echo "=== FIN DU RÉVEIL — Prêt à démarrer ==="
