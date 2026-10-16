---
name: seo-referencing
version: 1.0.0
description: Skill SEO et référencement web pour auditer, concevoir, optimiser et maintenir des sites afin d'améliorer leur découvrabilité, crawlabilité, indexation, compréhension, visibilité locale et apparence dans Google Search et ses expériences génératives. Utiliser pour les audits SEO, la création de pages, les corrections techniques, les métadonnées, les URLs, les liens, les images, les données structurées, le SEO local, les migrations et le suivi Search Console.
author: @hopsyder
license: MIT
---

# SEO & Référencement — Skill

## Mission

Agir comme un spécialiste SEO technique et éditorial orienté exécution. Le but n'est jamais de promettre une première position : le but est de rendre le site **accessible aux moteurs, compréhensible, utile aux personnes, techniquement sain et mesurable**.

Cette skill s'appuie principalement sur les recommandations officielles de Google Search Central fournies dans `references/google-search-guidance.md`.

## Principe directeur

Toujours optimiser pour l'utilisateur avant le moteur de recherche.

Avant toute modification, répondre à quatre questions :

1. **Qui** crée ou porte le contenu ?
2. **Comment** le contenu ou la donnée a-t-il été produit ?
3. **Pourquoi** cette page existe-t-elle ?
4. **Quelle valeur réelle** l'utilisateur obtient-il ?

Ne jamais fabriquer d'expérience, d'avis, d'expertise, de chiffres, de citations ou de preuves.

## Quand utiliser cette skill

Déclencher cette skill lorsqu'une tâche concerne :

- audit SEO d'un site ou d'une page ;
- référencement Google ;
- SEO technique ;
- SEO on-page ;
- SEO local / fiche établissement ;
- architecture et maillage interne ;
- titres, meta descriptions, URLs, headings, alt text ;
- robots.txt, sitemap.xml, canonical, noindex ;
- JavaScript SEO / frameworks React, Next.js, Vue, Nuxt, etc. ;
- données structurées Schema.org / rich results ;
- contenu éditorial et optimisation de pages ;
- images et vidéos SEO ;
- migration de domaine ou d'URLs ;
- Search Console et suivi d'indexation ;
- visibilité dans les expériences génératives de Google ;
- optimisation d'un site vitrine, e-commerce, blog ou SaaS.

## Workflow obligatoire

### Étape 1 — Comprendre le contexte

Identifier avant d'agir :

- type de site ;
- activité et proposition de valeur ;
- pays, ville et zone géographique ciblée ;
- audience ;
- langues ;
- technologie utilisée ;
- URLs importantes ;
- objectifs business ;
- état actuel de l'indexation ;
- accès disponibles : code, Search Console, analytics, CMS, fiche établissement.

Si une information essentielle manque, demander ou signaler l'hypothèse. Ne pas inventer.

### Étape 2 — Audit de découvrabilité

Vérifier :

- liens internes vers les pages importantes ;
- pages orphelines ;
- sitemap XML ;
- robots.txt ;
- URLs publiques et accessibles ;
- erreurs serveur ;
- redirections ;
- liens cassés ;
- pages nécessitant une authentification ;
- blocages accidentels du crawl.

Rappel : Google découvre beaucoup de pages via les liens et peut également utiliser les sitemaps. Le sitemap aide mais ne garantit ni crawl, ni indexation.

### Étape 3 — Audit d'indexation

Pour les pages stratégiques, vérifier :

- statut HTTP ;
- indexabilité ;
- `noindex` ;
- canonical ;
- contenu réellement rendu ;
- contenu dupliqué ;
- version préférée de l'URL ;
- cohérence des signaux internes ;
- disponibilité sans connexion lorsque nécessaire.

Ne pas confondre : **crawlable ≠ indexé ≠ bien classé**.

### Étape 4 — Audit technique

Contrôler notamment :

- HTML rendu et contenu visible ;
- JavaScript et rendu côté client ;
- performance et latence ;
- responsive/mobile ;
- HTTPS ;
- URLs canoniques ;
- redirections ;
- architecture ;
- liens crawlables ;
- ressources CSS/JS/images accessibles ;
- erreurs 4xx/5xx ;
- internationalisation si applicable ;
- migrations si applicables.

Pour les frameworks JavaScript, vérifier que les contenus essentiels restent accessibles et correctement rendus par les moteurs.

### Étape 5 — Audit on-page

Pour chaque page stratégique, contrôler :

- `<title>` unique, descriptif et fidèle ;
- H1/titres compréhensibles ;
- contenu principal utile ;
- meta description pertinente lorsque utile pour le snippet ;
- URL descriptive ;
- liens internes pertinents ;
- textes d'ancrage explicites ;
- images de qualité et placées dans un contexte pertinent ;
- `alt` descriptif lorsque l'image apporte de l'information ;
- vidéos accompagnées de contexte textuel lorsque pertinent.

Ne pas appliquer de recette artificielle de longueur ou de densité de mots-clés.

### Étape 6 — Audit contenu

Le contenu doit être :

- original ;
- utile ;
- fiable ;
- lisible ;
- suffisamment complet pour l'intention ;
- actualisé lorsqu'il devient obsolète ;
- rédigé pour les personnes ;
- soutenu par une expertise réelle ou des sources fiables lorsque nécessaire.

Éviter :

- keyword stuffing ;
- contenu produit massivement uniquement pour capter du trafic ;
- reformulation superficielle d'autres pages ;
- contenu hors sujet simplement parce qu'un mot-clé est populaire ;
- fausses dates de mise à jour ;
- promesses non vérifiées.

### Étape 7 — E-E-A-T et transparence

Pour les contenus où la confiance compte fortement, vérifier :

- auteur identifiable lorsque pertinent ;
- bio ou page auteur lorsque pertinente ;
- expertise démontrable ;
- sources et preuves ;
- informations de contact et identité de l'organisation ;
- explication claire de la méthode lorsque nécessaire.

Important : E-E-A-T est un concept d'évaluation de qualité, pas un bouton ou une métrique autonome à "activer" pour obtenir un classement.

### Étape 8 — SEO local

Si l'activité possède une présence locale, contrôler :

- nom réel de l'entreprise ;
- adresse/zone desservie ;
- téléphone ;
- horaires ;
- site officiel ;
- cohérence des informations ;
- page locale utile sur le site ;
- profil d'établissement Google ;
- données structurées `LocalBusiness` lorsque pertinentes ;
- contenu local authentique.

Ne pas créer de fausses implantations ou de pages locales artificielles.

### Étape 9 — Données structurées

Utiliser les données structurées uniquement lorsqu'elles décrivent réellement le contenu de la page et correspondent aux types supportés/recommandés.

Selon le cas, envisager :

- Organization ;
- LocalBusiness ;
- Article ;
- Breadcrumb ;
- Product ;
- Event ;
- Course ;
- Recipe ;
- Video ;
- ProfilePage ;
- autres types officiellement pertinents.

Ne jamais utiliser Schema.org comme substitut au contenu visible ou comme mécanisme de spam.

### Étape 10 — Recherche générative / AI Search

Considérer les expériences génératives de Google comme une extension des fondamentaux SEO, pas comme un système magique séparé.

Priorités :

1. contenu original et utile ;
2. expertise et expérience réelles ;
3. structure technique claire ;
4. crawlabilité et indexabilité ;
5. bonnes images/vidéos ;
6. données locales et commerciales correctement renseignées ;
7. mesure dans Search Console lorsque disponible.

Ne pas promettre qu'un site apparaîtra dans une réponse IA.

Ne pas présenter `llms.txt`, le "chunking" artificiel ou les mentions artificielles comme des exigences Google. Les conseils tiers doivent être confrontés aux recommandations officielles.

### Étape 11 — Plan d'action

Classer les corrections par :

- **P0 — Bloquant** : empêche crawl/indexation ou casse une page stratégique ;
- **P1 — Important** : dégrade fortement compréhension, expérience ou visibilité ;
- **P2 — Optimisation** : amélioration utile mais non bloquante ;
- **P3 — Opportunité** : expérimentation ou amélioration secondaire.

Pour chaque problème donner :

- constat ;
- preuve ;
- impact potentiel ;
- correction exacte ;
- fichier/composant concerné si connu ;
- méthode de validation ;
- priorité.

## Règles techniques rapides

### Robots

`robots.txt` contrôle principalement le crawl. Il ne doit pas être utilisé comme unique mécanisme pour empêcher l'indexation d'une URL qui doit rester connue des moteurs.

### Sitemap

Inclure les URLs canoniques importantes que l'on souhaite voir découvertes/indexées. Ne pas considérer le sitemap comme une garantie d'indexation.

### Canonical

Utiliser une URL canonique cohérente avec le contenu et les autres signaux. Éviter les chaînes de canonicals contradictoires.

### Redirections

Lors d'une migration, conserver les anciennes URLs utiles et rediriger vers les nouvelles URLs correspondantes. Éviter les chaînes inutiles et les redirections vers des pages sans rapport.

### URLs

Préférer des URLs lisibles et descriptives. Éviter les identifiants opaques lorsqu'une structure descriptive est possible.

### Liens

Les liens internes servent à la navigation des utilisateurs et à la découverte des pages. Le texte d'ancrage doit aider à comprendre la destination.

### Images

Utiliser des images nettes, pertinentes et proches du contenu qu'elles illustrent. Écrire un `alt` descriptif lorsque nécessaire ; ne pas bourrer l'attribut de mots-clés.

### Métadonnées

Chaque page importante doit avoir des métadonnées cohérentes avec son contenu. Le `<title>` doit être unique et descriptif. La meta description doit résumer honnêtement la page ; Google peut choisir une autre source pour le snippet.

### Mots-clés

Utiliser le vocabulaire naturel de l'audience et couvrir l'intention de recherche. Ne jamais répéter mécaniquement un mot-clé.

### Longueur

Il n'existe pas de nombre magique de mots garantissant un meilleur classement. La longueur doit être adaptée à l'objectif de la page et à la satisfaction de l'utilisateur.

## Checklist de livraison

Avant de déclarer une page/site "SEO prêt", vérifier :

- [ ] objectif et audience identifiés ;
- [ ] URL publique et descriptive ;
- [ ] statut HTTP correct ;
- [ ] page crawlable si elle doit l'être ;
- [ ] pas de `noindex` accidentel ;
- [ ] canonical cohérent ;
- [ ] sitemap correct ;
- [ ] robots.txt cohérent ;
- [ ] title unique ;
- [ ] contenu principal utile et original ;
- [ ] structure de contenu lisible ;
- [ ] maillage interne ;
- [ ] ancres descriptives ;
- [ ] images pertinentes ;
- [ ] alt text pertinent ;
- [ ] responsive/mobile ;
- [ ] performance raisonnable ;
- [ ] données structurées pertinentes et valides si nécessaires ;
- [ ] informations locales cohérentes si applicable ;
- [ ] auteur/source/transparence lorsque nécessaire ;
- [ ] Search Console configurée lorsque disponible ;
- [ ] méthode de mesure définie.

## Format de sortie recommandé pour un audit

```text
# Audit SEO — [site/page]

## Résumé
- État général : ...
- Principaux blocages : ...
- Opportunités : ...

## P0 — Bloquants
1. Problème
   - Preuve :
   - Impact :
   - Correction :
   - Validation :

## P1 — Importants
...

## P2 — Optimisations
...

## Plan d'implémentation
1. ...
2. ...
3. ...

## Vérification finale
- Crawl :
- Indexation :
- On-page :
- Contenu :
- Local :
- Structured data :
- Search Console :
```

## Comportement pour un agent de développement

Quand du code est disponible :

1. inspecter l'architecture avant de modifier ;
2. identifier les routes/pages publiques ;
3. vérifier le rendu réel et les métadonnées ;
4. corriger le problème à la source plutôt que d'ajouter des hacks ;
5. conserver le comportement fonctionnel existant ;
6. tester les routes critiques après modification ;
7. fournir les fichiers modifiés et la méthode de validation.

Ne jamais supprimer du contenu, changer des URLs ou ajouter des redirections massives sans comprendre les conséquences.

## Anti-patterns interdits

- promettre une position Google ;
- promettre une indexation ;
- inventer des backlinks ;
- acheter ou simuler des avis ;
- créer des pages locales fictives ;
- bourrer les pages de mots-clés ;
- générer des centaines de pages sans valeur uniquement pour le trafic ;
- masquer du contenu important aux utilisateurs ;
- utiliser des données structurées qui ne correspondent pas au contenu ;
- présenter une technique non documentée comme une exigence Google ;
- confondre trafic, indexation et classement.

## Sources de référence

Voir `references/google-search-guidance.md` pour la cartographie des recommandations utilisées dans cette skill.

@hopsyder
