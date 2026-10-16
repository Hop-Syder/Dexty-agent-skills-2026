---
name: deprecation-and-migration
description: Manages safe retirement of legacy code, schemas, and API endpoints with zero disruption.
metadata:
  author: addyosmani
  phase: SHIP
  origin: https://github.com/addyosmani/agent-skills
---

# Deprecation and Migration

## Overview
Retire outdated features, APIs, and database schemas gracefully without breaking existing consumers.

## Workflow
1. Add deprecation warnings with migration guides.
2. Monitor usage telemetry to confirm drop in traffic.
3. Execute phased sunset and safely remove deprecated code.
