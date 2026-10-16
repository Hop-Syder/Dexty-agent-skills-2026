---
name: security-and-hardening
description: Hardens application against OWASP vulnerabilities, audits dependencies, and secures configuration.
metadata:
  author: addyosmani
  phase: REVIEW
  origin: https://github.com/addyosmani/agent-skills
---

# Security and Hardening

## Overview
Protect web applications by enforcing security headers (CSP, CORS, HSTS), validating all user input, auditing dependencies, and scrubbing secrets.

## Workflow
1. Scan code for hardcoded API keys, tokens, and passwords.
2. Validate and sanitize inputs with Zod/schema validators.
3. Check third-party packages with vulnerability scanners (`npm audit`, `skillspector`).
4. Ensure least-privilege principles for cloud/database roles.
