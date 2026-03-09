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

### code-discipline
- Path: `.agents/skills/code-discipline/SKILL.md`
- Purpose: Prevents helper/wrapper/abstraction bloat and enforces reuse of platform, framework, and existing utilities.
- Use when: Adding or refactoring logic where maintainability, reuse, and abstraction discipline matter.

## Standard Pairing

For most coding tasks, use this skill trio together:
1. `agent-execution-mode`
2. `repo-standards-enforcement`
3. `code-discipline`

This baseline set prevents partial implementations, enforces standards, and blocks unnecessary abstraction sprawl.

## Mode Defaults

- Default mode: `production`
- Elevated mode: `hardening` when the task is correctness-sensitive or has failed previously.
- Review modes:
  - `agentic-self-review`
  - `recommendation-review`
  - `general-review`

## Quick Validation Checklist

Before claiming completion, ensure:
- Requested scope is fully implemented.
- No placeholders, TODOs, or fake completion remain in required paths.
- Type checking and tests were run.
- Documentation is updated when behavior or architecture changed.
- Reported status matches reality.
