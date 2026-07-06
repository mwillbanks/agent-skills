# Runtime Decision Matrix

| Workload shape | Default runtime | Validation focus |
|---|---|---|
| Request/response under latency budget | API server or function | Contract, auth, latency, error envelope |
| Bursty event processing | Serverless function | Timeout, retries, idempotency, DLQ |
| Continuous queue consumption | Container worker | Graceful shutdown, concurrency, health checks |
| Edge routing/header/cache logic | Edge worker/CDN function | Runtime limits, cache correctness, origin behavior |
| Multi-step durable process | Workflow engine | Compensation, replay, step visibility |
| Periodic scan/report | Scheduler plus job | Missed runs, overlap, checkpoints |
