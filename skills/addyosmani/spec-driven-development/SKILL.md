---
name: spec-driven-development
description: Creates specs before coding. Use when starting a new project, feature, or significant change and no specification exists yet. Use when drafting a PRD or requirements document.
metadata:
  author: addyosmani
  phase: DEFINE
  origin: https://github.com/addyosmani/agent-skills
---

# Spec-Driven Development

## Overview
Write a structured specification before writing any code. The spec is the shared source of truth between the engineer and the agent — defining objectives, tech stack, executable commands, boundary conditions, and acceptance criteria. Code without a spec is guessing.

## The Gated Workflow
1. **Scope Check** — Decompose into a capability map if multiple independent capabilities are bundled.
2. **Specify** — Document objectives, commands, structure, code style, testing strategy, boundaries (Always, Ask first, Never).
3. **Plan** — Map components, dependencies, risks, and verification gates.
4. **Tasks** — Slice into atomic, testable tasks.
5. **Implement** — Execute one task at a time with incremental verification.

## Rationalizations & Red Flags
- *"This is simple, I don't need a spec"* -> Even small tasks require clear acceptance criteria.
- *"I'll write the spec after I code it"* -> That is documentation, not specification.
- *Red Flag:* Writing code before requirements are committed to file.
