# Spec: Skill Workflow Hardening

## Summary

Strengthen this repository’s execution, specification, review, and code-discipline skills so they prevent spec drift, weak manager packets, review steering, partial-scope review closure, sloppy frontend/code abstractions, and overfitting to Speckit as the default SDD workflow. Add reusable skills and validation assets that make these controls durable across repositories.

## Requirements

### FR-001 Spec-driven delivery mode

`agent-execution-mode` must define a `spec-driven-delivery` mode that:

- detects and adapts to the repository's existing SDD workflow before creating or updating governing artifacts
- creates or updates governing spec artifacts before code changes when spec-driven delivery is in scope
- carries work through implementation, validation, independent review, and post-mortem
- updates durable docs, artifacts, skills, scripts, checks, and related guidance when findings justify them

### FR-002 Spec amendment without history loss

Spec-governed rework must update existing artifacts instead of replacing them.

- existing completed tasks must remain visible
- superseded requirements must be marked and explained rather than silently removed
- requirement changes must trigger clarification, plan consistency, task alignment, and analyze consistency reruns

### FR-003 Independent review enforcement

`agent-execution-mode` must require:

- an optional early changed-surface review gate only as a narrow preliminary check
- a mandatory final full-scope review gate against the entire prompt and governing spec
- reviewer packets grounded in authoritative intent and repo state rather than worker self-description
- explicit blocking of review steering behavior

### FR-004 Sub-agent availability and fallback

When sub-agents are required for the final independent review and are unavailable:

- if approval could make them available, the agent must request that approval
- if no answer arrives within 90 seconds, work may continue with a recorded fallback constraint
- the fallback constraint must be explicitly carried into the final artifact and report

### FR-005 Manager packet integrity

Manager-to-subagent packets must include:

- exact intent source
- governing spec or prompt references
- required skills
- scope boundaries
- validation or evidence plan
- acceptance criteria
- stop conditions

### FR-006 Conditional Speckit governance

`speckit-feature-orchestrator` must:

- confirm that Speckit is actually intended before it runs
- act as a chief architect and management gate instead of passively accepting subagent output
- preserve and update existing spec artifacts when rework occurs
- use direct-mode clarification with a minimum of 3 and maximum of 10 rounds
- keep iterate mode behavior human-friendly and lighter weight

### FR-011 Repository-aware SDD detection and adaptation

Workflow skills must:

- inspect repositories for existing spec-like, planning, task, tool, and CI signals before assuming a workflow
- classify workflow shape as structured, partial, or absent
- follow existing structured workflows without breaking conventions
- fill missing stages conservatively when the workflow is partial
- bootstrap only a lightweight structure when no workflow exists
- avoid introducing Speckit or foreign structure unless Speckit is clearly intended or explicitly requested

### FR-007 Mandatory artifact hygiene

Implementation-oriented skill guidance must require that docs, ADRs, specs, plans, tasks, validation notes, review artifacts, and post-mortems are either:

- updated
- confirmed current
- or explicitly marked not applicable with reason

### FR-008 Code-discipline hardening

`code-discipline` must explicitly tighten:

- helper and wrapper admission
- naming discipline for meaningless prefixes such as `normalized` and `resolved`
- preference for reputable libraries over reinvention
- consistent constants and utility placement
- `styled()` file organization
- design-system, theme token, and composition-first frontend architecture

### FR-009 New reusable skills

The repository must add reusable skills for:

- review remediation gate
- requirements traceability matrix
- spec change governance
- frontend system discipline

### FR-010 Validation assets

The repository must include tests, evals, scripts, and documentation updates needed to validate the new skills and changed guidance.

### FR-012 Mandatory skill-creator evaluation execution

When `skill-creator` is used for new or materially changed skills with objective or semi-objective behavior:

- defining `evals/evals.json` must be treated only as setup, not completion
- the run-and-evaluate loop must continue through execution of the test cases
- the human review surface from `eval-viewer/generate_review.py` must be used when the environment supports it
- the skill must not be described as evaluated unless at least one full evaluation loop has actually run, unless the user explicitly opted out or the environment truly blocked it

## Non-Goals

- Publishing repo-specific application workflows
- Replacing existing Bun or skills-ref validation flows
- Introducing non-generic MCP integrations without a durable reusable need

## Acceptance Criteria

1. The new `.specify/` feature directory exists with spec, plan, tasks, validation, closure, and post-mortem artifacts for this initiative.
2. `agent-execution-mode` and supporting references encode the new `spec-driven-delivery` mode, stricter review independence, manager packet rules, fallback handling, and mandatory post-mortem.
3. `speckit-feature-orchestrator` is updated to govern update-in-place rework, stronger direct-mode clarification, and conditional Speckit eligibility.
4. `code-discipline` is tightened and frontend system guidance exists either within it or as a dedicated new skill.
5. The four new skills exist with valid structure and eval definitions.
6. Repo docs and indexes reflect the new modes and skills truthfully.
7. Validation passes for tests and skills-ref validation, and new or changed eval assets exist for targeted skill coverage.
8. Workflow skills detect and adapt to repository-native SDD structure instead of assuming Speckit by default.
9. Repo guidance and `skill-creator` explicitly require executing the skill evaluation loop instead of stopping at `evals/evals.json`.
