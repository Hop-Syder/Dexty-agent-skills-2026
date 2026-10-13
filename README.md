<div align="center">

  <video src="assets/dexty-presentation.mp4" poster="assets/dexty-logo.svg" controls autoplay muted loop playsinline width="100%" style="max-width: 720px; border-radius: 16px; margin-bottom: 20px;" aria-label="Dexty 3.5 official presentation">
    Votre navigateur ne supporte pas la balise <code>video</code>. Vous pouvez télécharger la présentation ici : <a href="assets/dexty-presentation.mp4">assets/dexty-presentation.mp4</a>
  </video>

  <p>
    <a href="https://github.com/Hop-Syder/fullstack-agent-skills-2026/stargazers"><img src="https://img.shields.io/github/stars/Hop-Syder/fullstack-agent-skills-2026?style=for-the-badge&color=00f5f" alt="Stars" /></a>
    <a href="docs/EVALUATION.md"><img src="https://img.shields.io/badge/Architecture%20Score-89%2F100-00e676?style=for-the-badge&logo=speedtest" alt="Score 89/100" /></a>
    <a href="skills.lock"><img src="https://img.shields.io/badge/Skills%20Lock-51%20Verified-7c4dff?style=for-the-badge&logo=anchor" alt="51 Skills Locked" /></a>
    <a href="https://github.com/NVIDIA/SkillSpector"><img src="https://img.shields.io/badge/Security-SkillSpector%20Audited-76b900?style=for-the-badge&logo=nvidia" alt="SkillSpector Audited" /></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="License MIT" /></a>
  </p>

</div>

---

## 💡 Pourquoi Desty 3.5 ?

La plupart des agents de code en 2026 souffrent de quatre défauts critiques :
1. **Amnésie de session** : ils oublient ce qui a été refusé, arbitré ou validé d'une session à l'autre.
2. **Sur-ingénierie & gaspillage de tokens** : ils chargent des répertoires entiers d'outils inutiles pour un problème donné.
3. **Mises à jour sauvages** : ils dérivent au gré des modifications en amont, cassant la reproductibilité.
4. **Auto-complaisance** : l'agent qui écrit le code se note lui-même et ignore ses propres failles.

**Desty 3.5 résout définitivement ces problèmes** grâce à une architecture souveraine développée par **[Nexus Partners](https://nexus-partners.xyz/)** sous la direction de **[@hopsyder (Hop-Syder)](https://github.com/Hop-Syder)**.

---

## ⚡ En quoi Desty 3.5 est unique

```text
┌───────────────────────────────────────────────────────────────────────────────────────────────────
│  1. ONBOARDING SUR-MESURE (7 questions)                                                         │
│     L'agent analyse votre stack, horizon et sensibilité pour sélectionner                       │
│     uniquement les skills requis (ex: 26/37 pour un SaaS Next.js + Postgres).                   │
├───────────────────────────────────────────────────────────────────────────────────────────────────
│  2. MÉTROLOGIE DU LOCK DÉTERMINISTE (skills.lock)                                               │
│     Versions scellées par commit SHA exact. Zéro mise à jour en douce.                          │
├───────────────────────────────────────────────────────────────────────────────────────────────────
│  3. GARDE-FOU DE SÉCURITÉ NVIDIA SKILLSPECTOR                                                   │
│     Tout skill tiers est scanné (prompt injection, exfiltration, permissions).                   │
├───────────────────────────────────────────────────────────────────────────────────────────────────
│  4. JUGE QA SÉPARÉ (Règle d'or : "Juge ≠ Exécutant")                                           │
│     L'agent d'évaluation note la conformité et la qualité sans avoir codé.                      │
├───────────────────────────────────────────────────────────────────────────────────────────────────
│  5. MÉMOIRE VIVE ET GARDIEN DE VISION (.project-memory/)                                        │
│     Réveil instantané au démarrage, protocole de contestation "Convainquez-moi"                │
└───────────────────────────────────────────────────────────────────────────────────────────────────
```

---

## 🏛️ La Chaîne de Commandement : 8 Pôles Spécialisés

Desty 3.5 coordonne 8 lead agents autonomes, assistés de sous-agents spécialisés :

| # | Pôle Directeur | Mission Opérationnelle | Fiche Détaillée |
|---|---|---|---|
| **①** | **Product Manager** | Cadrage du besoin, spécifications d'exigences, découpage en tâches et ADR | [`agents/01-product-manager.md`](agents/01-product-manager.md) |
| **②** | **Workflow / UX Owner** | Fil rouge utilisateur, design tokens, cinématiques d'écrans et contrats d'API front | [`agents/02-workflow-ux-owner.md`](agents/02-workflow-ux-owner.md) |
| **③** | **Security Lead** | Modèle de menaces STRIDE, durcissement du code et contrôle des permissions IA | [`agents/03-security-lead.md`](agents/03-security-lead.md) |
| **④** | **Build / Dev Lead** | Développement incrémental, cycle TDD, simplification YAGNI et débogage | [`agents/04-build-dev-lead.md`](agents/04-build-dev-lead.md) |
| **⑤** | **DevOps / Release** | Pipelines CI/CD automatisés, conteneurisation durcie et observabilité SRE | [`agents/05-devops-release.md`](agents/05-devops-release.md) |
| **⑥** | **QA / Evaluator** | Mesure indépendante : notation de conformité et de qualité de code (juge séparé) | [`agents/06-qa-evaluator.md`](agents/06-qa-evaluator.md) |
| **⑦** | **Data / ML** | Ingestion tabulaire, requêtage PostgreSQL, modèles ML/NLP et suivi de dérive | [`agents/07-data-ml.md`](agents/07-data-ml.md) |
| **⑧** | **Project Memory** | Mémoire vive, rappel des décisions passées et protection de la vision produit | [`agents/08-project-memory.md`](agents/08-project-memory.md) |

---

## 🔒 Le Système en 4 Pièces : Zéro Dérive, Zéro Surprise

```text
 ┌─────────────┐       ┌──────────────────┐       ┌──────────────────┐       ┌──────────────────┐
 │ skills.lock │ ────► │  skills-sync.sh  │ ────► │  skills-check.sh │ ────► │  Weekly Watch    │
 └─────────────┘       └──────────────────┘       └──────────────────┘       └──────────────────┘
  Seule source de       Installation locale        Audit API amont sans       Action cron qui    
  vérité (commit SHA    100% offline avec          clonage. Détecte les       ouvre une PR avec 
  & score certifié).    scan SkillSpector.         diffs de version.          diff & score.
```

- **Rien n'est mis à jour sans validation humaine via Pull Request.**
- **Aucun skill n'est exécuté sans scan de sécurité préalable réussi.**
- **Rien d'autre n'est chargé en mémoire que ce qui est consigné dans le lock.**

---

## 🚀 Démarrage Rapide en 60 Secondes

### 1. Récupérer le super-agent
```bash
git clone https://github.com/Hop-Syder/fullstack-agent-skills-2026.git ~/fullstack-agent-skills-2026
```

### 2. Installer et lancer l'onboarding interactif dans votre projet
```bash
~/fullstack-agent-skills-2026/install.sh /chemin/vers/mon-projet --onboard
```

Répondez aux **7 questions guidées** :
1. Nom du projet
2. Description synthétique
3. Stack technique (ex : Next.js + Postgres + Tailwind)
4. Fonctionnalités prioritaires (auth, dashboard, paiement, API)
5. Horizon visé (MVP, Production soignée, Entreprise)
6. Exposition publique sur Internet (durcissement sécurité)
7. Présence de données sensibles (activation audit Trail of Bits)

### 3. Démarrer votre environnement de travail
```bash
cd /chemin/vers/mon-projet
claude # ou codex, cursor, vscode
```
L'agent Project Memory se réveille, charge votre carte mentale `MAP.md`, affiche l'état d'avancement et veille sur votre vision.

---

## 📊 Évaluation & Métriques d'Architecture

L'architecture de Desty a été rigoureusement notée selon la grille formelle de [`docs/EVALUATION.md`](docs/EVALUATION.md) :

```text
┌─────────────────────────┬────────┬──────────────────────────────────────────────────────────
│ Axe d'Évaluation        │  Note  │ Justification & Rigueur                                  │
├─────────────────────────┼────────┼──────────────────────────────────────────────────────────
│ Couverture Cycle SDLC   │  20/20 │ DEFINE → PLAN → BUILD → VERIFY → REVIEW → SHIP + Data    │
│ Séparation des Rôles    │  20/20 │ Juge QA séparé de l'exécutant Dev. Zéro doublon.         │
│ Traçabilité des Sources │  18/20 │ 6 dépôts vérifiés. Skills manquants marqués à sourcer    │
│ Orchestration & Worktree│  17/20 │ Patterns Jesse Vincent / Obra Superpowers intégrés       │
│ Évaluabilité du Système │  14/20 │ Kit d'épreuve sur 4 scénarios réels documenté            │
├─────────────────────────┼────────┼──────────────────────────────────────────────────────────
│ SCORE GLOBAL ARCHI      │ 89/100 │ Plafond de maturité théorique atteint (Prêt pour prod)   │
└─────────────────────────┴────────┴──────────────────────────────────────────────────────────
```

---

## 📂 Organisation du Dépôt

```text
fullstack-agent-skills-2026/
├── README.md                          # Vitrine officielle Desty 3.5
├── AGENTS.md                          # Protocole universel lu par tous les coding agents
├── CLAUDE.md                          # Configuration Claude Code (@AGENTS.md)
├── INSTALL.md                         # Guide d'installation complet multi-outils
├── install.sh                         # Script d'installation idempotent dans vos projets
├── skills.catalog.json                # Catalogue complet des 37 compétences et triggers
├── skills.lock                        # Source de vérité déterministe (SHAs et scores)
├── tools/
│   ├── onboard.sh                     # Questionnaire interactif de sélection contextuelle
│   ├── skills-sync.sh                 # Installateur local sécurisé avec filtre SkillSpector
│   └── skills-check.sh                # Vérificateur upstream via API GitHub
├── workflows/
│   ├── skills-update.yml              # Audit hebdomadaire et création automatique de PR
│   └── sdlc-pipeline.yaml             # Pipeline de livraison logicielle multi-agents
├── agents/                            # Fiches opérationnelles des 8 pôles directeurs
├── docs/
│   ├── MAPPING.md                     # Cartographie matricielle des compétences
│   ├── SOURCES.md                     # Traçabilité des dépôts amont certifiés
│   └── EVALUATION.md                  # Grille de notation sur 100 points
├── assets/
│   ├── desty-logo.svg                 # Logo officiel vectoriel Desty 3.5 par Nexus Partners
│   └── desty-logo.jpg                 # Logo haute définition
├── .project-memory/                   # Système de mémoire vive (MAP, STATE, REFUSALS...)
└── skills/                            # Registre de référence (Addy Osmani & Superpowers)
```

---

## 🤝 Écosystème & Remerciements

Desty 3.5 s'appuie sur les contributions majeures de l'ingénierie open-source d'agents IA :
- [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) — Addy Osmani (Google)
- [obra/superpowers](https://github.com/obra/superpowers) — Jesse Vincent
- [anthropics/skills](https://github.com/anthropics/skills) — Anthropic
- [NVIDIA/SkillSpector](https://github.com/NVIDIA/SkillSpector) — NVIDIA
- [trailofbits/skills](https://github.com/trailofbits/skills) — Trail of Bits
- [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) — Vercel Labs
- [supabase/agent-skills](https://github.com/supabase/agent-skills) — Supabase

---

<div align="center">
  <sub>Conçu et maintenu par <b><a href="https://github.com/Hop-Syder">ISMAEL CHRISTIAN DAOUDA ABASSI (@Hop-Syder)</a></b> — <b><a href="https://nexus-partners.xyz/">Nexus Partners</a></b></sub>
</div>
