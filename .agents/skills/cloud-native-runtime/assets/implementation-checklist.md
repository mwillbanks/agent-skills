# Implementation Checklist

- [ ] Identify active runtime path and owning package.
- [ ] Load relevant references from `references/`.
- [ ] Trace auth, tenancy, persistence, infrastructure, and deployment path.
- [ ] Design failure, retry, idempotency, and observability behavior before editing.
- [ ] Implement in the correct architectural layer.
- [ ] Add or update tests for success, validation failure, authorization, and retry/failure paths.
- [ ] Run repository-native format, typecheck, lint, tests, and skill-specific validation.
- [ ] Review final diff for security, compatibility, cost, and operational behavior.
