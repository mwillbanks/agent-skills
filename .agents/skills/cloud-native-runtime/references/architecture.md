# Architecture Reference

Use this reference for cloud-native architecture planning, implementation, or review.

## Source-of-Truth Trace

Before deciding architecture, trace:

1. Product requirement or defect being solved.
2. Existing runtime path: route, worker, queue, function, scheduler, storage, CDN, or infra module.
3. Ownership boundary: application package, infra package, deployment workflow, generated SDK, or external service.
4. Persistence path and data model.
5. Auth, tenancy, and privilege boundary.
6. Operational owner: logs, dashboards, alerts, runbooks, deploy rollback.

If any path is only described in docs, verify it in code, configuration, tests, or live environment evidence before treating it as true.

## Architecture Decisions

Prefer managed runtime or service primitives when they reduce operational burden without weakening control, observability, portability, compliance, or cost predictability. Prefer application-owned code when the domain requires custom behavior, low latency, tight transactional control, or provider constraints make managed services misleading.

Decision criteria:

- Failure isolation: what fails independently?
- Scaling unit: request, tenant, event, object, job, shard, region.
- State ownership: stateless, per-entity state, shared database, object store, event log.
- Consistency: strong, eventual, idempotent replay, compensating action.
- Latency: synchronous request budget versus async completion.
- Operability: alerts, dashboards, retries, replay, rollback.
- Security: least privilege, network boundary, tenant isolation, audit trail.
- Cost: steady-state, burst, egress, storage, retries, observability, engineering time.

## Anti-Patterns

- Adding a new runtime surface without tracing the existing deployment and ownership path.
- Moving logic into infrastructure code because it is easier than fixing the application boundary.
- Creating fake production resources, placeholder secrets, or no-op wiring to satisfy a plan.
- Treating cloud provider service names as architecture. Name the capability and then choose a service.
- Replacing a simple synchronous path with async processing without defining completion, retry, and observability contracts.
- Adding a shared abstraction before proving two implementations share stable semantics.

## Review Prompts

Ask these before approving architecture:

- What source of truth proves this is the active runtime path?
- What breaks if the downstream service is slow, unavailable, or returns partial success?
- What data can be duplicated, reordered, delayed, or lost?
- What alert tells an operator the system is unhealthy?
- What is the rollback path?
