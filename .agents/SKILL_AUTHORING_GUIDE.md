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
.agents/
  skills/
    new-skill-name/
      SKILL.md
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
