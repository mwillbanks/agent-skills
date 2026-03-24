# Skills Index

This index is the single place to discover active skills and expected usage patterns for this repository.

## Active Skills

### agent-execution-mode
- Path: `.agents/skills/agent-execution-mode/SKILL.md`
- Purpose: Forces completion discipline, mode-based behavior, anti-laziness gates, and honest reporting.
- Use when: Implementing features, fixing bugs, hardening, architecture tasks, or running reviews.

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

## Standard Pairing

For most coding tasks, use this standard set together:
1. `agent-execution-mode`
2. `repo-standards-enforcement`
3. `code-discipline`
4. `biome-enforcement`

This standard set prevents partial implementations, enforces standards, preserves Biome enforcement discipline, and blocks unnecessary abstraction sprawl.

## Mode Defaults

- Default mode: `production`
- Elevated mode: `hardening` when the task is correctness-sensitive or has failed previously.
- Review modes:
  - `agentic-self-review`
  - `general-review`
  - `pr-review`

Execution modes `production`, `hardening`, `prototype`, `design`, and `architecture` must run `agentic-self-review` after completion is stated.

## Quick Validation Checklist

Before claiming completion, ensure:
- Requested scope is fully implemented.
- No placeholders, TODOs, or fake completion remain in required paths.
- Type checking and tests were run.
- Biome enforcement was run when the changed scope is Biome-managed.
- Documentation is updated when behavior or architecture changed.
- Reported status matches reality.
