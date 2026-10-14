# Guide d'installation — Dexty 3.5.1

## 1. Installation rapide dans un projet existant

```bash
# Cloner le registre Dexty 3.5.1
git clone https://github.com/Hop-Syder/Dexty-agent-skills-2026.git ~/Dexty-agent-skills-2026

# Installer Dexty et lancer immédiatement l'onboarding interactif (7 questions)
~/Dexty-agent-skills-2026/install.sh /chemin/vers/mon-projet --onboard
```

Si vous souhaitez installer la structure sans lancer le questionnaire immédiatement :

```bash
~/Dexty-agent-skills-2026/install.sh /chemin/vers/mon-projet --skip-onboard
# Puis plus tard :
bash /chemin/vers/mon-projet/tools/onboard.sh /chemin/vers/mon-projet
```

## 2. Ce que fait `install.sh`

1. Copie sans écraser l'existant :
   - `VERSION` (`3.5.1`)
   - `agents/` (les 8 fiches `01-` à `08-`)
   - `docs/super-agent/` (`MAPPING.md`, `SOURCES.md`, `EVALUATION.md`)
   - `.project-memory/` (templates vierges avec marqueur `DEXTY_TEMPLATE_UNCONFIGURED` et règles de sécurité dans `ERRORS.md`)
   - `.claude/hooks/memory-wake.sh`, `.claude/commands/resume.md` et `.claude/settings.json`
   - `tools/` (`onboard.sh`, `skills-sync.sh`, `skills-check.sh`) et les délégateurs racine
   - `skills/` (37 résumés opérationnels vérifiés par `SHA-256`) et `skills.catalog.json`
2. Complète `AGENTS.md` et `CLAUDE.md` de manière strictement idempotente (aucune duplication en cas de ré-exécution).
3. Ne copie aucun `skills.lock` pré-armé : le fichier `.agents/skills.lock` du projet est généré exclusivement par `tools/onboard.sh`.

## 3. Activation par éditeur / agent CLI

- **Claude Code** : ouvre le dossier du projet et lance `claude`. Le hook `SessionStart` déclaré dans `.claude/settings.json` exécute automatiquement `.claude/hooks/memory-wake.sh`.
- **OpenAI Codex CLI / Cursor / Windsurf / VS Code / Antigravity** : lisent automatiquement `AGENTS.md` à la racine du projet.

## 4. Comment appeler les 8 Agents Chefs avec `@`

Une fois installé, mentionnez directement la fiche de l'agent dans le chat de votre IDE :

| Agent Chef | Tag direct `@` | Rôle clé |
| :--- | :--- | :--- |
| **① Product Manager** | `@agents/01-product-manager.md` | Spécifications, backlog & cadrage (délègue à l'équipe) |
| **② Workflow / UX Owner** | `@agents/02-workflow-ux-owner.md` | Parcours utilisateur & design UI |
| **③ Security Lead** | `@agents/03-security-lead.md` | Audit menaces & garde-fous |
| **④ Build / Dev Lead** | `@agents/04-build-dev-lead.md` | Développement incrémental & TDD |
| **⑤ DevOps / Release** | `@agents/05-devops-release.md` | CI/CD, observabilité & mise en prod |
| **⑥ QA / Evaluator** | `@agents/06-qa-evaluator.md` | Juge indépendant (évalue sans coder) |
| **⑦ Data / ML** | `@agents/07-data-ml.md` | Schémas BDD PostgreSQL & pipelines données |
| **⑧ Project Memory** | `@agents/08-project-memory.md` | Gardien de la vision & reprise de session |

💡 **Workflow recommandé :** Commencez toujours par le Product Manager :
```text
@agents/01-product-manager.md Voici mon besoin : [décrire l'idée ou la fonctionnalité].
Étudie la tâche, rédige la spec et prépare le découpage pour le dev et la sécurité.
```

## 5. Activer le workflow GitHub Actions dans votre dépôt

Pour activer la suite de tests CI (`tests/run_audit_tests.sh`) et la veille hebdomadaire sur GitHub Actions :

```bash
mkdir -p .github/workflows
cp workflows/skills-update.yml .github/workflows/skills-update.yml
```
