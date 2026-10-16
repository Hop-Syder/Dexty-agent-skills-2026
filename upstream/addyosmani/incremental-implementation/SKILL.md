---
name: incremental-implementation
description: Implements features one atomic step at a time with test verification at every checkpoint.
metadata:
  author: addyosmani
  phase: BUILD
  origin: https://github.com/addyosmani/agent-skills
---

# Incremental Implementation

## Overview
Build software in small, verifiable increments. Never make sprawling cross-cutting edits without intermediate testing checkpoints.

## Workflow
1. Pick one task from the plan.
2. Write minimal code to fulfill the contract.
3. Run tests immediately.
4. Commit when green before moving to the next task.
