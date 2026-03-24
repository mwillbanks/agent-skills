# Agent Skills

A collection of aggressively opinionated agent skills designed to prevent lazy, partial, shortcut‑ridden AI behavior and force agents to actually finish the work they start.

This repository exists because agents are incredibly useful right up until they:

- stop halfway through an implementation
- approximate instead of implement
- leave TODOs in required paths
- skip tests and validation
- ignore repository conventions
- pretend something is "done" when it obviously is not

These skills exist to push agents in the opposite direction.

The expectation is simple:

**If the task is supposed to be done, the agent should actually finish the damn task.**

---

# Purpose

This repository is a personal collection of agent skills used to shape how AI systems behave during engineering and technical work.

The goal is not to make agents "friendlier".

The goal is to make them **more disciplined, more thorough, and less likely to cut corners.**

These skills enforce behaviors such as:

- finishing implementations instead of stopping early
- respecting repository standards and tooling
- maintaining documentation accuracy
- performing proper validation and testing
- avoiding one‑off hacks that destroy maintainability
- producing transparent reporting about what actually happened

In short: **less pretending, more doing.**

---

# What this repository contains

This repository will eventually contain a large collection of agent skills covering many different areas of agent behavior.

Examples of the kinds of skills that may exist in this repository include:

- execution discipline
- repository standards enforcement
- code discipline and abstraction control
- documentation hygiene
- architecture guidance
- validation workflows
- review systems
- environment interaction
- tooling and build systems
- debugging workflows
- infrastructure and deployment patterns

The exact contents will evolve over time.

The important thing is that every skill exists to solve a real problem where agents commonly behave poorly.

Current active skill index is maintained in `.agents/SKILLS_INDEX.md`.

---

# Design philosophy

These skills follow a few simple principles.

## Completeness over speed

Agents frequently optimize for appearing finished rather than actually being finished.

These skills push agents to complete the work instead of returning early with something that merely *looks* correct.

## Maintainability over shortcuts

Quick hacks and one‑off solutions create long‑term maintenance problems.

Skills in this repository prefer reusable patterns, shared abstractions, and design‑system aligned implementations.

## Honest reporting

Agents should clearly communicate:

- what was completed
- what assumptions were made
- what decisions were inferred
- what validation was performed
- what blockers actually exist

No vague "looks good" summaries.

## Documentation that matches reality

Stale documentation is worse than missing documentation.

Skills in this repository encourage updating documentation whenever behavior or architecture changes would otherwise leave it incorrect.

## Repository standards are not optional

If a repository has tooling, conventions, or architecture patterns, those are expected to be followed.

Agents should adapt to the repository rather than invent their own rules.

---

# Repository structure

Skills are organized under the `.agents` directory.

```text
.agents/
  prompts/
  skills/
    <skill-name>/
      SKILL.md
      assets/
      references/
```

Each skill is self‑contained and defines:

- when the skill should be used
- what behaviors it enforces
- what validation expectations exist
- what failure patterns it prevents

Supporting templates belong in `assets/` and supporting documentation belongs in `references/`.

---

# Intended usage

These skills are intended for agent systems capable of skill discovery and scoped instruction injection.

A typical workflow will apply one or more skills to shape agent behavior for a given task.

Example:

```markdown
Use `agent-execution-mode` and `repo-standards-enforcement`.

Implement the requested change completely, respect repository standards, run validation, and do not claim completion until the work actually satisfies the task.
```

For repository installation via the Skills CLI:

```bash
bunx skills add mwillbanks/agent-skills
```

---

# Non‑goals

This repository is not trying to:

- be neutral
- optimize for minimal diffs
- encourage "good enough" implementations
- prioritize speed over correctness

If a task is intentionally a prototype or exploration, that should be stated explicitly.

Otherwise, the expectation is that the agent does the job properly.

---

## License

This project is licensed under the Apache License, Version 2.0.

See the LICENSE file for the full license text and the NOTICE file for required attribution notices.

## Attribution

Reuse, modification, and redistribution must preserve attribution to the original author and repository owner.

Redistributions must retain the NOTICE file.

Recipients must not misrepresent the authorship or origin of this work as their own original creation.

## Releases

This repository uses release-it for versioning and GitHub releases.

- `bun test` validates all skills against the Agent Skills specification.
- `bun run skills:validate` validates all skills against the Agent Skills specification.
- `bun run release` runs release-it and creates a GitHub release.