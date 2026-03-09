# Ruthless Code Review

Use this for strict technical review with high signal and zero fluff.

## Prompt

Run a ruthless review of the requested changes.

Rules:
1. Prioritize findings over praise.
2. Rank by severity: High, Medium, Low.
3. Each finding must include impact and concrete fix recommendation.
4. Include file references and exact technical evidence.
5. Identify missing tests and regression risks.
6. Call out stale/missing docs when behavior changed.

Output:
- Findings (High/Medium/Low)
- Open questions/assumptions
- Optional concise change summary
