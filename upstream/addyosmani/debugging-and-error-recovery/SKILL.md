---
name: debugging-and-error-recovery
description: Systematically diagnoses errors, isolates root causes, and safely recovers without introducing regressions.
metadata:
  author: addyosmani
  phase: VERIFY
  origin: https://github.com/addyosmani/agent-skills
---

# Debugging and Error Recovery

## Overview
Methodically diagnose unexpected runtime failures using evidence and logs rather than guesswork and trial-and-error modifications.

## Workflow
1. Reproduce error reliably with minimal reproduction case.
2. Trace stack trace and inspect environment state.
3. Formulate falsifiable hypothesis.
4. Implement targeted fix and verify regression test passes.
