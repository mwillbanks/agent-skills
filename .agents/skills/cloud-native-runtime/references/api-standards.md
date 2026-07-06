# API Standards Reference

Use this for REST, RPC, webhook, GraphQL, or internal API implementation and review.

## Contract Checklist

- Route and method match existing API conventions.
- Request schema validates all user-controlled inputs at the boundary.
- Response schema is stable and documented in tests or generated clients when applicable.
- Error envelope is consistent and does not leak internals.
- Authn and authz are enforced before data access or side effects.
- Tenant, account, organization, or domain scoping is explicit.
- Pagination, filtering, sorting, and limits have bounded defaults.
- Idempotency is defined for create, upload, webhook, and retryable operations.
- Correlation/request IDs appear in logs and error responses when repository conventions allow.

## Validation Pattern

For API changes, prefer tests at the narrowest meaningful layer:

1. Schema or handler unit tests for validation and edge cases.
2. Route integration tests for auth, persistence, and error envelopes.
3. Contract or generated client validation when SDKs exist.
4. Runtime smoke test only when repository tooling supports it safely.

## Anti-Patterns

- Trusting frontend validation as backend validation.
- Returning provider SDK errors directly to clients.
- Adding a new error shape for one route.
- Skipping authz because authn already exists.
- Accepting unbounded arrays, file sizes, filters, or page sizes.
- Writing tests only for happy paths.
