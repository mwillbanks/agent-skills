# Scheduling Reference

Use this for cron jobs, EventBridge-like schedules, scheduled workers, timers, and recurring background work.

## Design Checklist

- Define schedule expression, time zone, and daylight-saving behavior.
- Define missed-run behavior: skip, catch up, replay, or compensate.
- Add overlap protection for long-running jobs.
- Add idempotency for reruns.
- Add observability for start, finish, duration, failure, skipped, and late runs.
- Store checkpoints when scanning mutable data.
- Keep schedule definitions in the source-of-truth infrastructure or runtime config layer.

## Implementation Guidance

- Prefer managed schedulers when they provide reliability, auditability, and IAM integration.
- Keep job logic testable separately from the scheduler trigger.
- Validate schedule syntax with provider or framework tooling when available.
- If a job changes data, test partial failure and rerun behavior.

## Anti-Patterns

- Local process timers for production-critical schedules unless the runtime guarantees singleton behavior.
- Hidden schedules configured only through a console.
- No alert for missed or failing runs.
- Assuming all cron expressions use the same day-of-week or time-zone semantics.
