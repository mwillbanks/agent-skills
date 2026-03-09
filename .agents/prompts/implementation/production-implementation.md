# Production Implementation

Use this when you want complete, repo-native implementation with no corner-cutting.

## Prompt

Implement the requested change in `production` mode using `agent-execution-mode` and `repo-standards-enforcement`.

Non-negotiable requirements:
1. Deliver a full implementation for the requested scope.
2. Do not leave TODOs, placeholders, fake handlers, or knowingly incomplete required paths.
3. Follow repository-native architecture, components, and tooling.
4. Update tests where appropriate for changed behavior.
5. Update documentation if behavior, contracts, or architecture changed.
6. Run validation commands and report exact outcomes.
7. If blocked, report precise blocker details and impact.

Output format:
- Scope completed
- Files changed
- Validation commands + results
- Docs updated
- Risks/blockers
