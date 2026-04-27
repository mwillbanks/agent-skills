# Feature Intake

## Feature Name

Skill Workflow Hardening

## Problem Statement

The current skill set does not adequately prevent spec drift, review steering, weak sub-agent packet context, missing independent review delegation, overly soft code-discipline enforcement, fragmented artifact tracking, overfitting to Speckit as though every repository uses the same SDD workflow, or a skill-authoring failure mode where agents stop at `evals/evals.json` without actually running the required `skill-creator` evaluation loop. These gaps caused repeated execution churn in real project work and reduce trust in the skills as durable operating controls.

## Why It Matters

This repository is intended to shape agent behavior across many repositories and agent runtimes. If the skills themselves do not strongly enforce spec updates, truthful artifacts, independent reviews, and reusable architecture discipline, they reproduce the same failures they are meant to prevent.

## Current Behavior

- `agent-execution-mode` provides strong execution and review guidance but still centers `.agents/*` tracking and now needs to describe spec-driven work without treating Speckit as the default.
- `speckit-feature-orchestrator` stops at implementation-ready artifacts and does not strongly govern update-in-place rework, direct-mode clarification depth, or a preflight check that Speckit is actually the right workflow.
- repo authoring guidance currently overstates “eval coverage” and does not clearly force the full `skill-creator` run/review/improve loop after `evals/evals.json` is written.
- `code-discipline` is still too permissive about helper sprawl, weak naming, and frontend system rigor.
- No reusable skills exist yet for review-remediation closure, requirements traceability, spec change governance, or frontend system discipline.

## Required Changes

- Add a spec-driven delivery model to `agent-execution-mode` that runs spec creation or update, implementation, validation, independent review, mandatory post-mortem, and durable follow-through updates.
- Make `agent-execution-mode` repository-aware for SDD detection so it follows existing repo-native planning workflows, fills missing stages conservatively, and bootstraps a lightweight structure only when no workflow exists.
- Make spec-driven artifact routing and amendment behavior explicit: update existing spec artifacts instead of replacing them, preserve completed tasks, record superseded requirements, and rerun consistency passes after requirement changes.
- Require a mandatory independent final full-scope review gate, permit an earlier changed-surface review only as an optional preliminary gate, and ban review steering.
- Require managers to pass authoritative intent, required skills, acceptance criteria, validation plans, and stop conditions to sub-agents.
- Strengthen `speckit-feature-orchestrator` to act as a chief-architect gate, confirm Speckit eligibility before use, and increase direct-mode clarification to a minimum of 3 and maximum of 10 rounds.
- Harden `code-discipline` and add reusable frontend system guidance.
- Create generic reusable skills for review remediation, requirements traceability, spec change governance, and frontend system discipline.
- Add tests, evals, scripts, and documentation updates needed to keep the new behavior durable.
- Harden `skill-creator`, `AGENTS.md`, `SKILL_AUTHORING_GUIDE.md`, and related discovery docs so skill work cannot treat `evals/evals.json` as completed evaluation.

## Must Not Change

- Existing skills must remain generic and reusable across repositories.
- Existing accepted guidance must not be weakened to make the skills less demanding.
- The repository should remain Bun-first and skills-ref-compatible.

## Explicit Non-Goals

- Do not introduce repo-specific application code or business logic.
- Do not add marketplace-specific MCP servers unless a generic, justified reusable capability is required for the new skills.
- Do not replace the repository’s current skill packaging and validation model.

## Constraints And Repository Boundaries

- Skills live under `.agents/skills/<skill-name>/`.
- Skills must validate under `skills-ref`.
- This repository now has a `.specify/` workflow, but the skill guidance must treat that as this repository's chosen workflow rather than a universal default for every repository.
- New or updated skills should include eval coverage and supporting references or assets only where they improve reuse and validation.
- When evaluation is in scope, skill work must execute the run-and-review loop rather than stopping at eval-definition artifacts.

## Architectural Guidance

- Treat `agent-execution-mode` as the primary delivery orchestrator.
- Treat `speckit-feature-orchestrator` as the Speckit-specific feature-definition and update-in-place spec governor, not the universal SDD entrypoint.
- Keep review independence rules centralized in `agent-execution-mode` and its references.
- Split new skills by durable concern boundaries rather than creating one oversized catch-all skill.

## API Or Interface Guidance

- Skill frontmatter descriptions should remain strong and trigger-oriented.
- New modes and artifact rules must be reflected consistently across SKILL bodies, references, README surfaces, and indexes.

## UX Guidance

- Skill instructions should remain direct, explicit, and enforceable.
- Output contracts should stay concise but unambiguous.

## Performance And Safety Expectations

- New workflows should prefer targeted validation and evidence over noisy repo-wide churn unless shared artifacts require broader checks.
- Mandatory review independence must not be sacrificed for token thrift.

## Testing Expectations

- `bun test`
- `bun run skills:validate`
- Additional repo-local tests for spec artifacts, skill eval coverage, and guidance integrity as needed
- Targeted skill-creator-style eval coverage for new skills and materially changed existing skills
- For skill-authoring work, execute at least one real `skill-creator` evaluation loop unless the user explicitly opts out or the environment truly blocks it

## Assumptions Resolved By Management Judgment

- This repository's `.specify/` workflow remains valid here, but the shared skills must detect and align with each target repository's workflow rather than exporting `.specify` or Speckit as a default.
- Post-mortem is mandatory for the new spec-driven delivery mode, not conditional.
- If sub-agents are unavailable but can be unlocked by approval in another runtime, the skill guidance should require requesting approval first, then allow continuation after 90 seconds with the fallback constraint recorded.
- For skill-authoring work, “eval coverage exists” is insufficient evidence; the actual `skill-creator` run/review/improve loop must happen unless the user explicitly says not to run it.
