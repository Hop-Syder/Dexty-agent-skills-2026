---
name: dispatching-parallel-agents
description: Dispatches multiple parallel sub-agents for independent tasks and merges results cleanly.
metadata:
  author: obra
  framework: superpowers
  origin: https://github.com/obra/superpowers
---

# Dispatching Parallel Agents

## Overview
Accelerate execution when tasks are decoupled. Dispatch multiple concurrent sub-agents simultaneously, each in their own workspace, and merge validated outputs.

## Workflow
1. Confirm zero shared state or dependency between tasks.
2. Spawn concurrent worker agents with strict boundaries.
3. Collect, inspect, and reconcile results before final commit.
