# Findings Closure

## Open

### B1

- Title: Spec-driven closeout artifacts are still incomplete
- Governing requirement: `FR-001`, `FR-003`, `FR-007`
- Affected files:
  - `tasks.md`
  - `traceability.md`
  - `post-mortem.md`
- Planned fix:
  - Complete the feature-folder closeout in place, update task state, replace placeholder post-mortem content with real conclusions, and record review evidence in the traceability matrix.
- Validation:
  - `bun run specify:validate`
  - `bun test`
- Evidence:
  - `review.md` now records Review 1, Review 2, and Review 3 blocking outcomes instead of leaving the rerun as a placeholder
  - `traceability.md` now records the actual blocking review history for Reviews 1 through 3
  - `post-mortem.md` now contains actual conclusions and corrective actions
- Status: `closed`

### B2

- Title: `specify:validate` only checks file existence
- Governing requirement: `FR-007`, `FR-010`
- Affected files:
  - `scripts/validate-specify.ts`
- Planned fix:
  - Strengthen the validator so completed feature folders cannot pass with placeholder or pending closeout artifacts.
- Validation:
  - `bun run specify:validate`
  - `bun test`
- Evidence:
  - `scripts/validate-specify.ts` now checks closeout-content consistency for feature folders with no open tasks
  - `bun run specify:validate` passes after the stronger checks
- Status: `closed`

### B3

- Title: `tests/specify.test.ts` hardcodes a single feature directory
- Governing requirement: `FR-010`
- Affected files:
  - `tests/specify.test.ts`
- Planned fix:
  - Make the test assert validator success semantics without pinning the repository to exactly one feature folder.
- Validation:
  - `bun test`
- Evidence:
  - `tests/specify.test.ts` now derives the expected feature count dynamically
  - `tests/skills.test.ts` now has an explicit 30-second timeout budget
  - `bun test` passes
- Status: `closed`

### B4

- Title: Skills index mode inventory is stale
- Governing requirement: `FR-007`
- Affected files:
  - `.agents/SKILLS_INDEX.md`
- Planned fix:
  - Bring the mode inventory into sync with the canonical `agent-execution-mode` skill.
- Validation:
  - manual docs truth review
- Evidence:
  - `.agents/SKILLS_INDEX.md` now includes `agent-review`, `bugfix`, `documentation`, `specification-and-plan`, and `post-mortem`
- Status: `closed`

### B5

- Title: Amendment closeout was not reflected truthfully in the governed packet
- Governing requirement: `FR-001`, `FR-003`, `FR-007`, `FR-011`
- Affected files:
  - `review.md`
  - `traceability.md`
  - `tasks.md`
  - `validation.md`
- Planned fix:
  - Record the real Review 6 blocking result in the governed packet, reopen the final review gate, and reconcile traceability and validation state so they only claim recorded evidence.
- Validation:
  - `bun run specify:validate`
  - `bun run skills:validate-evals`
  - `bun test`
  - `bun run skills:validate`
  - `git diff --check`
- Evidence:
  - `review.md` now records Review 6 as a real blocking review instead of leaving the amendment implied but unrecorded
  - `tasks.md` now reopens the final review gate until the rerun returns `APPROVE`
  - `validation.md` and `traceability.md` now describe Review 6 as a block on governed-packet truthfulness rather than implying amendment closure
- Status: `closed`

### B6

- Title: Skill-creator amendment validation evidence was stale in the governed packet
- Governing requirement: `FR-010`, `FR-012`
- Affected files:
  - `validation.md`
  - `review.md`
  - `traceability.md`
- Planned fix:
  - Update the governed packet to the current validator evidence for the 9-skill eval-definition set, record the real Review 8 block, and rerun the final review gate against the corrected packet.
- Validation:
  - `bun run specify:validate`
  - `bun run skills:validate-evals`
  - `bun test`
  - `bun run skills:validate`
  - `git diff --check`
- Evidence:
  - `validation.md` now records the live `Validated eval definitions for 9 skills.` output
  - `review.md` now records Review 8 as the real block on stale amendment evidence
  - `traceability.md` will cite Review 8 as a docs-truth block for the FR-012 amendment until the rerun returns `APPROVE`
- Status: `closed`

### B7

- Title: README active-skill inventory omitted `skill-creator`
- Governing requirement: `FR-007`, `FR-012`
- Affected files:
  - `README.md`
  - `review.md`
  - `traceability.md`
- Planned fix:
  - Make the README active-skill inventory truthful by adding `skill-creator`, then record the real Review 9 block and rerun the final review gate.
- Validation:
  - `bun run specify:validate`
  - `bun run skills:validate-evals`
  - `bun test`
  - `bun run skills:validate`
  - `git diff --check`
- Evidence:
  - `README.md` now lists `skill-creator` in the active-skill inventory
  - `review.md` now records Review 9 as the real docs-truth block before the final rerun
  - `traceability.md` will cite Review 9 until the rerun returns `APPROVE`
- Status: `closed`

## Closure Rules

- Every blocking finding must be recorded here before remediation begins.
- Each entry must include the governing requirement, affected files, planned fix, validation steps, evidence, and final status.
- No final completion claim is valid while any entry remains open or fixed-awaiting-validation.
