# Resilience and Idempotency Reference

Use this for retries, timeouts, duplicate suppression, transactions, compensation, and backpressure.

## Required Decisions

- Timeout per external call and total operation.
- Retryable versus terminal errors.
- Backoff and jitter.
- Idempotency key and storage.
- Transaction boundary.
- Compensation or reconciliation process.
- Backpressure behavior when downstream is slow.
- Replay behavior for jobs and events.

## Idempotency Patterns

- Client-provided idempotency key for create-like APIs.
- Deterministic event ID or object key for queue/event processing.
- Unique database constraint plus conflict-safe upsert.
- State machine with monotonic transitions.
- Outbox/inbox table for cross-system publish/consume reliability.

## Anti-Patterns

- Blind retries around non-idempotent side effects.
- Infinite retries without dead-letter or operator visibility.
- Assuming provider retries preserve order.
- Treating a 200 response as durable completion when downstream side effects are async.
