# Plan: Skill Workflow Hardening

## Architecture

1. Keep `.specify/` as this repository's own spec workflow surface while making the shared skills repository-aware instead of Speckit-default.
2. Update orchestration skills first so the core delivery and spec-management model is correct.
3. Add new reusable skills with bundled references, evals, and any minimal scripts required for deterministic checks.
4. Update repository docs, indexes, and skill-authoring policy so published guidance matches the new behavior and requires the actual `skill-creator` evaluation loop.
5. Add automated tests for skill structure, eval presence where required, and spec artifact integrity.

## Workstreams

### Workstream A: Core execution, review, and repository-aware SDD model

- Update `agent-execution-mode/SKILL.md`
- Update `agent-execution-mode/references/WORKFLOWS.md`
- Update `agent-execution-mode/references/SUBAGENT_MANAGEMENT.md`
- Update `agent-execution-mode/references/REVIEW_INSTRUCTIONS.md`
- Update assets and evals as needed

### Workstream B: Conditional Speckit governance

- Update `speckit-feature-orchestrator/SKILL.md`
- Update its workflow and validation references
- Update `execution-alignment-gate` only where it must acknowledge spec updates and approval fallback behavior

### Workstream C: Code discipline and frontend guidance

- Harden `code-discipline`
- Add `frontend-system-discipline`
- Update related indexes and docs

### Workstream D: New reusable skills

- Create `review-remediation-gate`
- Create `requirements-traceability-matrix`
- Create `spec-change-governance`
- Add eval definitions and references for each

### Workstream E: Repository truth and validation

- Update `README.md`, `AGENTS.md`, `.agents/SKILLS_INDEX.md`, and authoring guidance as needed
- Update `skill-creator/SKILL.md` so evaluation setup cannot be mistaken for evaluation execution
- Add tests or validators for new skill/eval/spec expectations where durable repo enforcement is warranted
- Run Bun tests and skills validation
- Run the mandatory final independent review gate

## Validation Strategy

- Validate all skills with `bun run skills:validate`
- Validate repo tests with `bun test`
- Add targeted automated checks for newly required artifacts and eval coverage
- Inspect changed-skill eval definitions for presence and structural correctness

## Risks And Mitigations

- Risk: Oversized overlapping edits across skill files
  - Mitigation: split work into disjoint sub-agent ownership areas
- Risk: New skill guidance drifts from updated orchestrator guidance
  - Mitigation: centralize shared rules in orchestrator skill refs and cross-check in final validation
- Risk: Repository-aware guidance becomes too vague and stops giving the agent a decisive workflow
  - Mitigation: classify workflows explicitly as structured, partial, or absent and define how each branch behaves
- Risk: Review packet independence changes remain too soft
  - Mitigation: add explicit blocking language in both SKILL and review-reference surfaces
