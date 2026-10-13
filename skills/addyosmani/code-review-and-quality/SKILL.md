---
name: code-review-and-quality
description: Executes a rigorous 5-axis code review (correctness, security, performance, maintainability, tests).
metadata:
  author: addyosmani
  phase: REVIEW
  origin: https://github.com/addyosmani/agent-skills
---

# Code Review and Quality

## Overview
Perform structured multi-perspective code review before merging changes into main branch.

## Review Axes
1. **Correctness**: Does it meet the specification?
2. **Security**: Any vulnerabilities, secrets, or unsanitized inputs?
3. **Performance**: Algorithmic complexity, memory leaks, I/O bottlenecks?
4. **Maintainability**: Readability, naming, documentation?
5. **Testing**: Sufficient coverage of happy and error paths?
