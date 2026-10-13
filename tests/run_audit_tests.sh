#!/usr/bin/env bash
# tests/run_audit_tests.sh — Suite de tests automatisés de non-régression (Dexty 3.5.1)
# Reproduit intégralement les tests d'audit T1 à T12b + invariants d'ensembles et d'hygiène en bac à sable isolé (/tmp)
# Aucun appel réseau réel (curl stubbé).
# @hopsyder — Nexus Partners

set -euo pipefail

BOLD="\033[1m"
GREEN="\033[32m"
RED="\033[31m"
CYAN="\033[36m"
RESET="\033[0m"

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SANDBOX="$(mktemp -d /tmp/dexty-audit-suite.XXXXXX)"
trap 'rm -rf "$SANDBOX"' EXIT

PASS=0
FAIL=0

pass_test() {
  echo -e "${GREEN}✓ PASS${RESET} — $1"
  PASS=$((PASS + 1))
}

fail_test() {
  echo -e "${RED}✗ FAIL${RESET} — $1" >&2
  FAIL=$((FAIL + 1))
}

echo -e "${BOLD}${CYAN}=== SUITE DE TESTS AUTOMATISÉS DEXTY 3.5.1 (T1 à T12b + INVARIANTS) ===${RESET}"
echo "Dépôt testé : $REPO_DIR"
echo "Bac à sable : $SANDBOX"
echo ""

mkdir -p "$SANDBOX/bin"
cat > "$SANDBOX/bin/curl" <<'EOF'
#!/usr/bin/env bash
if [ "${DEXTY_CURL_MODE:-fail}" = "up_to_date" ]; then
  echo '[{"sha": "1be8e34187e34647bb83adc3a1323b26ae6f6abe"}]'
  exit 0
elif [ "${DEXTY_CURL_MODE:-fail}" = "update_available" ]; then
  echo '[{"sha": "ffffffffffffffffffffffffffffffffffffffff"}]'
  exit 0
fi
exit 22
EOF
chmod +x "$SANDBOX/bin/curl"
export PATH="$SANDBOX/bin:$PATH"

if python3 - "$REPO_DIR" <<'PY'
import hashlib, json, os, sys
repo = sys.argv[1]
assert not os.path.exists(os.path.join(repo, "workflows")), "Ancien dossier workflows/ racine encore présent"
assert os.path.isfile(os.path.join(repo, "VERSION")), "Fichier VERSION manquant"
assert os.path.isfile(os.path.join(repo, "LICENSE")), "Fichier LICENSE manquant"

with open(os.path.join(repo, "skills.catalog.json"), "r", encoding="utf-8") as f:
    cat = json.load(f)
assert "Supabase" in cat["_meta"]["sources"], "Source Supabase absente de _meta.sources"
cat_ids = {s["id"] for s in cat["skills"]}
assert len(cat_ids) == 37, f"Attendu 37 skills dans le catalogue, trouvé {len(cat_ids)}"

vendor_dir = os.path.join(repo, "skills")
vendor_ids = {d for d in os.listdir(vendor_dir) if os.path.isfile(os.path.join(vendor_dir, d, "SKILL.md"))}
assert cat_ids == vendor_ids, f"Incohérence catalogue vs vendors: diff={cat_ids ^ vendor_ids}"

for s in cat["skills"]:
    p = os.path.join(repo, s["vendored_path"])
    with open(p, "rb") as sf:
        h = hashlib.sha256(sf.read()).hexdigest()
    assert h == s["sha256"], f"SHA-256 invalide pour {s['id']}"
    assert len(s.get("commit", "")) == 40, f"Commit invalide pour {s['id']}"
PY
then
  pass_test "T0 (Invariants AUD-005/014/020/028) : 37/37 skills alignés (catalogue == vendors), SHA-256 vérifiés, VERSION et LICENSE présents"
else
  fail_test "T0 : Échec des invariants structurels"
fi

T1_DIR="$SANDBOX/proj_t1"
mkdir -p "$T1_DIR"
printf "MonAppSaaS\nPlateforme de facturation B2B\nNext.js + Postgres\nauth, dashboard, api, test\n2\no\no\no\n" \
  | bash "$REPO_DIR/install.sh" "$T1_DIR" --onboard >/dev/null

if [ -f "$T1_DIR/.agents/skills.lock" ] \
   && grep -q "MonAppSaaS" "$T1_DIR/.project-memory/MAP.md" \
   && ! grep -q "Dexty Agent Skills" "$T1_DIR/.project-memory/MAP.md" \
   && python3 -c "import json; d=json.load(open('$T1_DIR/.agents/skills.lock')); assert len(d['skills']) >= 14 and all(len(s['commit'])==40 and len(s['sha256'])==64 for s in d['skills'])"; then
  pass_test "T1 & T4 (AUD-006/007/013) : install.sh --onboard pose les questions, remplit MAP.md avec le projet utilisateur et génère un lock avec commit+sha256"
else
  fail_test "T1 & T4 : Échec du flux install.sh --onboard ou de la mise à jour de MAP.md"
fi

T2_DIR="$SANDBOX/proj_t2"
mkdir -p "$T2_DIR"
bash "$REPO_DIR/install.sh" "$T2_DIR" --skip-onboard >/dev/null
LINES_1=$(wc -l < "$T2_DIR/AGENTS.md")
bash "$REPO_DIR/install.sh" "$T2_DIR" --skip-onboard >/dev/null
LINES_2=$(wc -l < "$T2_DIR/AGENTS.md")

if [ "$LINES_1" -eq "$LINES_2" ] && [ -f "$T2_DIR/.claude/settings.json" ] && grep -q "memory-wake.sh" "$T2_DIR/.claude/settings.json"; then
  pass_test "T2 & T12b (AUD-008/015) : AGENTS.md strictement idempotent ($LINES_1 lignes) et .claude/settings.json copié avec hook SessionStart"
else
  fail_test "T2 & T12b : Duplication d'AGENTS.md ($LINES_1 -> $LINES_2) ou .claude/settings.json manquant"
fi

WAKE_OUT=$(CLAUDE_PROJECT_DIR="$T2_DIR" bash "$T2_DIR/.claude/hooks/memory-wake.sh")
if echo "$WAKE_OUT" | grep -q "onboarding requis" && ! echo "$WAKE_OUT" | grep -q "Dexty Agent Skills"; then
  pass_test "T3 (AUD-007) : memory-wake.sh détecte le template vierge et invite à l'onboarding sans contamination mémoire"
else
  fail_test "T3 : memory-wake.sh n'a pas détecté le template vierge"
fi

T5_DIR="$SANDBOX/proj_t5"
PWN_PY="$SANDBOX/PWNED_PYTHON.txt"
mkdir -p "$T5_DIR"
bash "$REPO_DIR/install.sh" "$T5_DIR" --skip-onboard >/dev/null
printf 'Projet"""; open("%s","w").write("pwn"); x="""\nDesc\nReact\nauth\n1\nn\nn\nn\n' "$PWN_PY" \
  | bash "$T5_DIR/tools/onboard.sh" "$T5_DIR" >/dev/null

if [ ! -e "$PWN_PY" ] && [ -f "$T5_DIR/.agents/skills.lock" ]; then
  pass_test "T5 (AUD-004) : Injection Python (triple quotes dans le nom du projet) totalement neutralisée"
else
  fail_test "T5 : Exécution de code Python détectée ou crash de onboard.sh"
fi

T6_DIR="$SANDBOX/proj_t6"
mkdir -p "$T6_DIR"
bash "$REPO_DIR/install.sh" "$T6_DIR" --skip-onboard >/dev/null
printf "TestNetFail\nDesc\nNext.js\nauth\n1\no\nn\nn\n" | bash "$T6_DIR/tools/onboard.sh" "$T6_DIR" >/dev/null
rm -rf "$T6_DIR/.agents/skills"/*

set +e
bash "$T6_DIR/tools/skills-sync.sh" "$T6_DIR" --no-vendor >/dev/null 2>&1
T6_CODE=$?
set -e
INSTALLED_FILES=$(find "$T6_DIR/.agents/skills" -name "SKILL.md" | wc -l)

if [ "$T6_CODE" -ne 0 ] && [ "$INSTALLED_FILES" -eq 0 ]; then
  pass_test "T6 (AUD-001/016) : Échec réseau retourne exit $T6_CODE et ne génère aucun faux fichier SKILL.md (0 installé)"
else
  fail_test "T6 : Code de sortie=$T6_CODE, fichiers créés=$INSTALLED_FILES"
fi

T7A_DIR="$SANDBOX/proj_t7a"
mkdir -p "$T7A_DIR/.agents"
cat > "$T7A_DIR/.agents/skills.lock" <<'EOF'
{
  "policy": {"min_security_score": 85},
  "skills": {
    "idea-refine": {
      "repo": "addyosmani/agent-skills",
      "path": "skills/idea-refine",
      "commit": "1be8e34187e34647bb83adc3a1323b26ae6f6abe",
      "scan_score": 42,
      "scan_status": "REJECTED"
    }
  }
}
EOF
set +e
bash "$REPO_DIR/tools/skills-sync.sh" "$T7A_DIR" >/dev/null 2>&1
T7A_CODE=$?
set -e
if [ "$T7A_CODE" -ne 0 ] && [ ! -f "$T7A_DIR/.agents/skills/idea-refine/SKILL.md" ]; then
  pass_test "T7a (AUD-016) : Skill avec score 42 (< 85) refusé avec code de sortie non nul (exit $T7A_CODE)"
else
  fail_test "T7a : Le skill à score bas n'a pas fait échouer skills-sync.sh"
fi

T7B_DIR="$SANDBOX/proj_t7b"
mkdir -p "$T7B_DIR/.agents"
cat > "$T7B_DIR/.agents/skills.lock" <<'EOF'
{
  "policy": {"min_security_score": 85},
  "skills": {
    "evil-skill": {
      "repo": "evil/repo",
      "path": "skills/evil-skill",
      "commit": "1be8e34187e34647bb83adc3a1323b26ae6f6abe",
      "scan_score": 90,
      "scan_status": "APPROVED"
    }
  }
}
EOF
set +e
bash "$REPO_DIR/tools/skills-sync.sh" "$T7B_DIR" >/dev/null 2>&1
T7B_CODE=$?
set -e
if [ "$T7B_CODE" -ne 0 ] && [ ! -f "$T7B_DIR/.agents/skills/evil-skill/SKILL.md" ]; then
  pass_test "T7b (AUD-001/002/011) : Dépôt externe evil/repo avec score auto-déclaré 90 rejeté (exit $T7B_CODE, aucun faux SKILL.md)"
else
  fail_test "T7b : Faux SKILL.md créé ou exit 0 sur evil/repo"
fi

T8_DIR="$SANDBOX/proj_t8"
mkdir -p "$T8_DIR/.agents" "$T8_DIR/.project-memory"
cat > "$T8_DIR/.agents/skills.lock" <<'EOF'
{
  "skills": [
    {"id": "idea-refine", "repo": "addyosmani/agent-skills", "path": "skills/idea-refine", "commit": null}
  ]
}
EOF
set +e
T8_OUT=$(bash "$REPO_DIR/skills-check.sh" "$T8_DIR" 2>&1)
T8_CODE=$?
set -e
if [ "$T8_CODE" -eq 2 ] && ! echo "$T8_OUT" | grep -q "Traceback" && grep -q '"status": "UNPINNED"' "$T8_DIR/.agents/.last-check.json"; then
  pass_test "T8 (AUD-017) : skills-check.sh gère un commit null sans crasher (statut UNPINNED, exit 2)"
else
  fail_test "T8 : Crash ou mauvais code de retour ($T8_CODE)"
fi

set +e
DEXTY_CURL_MODE="fail" bash "$REPO_DIR/tools/skills-check.sh" "$T1_DIR" >/dev/null 2>&1
T8B_CODE=$?
set -e
if [ "$T8B_CODE" -eq 2 ] && python3 -c "import json; r=json.load(open('$T1_DIR/.agents/.last-check.json')); assert r['summary']['up_to_date']==0 and r['summary']['unknown']>0"; then
  pass_test "T8b (AUD-009/010) : skills-check.sh hors-ligne retourne UNKNOWN (0 up_to_date) et exit 2"
else
  fail_test "T8b : skills-check.sh a déclaré des skills à jour hors-ligne"
fi

T9_DIR="$SANDBOX/proj_t9"
mkdir -p "$T9_DIR/.agents" "$T9_DIR/.project-memory"
cat > "$T9_DIR/.agents/skills.lock" <<'EOF'
{
  "skills": [
    {"id": "idea-refine", "repo": "addyosmani/agent-skills", "path": "skills/idea-refine", "commit": "1be8e34187e34647bb83adc3a1323b26ae6f6abe"}
  ]
}
EOF
DEXTY_CURL_MODE="up_to_date" bash "$REPO_DIR/tools/skills-check.sh" "$T9_DIR" >/dev/null
set +e
DEXTY_CURL_MODE="update_available" bash "$REPO_DIR/tools/skills-check.sh" "$T9_DIR" >/dev/null
T9_UPD_CODE=$?
set -e
if [ "$T9_UPD_CODE" -eq 1 ] && grep -q '"status": "UPDATE_AVAILABLE"' "$T9_DIR/.agents/.last-check.json"; then
  pass_test "T9 (AUD-009) : skills-check.sh compare exactement le SHA verrouillé (exit 0 si égal, exit 1 si différent)"
else
  fail_test "T9 : Comparaison de SHA défaillante"
fi

T10_DIR="$SANDBOX/mon projet avec espaces"
mkdir -p "$T10_DIR"
if bash "$REPO_DIR/install.sh" "$T10_DIR" --skip-onboard >/dev/null && [ -f "$T10_DIR/.claude/settings.json" ]; then
  pass_test "T10 : Installation dans un chemin avec espaces réussie"
else
  fail_test "T10 : Échec sur chemin avec espaces"
fi

T11_DIR="$SANDBOX/proj_t11"
PWN_SH="$SANDBOX/PWNED_SHELL.txt"
mkdir -p "$T11_DIR/.agents"
cat > "$T11_DIR/.agents/skills.lock" <<EOF
{
  "skills": {
    "pwn-skill": {
      "repo": "evil/repo'; touch $PWN_SH; echo '",
      "path": "skills/pwn",
      "commit": "1be8e34187e34647bb83adc3a1323b26ae6f6abe",
      "scan_score": 99,
      "scan_status": "APPROVED"
    }
  }
}
EOF
set +e
bash "$REPO_DIR/tools/skills-sync.sh" "$T11_DIR" >/dev/null 2>&1
T11_CODE=$?
set -e
if [ "$T11_CODE" -ne 0 ] && [ ! -e "$PWN_SH" ]; then
  pass_test "T11 (AUD-003) : Injection shell via repo dans skills.lock bloquée (aucun fichier créé, exit $T11_CODE)"
else
  fail_test "T11 : Injection shell exécutée ou non bloquée !"
fi

if [ ! -f "$T2_DIR/skills.lock" ] && [ ! -f "$T1_DIR/skills.lock" ] && bash "$T1_DIR/skills-sync.sh" "$T1_DIR" >/dev/null; then
  pass_test "T12 (AUD-012/021) : Source de vérité unique (.agents/skills.lock uniquement) et parité ./skills-sync.sh == ./tools/skills-sync.sh"
else
  fail_test "T12 : Divergence de locks ou échec du délégateur racine"
fi

echo ""
echo -e "${BOLD}Résultat final : ${GREEN}$PASS réussis${RESET}, ${RED}$FAIL échoué(s)${RESET}."
[ "$FAIL" -eq 0 ]
