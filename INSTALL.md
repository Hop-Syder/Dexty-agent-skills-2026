<!-- INSTALL.md — Installer et démarrer le super-agent · @hopsyder (https://github.com/Hop-Syder) — Nexus Partners (https://nexus-partners.xyz/) -->

# Guide d'Installation — Desty 3.5

Desty 3.5 introduit un flux d'onboarding contextuel : **l'agent sélectionne les skills pertinents en fonction de votre projet spécifique**, les verrouille dans `skills.lock`, et gère leur cycle de vie sans mise à jour imprévue.

---

## 🏁 Installation pas-à-pas

### Étape 1 : Récupérer le kit
```bash
git clone https://github.com/Hop-Syder/fullstack-agent-skills-2026.git ~/fullstack-agent-skills-2026
```

### Étape 2 : Installer et lancer l'onboarding
```bash
~/fullstack-agent-skills-2026/install.sh /chemin/vers/mon-projet --onboard
```

Le script vous pose 7 questions simples :
1. **Nom du projet**
2. **Description** (1 à 3 phrases)
3. **Stack technique** (ex: Next.js + Postgres + Tailwind)
4. **Fonctionnalités prioritaires** (auth, paiement, dashboard, CI/CD)
5. **Horizon visé** (MVP, Production soignée, Entreprise)
6. **Application publique ?** (active le durcissement réseau/headers)
7. **Données sensibles ?** (active les skills d'audit Trail of Bits)

### Étape 3 : Synchronisation automatique
À partir de vos réponses, Desty 3.5 sélectionne les skills pertinents parmi les 37 du catalogue `skills.catalog.json`, génère `.agents/skills.lock` et lance `tools/skills-sync.sh` avec validation SkillSpector.

---

## 🛠️ Commandes utiles

- **Vérifier les mises à jour amont** :
  ```bash
  ./tools/skills-check.sh
  ```
- **Resynchroniser les skills locaux** :
  ```bash
  ./tools/skills-sync.sh
  ```
- **Relancer l'onboarding** :
  ```bash
  ./tools/onboard.sh
  ```
