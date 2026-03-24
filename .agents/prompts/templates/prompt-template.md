# <Prompt Title>

## Objective
<Exactly what the agent must accomplish.>

## Inputs
- Repo: <repo name>
- Target files or modules: <paths>
- Constraints: <constraints>

## Execution Mode
- Use `agent-execution-mode` in `<mode>`.
- Use `repo-standards-enforcement`.

## Non-Negotiable Requirements
1. Complete implementation only.
2. No placeholders, TODOs, stubs, or fake handlers in required paths.
3. Follow repository-native patterns and tooling.
4. Run validation before completion claims.
5. Update docs when behavior/contracts/architecture changed.

## Deliverables
- Code changes in the correct modules.
- Tests added/updated where appropriate.
- Documentation updates where required.
- Concise summary of decisions.

## Validation Commands
- <command 1>
- <command 2>

## Done Criteria
- Requested scope complete.
- Validation commands succeeded (or blocker documented precisely).
- No obvious regressions in adjacent affected flows.
- If mode is `production`, `hardening`, `prototype`, `design`, or `architecture`, run `agentic-self-review` after stating completion and fix safe issues before concluding.

## Final Report Format
- Scope completed
- Files changed
- Validation commands and results
- Docs updated
- Risks/blockers
