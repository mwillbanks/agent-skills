# Observability Reference

Use this for logs, metrics, traces, alerting, dashboards, and runtime diagnostics.

## Minimum Runtime Signals

For every cloud runtime change, identify:

- Logs: structured fields, correlation ID, tenant/account ID where safe, event/job/request ID, error class.
- Metrics: request count, latency, error count, saturation, queue depth, retry count, duration, cost-sensitive volume.
- Traces: inbound request, downstream calls, queue publish/consume, background job spans.
- Alerts: symptom-based, routed to owner, with runbook or immediate next step.
- Dashboards: enough to inspect health during rollout.

## Implementation Guidance

- Use repository observability libraries and conventions first.
- Do not log secrets, tokens, raw PII, private object keys, or full provider credentials.
- Preserve correlation across async boundaries by passing request/event IDs.
- Alert on user impact and durable backlog, not only process crashes.
- Add log sampling only after confirming incidents remain diagnosable.

## Review Questions

- How would an operator know this path is failing?
- What dimensions isolate tenant, route, queue, provider, and runtime?
- Can one request be traced across API, queue, worker, and storage?
- Are dashboards or alerts updated with the new failure modes?
