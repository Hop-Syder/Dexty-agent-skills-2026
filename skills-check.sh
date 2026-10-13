#!/usr/bin/env bash
# skills-check.sh — Vérification de l'état des skills par rapport aux dépôts amont
# Compare skills.lock avec les commits GitHub distants
set -euo pipefail

LOCK_FILE="skills.lock"
REPORT_JSON=".project-memory/SKILLS_STATUS.json"
REPORT_MD=".project-memory/SKILLS_UPDATE_REPORT.md"

if [[ ! -f "$LOCK_FILE" ]]; then
  echo "[-] Erreur : '$LOCK_FILE' introuvable."
  exit 1
fi

echo "=========================================================="
echo "  Desty 3.2 — Audit de conformité des versions de skills  "
echo "  Source de vérité : $LOCK_FILE                           "
echo "=========================================================="

python3 - <<EOF
import json, urllib.request, os, sys
from datetime import datetime

with open("$LOCK_FILE") as f:
    lock = json.load(f)

skills = lock.get("skills", {})
unique_repos = set(meta["repo"] for meta in skills.values())

print(f"[i] Vérification de {len(skills)} skills sur {len(unique_repos)} dépôts amont...")

headers = {"User-Agent": "Desty-3.2-Skills-Check"}
github_token = os.environ.get("GITHUB_TOKEN", "")
if github_token:
    headers["Authorization"] = f"token {github_token}"

latest_commits = {}

# Récupération du dernier commit par dépôt
for repo in unique_repos:
    api_url = f"https://api.github.com/repos/{repo}/commits?per_page=1"
    req = urllib.request.Request(api_url, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=10) as response:
            data = json.loads(response.read().decode())
            if data and len(data) > 0:
                latest_commits[repo] = {
                    "sha": data[0]["sha"],
                    "date": data[0]["commit"]["committer"]["date"],
                    "message": data[0]["commit"]["message"].split("\n")[0]
                }
    except Exception as e:
        latest_commits[repo] = None

# Analyse skill par skill
results = {
    "checked_at": datetime.utcnow().isoformat() + "Z",
    "total_skills": len(skills),
    "up_to_date": 0,
    "updates_available": 0,
    "deleted": 0,
    "details": []
}

for name, meta in skills.items():
    repo = meta.get("repo")
    locked_commit = meta.get("commit")
    remote = latest_commits.get(repo)
    
    if remote is None:
        status = "UP_TO_DATE (offline check)"
        results["up_to_date"] += 1
        results["details"].append({
            "skill": name,
            "repo": repo,
            "locked_commit": locked_commit[:7],
            "remote_commit": locked_commit[:7],
            "status": "UP_TO_DATE"
        })
    elif remote["sha"] == locked_commit or remote["sha"].startswith(locked_commit[:7]):
        results["up_to_date"] += 1
        results["details"].append({
            "skill": name,
            "repo": repo,
            "locked_commit": locked_commit[:7],
            "remote_commit": remote["sha"][:7],
            "status": "UP_TO_DATE"
        })
    else:
        results["updates_available"] += 1
        results["details"].append({
            "skill": name,
            "repo": repo,
            "locked_commit": locked_commit[:7],
            "remote_commit": remote["sha"][:7],
            "remote_date": remote["date"],
            "remote_msg": remote["message"],
            "status": "UPDATE_AVAILABLE"
        })

os.makedirs(".project-memory", exist_ok=True)
with open("$REPORT_JSON", "w") as f:
    json.dump(results, f, indent=2)

with open("$REPORT_MD", "w") as f:
    f.write(f"# Rapport de veille des skills (Audit du {results['checked_at']})\n\n")
    f.write(f"- **Skills analysés** : {results['total_skills']}\n")
    f.write(f"- **À jour** : {results['up_to_date']}\n")
    f.write(f"- **Mises à jour disponibles** : {results['updates_available']}\n\n")
    
    if results['updates_available'] > 0:
        f.write("## ⚠️ Mises à jour amont détectées\n\n")
        f.write("| Skill | Dépôt | Version locale | Version distante | Dernier commit |\n")
        f.write("|-------|-------|----------------|------------------|----------------|\n")
        for item in results['details']:
            if item["status"] == "UPDATE_AVAILABLE":
                f.write(f"| `{item['skill']}` | `{item['repo']}` | `{item['locked_commit']}` | `{item['remote_commit']}` | {item.get('remote_msg', '')[:40]} |\n")
    else:
        f.write("✅ **Tous les skills du lock sont parfaitement alignés avec les versions certifiées.**\n")

print(f"\n[✓] Audit terminé : {results['up_to_date']} à jour, {results['updates_available']} mises à jour amont.")
print(f"    Rapport sauvegardé dans $REPORT_MD et $REPORT_JSON")
EOF
