---
name: shipping-and-launch
description: Orchestrates production launch with pre-flight checks, feature flags, and smoke tests.
metadata:
  author: addyosmani
  phase: SHIP
  origin: https://github.com/addyosmani/agent-skills
---

# Shipping and Launch

## Overview
Ensure safe and reliable production releases with zero downtime. Execute comprehensive pre-flight checklists before flipping production traffic.

## Workflow
1. Verify CI status and database migration safety.
2. Run smoke tests in staging environment.
3. Roll out gradually via canary deployment or feature flags.
4. Verify production telemetry post-launch.
