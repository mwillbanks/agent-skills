# Skill Authoring Guide

This guide defines how skills in this repository must be authored so agents obey them consistently.

**OFFICIAL SPECIFICATION**: [Agent Skills Specification](https://agentskills.io/specification)

## 1. Required Structure

Always start with the scaffold command:

```bash
bunx skills init new-skill-name
```

Required structure:

```text
.specify/
  constitution.md
  features/
    <feature-id>/
      feature-foundation.md
      spec.md
      plan.md
      tasks.md
      findings-closure.md
      validation.md
      review.md
      traceability.md
      post-mortem.md

.agents/
  skills/
    new-skill-name/
      SKILL.md
      evals/
        evals.json
      references/
        <reference-name>.md
      scripts/
        <script-name>.sh
      templates/
        <template-name>.[md|mdx]
```

Required naming:
- Skill directory: kebab-case.
- Skill file: exactly `SKILL.md`.
- Script names: kebab-case.
- Eval file: `evals/evals.json` when the skill has objective or semi-objective behaviors that should be regression checked.

## 1.1 Mandatory Evaluation Loop For Skill Work

When a skill has objective or semi-objective behavior and the user has not explicitly opted out, the evaluation loop is mandatory:

1. define or update `evals/evals.json`
2. run the test cases
3. run the appropriate baseline when the environment supports it
4. generate the human review surface with `eval-viewer/generate_review.py`
5. collect or read human feedback
6. improve the skill and rerun as needed

`evals/evals.json` alone is not completion, not validation, and not acceptable evidence that the skill was actually evaluated.
If the loop is skipped, the exact user opt-out or environment blocker must be documented.

## 2. How Aggressive Skills Should Be

Skill language should be explicit and enforceable, not polite and optional.

Use:
- clear `must`, `required`, `non-negotiable`, `do not` statements
- default assumptions that bias toward production completeness
- strict definition-of-done gates
- completion claims tied to validation evidence

Avoid:
- vague guidance like "consider" or "try"
- ambiguous quality expectations
- soft language that allows easy evasion

## 3. Anti-Laziness Patterns To Include

Every implementation-oriented skill should include these patterns:

1. Anti-partial rule
- Explicitly forbid partial completion when user asked for completion.

2. No-placeholder rule
- Forbid TODOs, stubs, fake handlers, and knowingly incomplete required paths.

3. Validation gate
- Require concrete commands and outcomes before completion claims.

4. Documentation gate
- Require docs updates when behavior/contracts/architecture change.

5. Self-review gate
- Force a strict self-check before final response.

6. Honest blocker rule
- If blocked, require precise blocker reporting and impact.

7. Adjacent-fix rule
- Require fixing tightly coupled issues that make the requested task incorrect.

## 4. How To Write Skills Agents Actually Obey

Use this formula:

1. Trigger precision
- A strong `description` frontmatter line with clear trigger phrases.

2. Scope precision
- A specific `When to use` section with concrete task classes.

3. Modeled behavior
- Define modes when behavior differs (`production`, `hardening`, `review`, `prototype`).

4. Enforceable policies
- Include explicit required and forbidden behaviors.

5. Checklists
- Add a definition-of-done checklist and pre-finish self-review checklist.

6. Output contract
- Tell the agent exactly what to report (commands run, results, docs changed, blockers).

7. Artifact contract
- Define where trackers/reports/review artifacts must be written when applicable.

8. Traceability contract
- When the skill governs broad or high-risk work, explain whether it should update a traceability or closure artifact.

9. Evaluation execution contract
- If the skill references a mandatory evaluation or review loop, the authoring workflow must actually execute it instead of stopping at setup artifacts.

## 5. Recommended SKILL.md Skeleton

```markdown
---
name: <skill-name>
description: <when to use this skill, with trigger phrases>
---

# <Skill Title>

## When to use
- ...

## Modes
- production
- hardening
- review

## Non-negotiable rules
- ...

## Required posture
- ...

## Validation checklist
- ...

## Definition of done
- ...

## Final output contract
- ...
```

## 6. Authoring Quality Bar

A skill is ready only when:
- another engineer can predict exactly when it should activate
- it contains hard anti-laziness guardrails
- it has enforceable validation and done criteria
- it does not rely on interpretation to be followed correctly
- it has eval coverage when the behavior should be regression tested
- its required evaluation loop has actually been run unless the user explicitly opted out or the environment truly blocked it
