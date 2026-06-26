# Gate Contract

This document defines the deterministic behavior for `ts-code-validation-gate`.

## Run lifecycle

1. Create/verify `.agents/.code-validation-gate/`.
2. Ensure `.git/info/exclude` contains `.agents/.code-validation-gate/`.
3. Before running checks, inspect the most recent prior run:
   - If it has `needs-remediation.flag` and unresolved checklist items (`- [ ]`) in `remediation-ledger.md`, stop immediately with `status = fail-closed`.
4. Create new run directory.
5. Execute checks and capture evidence.
6. Emit `status.json`.

## Check contract

- Formatting/linting checks are auto-selected by root config detection.
- Unit tests should prioritize quick failure signal and avoid noisy output.
- Security checks must include semgrep and osv-scanner.
- Code quality check must include fallow compact mode with fail-on-issues.

## Failure contract

If any check fails:

- `status = fail`
- create `needs-remediation.flag`
- create `remediation-ledger.md` with one checklist item per failed check
- prohibit future “review-valid” status until all prior checklist items are completed

## Review validity rule

Review validity is binary:

- valid only when latest run returns `pass`
- invalid for `fail` and `fail-closed`

## Remediation ledger checklist format

- Required unchecked marker: `- [ ]`
- Required completed marker: `- [x]`

Any remaining `- [ ]` in prior ledger forces `fail-closed` on next run.
