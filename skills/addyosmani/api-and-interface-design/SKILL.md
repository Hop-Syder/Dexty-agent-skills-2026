---
name: api-and-interface-design
description: Designs strict, typed, and backwards-compatible API contracts before implementation.
metadata:
  author: addyosmani
  phase: BUILD
  origin: https://github.com/addyosmani/agent-skills
---

# API and Interface Design

## Overview
Design contract-first interfaces (TypeScript types, OpenAPI, Zod schemas, GraphQL schemas) ensuring strict typing and predictable error envelopes.

## Workflow
1. Model domain entities and request/response payloads.
2. Define deterministic error structures (code, message, details).
3. Validate schemas before writing controller or handler logic.
