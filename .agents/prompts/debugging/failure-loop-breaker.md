# Failure Loop Breaker

Use this when repeated attempts keep failing without meaningful new information.

## Prompt

Stop brute-force retries. Execute a loop-breaker pass.

Protocol:
1. Document what has already failed and why.
2. Introduce a new diagnostic axis (instrumentation/logging/isolation).
3. Re-check assumptions against actual runtime behavior.
4. Choose a new strategy materially different from prior attempts.
5. Validate with measurable pass/fail criteria.

Output:
- Failed attempts summary
- New diagnostic signal
- New strategy chosen
- Validation outcomes
