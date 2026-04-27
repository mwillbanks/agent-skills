# Skills Index

This index is the single place to discover active skills and expected usage patterns for this repository.

## Active Skills

### agent-execution-mode
- Path: `.agents/skills/agent-execution-mode/SKILL.md`
- Purpose: Enforces complete execution, managed sub-agent orchestration, repository-aware spec-driven delivery, independent review gating, validation, post-mortem closure, and honest reporting.
- Use when: Implementing or hardening behavior, running architecture or design work, producing production-grade delivery, or performing review workflows that must be complete and verified.

### execution-alignment-gate
- Path: `.agents/skills/execution-alignment-gate/SKILL.md`
- Purpose: Detects materially ambiguous or under-specified requests, routes clarification to the right target, and keeps alignment bounded before execution.
- Use when: Ambiguity could cause the wrong deliverable, wrong scope, wrong implementation path, wrong validation target, avoidable rework, or repeated token-wasting clarification loops.

### repo-standards-enforcement
- Path: `.agents/skills/repo-standards-enforcement/SKILL.md`
- Purpose: Enforces repository-native tooling, TypeScript correctness, test discipline, and maintainability.
- Use when: Any code, test, tooling, or infrastructure artifact is modified.

### biome-enforcement
- Path: `.agents/skills/biome-enforcement/SKILL.md`
- Purpose: Keeps Biome as the final enforcement routine while guiding config decisions, ignore-path triage, and structured remediation.
- Use when: Code, tests, Biome config, or generated-output paths change and Biome-aware validation is required.

### code-discipline
- Path: `.agents/skills/code-discipline/SKILL.md`
- Purpose: Prevents helper/wrapper/abstraction bloat and enforces reuse of platform, framework, and existing utilities.
- Use when: Adding or refactoring logic where maintainability, reuse, and abstraction discipline matter.

### frontend-system-discipline
- Path: `.agents/skills/frontend-system-discipline/SKILL.md`
- Purpose: Enforces design-system, theme-token, composition, constants, and styling-surface discipline for frontend work.
- Use when: Frontend code, design-system work, MUI styling, or cross-component UI patterns are being created or changed.

### speckit-feature-orchestrator
- Path: `.agents/skills/speckit-feature-orchestrator/SKILL.md`
- Purpose: Orchestrates a full Speckit feature workflow from constitution amendment through specification, clarification, plan, tasks, and analysis using a chief-architect management-agent model with `iterate` and `direct` modes.
- Use when: A user wants to discuss and refine a feature first or directly drive it into implementation-ready or update-in-place Speckit artifacts in one controlled pass, and Speckit is clearly the repository workflow or explicitly requested.

### review-remediation-gate
- Path: `.agents/skills/review-remediation-gate/SKILL.md`
- Purpose: Converts review findings into evidence-backed closure work and blocks narrative-only "fixed" claims.
- Use when: Work has review findings or blocking comments that must be remediated and closed truthfully.

### requirements-traceability-matrix
- Path: `.agents/skills/requirements-traceability-matrix/SKILL.md`
- Purpose: Maps requirements to implementation surfaces, tests, docs, validation, and review evidence.
- Use when: Broad or high-risk work needs a durable proof surface showing what requirement is satisfied where.

### spec-change-governance
- Path: `.agents/skills/spec-change-governance/SKILL.md`
- Purpose: Governs requirement changes in spec-driven workflows so spec, plan, and tasks are updated in place instead of rewritten destructively.
- Use when: A governed feature changes midstream and the existing specification artifacts must stay truthful.

### skill-creator
- Path: `.agents/skills/skill-creator/SKILL.md`
- Purpose: Creates or improves skills through a mandatory draft -> run test cases -> human review -> improve loop when evaluation has not been explicitly skipped.
- Use when: Creating a new skill, improving an existing skill, benchmarking skill behavior, or running a skill evaluation loop with baseline comparison and human review.

## Standard Pairing

For most coding tasks, use this standard set together:
1. `agent-execution-mode`
2. `repo-standards-enforcement`
3. `code-discipline`
4. `biome-enforcement`

Add `execution-alignment-gate` before execution when ambiguity is material enough to threaten scope, implementation correctness, or validation accuracy.
Add `frontend-system-discipline` whenever frontend architecture, design tokens, styling organization, or design-system reuse is in scope.

This standard set prevents partial implementations, enforces standards, preserves Biome enforcement discipline, and blocks unnecessary abstraction sprawl while the alignment gate prevents avoidable wrong-path execution.

For skill authoring or skill changes, add `skill-creator` and do not stop at `evals/evals.json`; the run-and-review loop must execute unless the user explicitly opts out.

## Mode Defaults

- Default mode: `production`
- Elevated mode: `hardening` when the task is correctness-sensitive or has failed previously.
- End-to-end spec mode: `spec-driven-delivery` using the repository's existing SDD workflow when it exists
- Planning mode: `specification-and-plan` using repository-aware SDD detection rather than a forced tool choice
- Other execution modes:
  - `bugfix`
  - `prototype`
  - `design`
  - `documentation`
  - `architecture`
- Review modes:
  - `agent-review`
  - `agentic-self-review`
  - `general-review`
  - `pr-review`
- Analysis mode:
  - `post-mortem`
- Retired mode: `recommendation-review` was removed; use `general-review` or `pr-review` instead.

Execution modes `production`, `bugfix`, `hardening`, `prototype`, `design`, `documentation`, `specification-and-plan`, `spec-driven-delivery`, and `architecture` must run an independent final review after completion is stated.

## Quick Validation Checklist

Before claiming completion, ensure:
- Requested scope is fully implemented.
- No placeholders, TODOs, or fake completion remain in required paths.
- Type checking and tests were run.
- Biome enforcement was run when the changed scope is Biome-managed.
- Documentation is updated when behavior or architecture changed.
- Reported status matches reality.
- Spec-local artifacts are updated truthfully when the work is spec-governed.
