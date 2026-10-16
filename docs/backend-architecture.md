<!--
  @author @hopsyder
  @organization Nexus Partners
  @description Architecture Backend Standard & Contrat Frontend-Backend par Défaut
  @created 2026-10-16
  @site nexus-partners.xyz
-->

# Architecture Backend Standard & Contrat Frontend-Backend par Défaut

> **Directive Absolue pour DEXTY et tous les Développeurs** :  
> Ce document est la **spécification maîtresse et l'architecture par défaut** pour concevoir, implémenter et interfacer un backend avec Dexty, quel que soit le projet ou le domaine métier.  
> Toute architecture logicielle de backend développée doit s'aligner rigoureusement sur ces principes, ce découpage modulaire, ce pipeline de validation séquentiel (*Fail-Fast*) et ce **contrat d'interface unifié Frontend-Backend**.

---

## 1. Principes Fondamentaux de l'Architecture

Toute application backend construite avec Dexty doit respecter 5 piliers cardinaux :

1. **Isolation et Reproductibilité Absolue (Zéro Friction d'Installation)** :
   - Encapsulation systématique dans des conteneurs légers (Docker / Docker Compose).
   - Les dépendances système, moteurs de base de données, extensions et runtimes sont standardisés et montés avec rechargement à chaud en développement.
2. **Modularité Étanche & Faible Couplage** :
   - Découpage strict par domaine et responsabilités (Core/Configuration, Métier/Entités, Pipeline de validation/Sécurité, Canaux/Intégrations).
   - Les vues/contrôleurs sont des passe-plats minces (*thin controllers*) : ils valident la requête, invoquent le service métier ou le pipeline, et retournent la réponse DTO.
3. **Pipeline Séquentiel Ordonné (*Fail-Fast*)** :
   - Traitement systématique des opérations en entonnoir : de la validation la moins coûteuse (format, jetons, mémoire, types) à la plus lourde (recherche BDD, hashing, services externes, IA, écritures transactionnelles).
   - Toute violation métier interrompt immédiatement la chaîne avec une exception explicite et un code d'erreur normalisé.
4. **Contrat d'Interface Frontend-Backend Strict & Typé** :
   - Schéma OpenAPI / Swagger synchronisé en temps réel (`drf-spectacular` ou équivalent).
   - Format d'erreur JSON unique et prévisible sur toute l'API.
   - Les modèles de données exposés au frontend sont des DTOs/serializers maîtrisés, garantissant le cloisonnement des données internes ou sensibles.
5. **Transactions Atomiques et Intégrité** :
   - Les écritures critiques sont protégées par transactions atomiques (`@transaction.atomic`). Aucune écriture partielle n'est tolérée en cas d'échec intermédiaire.

---

## 2. Vue Globale de l'Architecture & Flux de Données

```text
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           FRONTEND / CLIENTS UNIFIÉS                            │
│     Web App (Next.js / Vite)   │   Mobile App   │   Canaux / Webhooks tierces   │
└────────────────────────┬────────────────────────────────────────┬───────────────┘
                         │                                        │
           HTTPS REST / JSON / Multipart               Webhooks signés (HMAC)
                         │                                        │
┌────────────────────────▼────────────────────────────────────────▼───────────────┐
│                          API BACKEND STANDARDISÉE                               │
│                                                                                 │
│  ┌───────────────────────┐  ┌───────────────────────┐  ┌─────────────────────┐  │
│  │ config / core         │  │ domain / business     │  │ pipeline / engine   │  │
│  │ - Settings & Seuils   │  │ - Modèles & Entités   │  │ - Chaîne Fail-Fast  │  │
│  │ - Exception Handler   │  │ - Services (@atomic)  │  │ - Anti-fraude & Sec │  │
│  │ - OpenAPI / Swagger   │  │ - Serializers / DTOs  │  │ - Validateurs tiers │  │
│  │ - Correlation & Auth  │  │ - Idempotency Manager │  │ - Direct Upload Pres│  │
│  └───────────────────────┘  └───────────────────────┘  └─────────────────────┘  │
│                                                                                 │
└────────────────────────┬────────────────────────────────────────┬───────────────┘
                         │                                        │
             ORM / Connexion Poolée                       S3 / R2 Bucket
                         │                                        │
┌────────────────────────▼────────────────────┐  ┌────────────────▼───────────────┐
│        BASE DE DONNÉES & PERSISTANCE        │  │     STOCKAGE FICHIERS BLOB     │
│  - PostgreSQL (Index, Contraintes, Audit)   │  │  - Upload direct via Presigned │
│  - Redis (Cache, Sessions, Rate-Limit)      │  │  - MinIO en dev / S3-R2 en prd │
└─────────────────────────────────────────────┘  └────────────────────────────────┘
```

---

## 3. Structure Canonique du Répertoire Backend

Tout projet backend s'organise autour d'une arborescence normalisée et prévisible :

```text
backend/
├── config/                     # SOCLE TECHNIQUE, CONFIGURATION & SEUILS
│   ├── settings.py             # Configuration Django / Framework & source unique des seuils
│   ├── errors.py               # Handler d'exceptions uniformisé & classes d'erreurs (ApiError, Rejection)
│   ├── middleware.py           # Correlation ID (X-Request-ID), Auth, Normalisation
│   ├── urls.py                 # Routage principal et endpoints OpenAPI (/api/docs/, /api/schema/)
│   └── wsgi.py / asgi.py
│
├── core/                       # UTILITAIRES TRANSVERSAUX PARTAGÉS
│   ├── authentication.py       # Mécanismes Auth (Cookie HttpOnly JWT, Silent Refresh)
│   ├── pagination.py           # Stratégie standard de pagination (cursor / page-number)
│   ├── permissions.py          # Règles d'autorisation transversales (RBAC)
│   ├── idempotency.py          # Gestionnaire de clés d'idempotence (X-Idempotency-Key)
│   ├── storage.py              # Génération d'URLs pré-signées pour upload direct (S3 / R2 / MinIO)
│   └── utils.py                # Fonctions pures et sécurisées
│
├── <domaine_principal>/        # CŒUR MÉTIER (ex: orders, users, catalog, tickets...)
│   ├── models.py               # Modèles de données relationnels et contraintes
│   ├── serializers.py          # Contrats DTO d'entrée et de sortie JSON
│   ├── views.py                # Contrôleurs minces (délèguent aux services métier)
│   ├── services.py             # Logique applicative transactionnelle (@transaction.atomic)
│   ├── checks.py               # Validations unitaires d'entrée pour le domaine
│   ├── fixtures/               # Données de référence et amorçage
│   └── management/commands/    # Commandes CLI de maintenance et seed
│
├── verification/               # PIPELINE DE CONTRÔLE SÉQUENTIEL (Fail-Fast)
│   ├── pipeline.py             # Orchestrateur de la chaîne séquentielle ordonnée
│   ├── context.py              # DTO/Contexte transportant l'état à travers les étapes
│   └── steps/                  # Étapes isolées (validation intégrité, hashing, IA, détection doublons)
│
└── integrations/               # CANAUX EXTERNES & WEBHOOKS
    ├── webhooks.py             # Contrôleurs de réception sécurisés
    ├── signature.py            # Validation cryptographique des signatures (HMAC-SHA256)
    └── clients.py              # Clients d'appel tiers (mockable en dev/test)
```

---

## 4. Les Règles d'Or du Pipeline de Traitement (*Fail-Fast Pipeline*)

Pour toute opération critique (création de ressource, soumission de formulaire, transaction sensible), le backend doit exécuter un pipeline séquentiel ordonné :

```text
Requête Entrante (Payload JSON ou Confirmation d'Upload)
   │
   ▼
[Étape 1 : Validation de Session / Jeton]   ──► Jeton actif, non révoqué, dans sa fenêtre TTL ?
   │                                            Sinon : AUTH_EXPIRED (410) ou UNAUTHENTICATED (401)
   ▼
[Étape 2 : Idempotence de la Requête]       ──► En-tête X-Idempotency-Key déjà traité ?
   │                                            OUI  ──► Rejoue la réponse sauvegardée sans réexécuter
   ▼                                            NON  ──► Continue l'évaluation
[Étape 3 : Validation Format & Intégrité]   ──► Payload conforme au schéma DTO / Serializer ?
   │                                            Sinon : INVALID_INPUT (400) ou PAYLOAD_TOO_LARGE (413)
   ▼
[Étape 4 : Règles aux Limites / Seuils]     ──► Métriques dans les bornes autorisées ?
   │                                            Sinon : THRESHOLD_EXCEEDED (422) avec {current, max}
   ▼
[Étape 5 : Règles de Domaine Métier]        ──► Contraintes fonctionnelles satisfaites ?
   │                                            Sinon : BUSINESS_RULE_VIOLATION (422)
   ▼
[Étape 6 : Unicité & Détection Doublons]     ──► Empreinte ou hash déjà existant ?
   │                                            Sinon : DUPLICATE_SUBMISSION (409 ou 422)
   ▼
[Étape 7 : Enrichissement / Analyse Tiers]  ──► Validation IA, scoring de risque ou services externes
   │                                            Sinon : VERIFICATION_FAILED (422)
   ▼
[Étape 8 : Persistance Transactionnelle]    ──► Écriture en base dans un bloc @transaction.atomic
   │
   ▼
Réponse 201 Created / 200 OK (DTO normalisé + Correlation ID)
```

Chaque étape est une fonction pure prenant le contexte d'exécution. Si une étape échoue, elle lève une `Rejection(code, message, details)` qui est interceptée par le gestionnaire d'erreurs pour formater la réponse HTTP idoine.

---

## 5. Le Contrat Frontend-Backend

Le Frontend et le Backend forment un système couplé par un **contrat strict, prévisible et entièrement typé**.

### 5.1 Format Universel des Réponses d'Erreur

Aucune erreur non gérée ou trace brute ne doit fuiter. **Toutes** les erreurs de l'API suivent impérativement la structure suivante :

```json
{
  "error": {
    "code": "CODE_NORMALISE_EN_SCREAMING_SNAKE",
    "message": "Message explicatif lisible, compréhensible par le client.",
    "details": {
      "field_name": ["Détail spécifique au champ"],
      "expected": 50,
      "actual": 80
    },
    "correlation_id": "req_01HXYZ987ABC654321"
  }
}
```

### Table des Codes d'Erreurs Standards :
- `INVALID_INPUT` (400) : Données manquantes, mal formées ou non conformes au schéma.
- `UNAUTHENTICATED` (401) : Jeton absent, invalide ou session fermée.
- `FORBIDDEN` (403) : Permissions insuffisantes pour la ressource demandée.
- `NOT_FOUND` (404) : Ressource inexistante.
- `CONFLICT` / `ALREADY_EXISTS` (409) : Ressource en conflit (doublon, jeton déjà consommé).
- `EXPIRED` (410) : Session ou jeton expiré.
- `UNPROCESSABLE_ENTITY` (422) : Échec de validation métier ou pipeline (règles de domaine non respectées).
- `RATE_LIMITED` (429) : Trop de requêtes envoyées dans la fenêtre de temps.
- `SERVER_ERROR` (500) : Erreur interne masquée avec log côté serveur et identifiant d'incident (`correlation_id`).

---

### 5.2 Format Universel des Réponses de Succès

Les endpoints retournent des structures régulières :

- **Ressource Unitaire** :
```json
{
  "data": {
    "id": "uuid-v4",
    "attributes": { ... },
    "created_at": "2026-10-16T15:00:00Z"
  }
}
```
- **Listes Paginées** :
```json
{
  "data": [ ... ],
  "pagination": {
    "count": 142,
    "next": "/api/v1/items?page=3",
    "previous": "/api/v1/items?page=1",
    "total_pages": 8,
    "current_page": 2
  }
}
```

---

### 5.3 Protocole d'Authentification & Gestion des Sessions

Pour garantir une sécurité maximale contre les attaques XSS et CSRF tout en offrant une expérience utilisateur fluide :

1. **Stockage des Tokens** :
   - **Access Token** : Durée courte (15 minutes). Transmis au client soit via en-tête `Authorization: Bearer <token>`, soit via Cookie sécurisé `__Host-access_token; HttpOnly; Secure; SameSite=Strict`.
   - **Refresh Token** : Durée longue (7 jours). Strictement conservé dans un Cookie `__Host-refresh_token; HttpOnly; Secure; SameSite=Strict; Path=/api/v1/auth/refresh`.
2. **Mécanisme de Silent Refresh (Rafraîchissement Transparent)** :
   - Le client frontend configure un intercepteur HTTP (Axios / Fetch).
   - En cas de réponse `401` avec `code: "UNAUTHENTICATED"` ou `"TOKEN_EXPIRED"`, le client appelle immédiatement `POST /api/v1/auth/refresh`.
   - Si le refresh réussit, le nouveau token est appliqué et la requête originale en échec est rejouée de manière transparente pour l'utilisateur.
   - En cas d'échec du refresh, la session locale est nettoyée et l'utilisateur est redirigé vers l'écran de connexion.
3. **Payload Utilisateur Normalisé** :
   Le endpoint `GET /api/v1/auth/me` ou la réponse de login retourne un profil standardisé :
   ```json
   {
     "user": {
       "id": "usr_98a76b54",
       "email": "dev@nexus-partners.xyz",
       "role": "ADMIN",
       "permissions": ["reports:read", "reports:write", "users:manage"]
     }
   }
   ```

---

### 5.4 Téléversement de Fichiers Haut Débit (*Direct-to-Storage Presigned Uploads*)

Pour éviter de saturer les processus du serveur d'API avec des fichiers volumineux (photos, documents, vidéos) :

```text
1. Frontend ──► POST /api/v1/uploads/presign { filename, file_type, size_bytes } ──► Backend
2. Backend  ──► Génère URL signée S3/R2/MinIO (TTL 5 min) + token de validation  ──► Frontend
3. Frontend ──► PUT https://storage.nexus-partners.xyz/bucket/... (Binaire brut)  ──► Cloud Storage
4. Frontend ──► POST /api/v1/domain/create { ...data, file_token }               ──► Backend (Validation)
```

- En environnement **local/développement** : Utilisation d'un conteneur MinIO ou émulateur S3 local monté sur Docker.
- En environnement **production** : Cloudflare R2 ou AWS S3 avec politique CORS stricte autorisant uniquement les origines frontend officielles.

---

### 5.5 Consommation Frontend, Cache & Idempotence

1. **Génération Automatisée des Types (End-to-End Type Safety)** :
   - L'API expose le schéma complet sur `/api/schema/`.
   - Le frontend utilise `openapi-typescript` ou `@hey-api/openapi-ts` pour générer automatiquement l'ensemble des types TypeScript à chaque build ou mise à jour de schéma.
2. **Clés d'Idempotence (`X-Idempotency-Key`)** :
   - Pour toute opération non réentrante (paiement, validation finale, soumission de formulaire critique), le frontend génère un UUID v4 et l'envoie dans le header `X-Idempotency-Key`.
   - Le backend met en cache le résultat d'exécution pendant 24h. Tout ré-envoi accidentel (double-clic, micro-coupure réseau) renvoie la réponse d'origine sans rejouer les effets de bord.
3. **Stratégie de Cache Client (TanStack Query / SWR)** :
   - Nommage prévisible des Query Keys : `['<resource>', '<action>', params]`. Exemples : `['orders', 'detail', id]`, `['orders', 'list', filters]`.
   - Invalidation chirurgicale lors des mutations :
     ```typescript
     queryClient.invalidateQueries({ queryKey: ['orders', 'list'] });
     ```

---

### 5.6 Observabilité & Traçabilité (`X-Request-ID` & Correlation ID)

1. **Propagation du Correlation ID** :
   - Tout appel API peut comporter un en-tête `X-Request-ID`. S'il est absent, le middleware backend en génère un automatiquement (`req_<uuid>`).
   - Cet identifiant est injecté dans le contexte de logs backend et retourné dans les en-têtes de réponse : `X-Correlation-ID: req_01HXYZ987ABC654321`.
2. **Gestion des Crashs (500)** :
   - En cas d'erreur inattendue 500, la réponse JSON inclut `correlation_id`.
   - Le frontend affiche à l'utilisateur : *"Une erreur est survenue (Réf: req_01HXYZ...). Veuillez contacter le support."*
   - Les ingénieurs retrouvent instantanément la stack trace complète dans les logs serveur ou Sentry en filtrant par ce correlation ID.

---

## 6. Centralisation des Constantes et Seuils Métier

**Zéro valeur magique dans le code.** Tout seuil, quota, délai TTL ou limite de taille doit résider dans `config/settings.py` (ou équivalent de configuration d'environnement) avec des valeurs par défaut saines et surchargeables par variables d'environnement :

```python
# ==============================================================================
# SEUILS MÉTIER & CONTRAINTES SYSTÈME (Source unique de vérité)
# ==============================================================================
API_DEFAULT_PAGE_SIZE = env.int("API_DEFAULT_PAGE_SIZE", default=20)
API_MAX_PAGE_SIZE = env.int("API_MAX_PAGE_SIZE", default=100)

SESSION_ACCESS_TTL_MIN = env.int("SESSION_ACCESS_TTL_MIN", default=15)
SESSION_REFRESH_TTL_DAYS = env.int("SESSION_REFRESH_TTL_DAYS", default=7)

MAX_FILE_UPLOAD_MB = env.int("MAX_FILE_UPLOAD_MB", default=10)
ALLOWED_FILE_EXTENSIONS = ("jpg", "jpeg", "png", "webp", "pdf")

RATE_LIMIT_ANONYMOUS = env.str("RATE_LIMIT_ANONYMOUS", default="60/m")
RATE_LIMIT_AUTHENTICATED = env.str("RATE_LIMIT_AUTHENTICATED", default="300/m")
```

---

## 7. Environnement d'Exécution et Conteneurisation Standard

Le backend doit toujours être accompagné d'une configuration `docker-compose.yml` prête à l'emploi :

1. **Service `db`** :
   - Image PostgreSQL officielle à jour.
   - Volume persistant monté pour les données.
   - Contrôle d'état de santé (`healthcheck: pg_isready`).
2. **Service `web`** :
   - Dockerfile multi-stage ou optimisé (Python slim / Node alpine / Rust musl selon le stack projet).
   - Code monté en volume local avec rechargement à chaud (`hot-reload`) en développement.
   - Script d'entrée (`entrypoint.sh`) qui attend la base de données, applique automatiquement les migrations en attente et amorce les fixtures requises.
3. **Variables d'Environnement** :
   - Fichier `.env.example` exhaustif, documentant chaque clé requise.
   - Jamais de secret ou clé de production dans le code source.

---

## 8. Protocole de Test et Assurance Qualité

Aucune livraison backend n'est acceptée sans validation automatique :

1. **Couverture Minimale Exigée** :
   - Tout endpoint d'écriture doit disposer d'au minimum 2 tests :
     - **Cas Nominal** : Vérifie l'exécution complète, la transaction en base et le statut 200/201.
     - **Cas d'Échec** : Vérifie le rejet par le pipeline avec le code d'erreur HTTP exact et la structure JSON d'erreur.
2. **Isolation des Tests** :
   - Les tests s'exécutent sur une base de données de test éphémère ou réinitialisée à chaque exécution.
   - Les appels externes (APIs tierces, webhooks, passerelles de paiement, modèles IA) sont systématiquement bouchonnés (*mocked*).
3. **Commande d'Exécution** :
   ```bash
   # Lancer l'intégralité de la suite de tests
   docker compose exec web python manage.py test
   ```

---

## 9. Conclusion : Règle d'Adoption Permanente

À compter de cette version, Dexty applique cette architecture standardisée dès qu'un travail backend est requis. Chaque composant s'insère dans cette structure modulaire, garantissant une évolutivité immédiate, une maintenance aisée et une intégration fluide avec le frontend.
