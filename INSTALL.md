<!-- INSTALL.md — Installer et démarrer le super-agent · @hopsyder (https://github.com/Hop-Syder) — Nexus Partners (https://nexus-partners.xyz/) -->

# Installer et utiliser le super-agent Desty 3.2

Un système complet et sécurisé : **on installe en local uniquement les skills choisis, figés sur une version exacte dans `skills.lock`, et on est prévenu quand ils changent, sans jamais rien mettre à jour en douce.**

---

## 🏛️ Les 4 pièces maîtresses du système

| Pièce | Rôle |
|---|---|
| **`skills.lock`** | La liste de tous les skills certifiés de `docs/MAPPING.md`. Pour chacun : le dépôt d'origine, le chemin, la version exacte (commit SHA) et la date du dernier scan. **C'est la seule et unique source de vérité.** |
| **`skills-sync.sh`** | **Remplace `--with-skills`.** Il télécharge/installe uniquement les skills listés dans le lock, à la version fixée, dans `.agents/skills/`. Il les soumet à SkillSpector et refuse immédiatement ceux qui échouent. |
| **`skills-check.sh`** | Compare votre `skills.lock` avec GitHub, skill par skill : à jour (`UP_TO_DATE`), mise à jour disponible (`UPDATE_AVAILABLE`), ou supprimé en amont (`DELETED`). |
| **Workflow de veille hebdomadaire** (`workflows/skills-watch.yml`) | Exécute la vérification chaque semaine (le lundi). Si un skill a changé, il ouvre une Pull Request détaillée avec le diff et le score de sécurité. |

> 🧠 **Au démarrage**, l'agent **Project Memory** vérifie le statut : *« 2 mises à jour de skills en attente, voir PR #12 »*.

---

## 🔄 Votre quotidien avec ce système

1. **Installation (une seule fois)** :
   ```bash
   ~/fullstack-agent-skills-2026/install.sh /chemin/vers/mon-projet
   cd /chemin/vers/mon-projet && ./skills-sync.sh
   ```
   Vous disposez de vos skills scannés et validés en local dans `.agents/skills/`. Ils fonctionnent **à 100% hors ligne sans latence réseau**.
2. **Au travail quotidien** :
   L'agent utilise les skills locaux. Pas de réseau, pas de tokens gaspillés, stabilité totale.
3. **Chaque semaine (veille automatisée)** :
   Une PR automatique arrive s'il y a du nouveau sur les dépôts officiels. Vous lisez le diff et le score de sécurité SkillSpector, puis vous fusionnez ou refusez. Si vous fusionnez, le lock est mis à jour et toute l'équipe reçoit la même version.
4. **Ajouter un skill** :
   Vous ajoutez l'entrée dans `skills.lock`, vous relancez `./skills-sync.sh`. Il est scanné avant d'être accepté.

---

## 🛡️ Les règles absolues

- **Rien n'est mis à jour sans votre validation explicite** (zéro surprise en douce).
- **Aucun skill n'est installé sans scan réussi** (politique stricte SkillSpector).
- **Rien d'autre que ce qui est listé dans le lock.**

---

## 🚀 Guide par outil de développement

### Claude Code (terminal)
```bash
cd mon-projet && claude
```
- Le hook `SessionStart` charge la mémoire et vous alerte si des mises à jour de skills sont en attente.
- Réveil manuel disponible via la commande `/resume`.

### VS Code (GitHub Copilot mode agent)
- Copilot lit `AGENTS.md`. Le réveil et la politique de lock sont appliqués au premier échange.

### Codex (CLI)
```bash
cd mon-projet && codex
```
- Lit `AGENTS.md` à la racine et charge les skills verrouillés depuis `.agents/skills/`.

### Cursor & OpenClaw
- Chargent automatiquement les instructions de session d'`AGENTS.md` et les skills scannés de `.agents/skills/`.
