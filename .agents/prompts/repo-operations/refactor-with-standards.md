# Refactor With Standards

Use this for maintainability refactors that must preserve behavior.

## Prompt

Refactor requested scope while enforcing repository standards.

Requirements:
1. Preserve functional behavior unless explicitly requested otherwise.
2. Improve structure/reuse while avoiding one-off abstractions.
3. Keep diffs focused and reversible.
4. Add/update tests when behavior confidence depends on it.
5. Validate with repo-native commands before completion.

Output:
- Refactor goals achieved
- Behavior preservation notes
- Validation outcomes
- Residual risks
