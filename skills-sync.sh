#!/usr/bin/env bash
# skills-sync.sh — Délégateur racine vers tools/skills-sync.sh (chaîne d'exécution unique, AUD-012)
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/tools/skills-sync.sh" "$@"
