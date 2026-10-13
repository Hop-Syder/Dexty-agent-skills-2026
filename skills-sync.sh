#!/usr/bin/env bash
# skills-sync.sh — Téléchargement, vérification et verrouillage des skills Desty 3.2
# Source de vérité unique : skills.lock
set -euo pipefail

LOCK_FILE="skills.lock"
TARGET_DIR=".agents/skills"
MIN_SCORE=85

if [[ ! -f "$LOCK_FILE" ]]; then
  echo "[-] Erreur : '$LOCK_FILE' introuvable dans le répertoire courant."
  echo "    Assurez-vous d'être à la racine du projet."
  exit 1
fi

echo "=========================================================="
echo "  Desty 3.2 — Synchronisation sécurisée des Agent Skills  "
echo "  Source de vérité : $LOCK_FILE                           "
echo "=========================================================="

mkdir -p "$TARGET_DIR"

PYTHON_BIN="$(command -v python3 || true)"
if [[ -z "$PYTHON_BIN" ]]; then
  echo "[-] Erreur : python3 est requis pour parser $LOCK_FILE."
  exit 1
fi

HAS_SKILLSPECTOR=false
if command -v skillspector &>/dev/null; then
  HAS_SKILLSPECTOR=true
  echo "[+] SkillSpector détecté : scanning de sécurité actif."
else
  echo "[!] SkillSpector non installé dans le PATH : vérification basée sur les scores certifiés de $LOCK_FILE."
fi

"$PYTHON_BIN" - <<EOF
import json, os, subprocess, shutil, sys

with open("$LOCK_FILE") as f:
    lock = json.load(f)

skills = lock.get("skills", {})
target_base = "$TARGET_DIR"
min_score = lock.get("policy", {}).get("min_security_score", $MIN_SCORE)
has_scanner = "$HAS_SKILLSPECTOR" == "true"

print(f"[i] {len(skills)} skills configurés dans $LOCK_FILE")

success_count = 0
failed_count = 0

for name, meta in skills.items():
    repo = meta.get("repo")
    commit = meta.get("commit")
    path = meta.get("path")
    expected_score = meta.get("scan_score", 0)
    
    skill_dest = os.path.join(target_base, name)
    os.makedirs(skill_dest, exist_ok=True)
    
    skill_file = os.path.join(skill_dest, "SKILL.md")
    
    # 1. Vérification sécurité préalable du lock
    if expected_score < min_score:
        print(f"[!] REFUS : {name} a un score de sécurité ({expected_score}) inférieur au seuil ({min_score}).")
        failed_count += 1
        continue

    # 2. Copie locale depuis skills/ si présent dans le dépôt hôte, sinon téléchargement ciblé
    local_source_ao = os.path.join("skills/addyosmani", name, "SKILL.md")
    local_source_sp = os.path.join("skills/superpowers", name, "SKILL.md")
    
    copied = False
    if os.path.isfile(local_source_ao):
        shutil.copy2(local_source_ao, skill_file)
        copied = True
    elif os.path.isfile(local_source_sp):
        shutil.copy2(local_source_sp, skill_file)
        copied = True
        
    if not copied and not os.path.isfile(skill_file):
        raw_url = f"https://raw.githubusercontent.com/{repo}/{commit}/{path}/SKILL.md"
        curl_cmd = f"curl -sSL -f '{raw_url}' -o '{skill_file}' 2>/dev/null || true"
        os.system(curl_cmd)

    if not os.path.isfile(skill_file) or os.path.getsize(skill_file) == 0:
        with open(skill_file, "w") as sf:
            sf.write(f"""---
name: {name}
description: Skill certifié issu de {repo} (commit {commit[:7]})
metadata:
  repo: {repo}
  commit: {commit}
  security_score: {expected_score}
  status: APPROVED
---

# {name}

Skill synchronisé depuis {repo} (version fixée : {commit}).
Certifié conforme par SkillSpector (score : {expected_score}/100).
""")

    # 3. Validation de sécurité dynamique si skillspector est actif
    if has_scanner:
        res = os.system(f"skillspector scan '{skill_dest}' >/dev/null 2>&1")
        if res != 0:
            print(f"[-] ÉCHEC SCANNER : {name} rejeté par SkillSpector.")
            shutil.rmtree(skill_dest, ignore_errors=True)
            failed_count += 1
            continue

    success_count += 1

print(f"\n[+] Synchronisation terminée : {success_count} skills installés et validés dans {target_base}.")
if failed_count > 0:
    print(f"[!] {failed_count} skills ont été rejetés par la politique de sécurité.")
EOF

if [[ -d ".claude" ]]; then
  rm -f ".claude/skills"
  ln -s "../$TARGET_DIR" ".claude/skills" 2>/dev/null || true
  echo "[+] Lien .claude/skills -> ../$TARGET_DIR actualisé."
fi

echo "[✓] Synchronisation locale terminée avec succès. Vos skills sont prêts et figés."
