# Infrastructure Reference

Use this for Pulumi, Terraform, CDK, CloudFormation, deployment configuration, environment variables, and cloud resource review.

## Ownership

- Infrastructure code owns resource topology, permissions, environment configuration, and deployment wiring.
- Application code owns runtime behavior and domain logic.
- Generated SDKs or provider bindings should not be manually edited unless the repository explicitly owns them.
- Do not add fake production resources or no-op placeholders to satisfy shape-only validation.

## Infrastructure Change Checklist

- Identify the workspace, stack, account, region, and environment boundary.
- Trace existing naming, tagging, secret, and config conventions.
- Use least-privilege IAM and scoped network access.
- Keep secrets in secret stores or encrypted config, not plaintext env files.
- Define alarms, logs, dashboards, and retention where production behavior changes.
- Include deletion protection, backup, or lifecycle policy when data persistence is introduced.
- Avoid resource replacement unless intended and safe.
- Inspect plan/diff before applying. Do not deploy unless explicitly authorized.

## Pulumi Guidance

- Keep component boundaries aligned with existing project layout.
- Avoid mixing app runtime logic into Pulumi code.
- Prefer typed config and secret config for environment-specific values.
- Review previews for replacements, deletes, IAM broadening, public exposure, and unexpected region/account targets.

## Anti-Patterns

- Hardcoding account IDs, ARNs, bucket names, domains, or secrets without established convention.
- Adding wildcard IAM because the exact resource is inconvenient to derive.
- Skipping preview review.
- Changing production infrastructure as validation without explicit user authorization.
