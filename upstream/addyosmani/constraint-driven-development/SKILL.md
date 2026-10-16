---
name: constraint-driven-development
description: Enforces strict technical, operational, and performance constraints throughout design and implementation.
metadata:
  author: addyosmani
  phase: PLAN
  origin: https://github.com/addyosmani/agent-skills
---

# Constraint-Driven Development

## Overview
Anchor engineering decisions in explicit hard constraints (memory budgets, latency limits, browser support, bundle size limits, compliance rules).

## Workflow
1. Enumerate non-negotiable boundaries.
2. Validate technical choices against budget thresholds.
3. Fail builds if hard constraints are violated.
