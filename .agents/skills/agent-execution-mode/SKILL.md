---
name: agent-execution-mode
description: Parent-agent execution policy for implementation, validation, delegation, and mandatory code review orchestration through the code_review_ts sidecar.
license: Apache-2.0
metadata:
  author: Mike Willbanks
  purpose: Parent-agent execution mode and code-review orchestration contract
---

# Agent Execution Mode

Use this skill for parent-agent implementation workflows.

This skill defines how the parent agent plans, executes, validates, and delegates work, including the mandatory code-review handoff path.

## Code review orchestration (mandatory)

When a code review workflow is requested or required:

1. Do **not** use built-in review entrypoints:
   - `/review`
   - `codex review`
   - `codex exec review`
   - any equivalent wrapper.
2. Launch the `code_review_ts` sidecar defined in `agents/code-review-ts.toml`.
3. Provide complete context to the sidecar:
   - specification/acceptance criteria,
   - desired outcomes,
   - changed files and directly affected paths,
   - auth/privilege/architecture constraints.
4. Require the sidecar to execute `ts-code-validation-gate` before semantic review.
5. Treat gate failure as fail-fast: no semantic review pass is valid until the gate passes.
6. Require a single-pass, uncapped review result (P0 through nitpick) with all findings reported at once.
7. Require the `SubagentStop` coverage validator to approve transcript tool-call evidence before accepting the handoff.
8. After review, create and maintain a remediation document for all findings.
9. Resolve all remediation items before requesting another review pass.

## Parent ownership

The parent agent remains responsible for:

- final correctness and integration,
- remediation completion,
- final validation and status,
- user-facing communication.

Subagents assist; they do not own completion.
