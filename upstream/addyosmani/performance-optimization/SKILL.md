---
name: performance-optimization
description: Profiles bottlenecks and optimizes Core Web Vitals, API response latency, and database queries.
metadata:
  author: addyosmani
  phase: REVIEW
  origin: https://github.com/addyosmani/agent-skills
---

# Performance Optimization

## Overview
Measure first, optimize second. Target Core Web Vitals (LCP, INP, CLS) for frontend and P95 latency and query efficiency for backend.

## Workflow
1. Profile runtime with DevTools or telemetry traces.
2. Identify slow database queries, unbounded loops, or heavy JS bundles.
3. Implement caching, code-splitting, or query indexing.
4. Benchmark to confirm measurable speedup.
