# Runtime Selection Reference

Use this when choosing between API servers, serverless functions, containers, edge workers, batch jobs, and long-running workers.

## Selection Criteria

| Runtime | Use When | Avoid When |
|---|---|---|
| API server | Low-latency request/response, shared routing, stable process model | Work exceeds request budget or needs independent retries |
| Lambda/serverless function | Event-driven, bursty, isolated tasks, provider-managed scaling | Cold start, timeout, package size, VPC, or concurrency limits dominate |
| Container service | Long-running service, custom runtime, predictable traffic, background workers | Team cannot operate deployment, scaling, and health checks |
| Edge worker | CDN-adjacent auth, redirects, header logic, lightweight personalization | Needs private network access, heavy CPU, large dependencies, strong consistency |
| Batch job | Bounded offline processing, backfills, reports | User-facing completion or continuous queue handling is required |
| Workflow orchestrator | Multi-step durable process with retries and compensation | Simple single-step job or tightly transactional database update |

## Implementation Guidance

- Preserve repository runtime conventions unless a real requirement forces change.
- Define timeout, concurrency, memory, retry, and idempotency expectations.
- Add health or readiness checks for long-running services.
- For serverless functions, verify package size, cold start, IAM, VPC, and timeout constraints from current provider docs.
- For containers, verify signal handling, graceful shutdown, readiness, autoscaling, and log routing.
- For edge runtimes, verify unsupported APIs and provider-specific limits before committing.

## Decision Output

When making a runtime decision, record:

- Chosen runtime and alternatives rejected.
- Workload shape.
- State and consistency needs.
- Failure and retry model.
- Observability requirements.
- Validation command or test proving the active path.
