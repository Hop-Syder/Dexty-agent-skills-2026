---
name: subagent-driven-development
description: Executes development plans by dispatching fresh, isolated sub-agents with strict quality review gates.
metadata:
  author: obra
  framework: superpowers
  origin: https://github.com/obra/superpowers
---

# Subagent-Driven Development

## Overview
Orchestrate complex engineering workflows by breaking plans into tasks, assigning each task to a dedicated, fresh sub-agent, and requiring an independent task reviewer sign-off before closing each task.

## The Loop
1. Master agent loads plan.
2. Master agent dispatches an Implementer sub-agent for Task N.
3. Implementer completes code and tests.
4. Master agent dispatches Reviewer sub-agent to verify spec compliance and code quality.
5. If issues found, enter fix loop until approved.
6. Advance to Task N+1.
