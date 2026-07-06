# Production Readiness Reference

Use this before deployment, launch, release readiness, or GO/NO GO decisions.

## Readiness Gates

- Requirements satisfied with code or configuration evidence.
- Runtime path verified against repository source of truth.
- Infrastructure plan reviewed for replacements, deletes, exposure, and IAM broadening.
- Secrets and environment config present through approved mechanisms.
- Database migrations or storage changes have rollback or recovery plan.
- Observability and alerts cover new failure modes.
- Load, concurrency, and retry behavior are bounded.
- Security review is complete for public, privileged, or multi-tenant surfaces.
- Tests and validation commands pass or unrelated baseline failures are documented.
- Rollback plan is executable.

## GO/NO GO Guidance

Use GO only when all required gates pass and no known task-related defect remains.
Use NO GO when any required runtime, security, data, infra, or validation gate is missing or failing.
Use BLOCKED only when completion requires unavailable credentials, permissions, tools, services, or a product decision that cannot be inferred safely.

## Evidence Format

For each requirement, record:

- Requirement.
- Evidence path or command.
- Result.
- Residual risk.
- Owner or next action.
