---
name: observability-and-instrumentation
description: Instruments application with structured logs, metrics, OpenTelemetry traces, and healthchecks.
metadata:
  author: addyosmani
  phase: SHIP
  origin: https://github.com/addyosmani/agent-skills
---

# Observability and Instrumentation

## Overview
Build deep system visibility through OpenTelemetry, structured JSON logging, Prometheus metrics, and automated alerting.

## Workflow
1. Add structured logging with correlation IDs.
2. Expose `/health` and `/ready` endpoints.
3. Instrument key user transactions with latency traces.
4. Establish alerting thresholds for error rates and latency spikes.
