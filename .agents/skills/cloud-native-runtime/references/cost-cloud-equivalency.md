# Cost and Cloud Equivalency Reference

Use this for managed cloud substitute analysis, service mapping, cost-risk comparison, and provider-neutral architecture decisions.

## Capability-First Mapping

Name the capability first, then provider examples:

| Capability | AWS example | Azure example | Google Cloud example | Common self-hosted equivalent |
|---|---|---|---|---|
| Object storage | S3 | Blob Storage | Cloud Storage | MinIO |
| CDN | CloudFront | Azure Front Door/CDN | Cloud CDN | Nginx/Varnish plus edge provider |
| Queue | SQS | Service Bus Queue | Pub/Sub | RabbitMQ/Redis streams |
| Scheduler | EventBridge Scheduler | Logic Apps/Functions timer | Cloud Scheduler | cron/Kubernetes CronJob |
| Serverless function | Lambda | Azure Functions | Cloud Functions/Cloud Run functions | Container worker |
| Workflow | Step Functions | Durable Functions | Workflows | Temporal/Camunda |
| Secrets | Secrets Manager/SSM | Key Vault | Secret Manager | Vault/SOPS |
| Observability | CloudWatch/X-Ray | Azure Monitor | Cloud Logging/Trace | OpenTelemetry plus Grafana stack |

## Replacement-Cost Comparison

When asked for managed substitute cost, compare:

- Provider service charges: requests, compute duration, storage, data transfer, retention.
- Required adjacent services: NAT, CDN, logging, secrets, queues, dashboards, backups.
- Engineering and operations: on-call, patching, backups, capacity, incident response.
- Migration and lock-in: SDK changes, data transfer, provider-specific config.
- Risk: downtime, compliance, security posture, recovery time.

Use current provider pricing docs for numeric estimates. Do not rely on static prices in this skill.

## Decision Guidance

- Prefer managed services when operational burden and reliability risk dominate.
- Prefer portable/self-hosted components when requirements demand provider independence, custom control, or predictable always-on cost.
- Avoid false equivalence: two services with similar names may differ in consistency, retry semantics, identity, networking, limits, and observability.
