# Implementation Hardening

Use this when correctness, regression prevention, and production safety are priorities.

## Prompt

Execute this task in `hardening` mode with strict correctness gates.

Requirements:
1. Fix the requested issue completely.
2. Include tightly coupled adjacent fixes required for correctness.
3. Strengthen state handling, error handling, contracts, and edge-case coverage.
4. Add or update tests to prevent regressions.
5. Validate with typecheck + tests + any repo lint/format checks.
6. After stating completion, run `agentic-self-review` and fix obvious safe issues before concluding.
7. Do not claim completion while obvious risks remain.

Provide:
- Root cause
- Fix strategy
- Code changes
- Regression prevention tests
- Validation evidence
- Residual risks (if any)
