<!-- INSTALL.md — Installer et démarrer le super-agent · @hopsyder (https://github.com/Hop-Syder) — Nexus Partners (https://nexus-partners.xyz/) -->

# Installer et démarrer le super-agent Desty 3.2

## Comment c'est construit (à lire une fois)

Le kit repose sur trois éléments, et chaque outil en lit une partie :

| Élément | Rôle | Lu par |
|---------|------|--------|
| `AGENTS.md` | Instructions de session : réveil, gardien de la vision, journal | Codex, OpenClaw, Copilot (VS Code), Cursor ; Claude Code via `CLAUDE.md` |
| `.project-memory/` | La mémoire du projet (MAP, STATE, REFUSALS…) | Tous (ce sont de simples fichiers) |
| `.agents/skills/` | Les skills, en un seul exemplaire | Codex, OpenClaw, Copilot ; Claude Code via le lien `.claude/skills` |

**Le réveil automatique (hook) n'existe que dans Claude Code.** Ailleurs, c'est la section 1 d'`AGENTS.md` qui demande à l'agent de relire la mémoire au début de chaque session. Le résultat est le même, mais il dépend de l'agent qui suit ses instructions.

---

## Feuille de route d'installation (tous outils)

### Étape 1 : récupérer le kit
```bash
git clone https://github.com/Hop-Syder/fullstack-agent-skills-2026.git ~/fullstack-agent-skills-2026
```

### Étape 2 : l'installer dans ton projet
```bash
~/fullstack-agent-skills-2026/install.sh /chemin/vers/mon-projet
```
Le script n'écrase jamais l'existant : un `AGENTS.md`, un `CLAUDE.md` ou un `.claude/settings.json` déjà présent est **complété**, pas remplacé. Tu peux le relancer sans risque.

### Étape 3 : installer les skills (optionnel, recommandé)
```bash
~/fullstack-agent-skills-2026/install.sh /chemin/vers/mon-projet --with-skills
```
Cette option demande Node.js. Elle télécharge les skills des dépôts vérifiés dans `.agents/skills/`.

### Étape 4 : scanner les skills avant de t'en servir
```bash
uv tool install git+https://github.com/NVIDIA/SkillSpector.git
skillspector scan .agents/skills/<nom-du-skill>
```
Supprime tout skill classé *Do Not Install*.

### Étape 5 : remplir la carte mentale
Ouvre `.project-memory/MAP.md` et écris la vision, la cible, la finalité et ce qui est hors périmètre. **Sans cela, le gardien de la vision n'a rien pour juger.**

### Étape 6 : premier démarrage
Lance ton outil (voir ci-dessous). L'agent te demande une fois : fichiers (1) ou base de données (2). Ensuite il annonce où on en est.

### Étape 7 : committer
```bash
git add AGENTS.md CLAUDE.md agents docs .project-memory .agents .claude
git commit -m "chore: installe le super-agent"
```
La mémoire voyage avec le repo : toute personne qui clone le projet récupère la même carte mentale.

---

## Par outil

### Claude Code (terminal)
Rien de plus à faire après `install.sh`.
```bash
cd mon-projet && claude
```
- **Réveil automatique** : le hook `SessionStart` charge la mémoire à l'ouverture.
- **Réveil manuel** : tape `/resume`.
- La première fois, Claude Code te demande d'approuver le hook du projet. Accepte-le.

### VS Code
Deux cas, selon l'extension :
- **Extension Claude Code** : même comportement que dans le terminal (hook, `/resume`, `.claude/skills`). Ouvre le dossier du projet, puis le panneau Claude.
- **GitHub Copilot (mode agent)** : Copilot lit `AGENTS.md`. Le réveil passe donc par ces instructions, sans hook. Au premier message, écris « reprends le projet » pour le déclencher.

### Codex (CLI / IDE)
Codex lit `AGENTS.md` à la racine du projet et charge les skills depuis `.agents/skills/` : `install.sh` met tout en place.
```bash
cd mon-projet && codex
```

### OpenClaw
OpenClaw charge les skills depuis `<workspace>/skills` et `<workspace>/.agents/skills`. Le dossier créé par `install.sh` est donc reconnu tel quel.

### Cursor, Windsurf, JetBrains et autres
La plupart lisent `AGENTS.md` et le format `SKILL.md` en 2026. Même principe que Codex : instructions dans `AGENTS.md`, skills dans `.agents/skills/`.

---

## Vérifier que ça marche (2 minutes)

1. Écris une ligne dans `REFUSALS.md`, par exemple `- 2026-10-13 | ajouter un mode sombre | pas prioritaire pour la cible`.
2. Ouvre une nouvelle session et demande : « ajoute un mode sombre ».
3. **Réussi** si l'agent te rappelle le refus et demande ce qui a changé. **Échoué** s'il code directement.
