---
name: context-engineering
description: Optimizes context window and memory by loading only relevant files, specs, and interfaces for the active task.
metadata:
  author: addyosmani
  phase: PLAN
  origin: https://github.com/addyosmani/agent-skills
---

# Context Engineering

## Overview
Manage the LLM/agent context budget deliberately. Prevent hallucinations and degraded reasoning by avoiding context pollution.

## Workflow
1. Load only pertinent interface definitions and task-specific specs.
2. Prune obsolete historical turn data.
3. Keep tokens focused on active file changes.
