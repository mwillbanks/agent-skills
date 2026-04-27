# Sub-Agent Management

This reference defines how orchestration modes use sub-agents, how management quality is recorded, and how recurring learnings stay compressed.

## Applicability

Use this reference whenever `agent-execution-mode` is active and the agent is considering sub-agent delegation.

It is mandatory for:

- `production`
- `bugfix`
- `hardening`
- `prototype`
- `design`
- `documentation`
- `specification-and-plan`
- `spec-driven-delivery`
- `architecture`

It is also recommended for:

- `post-mortem`

It may also be applied in review modes when parallel evidence gathering is safe and useful.

## Managed delegation conditions

These modes permit managed sub-agent execution when all of the following are true:

- the work can be partitioned into independent chunks or read-only support tasks
- acceptance criteria can be stated up front
- file ownership or integration boundaries are clear
- the context and prompt setup cost is lower than the expected delivery gain
- the manager can validate outputs before integration

Multi-agent execution is not the default just because partitioning is possible.
The manager must still prefer the smallest viable execution shape for implementation and support delegation.
One bounded writer is preferred over parallel writers unless there is a clear delivery advantage with low integration cost.
Partitionability alone does not justify multiple workers.
Do not spawn helpers for trivial tasks, single-file edits with no meaningful parallel split, or tightly coupled work where delegation would create more churn than speed.
These minimization rules do not suppress the mandatory post-completion `agent-review` reviewer.

## Delegation preference ladder

The manager must prefer the smallest viable execution shape in this order:

1. no sub-agent
2. read-only scout or evidence-gathering worker
3. single bounded writer
4. parallel bounded writers on disjoint scopes
5. independent reviewer

Rules:

- Do not use multiple writing workers when one bounded writer is sufficient.
- Prefer read-only discovery workers before write delegation when uncertainty is high.
- Parallelization is justified only when the scopes are clearly disjoint and merge cost stays low.

## Manager responsibilities

The main agent becomes the manager.

Required behavior:

- consult `.agents/evaluations/management.json` if it exists before writing prompts
- choose agent type and prompt pattern deliberately
- give each worker a bounded task, explicit acceptance criteria, and a stop condition
- give each worker only the minimum context required and reuse a compact manager-prepared context packet when multiple workers need the same scoped inputs
- include the source intent, clarified intent, repository rules, files in scope, validation or evidence plan, and known risks in the prompt
- prevent overlapping write ownership unless one worker is read-only
- review every result before merging or approving it
- acknowledge strong outcomes briefly
- correct weak outcomes with strict professional feedback, concise scoring, and direct procedural guidance

Do not use adversarial language. Escalate by increasing specificity, constraint density, and evidence.

## Manager to worker packet contract

Every meaningful worker prompt should use tagged markdown sections in this exact order:

1. `# Mode`
2. `# Intent Source`
3. `# Task`
4. `# Scope`
5. `# Governing References`
6. `# Validation Or Evidence Plan`
7. `# Acceptance Criteria`
8. `# Stop Conditions`

Rules:

- `# Mode`: the active mode.
- `# Intent Source`: if a specification exists, include its exact path and any accepted plan or task files that matter. If no specification exists, include the original prompt or a compact faithful summary with the real goal and concrete specifics.
- `# Task`: one short paragraph or up to 5 bullets.
- `# Scope`: bounded files, directories, or artifacts. Keep it compact.
- `# Governing References`: only the applicable rules, skills, and artifacts. Include `code-discipline` and `repo-standards-enforcement` when code changes are in scope and those checks are relevant.
- `# Validation Or Evidence Plan`: for code work include commands. For non-code work include the evidence sources that support the resulting claims.
- `# Acceptance Criteria`: the exact conditions the worker must satisfy.
- `# Stop Conditions`: when the worker must hand control back to the manager instead of guessing.

Do not hide failing validation, known defects, or unresolved assumptions from the worker.
Do not forward unrelated repository context when a smaller packet is sufficient.
Prefer diffs, file paths, acceptance criteria, and validation commands over long narrative restatements.

## Required worker response shape

Every meaningful worker must return a concise structured response containing:

- `summary`: the short outcome of the assigned task
- `files`: the files inspected or changed
- `validation`: the checks run and their result
- `blockers`: unresolved issues, risks, or missing context
- `manager-action`: the exact next decision the manager should take

Rules:

- Worker responses must be concise and operational.
- Do not return long diary-style narration.
- Do not restate the entire prompt in the response.
- The manager is responsible for integration and final synthesis.

## Independent agent-review gate

Post-completion review requires an independent reviewer by default. The dedicated `agent-review` reviewer is pre-approved and must not be blocked by the general sub-agent minimization rules.

These packet rules apply only to delegated manager to reviewer communication for `agent-review` and its compatibility alias `agentic-self-review`. They do not replace the full human-facing review formats used by `general-review`, `pr-review`, or local fallback review.

Rules:

1. Spawn a dedicated reviewer using `agent-review` or the compatibility alias `agentic-self-review` for the mandatory post-completion gate.
2. Do not treat this reviewer as optional because of delegation-overhead heuristics, smallest-viable-execution preference, or conservative anti-parallelism rules.
3. Use the compact packet contract below. Do not send freeform narrative when the packet will do.
4. Tell the reviewer to act as the final reviewer and not to modify code.
5. Do not ask the reviewer to approve. Do not bias the verdict.
6. If the verdict is exactly `APPROVE`, the gate passes.
7. If the verdict is not exactly `APPROVE`, every finding is blocking.
8. Only the user may dismiss a disputed finding.
9. Fix blockers, rerun affected validation, and repeat the review gate.
10. If sub-agent review cannot run because runtime or user constraints actually prevent it, use a documented local fallback review and record the exact constraint.
11. If the reviewer path is unavailable, request approval for the documented local fallback once, wait up to 90 seconds for the delegation path to recover, and then use the fallback only if the same constraint still applies. Record the wait window and the exact reason the reviewer was unavailable.

### Manager to reviewer packet contract

Use tagged markdown sections in this exact order. Keep the packet compact and operational.

Required sections:

1. `# Mode`
2. `# Intent Source`
3. `# Task`
4. `# Repo Root`
5. `# Review Target`
6. `# Governing References`
7. `# Acceptance Basis`
8. `# Changed Scope`
9. `# Validation Digest`
10. `# Review Focus`

Section rules:

- `# Mode`: must state `agent-review` or `agentic-self-review`.
- `# Intent Source`: if a spec exists, include the exact spec path and the accepted plan or task files when they matter. If the work was prompt-driven, include the original prompt or a compact faithful summary with the actual goal and concrete specifics. Missing or selectively framed intent is invalid and must produce `BLOCK`.
- `# Task`: one short paragraph or up to 3 bullets describing what was completed and what the reviewer is verifying now.
- `# Repo Root`: single path only.
- `# Review Target`: state whether the reviewer should inspect changed files, diff, feature folder, or another bounded target.
- `# Governing References`: only the applicable spec, plan, task, repo-rule, or instruction references. Include `code-discipline` and `repo-standards-enforcement` when code changes are in scope and those checks are relevant.
- `# Acceptance Basis`: only the completion claims or contracts that the review must verify.
- `# Changed Scope`: up to 12 bullets listing the main changed files or bounded areas.
- `# Validation Digest`: up to 10 entries. For each entry include command identity and outcome. Include raw output only for failing or disputed commands.
- `# Review Focus`: up to 8 bullets calling out disputed, risky, or easy-to-miss areas.

Do not include:

- prior blocker history
- long narrative summaries
- repeated repository context
- full raw validation logs unless a command failed or the failure is under review
- a separate `current facts` section

Manager packet requirements:

- Do not dump unrelated repo context into the review prompt.
- Do not omit known failures, disputed areas, incomplete validation, or material evidence used to justify completion.
- Prefer file paths, commands, and bounded claims over narrative explanation.
- Keep the packet complete enough for integrity, but compressed enough to avoid waste.

### Reviewer to manager packet contract

Use tagged markdown sections in this exact order.

For approval:

1. First line exactly `APPROVE`
2. `# Coverage` with up to 3 bullets
3. `# Findings` with the single bullet `- none`

For a blocking review:

1. First line exactly `BLOCK`
2. `# Coverage` with up to 3 bullets
3. `# Findings` containing only blocker entries

Each blocker entry must use this fixed field set:

- `id`: short stable identifier such as `B1`
- `type`: one of `correctness`, `contract`, `validation`, `docs-truth`, `architecture`, `repo-rules`, `tests`
- `location`: file path required, line references when confidently available
- `issue`: the defect stated directly
- `required_fix`: the minimum corrective action required before approval

Reviewer response requirements:

- Do not restate the full manager packet.
- Do not emit severity summaries, risk sections, architecture essays, or action buckets in delegated `agent-review`.
- If the packet is materially incomplete, selectively framed, or missing required governing references, return `BLOCK` with `type: contract` or `type: repo-rules`.
- Treat every finding as blocking regardless of category.
- Keep coverage factual and bounded.
- Keep findings operational and remediation-oriented.

## Management evaluation file

Use `.agents/evaluations/management.json` as a rolling compressed management record.

Keep these top-level keys:

- `version`
- `lastCompressedAt`
- `agentTypes`
- `promptPatterns`
- `recentRuns`
- `repoLearnings`

Expected run fields:

- `timestamp`
- `mode`
- `agentType`
- `promptPattern`
- `task`
- `delegationShape`
- `outcome`
- `failureClass`
- `causeAttribution`
- `tokenRoi`
- `managerDecision`
- `notes`

Suggested enums:

- `delegationShape`: `solo`, `scout`, `single-writer`, `parallel-writers`, `review-only`, `mixed`
- `outcome`: `good`, `mixed`, `bad`
- `failureClass`: `none`, `scope-control`, `validation-miss`, `repo-rules-miss`, `design-miss`, `over-delegation`, `under-specified-prompt`, `integration-churn`
- `causeAttribution`: `none`, `prompt-pattern`, `agent-type`, `context-packaging`, `task-selection`, `manager-integration`
- `tokenRoi`: `positive`, `neutral`, `negative`
- `managerDecision`: `reuse`, `adjust-prompt`, `restrict-agent`, `decommission-pattern`, `decommission-agent`, `reinstate-agent`

Compression rules:

- keep aggregate counters per agent type and prompt pattern
- keep at most 20 entries in `recentRuns`
- compress when adding a new entry would exceed the limit
- roll repeated issues into `repoLearnings`
- keep `repoLearnings` limited to durable rules, not anecdotal run history
- delete stale detail that no longer changes delegation decisions

## Decommissioning policy

Decommissioning is progressive.

Rules:

- adjust prompt patterns before restricting agent types unless evidence clearly points to agent unsuitability
- first decommission the prompt pattern when repeated failures point to communication or framing problems
- decommission an agent type only after alternate prompt patterns fail to recover quality
- an agent type may be reinstated when evidence shows the prompt pattern or task shape caused the earlier failure
- document the evidence behind every restriction, decommission, or reinstatement

## Learning storage

Use split scope for recurring learnings:

- repo-specific learnings remain in `.agents/evaluations/management.json`
- cross-repository learnings go to `~/.agents/learnings/sub-agent-management.md`

Keep both compressed.

Rules:

- keep only durable, reusable rules
- merge duplicates aggressively
- convert repeated failures into one stronger rule instead of appending more examples
- keep cross-repository learnings compressed and deduplicated
- do not store anecdotal run history in cross-repository learnings

## Code-writing preflight

Before a code-writing worker edits code:

1. inspect the relevant repository rules, standards skills, validation configuration, and validation scripts
2. resolve the minimal validation command set
3. include that plan in the worker prompt

Do not run a full repo preflight by default. Expand scope only when shared configs, shared contracts, or cross-cutting changes require it.
