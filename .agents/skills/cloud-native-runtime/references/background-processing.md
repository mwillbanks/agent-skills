# Background Processing Reference

Use this for queues, workers, async jobs, fanout, workflow engines, and sync-to-async migrations.

## Core Contracts

Define these before implementation:

- Producer: who enqueues and with what schema.
- Consumer: who owns processing and deployment.
- Delivery semantics: at-most-once, at-least-once, exactly-once illusion through idempotency.
- Retry policy: delay, max attempts, backoff, jitter.
- Dead-letter handling: where poison messages go and who is alerted.
- Idempotency key: how duplicates are detected.
- Ordering: required, best-effort, partitioned, or irrelevant.
- Completion signal: callback, status row, event, notification, or no user-visible completion.

## Implementation Guidance

- Make handlers idempotent before enabling retries.
- Persist job state when users or operators need visibility.
- Log event IDs, job IDs, tenant IDs, and correlation IDs.
- Bound concurrency and downstream calls.
- Design replay and backfill behavior intentionally.
- Validate schema compatibility for producer and consumer deploy order.

## Anti-Patterns

- Moving slow request work to a queue without adding user-visible status.
- Retrying non-idempotent side effects.
- Treating a dead-letter queue as observability.
- Letting one poison message block an ordered queue indefinitely.
