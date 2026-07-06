# Security and Secrets Reference

Use this for auth, authorization, IAM, secrets, encryption, input validation, audit, and production hardening.

## Security Checklist

- Authenticate before reading or mutating protected data.
- Authorize by tenant/account/domain/resource, not only by user login.
- Validate all user-controlled input at the trusted boundary.
- Scope IAM permissions to required resources and actions.
- Store secrets in managed secret stores or encrypted config.
- Rotate or version secrets through established process, not ad hoc file edits.
- Encrypt sensitive data in transit and at rest according to repository and compliance requirements.
- Log security-relevant events without exposing sensitive values.
- Treat webhooks, uploads, queue messages, and scheduled job inputs as untrusted.

## Least Privilege

For every new cloud permission, record:

- Principal receiving permission.
- Resource scope.
- Allowed action list.
- Reason each action is needed.
- Validation proving the runtime uses that principal.

## Anti-Patterns

- Wildcard permissions without a documented provider limitation.
- Putting secrets in regular environment variables when the repo uses secret config.
- Disabling auth or validation to make local tests pass.
- Trusting object storage events or queue messages without schema validation.
