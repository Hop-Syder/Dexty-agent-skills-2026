#!/usr/bin/env bash
# tools/onboard.sh — Accueil intelligent au premier lancement
# Pose des questions sur le projet, sélectionne les skills pertinents,
# génère skills.lock et déclenche skills-sync.sh
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
MEMORY_DIR="$PROJECT_DIR/.project-memory"
MAP_FILE="$MEMORY_DIR/MAP.md"
STATE_FILE="$MEMORY_DIR/STATE.md"
LOCK_FILE="$PROJECT_DIR/.agents/skills.lock"
CATALOG="$REGISTRY_DIR/skills.catalog.json"

say()  { echo -e "${CYAN}◈${RESET} $*"; }
ask()  { echo -e "${BOLD}${BLUE}?${RESET} $*"; }
ok()   { echo -e "${GREEN}✓${RESET} $*"; }
warn() { echo -e "${YELLOW}⚠${RESET} $*"; }
hr()   { echo -e "${CYAN}$(printf '─%.0s' {1..60})${RESET}"; }

if [ ! -d "$MEMORY_DIR" ]; then
  echo "Erreur : .project-memory/ introuvable dans $PROJECT_DIR"
  echo "Exécute d'abord : install.sh $PROJECT_DIR"
  exit 1
fi
if ! command -v python3 &>/dev/null; then
  echo "Erreur : python3 requis pour l'onboarding."
  exit 1
fi
if [ ! -f "$CATALOG" ]; then
  echo "Erreur : skills.catalog.json introuvable dans $REGISTRY_DIR"
  exit 1
fi

hr
say "Bienvenue ! Je suis le ${BOLD}Desty 3.5 — Super-Agent Fullstack Delivery (Nexus Partners)${RESET}."
say "Avant de télécharger quoi que ce soit, je veux comprendre ${BOLD}ton projet${RESET}."
say "Ça prend 2 minutes. Je sélectionne ensuite uniquement les skills utiles."
echo ""

hr
ask "1. ${BOLD}Quel est le nom de ton projet ?${RESET}"
read -rp "   → " PROJECT_NAME
PROJECT_NAME="${PROJECT_NAME:-Mon Projet}"

echo ""
ask "2. ${BOLD}Décris ton projet en 1-3 phrases.${RESET}"
ask "   (Type d'app, domaine, utilisateurs cibles, problème résolu)"
read -rp "   → " PROJECT_DESC

echo ""
ask "3. ${BOLD}Quel est le stack technique principal ?${RESET}"
say "   Exemples : Next.js + Postgres | Django + React | Flutter + Supabase | FastAPI + Vue"
read -rp "   → " PROJECT_STACK

echo ""
ask "4. ${BOLD}Quelles fonctionnalités prioritaires ?${RESET}"
say "   Exemples : auth, API REST, dashboard, paiement, IA, mobile, CI/CD, monitoring"
read -rp "   → " PROJECT_FEATURES

echo ""
ask "5. ${BOLD}Quel est l'horizon visé ?${RESET}"
echo "   1) MVP rapide / Prototype (focus vitesse et validation)"
echo "   2) Produit soigné / Prêt pour la prod (focus qualité et tests)"
echo "   3) Entreprise / Haute dispo (focus sécurité, audit, observabilité)"
read -rp "   → [1/2/3] " HORIZON_CHOICE
case "${HORIZON_CHOICE:-2}" in
  1) HORIZON="mvp" ;;
  3) HORIZON="enterprise" ;;
  *) HORIZON="production" ;;
esac

echo ""
ask "6. ${BOLD}L'application sera-t-elle publique sur Internet ?${RESET}"
say "   (Si oui, on renforce la sécurité web : headers, rate-limiting, CSP)"
read -rp "   → [o/n] " IS_PUBLIC
[[ "$IS_PUBLIC" =~ ^[oOyY] ]] && PUBLIC_APP="true" || PUBLIC_APP="false"

echo ""
ask "7. ${BOLD}Manipulera-t-elle des données sensibles ?${RESET}"
say "   (Mots de passe, paiements, données perso/RGPD, clés API, santé)"
read -rp "   → [o/n] " IS_SENSITIVE
[[ "$IS_SENSITIVE" =~ ^[oOyY] ]] && SENSITIVE_DATA="true" || SENSITIVE_DATA="false"

echo ""
hr
say "${BOLD}Analyse de ton projet et sélection des skills...${RESET}"

mkdir -p "$PROJECT_DIR/.agents"

SELECTION_OUTPUT=$(python3 - <<EOF
import json, re, sys

with open("$CATALOG") as f:
    catalog = json.load(f)

name = """$PROJECT_NAME"""
desc = """$PROJECT_DESC"""
stack = """$PROJECT_STACK"""
features = """$PROJECT_FEATURES"""
horizon = "$HORIZON"
is_public = "$PUBLIC_APP" == "true"
is_sensitive = "$SENSITIVE_DATA" == "true"

context = f"{name} {desc} {stack} {features}".lower()

ALWAYS = [
    "idea-refine",
    "spec-driven-development",
    "planning-and-task-breakdown",
    "incremental-implementation",
    "debugging-and-error-recovery",
    "writing-plans",
    "executing-plans",
    "using-superpowers"
]

selected = {}
reasons = {}

for skill in catalog["skills"]:
    sid = skill["id"]
    if sid in ALWAYS:
        selected[sid] = skill
        reasons[sid] = "Socle indispensable (toujours inclus)"
        continue

    matched = []
    for trigger in skill.get("triggers", []):
        if re.search(r'\b' + re.escape(trigger.lower()) + r'\b', context):
            matched.append(trigger)

    if matched:
        selected[sid] = skill
        reasons[sid] = f"Mot-clé détecté : {', '.join(matched[:3])}"

if horizon in ["production", "enterprise"]:
    for sid in ["test-driven-development", "requesting-code-review", "code-simplification", "code-review-and-quality"]:
        if sid not in selected:
            for s in catalog["skills"]:
                if s["id"] == sid:
                    selected[sid] = s
                    reasons[sid] = f"Requis pour niveau {horizon}"

if is_public or is_sensitive:
    for sid in ["security-and-hardening", "security-threat-model", "security-best-practices"]:
        if sid not in selected:
            for s in catalog["skills"]:
                if s["id"] == sid:
                    selected[sid] = s
                    reasons[sid] = "Requis : app publique ou données sensibles"

if is_sensitive:
    for sid in ["differential-review", "security-awareness"]:
        if sid not in selected:
            for s in catalog["skills"]:
                if s["id"] == sid:
                    selected[sid] = s
                    reasons[sid] = "Requis : données sensibles"

if re.search(r'\b(react|next|nextjs|next\.js|frontend|ui)\b', context):
    for sid in ["frontend-ui-engineering", "frontend-design", "react-best-practices"]:
        if sid not in selected:
            for s in catalog["skills"]:
                if s["id"] == sid:
                    selected[sid] = s
                    reasons[sid] = "Détecté stack frontend React/Next.js"

if re.search(r'\b(postgres|postgresql|sql|supabase|prisma|drizzle)\b', context):
    if "postgres-best-practices" not in selected:
        for s in catalog["skills"]:
            if s["id"] == "postgres-best-practices":
                selected["postgres-best-practices"] = s
                reasons["postgres-best-practices"] = "Détecté base relationnelle Postgres"

lock = {
    "_meta": {
        "project": name,
        "description": desc,
        "stack": stack,
        "horizon": horizon,
        "selected_at": "2026-10-13",
        "total_skills": len(selected),
        "total_catalog": len(catalog["skills"])
    },
    "skills": {}
}

for sid, skill in selected.items():
    lock["skills"][sid] = {
        "source": skill["source"],
        "repo": skill["repo"],
        "path": skill["path"],
        "agent": skill["agent"],
        "installed_at": None,
        "installed_sha": None,
        "upstream_sha": None,
        "last_scan_score": None,
        "last_scan_verdict": "PENDING",
        "last_checked": None,
        "reason": reasons.get(sid, "Sélectionné")
    }

with open("$LOCK_FILE", "w") as f:
    json.dump(lock, f, indent=2)

print(f"{len(selected)}|{len(catalog['skills'])}")
EOF
)

IFS='|' read -r NB_SELECTED NB_TOTAL <<< "$SELECTION_OUTPUT"

echo ""
ok "${BOLD}$NB_SELECTED skills sélectionnés${RESET} sur $NB_TOTAL dans le catalogue."
say "Fichier généré : ${BOLD}$LOCK_FILE${RESET}"
echo ""

# Remplissage automatique de MAP.md
cat > "$MAP_FILE" <<EOF
# Carte Mentale du Projet — $PROJECT_NAME

> $PROJECT_DESC

## 1. Vision
- **Projet** : $PROJECT_NAME
- **Description** : $PROJECT_DESC
- **Stack principal** : $PROJECT_STACK
- **Horizon** : $HORIZON
- **Application publique** : $PUBLIC_APP
- **Données sensibles** : $SENSITIVE_DATA

## 2. Fonctionnalités prioritaires
$PROJECT_FEATURES

## 3. Configuration des Agents
- **Skills alloués** : $NB_SELECTED skills verrouillés dans \`.agents/skills.lock\`
- **Super-Agent** : Desty 3.5 (Nexus Partners)
EOF

ok "Carte mentale initialisée dans $MAP_FILE."
echo ""

say "Lancement du téléchargement et du scan des skills..."
if [ -f "$REGISTRY_DIR/tools/skills-sync.sh" ]; then
  bash "$REGISTRY_DIR/tools/skills-sync.sh" "$PROJECT_DIR"
fi

echo ""
hr
ok "${BOLD}Onboarding terminé avec succès !${RESET}"
say "Ton projet est prêt. Desty 3.5 est opérationnel."
hr
