#!/usr/bin/env bash
# memory-wake.sh — Réveil de l'agent Project Memory au démarrage de session (Dexty 3.5.1)
# Imprime une mémoire compacte (MAP + STATE + REFUSALS) injectée dans le contexte.
# Détecte un nouveau projet via les marqueurs de template unifiés et invite à l'onboarding.
# @hopsyder — Nexus Partners

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
MEM_DIR="$PROJECT_DIR/.project-memory"
LOCK_FILE="$PROJECT_DIR/.agents/skills.lock"
CHECK_CACHE="$PROJECT_DIR/.agents/.last-check.json"
REGISTRY_DIR="${AGENT_SKILLS_REGISTRY:-$PROJECT_DIR}"

if [ ! -d "$MEM_DIR" ]; then
  echo "=== DEXTY 3.5.1 : nouveau projet non installé ==="
  echo "⚠ Aucune mémoire de projet détectée (.project-memory/ absent)."
  echo "Pour installer Dexty : bash $REGISTRY_DIR/install.sh $PROJECT_DIR --onboard"
  exit 0
fi

MAP_FILE="$MEM_DIR/MAP.md"
STATE_FILE="$MEM_DIR/STATE.md"

IS_UNCONFIGURED=false
if [ ! -f "$MAP_FILE" ]; then
  IS_UNCONFIGURED=true
elif grep -qE "(DEXTY_TEMPLATE_UNCONFIGURED|\(nom du projet\)|^\*À compléter|^> \*Une phrase)" "$MAP_FILE" 2>/dev/null; then
  IS_UNCONFIGURED=true
fi

if [ "$IS_UNCONFIGURED" = true ]; then
  echo "=== DEXTY 3.5.1 : onboarding requis ==="
  echo ""
  echo "Ce projet utilise encore le template vierge de carte mentale (MAP.md non renseigné)."
  echo "Lance l'onboarding interactif pour définir ta vision et sélectionner les skills :"
  if [ -f "$PROJECT_DIR/tools/onboard.sh" ]; then
    echo "   bash $PROJECT_DIR/tools/onboard.sh $PROJECT_DIR"
  elif [ -f "$REGISTRY_DIR/tools/onboard.sh" ]; then
    echo "   bash $REGISTRY_DIR/tools/onboard.sh $PROJECT_DIR"
  fi
  echo ""
  echo "Ou réponds directement aux 7 questions (nom, description, stack, fonctionnalités, horizon 1-3, exposition publique o/n, données sensibles o/n)."
  exit 0
fi

echo "=== DEXTY 3.5.1 — MÉMOIRE DU PROJET ==="

if grep -q '^storage: unset' "$STATE_FILE" 2>/dev/null; then
  echo "[PREMIER LANCEMENT] Demande à l'utilisateur : mémoire en fichiers (1, défaut) ou en base de données (2) ?"
fi

for f in MAP.md STATE.md REFUSALS.md; do
  [ -f "$MEM_DIR/$f" ] || continue
  echo "--- $f ---"
  grep -v '^<!--' "$MEM_DIR/$f" | head -n 80
done

if [ -f "$CHECK_CACHE" ]; then
  CHECK_CACHE_PATH="$CHECK_CACHE" python3 - <<'PY' || true
import json, os

p = os.environ.get("CHECK_CACHE_PATH", "")
try:
    with open(p, "r", encoding="utf-8") as f:
        r = json.load(f)
    s = r.get("summary", {})
    u = s.get("updates_available", s.get("updates", 0))
    rem = s.get("removed_upstream", 0)
    unk = s.get("unknown", s.get("errors", 0))
    checked = str(r.get("checked_at", "date inconnue"))[:10]
    if u > 0 or rem > 0 or unk > 0:
        print("\n--- Alertes skills ---")
        print(f"⚠ SKILLS (vérifié le {checked}) : {u} mise(s) à jour disponible(s), {rem} supprimé(s) amont, {unk} inconnu(s)/hors-ligne.")
        print("  Consulte .project-memory/SKILLS_UPDATE_REPORT.md ou lance : bash tools/skills-check.sh")
except Exception:
    pass
PY
fi

if [ ! -f "$LOCK_FILE" ]; then
  echo ""
  echo "--- ⚠ Skills ---"
  echo "Aucun fichier .agents/skills.lock trouvé. Lance : bash tools/onboard.sh $PROJECT_DIR"
fi
