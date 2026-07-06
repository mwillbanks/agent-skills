# Cloud Mapping Matrix

| Need | AWS | Azure | Google Cloud | Portable/self-hosted |
|---|---|---|---|---|
| Object storage | S3 | Blob Storage | Cloud Storage | MinIO |
| CDN | CloudFront | Front Door/CDN | Cloud CDN | Nginx/Varnish plus CDN |
| Queue | SQS | Service Bus | Pub/Sub | RabbitMQ/Redis streams |
| Scheduler | EventBridge Scheduler | Functions timer/Logic Apps | Cloud Scheduler | cron/Kubernetes CronJob |
| Function | Lambda | Azure Functions | Cloud Functions | Container worker |
| Workflow | Step Functions | Durable Functions | Workflows | Temporal/Camunda |
| Secrets | Secrets Manager/SSM | Key Vault | Secret Manager | Vault/SOPS |
| Observability | CloudWatch/X-Ray | Azure Monitor | Cloud Logging/Trace | OpenTelemetry stack |

Verify current prices, limits, regions, and semantics before making numeric claims.
