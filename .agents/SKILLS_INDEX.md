# Skills Index

This index is the single place to discover active skills and expected usage patterns for this repository.

## Active Skills

### agent-execution-mode
- Path: `.agents/skills/agent-execution-mode/SKILL.md`
- Purpose: Enforces complete execution, managed sub-agent orchestration, independent self-review gating, validation, and honest reporting.
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

### speckit-feature-orchestrator
- Path: `.agents/skills/speckit-feature-orchestrator/SKILL.md`
- Purpose: Orchestrates a full Speckit feature workflow from constitution amendment through specification, clarification, plan, tasks, and analysis using a management-agent model with `iterate` and `direct` modes.
- Use when: A user wants to discuss and refine a feature first or directly drive it into implementation-ready Speckit artifacts in one controlled pass.

## Standard Pairing

For most coding tasks, use this standard set together:
1. `agent-execution-mode`
2. `repo-standards-enforcement`
3. `code-discipline`
4. `biome-enforcement`

Add `execution-alignment-gate` before execution when ambiguity is material enough to threaten scope, implementation correctness, or validation accuracy.

This standard set prevents partial implementations, enforces standards, preserves Biome enforcement discipline, and blocks unnecessary abstraction sprawl while the alignment gate prevents avoidable wrong-path execution.

## Mode Defaults

- Default mode: `production`
- Elevated mode: `hardening` when the task is correctness-sensitive or has failed previously.
- Other execution modes:
  - `prototype`
  - `design`
  - `architecture`
- Review modes:
  - `agentic-self-review`
  - `general-review`
  - `pr-review`
- Retired mode: `recommendation-review` was removed; use `general-review` or `pr-review` instead.

Execution modes `production`, `hardening`, `prototype`, `design`, and `architecture` must run `agentic-self-review` after completion is stated.

## Quick Validation Checklist

Before claiming completion, ensure:
- Requested scope is fully implemented.
- No placeholders, TODOs, or fake completion remain in required paths.
- Type checking and tests were run.
- Biome enforcement was run when the changed scope is Biome-managed.
- Documentation is updated when behavior or architecture changed.
- Reported status matches reality.
