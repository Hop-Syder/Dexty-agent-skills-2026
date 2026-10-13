#!/usr/bin/env bash
# skills-check.sh — Délégateur racine vers tools/skills-check.sh (chaîne d'exécution unique, AUD-012)
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/tools/skills-check.sh" "$@"
