# Review Checklist Reference

Use this for architecture and code review of cloud-native runtime changes.

## Review Order

1. Identify changed runtime surfaces.
2. Trace source-of-truth route from request/event/schedule to persistence and infra.
3. Check architecture boundary and ownership.
4. Check security and tenancy.
5. Check resilience and idempotency.
6. Check observability and operability.
7. Check cost and scaling risks.
8. Check validation coverage.
9. Report findings by severity with file and line evidence when available.

## Required Review Questions

- Is this the active runtime path?
- Does the change preserve existing public contracts unless intentionally changed?
- Are user-controlled inputs validated at the boundary?
- Is authorization scoped to the resource, tenant, or domain?
- Are external calls bounded by timeout and retry policy?
- Are side effects idempotent or transactionally safe?
- Are logs, metrics, traces, and alerts sufficient for rollout?
- Does IaC match app behavior and environment conventions?
- Are tests proving the changed behavior rather than only mocking it away?

## Severity Hints

- P0: likely production outage, data loss, privilege escalation, public secret exposure.
- P1: serious security flaw, broken deploy path, data corruption risk, unbounded production cost.
- P2: runtime correctness bug, missing authz, weak idempotency, missing critical observability.
- P3: maintainability, incomplete validation, unclear ownership, moderate operational risk.
- P4/P5: polish, documentation clarity, minor consistency.
