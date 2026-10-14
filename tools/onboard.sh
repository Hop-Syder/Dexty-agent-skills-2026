#!/usr/bin/env bash
# tools/onboard.sh — Onboarding contextuel en 7 questions (Dexty 3.5.1)
# Sélectionne les skills pertinents depuis skills.catalog.json,
# génère .agents/skills.lock (avec commit SHA + SHA-256) et remplit .project-memory/MAP.md.
# Zéro interpolation de code : toutes les entrées passent par os.environ (AUD-004).
# @hopsyder — Nexus Partners

set -euo pipefail

BOLD="\033[1m"
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
RESET="\033[0m"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REGISTRY_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_DIR="${1:-$(pwd)}"
FORCE_FLAG="${2:-}"

PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
MEMORY_DIR="$PROJECT_DIR/.project-memory"
MAP_FILE="$MEMORY_DIR/MAP.md"
STATE_FILE="$MEMORY_DIR/STATE.md"
LOCK_FILE="$PROJECT_DIR/.agents/skills.lock"

if [ -f "$PROJECT_DIR/skills.catalog.json" ]; then
  CATALOG="$PROJECT_DIR/skills.catalog.json"
elif [ -f "$PROJECT_DIR/.agents/skills.catalog.json" ]; then
  CATALOG="$PROJECT_DIR/.agents/skills.catalog.json"
else
  CATALOG="$REGISTRY_DIR/skills.catalog.json"
fi

say()  { echo -e "${CYAN}◈${RESET} $*"; }
ask()  { echo -e "${BOLD}${BLUE}?${RESET} $*"; }
ok()   { echo -e "${GREEN}✓${RESET} $*"; }
warn() { echo -e "${YELLOW}⚠${RESET} $*"; }
hr()   { echo -e "${CYAN}$(printf '─%.0s' {1..60})${RESET}"; }

if [ ! -d "$MEMORY_DIR" ]; then
  echo "Erreur : .project-memory/ introuvable dans $PROJECT_DIR. Lance d'abord install.sh." >&2
  exit 1
fi
if ! command -v python3 &>/dev/null; then
  echo "Erreur : python3 est requis pour l'onboarding." >&2
  exit 1
fi
if [ ! -f "$CATALOG" ]; then
  echo "Erreur : skills.catalog.json introuvable ($CATALOG)." >&2
  exit 1
fi

hr
say "Bienvenue dans ${BOLD}Dexty 3.5.1 — Super-Agent Fullstack Delivery (Nexus Partners)${RESET}."
say "Réponds à ces 7 questions pour configurer la mémoire du projet et verrouiller les skills utiles."
echo ""

ask "1. Quel est le nom de ton projet ?"
read -rp "   → " PROJECT_NAME || PROJECT_NAME=""
PROJECT_NAME="${PROJECT_NAME:-Mon Projet}"

ask "2. Décris ton projet en 1-3 phrases (type d'app, utilisateurs, problème résolu) :"
read -rp "   → " PROJECT_DESC || PROJECT_DESC=""
PROJECT_DESC="${PROJECT_DESC:-Application fullstack}"

ask "3. Quel est le stack technique principal ? (ex: Next.js + Postgres, FastAPI + React)"
read -rp "   → " PROJECT_STACK || PROJECT_STACK=""
PROJECT_STACK="${PROJECT_STACK:-Fullstack web}"

ask "4. Quelles sont les fonctionnalités prioritaires ? (ex: auth, API, dashboard, paiement, CI/CD)"
read -rp "   → " PROJECT_FEATURES || PROJECT_FEATURES=""
PROJECT_FEATURES="${PROJECT_FEATURES:-MVP core features}"

ask "5. Quel est l'horizon du projet ? [1=MVP rapide / 2=Produit soigné / 3=Entreprise]"
read -rp "   → [1/2/3] " PROJECT_HORIZON || PROJECT_HORIZON=""
PROJECT_HORIZON="${PROJECT_HORIZON:-2}"

ask "6. L'application sera-t-elle exposée publiquement sur Internet ? [o/n]"
read -rp "   → [o/n] " PUBLIC_APP || PUBLIC_APP=""
PUBLIC_APP="${PUBLIC_APP:-o}"

ask "7. Manipule-t-elle des données sensibles (paiement, santé, données personnelles) ? [o/n]"
read -rp "   → [o/n] " SENSITIVE_DATA || SENSITIVE_DATA=""
SENSITIVE_DATA="${SENSITIVE_DATA:-n}"

echo ""
hr
say "Sélection contextuelle et génération atomique de .agents/skills.lock…"

mkdir -p "$(dirname "$LOCK_FILE")"

export DEXTY_PROJECT_NAME="$PROJECT_NAME"
export DEXTY_PROJECT_DESC="$PROJECT_DESC"
export DEXTY_PROJECT_STACK="$PROJECT_STACK"
export DEXTY_PROJECT_FEATURES="$PROJECT_FEATURES"
export DEXTY_PROJECT_HORIZON="$PROJECT_HORIZON"
export DEXTY_PUBLIC_APP="$PUBLIC_APP"
export DEXTY_SENSITIVE_DATA="$SENSITIVE_DATA"
export DEXTY_CATALOG="$CATALOG"
export DEXTY_LOCK_FILE="$LOCK_FILE"
export DEXTY_MAP_FILE="$MAP_FILE"
export DEXTY_FORCE_MAP="$FORCE_FLAG"

COUNT=$(python3 - <<'PYEOF'
import json, os, tempfile
from datetime import datetime, timezone

name      = os.environ.get("DEXTY_PROJECT_NAME", "Mon Projet").strip() or "Mon Projet"
desc      = os.environ.get("DEXTY_PROJECT_DESC", "").strip()
stack     = os.environ.get("DEXTY_PROJECT_STACK", "").strip()
features  = os.environ.get("DEXTY_PROJECT_FEATURES", "").strip()
horizon   = os.environ.get("DEXTY_PROJECT_HORIZON", "2").strip()
public    = os.environ.get("DEXTY_PUBLIC_APP", "o").strip().lower() in ("o", "oui", "y", "yes")
sensitive = os.environ.get("DEXTY_SENSITIVE_DATA", "n").strip().lower() in ("o", "oui", "y", "yes")
cat_path  = os.environ["DEXTY_CATALOG"]
lock_path = os.environ["DEXTY_LOCK_FILE"]

combined = f"{desc} {stack} {features}".lower()

with open(cat_path, "r", encoding="utf-8") as f:
    catalog = json.load(f)

skills = catalog.get("skills", [])

def score_skill(s):
    sc = 0
    for t in s.get("triggers", []):
        if t.lower() in combined:
            sc += 10
    for tag in s.get("tags", []):
        if tag.lower() in combined:
            sc += 5
    return sc

selected_ids = {
    "documentation-and-adrs", "context-engineering", "doubt-driven-development",
    "dispatching-parallel-agents", "subagent-driven-development",
    "spec-driven-development", "planning-and-task-breakdown", "incremental-implementation"
}

for s in skills:
    if score_skill(s) >= 5:
        selected_ids.add(s["id"])

if horizon == "1":
    selected_ids -= {
        "security-awareness", "agentic-actions-auditor", "brand-guidelines",
        "canvas-design", "composition-patterns", "xlsx"
    }
elif horizon == "3":
    selected_ids.update({
        "security-threat-model", "security-best-practices", "differential-review",
        "security-awareness", "observability-and-instrumentation",
        "performance-optimization", "agentic-actions-auditor", "postgres-best-practices"
    })

if public:
    selected_ids.update({
        "security-and-hardening", "security-threat-model",
        "security-best-practices", "differential-review"
    })

if sensitive:
    selected_ids.update({
        "security-and-hardening", "security-threat-model",
        "security-best-practices", "differential-review", "security-awareness"
    })

stack_l = stack.lower()
feat_l = features.lower()

if any(x in stack_l for x in ("react", "next", "nextjs", "next.js")):
    selected_ids.update({"react-best-practices", "composition-patterns", "frontend-ui-engineering"})
    if any(x in stack_l for x in ("vercel", "nextjs", "next.js")):
        selected_ids.add("vercel-deploy")

if any(x in stack_l for x in ("postgres", "postgresql", "supabase", "sql")):
    selected_ids.add("postgres-best-practices")

if any(x in feat_l for x in ("test", "tdd", "qualité", "quality", "coverage")):
    selected_ids.add("test-driven-development")

if any(x in feat_l for x in ("ci", "cd", "pipeline", "github actions", "devops")):
    selected_ids.update({"ci-cd-and-automation", "shipping-and-launch"})

if any(x in feat_l for x in ("monitoring", "log", "métrique", "metric", "alert")):
    selected_ids.add("observability-and-instrumentation")

valid_ids = {s["id"] for s in skills}
selected_ids &= valid_ids

today = datetime.now(timezone.utc).strftime("%Y-%m-%d")
selected_list = []

for s in skills:
    if s["id"] in selected_ids:
        selected_list.append({
            "id": s["id"],
            "agent": s["agent"],
            "source": s["source"],
            "repo": s["repo"],
            "path": s["path"],
            "entrypoint": f"{s['path']}/SKILL.md",
            "commit": s["commit"],
            "sha256": s["sha256"],
            "vendored_path": s.get("vendored_path", f"skills/{s['id']}/SKILL.md"),
            "local_path": f".agents/skills/{s['id']}",
            "selected_at": today,
            "installed_at": None,
            "scan_status": "PENDING",
            "scan_score": None
        })

lock_data = {
    "version": "3.5.1",
    "orchestrator": "Dexty 3.5.1",
    "organization": "Nexus Partners",
    "generated_at": datetime.now(timezone.utc).isoformat(),
    "project": name,
    "policy": {
        "strict_locking": True,
        "auto_update": False,
        "min_security_score": 85,
        "require_sha256": True,
        "target_directory": ".agents/skills"
    },
    "skills": selected_list
}

lock_dir = os.path.dirname(lock_path)
fd, tmp_lock = tempfile.mkstemp(dir=lock_dir, suffix=".tmp")
with os.fdopen(fd, "w", encoding="utf-8") as tf:
    json.dump(lock_data, tf, ensure_ascii=False, indent=2)
os.replace(tmp_lock, lock_path)

print(len(selected_list))
PYEOF
)

ok "J'ai sélectionné et verrouillé ${BOLD}$COUNT skills${RESET} (avec commit SHA et empreinte SHA-256) dans ${BOLD}.agents/skills.lock${RESET}."

IS_TEMPLATE=false
if [ ! -f "$MAP_FILE" ]; then
  IS_TEMPLATE=true
elif grep -qE "(DEXTY_TEMPLATE_UNCONFIGURED|\(nom du projet\)|^\*À compléter|^> \*Une phrase)" "$MAP_FILE" 2>/dev/null; then
  IS_TEMPLATE=true
fi

if [ "$IS_TEMPLATE" = true ] || [ "$FORCE_FLAG" = "--force" ]; then
  DEXTY_SKILL_COUNT="$COUNT" python3 - <<'PYEOF'
import os, tempfile
from datetime import datetime, timezone

map_path  = os.environ["DEXTY_MAP_FILE"]
name      = os.environ.get("DEXTY_PROJECT_NAME", "Mon Projet").strip() or "Mon Projet"
desc      = os.environ.get("DEXTY_PROJECT_DESC", "").strip() or "À préciser"
stack     = os.environ.get("DEXTY_PROJECT_STACK", "").strip() or "À préciser"
features  = os.environ.get("DEXTY_PROJECT_FEATURES", "").strip() or "À préciser"
horizon   = os.environ.get("DEXTY_PROJECT_HORIZON", "2").strip()
public    = os.environ.get("DEXTY_PUBLIC_APP", "o").strip().lower() in ("o", "oui", "y", "yes")
sensitive = os.environ.get("DEXTY_SENSITIVE_DATA", "n").strip().lower() in ("o", "oui", "y", "yes")
count     = os.environ.get("DEXTY_SKILL_COUNT", "0")
today     = datetime.now(timezone.utc).strftime("%Y-%m-%d")

horizon_label = {
    "1": "MVP rapide — livrer vite, raffiner après",
    "2": "Produit soigné — qualité, tests, sécurité dès le départ",
    "3": "Entreprise — conformité, scalabilité, observabilité complète"
}.get(horizon, "Produit soigné")

constraints = []
if public:
    constraints.append("- Application publique sur Internet : durcissement et revue de sécurité obligatoires")
if sensitive:
    constraints.append("- Données sensibles : chiffrement, contrôle d'accès strict et audit Trail of Bits")
if not constraints:
    constraints.append("- Application interne : bonnes pratiques de sécurité standard")

content = f"""<!--
  MAP.md — Carte mentale du projet
  Générée par tools/onboard.sh (Dexty 3.5.1) le {today}
  @hopsyder — Nexus Partners
-->

# Carte mentale : {name}

## 1. Vision
- **Projet** : {name}
- **Finalité** : {desc}

## 2. Stack technique
- **Stack principal** : {stack}

## 3. Périmètre & Fonctionnalités prioritaires
- **Dans le périmètre** : {features}
- **Hors périmètre** : Toute dérive non validée dans DECISIONS.md

## 4. Horizon et contraintes
- **Horizon** : {horizon_label}
{chr(10).join(constraints)}

## 5. Skills verrouillés
- **{count} skills** sélectionnés le {today} dans `.agents/skills.lock`.
"""

map_dir = os.path.dirname(map_path)
fd, tmp_map = tempfile.mkstemp(dir=map_dir, suffix=".tmp")
with os.fdopen(fd, "w", encoding="utf-8") as tf:
    tf.write(content)
os.replace(tmp_map, map_path)
PYEOF
  ok "Carte mentale initialisée → ${BOLD}.project-memory/MAP.md${RESET}"
else
  warn "MAP.md déjà configuré pour ce projet — conservation de la version existante (utilise --force pour remplacer)."
fi

if [ -f "$STATE_FILE" ]; then
  sed -i 's/storage: unset/storage: files/' "$STATE_FILE"
fi

CONFIRM="o"
if [ -t 0 ]; then
  echo ""
  ask "Procéder à l'installation et à la vérification des $COUNT skills maintenant ? [O/n]"
  read -rp "   → " CONFIRM || CONFIRM="o"
  CONFIRM="${CONFIRM:-o}"
fi

if [[ "$CONFIRM" =~ ^[oOyY] ]]; then
  echo ""
  bash "$SCRIPT_DIR/skills-sync.sh" "$PROJECT_DIR"
else
  say "Synchronisation reportée. Lance : bash tools/skills-sync.sh $PROJECT_DIR"
fi

echo ""
hr
say "${BOLD}${GREEN}Félicitations ! Votre environnement Dexty 3.5.1 est prêt.${RESET}"
echo ""
echo -e "${BOLD}${CYAN}Vos 8 Agents Chefs sont prêts à être appelés avec @ :${RESET}"
echo -e "  ${BOLD}① Product Manager${RESET}      → ${GREEN}@agents/01-product-manager.md${RESET}  (Spécifications & cadrage)"
echo -e "  ${BOLD}② Workflow / UX Owner${RESET}  → ${GREEN}@agents/02-workflow-ux-owner.md${RESET}  (Parcours & design)"
echo -e "  ${BOLD}③ Security Lead${RESET}        → ${GREEN}@agents/03-security-lead.md${RESET}        (Garde-fous & menaces)"
echo -e "  ${BOLD}④ Build / Dev Lead${RESET}     → ${GREEN}@agents/04-build-dev-lead.md${RESET}       (Code & TDD)"
echo -e "  ${BOLD}⑤ DevOps / Release${RESET}     → ${GREEN}@agents/05-devops-release.md${RESET}       (CI/CD & performance)"
echo -e "  ${BOLD}⑥ QA / Evaluator${RESET}       → ${GREEN}@agents/06-qa-evaluator.md${RESET}         (Juge indépendant)"
echo -e "  ${BOLD}⑦ Data / ML${RESET}            → ${GREEN}@agents/07-data-ml.md${RESET}              (Données & BDD)"
echo -e "  ${BOLD}⑧ Project Memory${RESET}       → ${GREEN}@agents/08-project-memory.md${RESET}       (Vision & mémoire)"
echo ""
echo -e "${BOLD}${YELLOW}Pour démarrer une tâche :${RESET}"
echo -e "  ${CYAN}@agents/01-product-manager.md Voici mon besoin : [votre idée]${RESET}"
hr
echo ""
