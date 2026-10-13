<!--
  SOURCES.md — Dépôts sources vérifiés (Desty 3.5)
  Nexus Partners · Cotonou, Bénin
  Créateur: @hopsyder (https://github.com/Hop-Syder)
-->

# Dépôts sources (vérifiés)

Vérification effectuée le **13 octobre 2026** par recherche web directe
(existence du dépôt, étoiles, forks, contenu réel des skills). Aucun dépôt
n'est retenu sur la seule foi d'une suggestion — chacun ci-dessous a été
confirmé.

## ✅ Dépôts confirmés et utilisés

| Code | Dépôt | Ce que c'est | Popularité (≈) | Pourquoi retenu |
|------|-------|--------------|----------------|-----------------|
| **AO** | [`addyosmani/agent-skills`](https://github.com/addyosmani/agent-skills) | 25 skills « production-grade » couvrant tout le cycle DEFINE→PLAN→BUILD→VERIFY→REVIEW→SHIP | ~68k ★ (trending) | Colonne vertébrale : couvre PM, build, test, sécurité, CI/CD, ship |
| **AN** | [`anthropics/skills`](https://github.com/anthropics/skills) | Registre officiel Anthropic (skills exemples + spec SKILL.md) | ~128k ★ / ~15k forks | Référence du format ; skills design/doc/test |
| **SP** | [`obra/superpowers`](https://github.com/obra/superpowers) | Framework de développement piloté par sous-agents (Jesse Vincent) | Très populaire | Orchestration multi-agents, TDD, debug, revue |
| **TOB** | [`trailofbits/skills`](https://github.com/trailofbits/skills) | Skills de sécurité par Trail of Bits (audit, threat model) | ~5k ★ / ~436 forks | Pilier de l'agent Sécurité |
| **VL** | [`vercel-labs/agent-skills`](https://github.com/vercel-labs/agent-skills) | Skills Vercel (React, déploiement, composition) | Officiel Vercel | Front JS + déploiement |
| **NV** | [`NVIDIA/SkillSpector`](https://github.com/NVIDIA/SkillSpector) | **Outil** : scanner de sécurité de skills (0–100) | ~991 ★ | Garde-fou CI (voir note ci-dessous) |

### Sources complémentaires repérées (non centrales, disponibles au besoin)
- [`openai/skills`](https://github.com/openai/skills) — catalogue officiel OpenAI/Codex (ex. `gh-fix-ci`, `security-threat-model`).
- [`supabase/agent-skills`](https://github.com/supabase/agent-skills) — `postgres-best-practices` (utile si backend Supabase).
- [`ghostsecurity/skills`](https://github.com/ghostsecurity/skills) — tests de sécurité applicative.
- [`morluto/rea`](https://github.com/morluto/rea) — « Reverse Engineer Anything » (niche, non retenu pour build/test/prod).

---

## Note sur SkillSpector et la sécurité de la chaîne

En 2026, des études (NVIDIA, Snyk) montrent qu'une part importante des skills
publics contiennent des vulnérabilités, et qu'une minorité est franchement
malveillante (exfiltration de secrets, injection de prompt). **Tout skill
tiers adopté dans ce registre doit passer `skillspector scan` avant usage.**
C'est le rôle du sous-agent « Supply-chain gate » de l'agent Sécurité.
