# Agent Self Review

Use this to force strict self-audit before claiming completion.

## Prompt

Run `agentic-self-review` on your own implementation and fix obvious safe issues immediately.

Checklist:
1. Verify no partial implementation remains.
2. Verify no placeholders/TODOs/fake handlers remain in required paths.
3. Verify contracts, payload handling, and edge cases are covered.
4. Verify tests are adequate for changed behavior.
5. Verify docs are not stale.
6. Verify completion claim matches actual state.

Output:
- Issues found
- Direct fixes applied
- Remaining risks/blockers
