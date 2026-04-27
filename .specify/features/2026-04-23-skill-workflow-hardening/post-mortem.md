# Post-Mortem: Skill Workflow Hardening

Date: 2026-04-23
Mode: `production` with spec-governed delivery and mandatory post-mortem closeout

## Executive Summary

This rollout materially strengthened the repository’s core execution and specification skills, added four new reusable skills, introduced a `.specify` workflow surface for this repository, and added repo-level validation for spec artifacts and skill eval definitions. The first full-scope independent review correctly blocked the closeout because the spec-local truth surface and `.specify` validator were still too weak. That block was accurate and led to the final remediations below.

## What Changed

1. `agent-execution-mode` now supports `spec-driven-delivery`, mandatory post-mortem closeout, update-in-place spec history, stronger review-packet integrity, explicit approval-plus-90-second fallback behavior, and repository-aware SDD detection.
2. `speckit-feature-orchestrator` now acts more clearly as a chief-architect governor, preserves existing spec artifacts on rework, uses a 3-to-10-round clarification window in direct mode, and checks that Speckit is actually intended before imposing it.
3. `code-discipline` was hardened and `frontend-system-discipline` was added.
4. New skills were added for review remediation, requirements traceability, and spec change governance.
5. Repo docs, skill indexes, and authoring guidance were updated to reflect the new workflow.
6. Repo-level validation now covers `.specify` artifact consistency and required eval definitions for materially changed or new skills.

## Follow-on Amendment

The initial hardening pass still read too much like Speckit was the default SDD workflow. That was too rigid for shared skills meant to operate across different repositories. The follow-on amendment corrected that by making `agent-execution-mode` repository-aware for SDD detection, narrowing `speckit-feature-orchestrator` to confirmed Speckit workflows, and adding eval coverage for structured, partial, and absent workflow cases.

## Second Follow-on Amendment

The next defect was in skill-authoring discipline rather than SDD routing: repo guidance and the rollout artifacts still treated “eval coverage exists” as though that meant the `skill-creator` loop had actually been executed. It had not. This amendment corrects that by making the `skill-creator` run/review/improve loop explicit in repo policy, authoring guidance, and the skill itself, and by adding `skill-creator` to the eval-definition validator set so materially changed core skill updates cannot ship without at least the setup artifacts.

## What Went Wrong During This Rollout

1. The first final review gate caught that the spec-local closeout was not actually complete.
2. The initial `.specify` validator only checked file existence, which was too weak for the artifact-hygiene standard this rollout was introducing.
3. The first `specify` test was brittle because it hardcoded a single feature directory.
4. The skills index still lagged the canonical mode inventory.

## Corrective Actions Taken

1. Completed the spec-local review log, traceability evidence, and post-mortem instead of leaving placeholders.
2. Strengthened `scripts/validate-specify.ts` to reject placeholder or pending closeout content when a feature folder has no open tasks.
3. Made `tests/specify.test.ts` derive the expected feature count dynamically.
4. Synced the skills index mode inventory with the canonical execution skill.
5. Expanded eval coverage to all materially changed core skills in this rollout, not just the new skill directories.

## What Worked Well

1. Bounded sub-agent ownership worked well for parallel skill updates.
2. The spec-local feature folder kept planning, validation, review, and remediation tied together.
3. The independent full-scope review gate caught real workflow defects rather than cosmetic issues.
4. Repo-level scripts and tests made the new artifact rules enforceable instead of aspirational.

## Follow-Through Expectations

1. Future spec-driven deliveries in this repo should keep review, traceability, validation, and post-mortem state current before claiming completion.
2. New or materially changed reusable skills should default to eval coverage unless their behavior is inherently subjective.
3. The `.specify` validator should continue to evolve with the artifact contract if the workflow grows more sophisticated.
