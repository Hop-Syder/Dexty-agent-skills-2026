---
name: using-agent-skills
description: Meta-skill router that routes incoming developer tasks to the appropriate skill across the SDLC.
metadata:
  author: addyosmani
  phase: META
  origin: https://github.com/addyosmani/agent-skills
---

# Using Agent Skills (Router)

## Overview
Meta-skill and central switchboard. Analyzes user prompts and automatically routes execution to the best-suited specialized skill in the catalog.

## Routing Logic
- Idea / Scope -> `idea-refine`, `interview-me`
- New Feature / PRD -> `spec-driven-development`
- Task breakdown -> `planning-and-task-breakdown`
- Implementation -> `incremental-implementation`, `frontend-ui-engineering`
- Testing -> `test-driven-development`, `browser-testing-with-devtools`
- Review / Security -> `code-review-and-quality`, `security-and-hardening`
- Deployment -> `ci-cd-and-automation`, `shipping-and-launch`
