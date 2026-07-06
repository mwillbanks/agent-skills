---
name: cloud-native-runtime
description: >-
  Use when implementing, reviewing, or hardening cloud-native backend/runtime work: APIs, Lambda/serverless functions, background workers, Pulumi or IaC, EventBridge or scheduled jobs, S3/object-storage file uploads, media processing, CloudFront/CDN, networking, caching, secrets, observability, production deployment, architecture review, resilience, or cloud-service equivalency. Do not use for UI-only React/CSS/design/copywriting/blog/README-only tasks unless they change runtime, infrastructure, deployment, security, or observability behavior.
license: Apache-2.0
metadata:
  author: Mike Willbanks
  repository: https://github.com/mwillbanks/agent-skills
  homepage: https://github.com/mwillbanks/agent-skills
  bugs: https://github.com/mwillbanks/agent-skills/issues
  purpose: Cloud-native runtime implementation and review guidance for autonomous coding agents
---

# Cloud Native Runtime

Use this skill for implementation, review, remediation, or readiness work that changes cloud-native backend/runtime behavior: APIs, serverless functions, workers, schedules, queues, object storage, uploads, media processing, CDN/cache behavior, infrastructure-as-code, secrets, security, observability, deployment, resilience, or cloud-service equivalency.

Do not use this skill for UI-only styling, copywriting, README-only edits, or design-only work unless the task also changes runtime, infrastructure, deployment, security, or observability behavior.

## Core Workflow

1. Classify the task surface.
2. Load only the relevant reference files from the routing table below.
3. Trace the source of truth before planning or editing:
   - active code path
   - infrastructure path
   - persistence path
   - auth and tenant boundary
   - deployment and validation path
4. Make the smallest architecture-correct change in the owning layer.
5. Validate the changed behavior with repository-native commands.
6. Before completion, review security, observability, resilience, cost, and compatibility impact.

## Reference Routing

| Task surface | Read these files |
|---|---|
| Architecture planning or review | `references/architecture.md`, `references/review-checklist.md` |
| Runtime choice, Lambda, serverless, containers, edge | `references/runtime-selection.md`, `assets/runtime-decision-matrix.md` |
| API implementation or API review | `references/api-standards.md`, `assets/api-review-checklist.md` |
| Pulumi, Terraform, CDK, deployment config | `references/infrastructure.md`, `assets/infrastructure-review-checklist.md` |
| Background worker, queue, async processing | `references/background-processing.md`, `references/resilience-idempotency.md`, `assets/async-decision-matrix.md` |
| EventBridge, cron, scheduler, recurring job | `references/scheduling.md`, `references/background-processing.md` |
| S3/object storage, uploads, media resizing | `references/file-uploads-media.md`, `references/security-secrets.md`, `references/observability.md` |
| CloudFront/CDN, networking, cache, CORS | `references/networking-caching.md`, `assets/cloud-mapping-matrix.md` |
| Logs, metrics, traces, alerts | `references/observability.md`, `assets/observability-checklist.md` |
| IAM, secrets, auth, security hardening | `references/security-secrets.md`, `assets/security-checklist.md` |
| Retries, timeouts, duplicate suppression | `references/resilience-idempotency.md` |
| Managed service replacement or cost comparison | `references/cost-cloud-equivalency.md`, `assets/cloud-mapping-matrix.md` |
| Release or production readiness | `references/production-readiness.md`, `assets/production-readiness-checklist.md` |

When multiple rows apply, read the minimal set that covers the changed behavior. Do not load every reference by default.

## High-Value Gotchas

- Verify volatile provider facts from current provider docs before citing limits, prices, regions, API fields, IAM semantics, or service quotas.
- AWS service names in prompts are often examples of capabilities. Keep the architecture cloud-agnostic unless the repository or user explicitly commits to a provider.
- Infrastructure code should not absorb application domain logic. Application code should not hide resource topology or IAM assumptions.
- Async processing is not complete until idempotency, retries, dead-letter behavior, status visibility, and observability are defined.
- A successful deploy command is not production readiness. Readiness needs runtime, security, observability, rollback, and validation evidence.
- Do not add fake production resources, placeholder secrets, wildcard IAM, public buckets, or no-op wiring to make a plan look complete.

## Implementation Checklist

Load `assets/implementation-checklist.md` when starting a nontrivial implementation.

For small review-only tasks, use `references/review-checklist.md` instead.

## Expected Output Patterns

For implementation work, include in the final reasoning or commit notes:

- source-of-truth path inspected
- references used
- runtime or architecture decision made
- validation commands run
- residual risk, if any

For review or readiness work, produce findings first, ordered by severity, with file/line evidence when available. For readiness, give a clear GO or NO GO verdict.

## Package Validation

When editing this skill, run:

```bash
bash .agents/skills/cloud-native-runtime/scripts/validate-package.sh .agents/skills/cloud-native-runtime
```

Then run the repository validation commands from the repository root.
