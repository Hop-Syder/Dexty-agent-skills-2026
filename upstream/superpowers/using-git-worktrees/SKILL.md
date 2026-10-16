---
name: using-git-worktrees
description: Uses Git worktrees to isolate agent workspaces and run concurrent branches without repository conflicts.
metadata:
  author: obra
  framework: superpowers
  origin: https://github.com/obra/superpowers
---

# Using Git Worktrees

## Overview
Leverage `git worktree` to allow multiple agents or tasks to operate on distinct branches simultaneously in separate directories without switching HEAD in the main repo.
