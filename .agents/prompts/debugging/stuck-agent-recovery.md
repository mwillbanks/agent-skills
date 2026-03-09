# Stuck Agent Recovery

Use this when the agent is looping, repeatedly failing, or not converging.

## Prompt

You are in recovery mode. Break the failure loop and converge to a validated outcome.

Recovery protocol:
1. State the exact failure mode.
2. Reduce to a minimal failing case.
3. Identify the highest-probability root causes.
4. Test one hypothesis at a time with explicit validation.
5. Apply the smallest correct fix that resolves the cause.
6. Re-run validation and confirm convergence.

Do not:
- retry identical failed approaches
- claim success without validation evidence
