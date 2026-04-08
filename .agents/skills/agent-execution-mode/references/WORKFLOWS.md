# Workflow Rules

This file defines the durable workflow and document rules for `agent-execution-mode`.

## ID and timestamp rules

- Generate IDs from the task or review intent, not from a random string.
- IDs must be lowercase, unique, hyphen-separated, and stable for the life of the artifact.
- Good examples: `fix-auth-timeout`, `review-checkout-pr-482`, `report-cart-hardening`.
- Use UTC timestamps in ISO 8601 format: `2026-03-24T18:30:00Z`.
- `created-at` is immutable after creation.
- `updated-at` changes every time the artifact is materially updated.

## Mode resolution workflow

Infer the mode from the task intent before defaulting to `production`.

Resolution rules:

- use `documentation` when the output is documentation, a runbook, prompt guidance, or an explanation aligned to the current project state
- use `specification-and-plan` when the output is a spec, plan, tasks, RFC, or implementation workflow before coding
- use `bugfix` when the task centers on broken behavior, regressions, failing tests, or defect correction
- use `hardening` when the task centers on closing repeated correctness gaps, abuse cases, reliability gaps, or repeated regressions
- use `agent-review`, `general-review`, or `pr-review` when the primary output is review rather than implementation
- use `post-mortem` when the task asks why repeated prompts or rework were needed, or what process improvements would have prevented it
- use `design` or `architecture` when visual correctness or system decision-making is the main deliverable
- use `production` only when the task is implementation-oriented and no more specific mode clearly fits

## Task workflow

Use task tracking for implementation-oriented work, bugfix work, documentation work with durable deliverables, specification work with active execution, architecture work with active execution, and any large task that benefits from durable state.

Required files:

- `.agents/tasks/TASK_INDEX.md`
- `.agents/tasks/TASK_ID.md`

Required index columns:

| ID | Name | Description | Mode | Status | Thread IDs | Created At | Updated At |
| --- | --- | --- | --- | --- | --- | --- | --- |

Rules:

- Prepend new rows directly under the table header.
- Link both `ID` and `Name` to the task document.
- `Thread IDs` stores one or more agent thread identifiers as a comma-separated list in the index and as a YAML list in the task file.
- When sub-agents are used, include the manager thread plus meaningful worker and review threads.
- Keep task state concise. It is a state document, not a diary.

Suggested task states:

- `draft`
- `in-progress`
- `blocked`
- `review`
- `complete`

## Review workflow

Use review tracking for `general-review` and `pr-review`. `agent-review` and its compatibility alias `agentic-self-review` use the same review standard but do not create a markdown artifact unless explicitly required.

Required files:

- `.agents/reviews/REVIEW_INDEX.md`
- `.agents/reviews/REVIEW_ID.md`

Required index columns:

| ID | Name | PR # | Description | Mode | Status | Count | Created At | Updated At |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |

Rules:

- Prepend new rows directly under the table header.
- Link both `ID` and `Name` to the review document.
- `Count` is the number of review iterations performed for the same artifact.
- On review iteration 2 or later, add a `Resolved Since Previous Review` section before new findings.
- New findings for the current iteration go at the top of the current iteration block.
- Re-reviewing without resolving or reclassifying previous findings is sloppy and invalidates the artifact.
- Post-completion `agent-review` iterations should still be recorded in task or report state, even when no review artifact exists.

Suggested review states:

- `draft`
- `in-progress`
- `changes-requested`
- `approved`
- `commented`
- `rejected`

### PR review workflow

`pr-review` is not just a local diff read. It is a GitHub-backed review workflow.

Required steps:

1. Capture the PR link in frontmatter and the index.
2. Pull the PR diff and stated intent through GitHub MCP.
3. Review against the stated intent, changed behavior, architecture impact, and regression risk.
4. Record candidate inline comments and suggestions in the review artifact.
5. Use GitHub MCP to publish inline comments and the overall review state.
6. On later iterations, mark which earlier findings were resolved before logging new findings.

Review states to use for GitHub summary comments:

- `approved`
- `changes-requested`
- `comment`
- `rejected`

## Report workflow

Use reports for substantial implementation, architecture, or multi-step review work.

Required files:

- `.agents/reports/REPORT_INDEX.md`
- `.agents/reports/REPORT_ID.md`

Recommended index columns:

| ID | Name | Description | Mode | Status | Created At | Updated At |
| --- | --- | --- | --- | --- | --- | --- |

Rules:

- Prepend new rows directly under the table header.
- Link both `ID` and `Name` to the report document.
- Keep the latest run at the top of the report body.
- Do not delete prior runs. Reports are an execution history.
- When substantial sub-agent orchestration occurs, summarize the manager decisions, review-gate result, and any documented fallback.

Suggested report states:

- `draft`
- `in-progress`
- `complete`
- `blocked`

## Validation planning workflow

Before any code-writing agent edits code:

1. Inspect the relevant repository validation files, standards skills, and scripts, such as project config files, package scripts, or workspace task runners.
2. Resolve the minimal correct command set for static analysis, tests, and final repository enforcement.
3. Include that command plan in the manager prompt, task state, or execution notes before edits begin.

Rules:

- Do not default to expensive repo-wide preflight runs.
- Expand scope only when configs, shared contracts, or cross-cutting boundaries changed.
- When project-specific enforcement tooling exists, follow the repository-owned skill or workflow for when it runs. `repo-standards-enforcement` and `biome-enforcement` are examples of concern-specific owners, not universal requirements.

For `documentation`, `specification-and-plan`, and `post-mortem`, replace code validation with evidence validation when no code changes are in scope. Evidence validation should identify the source artifacts that support the resulting claims.

## Sub-agent orchestration workflow

The following modes permit managed sub-agent orchestration when the expected delivery gain outweighs the token cost and the delegation shape is justified:

- `production`
- `bugfix`
- `hardening`
- `prototype`
- `design`
- `documentation`
- `specification-and-plan`
- `architecture`
- `post-mortem`

The manager must prefer the smallest viable execution shape in this order:

1. no sub-agent
2. read-only scout or evidence-gathering worker
3. single bounded writer
4. parallel bounded writers on disjoint scopes
5. independent reviewer

Partitionability alone does not justify multiple workers.

Required safety checks before spawning a worker:

- the work can be split into independent chunks or read-only support tasks
- file ownership or integration boundaries are clear
- acceptance criteria and validation commands are explicit
- prompt setup cost is lower than the expected delivery gain
- the manager can review the result before integrating it

Do not parallelize trivial tasks, tightly coupled edits, or work that will create more merge churn than delivery speed.
Do not use multiple writing workers when one bounded writer is sufficient.
Prefer read-only discovery workers before write delegation when uncertainty is high.
Parallelization is justified only when the scopes are clearly disjoint and merge cost stays low.

Manager responsibilities:

- consult `.agents/evaluations/management.json` when it exists
- choose agent type and prompt pattern deliberately instead of delegating blindly
- provide the original user prompt or exact source-intent reference, clarified requirements, applicable skills, files in scope, validation or evidence plan, and stop conditions
- provide only the minimum context required for the worker task and reuse compact manager-prepared context packets when similar workers need the same scoped inputs
- prevent overlapping write ownership unless one agent is read-only
- review every worker result before merging or approving it
- give strict professional feedback with concise corrective guidance
- escalate by adding specificity, constraints, and evidence instead of hostile language

### Manager to worker packet contract

For meaningful worker prompts, use tagged markdown sections in this exact order:

1. `# Mode`
2. `# Intent Source`
3. `# Task`
4. `# Scope`
5. `# Governing References`
6. `# Validation Or Evidence Plan`
7. `# Acceptance Criteria`
8. `# Stop Conditions`

Section rules:

- `# Mode`: the inferred or explicitly requested mode.
- `# Intent Source`: if a spec exists, include the exact spec path and any accepted plan or task files. If no spec exists, include the original prompt or a compact faithful summary with the real goal and concrete specifics.
- `# Task`: one short paragraph or up to 5 bullets describing what the worker must do.
- `# Scope`: bounded files, directories, or artifacts. Keep to 12 bullets or fewer.
- `# Governing References`: only the skills, docs, specs, or instructions that actually govern the work. Include `code-discipline` and `repo-standards-enforcement` when code changes are in scope and those checks are relevant.
- `# Validation Or Evidence Plan`: up to 10 bullets. For code work include commands. For non-code work include the source artifacts that must support the claims.
- `# Acceptance Criteria`: only the conditions the worker must satisfy.
- `# Stop Conditions`: call out missing context, forbidden scope expansion, or conditions that require the worker to hand back control.

Missing or selectively framed intent in `# Intent Source` is a manager defect.

## Bugfix and hardening workflow

For `bugfix` and `hardening`:

1. State the bug, expected behavior, and evidence or reproduction before editing.
2. Identify the likely failure surface and the minimum safe repair.
3. Validate the repair against the original failure and any adjacent regression risk.
4. Carry that evidence into the `agent-review` packet.

## Documentation workflow

For `documentation`:

1. Identify the source of truth for each claim, such as code, tests, validated runtime behavior, existing docs, or operator artifacts.
2. Mark unknowns explicitly instead of inventing answers.
3. If documentation claims product behavior or operational readiness changed, run `agent-review` after completion.

## Specification and plan workflow

For `specification-and-plan`:

1. Detect repo-native or organization-native spec tooling first.
2. Prefer that workflow when present, such as Speckit, Speckitty, Symfony, or another established system.
3. If no spec workflow exists, recommend adding one, allow the user to continue, and record the decision in task or report state.
4. Produce durable artifacts that a later implementation pass can use directly.

## Post-mortem workflow

For `post-mortem`:

1. Identify where prompt quality, missing docs, missing skills, missing agent instructions, or missing MCP capabilities increased rework.
2. Recommend the highest-leverage additions in four buckets when relevant: skills, documentation, agent or instruction files, and MCP or tooling.
3. Provide a tighter prompt shape that would have produced a more precise or more efficient result.
4. Keep the mode analysis-only by default. Do not add a nested mandatory `agent-review` unless the user explicitly asks for one or the scope expands into durable repo changes that themselves require review.

## Post-completion agent-review workflow

The following modes must run `agent-review` after completion has been stated:

- `production`
- `bugfix`
- `hardening`
- `prototype`
- `design`
- `documentation`
- `specification-and-plan`
- `architecture`

Rules:

1. Do the work.
2. State completion only when the task is actually complete for the chosen mode.
3. Spawn a dedicated review sub-agent using `agent-review` or the compatibility alias `agentic-self-review`. This reviewer is approved by default for the mandatory post-completion gate and is not blocked by the general delegation minimization rules.
4. Provide the smallest sufficient evidence packet: source intent, clarified requirements, accepted plan, changed files or diff, validation or evidence results, relevant screenshots or artifacts, and applicable repository rules.
5. Instruct the reviewer to act as the final reviewer and not as a modifier.
6. If a review sub-agent cannot run because runtime or user constraints actually prevent it, perform a documented local fallback review and record the exact constraint.
7. If the verdict is exactly `APPROVE`, the gate passes.
8. If the verdict is not exactly `APPROVE`, every finding is blocking regardless of severity.
9. Only the user may dismiss a disputed finding.
10. Fix all blockers, rerun affected validation, and return to step 3 or step 6.
11. Conclude only after approval or a documented local fallback review.

This is a mandatory second gate, not an optional polish step.

Reviewer packet rules:

- Do not dump unrelated repo context into the review prompt.
- Do not omit the real source intent. If a spec was implemented, include its exact path and the accepted plan or task files when applicable. If no spec existed, include the original prompt or a faithful compact summary with the real goal and concrete specifics.
- Do not omit `code-discipline` or `repo-standards-enforcement` from governing references when code changes are in scope and those checks matter.
- Do not omit known failures or disputed areas.
- Reviewer prompts must be complete enough for integrity, but compressed enough to avoid waste.

## Management evaluation workflow

Use `.agents/evaluations/management.json` to track how sub-agent management is performing.

Required shape:

- `version`
- `lastCompressedAt`
- `agentTypes`
- `promptPatterns`
- `recentRuns`
- `repoLearnings`

For each meaningful run, record:

- timestamp
- mode
- agent type
- prompt pattern
- delegated task summary
- delegation shape: `solo`, `scout`, `single-writer`, `parallel-writers`, `review-only`, or `mixed`
- outcome: `good`, `mixed`, or `bad`
- failure class: `none`, `scope-control`, `validation-miss`, `repo-rules-miss`, `design-miss`, `over-delegation`, `under-specified-prompt`, or `integration-churn`
- cause attribution: `none`, `prompt-pattern`, `agent-type`, `context-packaging`, `task-selection`, or `manager-integration`
- token return on investment: `positive`, `neutral`, or `negative`
- manager decision, such as `reuse`, `adjust-prompt`, `restrict-agent`, `decommission-pattern`, `decommission-agent`, or `reinstate-agent`
- concise notes

Compression rules:

- keep aggregate counters by agent type and prompt pattern
- keep at most 20 entries in `recentRuns`
- compress when adding a new entry would exceed the limit
- roll repeated issues into `repoLearnings`
- keep `repoLearnings` limited to durable rules, not anecdotal run history
- remove stale or one-off noise that does not affect future delegation quality

Decommissioning rules:

- adjust prompt patterns before restricting agent types unless evidence clearly points to agent unsuitability
- decommission prompt patterns before decommissioning agent types
- restrict or decommission an agent type only after alternate prompt patterns fail to recover quality
- an agent type may be reinstated when evidence shows the prompt pattern or task framing caused the failure

## Learning compression workflow

Use split scope for recurring learnings:

- repo-specific learnings stay in `.agents/evaluations/management.json`
- cross-repository learnings go in `~/.agents/learnings/sub-agent-management.md`

Rules:

- keep only durable, reusable rules
- deduplicate aggressively
- rewrite repeated issues into a shorter higher-signal rule instead of appending more examples
- keep cross-repository learnings compressed and deduplicated
- do not store anecdotal run history in cross-repository learnings

## Design validation workflow

Use this whenever code changes have meaningful UI impact.

Required steps:

1. Use Figma MCP when a specification exists.
2. Fall back to screenshots or equivalent artifacts when Figma is unavailable.
3. Validate the implemented result with Playwright through the Docker MCP.
4. Check layout, content, interaction, visible state transitions, and responsive behavior when they are in scope.

Visual parity alone is not enough when behavior or state changes are part of the request.

## Review standards integration

All review modes must apply:

- [REVIEW_INSTRUCTIONS.md](REVIEW_INSTRUCTIONS.md)
- the `code-discipline` skill when duplication, bad abstractions, or unnecessary wrappers are present
- the `repo-standards-enforcement` skill when toolchain, package management, typing, testing, or repository policy are relevant
