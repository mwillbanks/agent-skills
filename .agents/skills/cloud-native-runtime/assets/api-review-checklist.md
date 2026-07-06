# API Review Checklist

- [ ] Route and method follow existing conventions.
- [ ] Request validation rejects malformed and unauthorized input.
- [ ] Authz checks resource, tenant, or domain access.
- [ ] Error envelope is stable and non-leaky.
- [ ] Pagination and filters are bounded.
- [ ] Idempotency exists for retryable mutations.
- [ ] Logs include request/correlation ID.
- [ ] Tests cover success, validation failure, auth failure, and persistence behavior.
