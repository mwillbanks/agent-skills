---
name: github-pr-review
description: Review GitHub pull requests directly in GitHub using GitHub MCP or gh, leave precise inline comments and final review states, and apply hard-nosed scrutiny for security, architecture, maintainability, testing, accessibility, and frontend compliance. Use whenever the user asks to review a PR, inspect a GitHub pull request, request changes, re-review a PR, post inline review comments, or submit a GitHub review instead of a local-only code review.
license: Apache-2.0
compatibility: Best with GitHub MCP access or gh CLI plus local git access for diff verification.
metadata:
  author: Mike Willbanks
  repository: https://github.com/mwillbanks/agent-skills
  homepage: https://github.com/mwillbanks/agent-skills
  bugs: https://github.com/mwillbanks/agent-skills/issues
  purpose: GitHub-native human PR review with strict engineering standards and batched review submission.
---

# GitHub PR Review

Use this skill when the review must happen inside GitHub itself.

This is not a local review-note skill. It is for reading a pull request, mapping defects to the real diff, posting a review in a human voice, and selecting the correct GitHub review state.

The review should read like a direct human reviewer:

- blunt
- specific
- concise
- unsentimental
- briefly positive only when something is genuinely strong

Do not write like an automated assistant. Do not use filler. Do not post a decorative summary.

## When to use

Use this skill for prompts like:

- "review PR 482"
- "request changes on this GitHub PR"
- "leave inline comments on the pull request"
- "re-review the open findings on this PR"
- "check the GitHub diff and submit the review"
- "review this PR against the stated intent"

Use it whenever the output must be a GitHub review event rather than a local markdown artifact.

## Core posture

- Review against intent, behavior change, and regression risk, not just diff mechanics.
- Treat security, correctness, maintainability, and architecture as higher priority than code style.
- Treat API layer abuse, database anti-patterns, and runtime health issues as first-class review targets.
- Treat missing tests for critical behavior as a real defect.
- Treat skipped validation, hidden risk, or misleading PR framing as a real defect.
- For frontend work, enforce accessibility, semantic HTML, framework compliance, reusable component boundaries, and zero inline styling shortcuts.
- For backend and cloud-facing work, enforce ingestion-only API boundaries, async worker or event-driven offloading for heavy workflows, Postgres-safe query patterns, and runtime-safe concurrency.
- If something is good, note it briefly and move on.

## Mandatory workflow

1. Resolve the best available review interface using [github-routing.md](./references/github-routing.md).
2. Capture the PR intent, head commit SHA, changed files, and the complete unified diff before drafting comments.
3. Review the change using [review-standards.md](./references/review-standards.md).
4. Classify each finding using [findings-and-comment-shape.md](./references/findings-and-comment-shape.md).
5. Build one batched review payload. Do not drip comments one by one.
6. Use [review-body-template.md](./assets/review-body-template.md) for the overall review body, [comment-payload-examples.json](./assets/comment-payload-examples.json) for MCP-native payload shapes, and [comment-payload-examples-gh.json](./assets/comment-payload-examples-gh.json) for gh REST payload shapes.
7. If you assemble a payload locally, run [validate-review-payload.ts](./scripts/validate-review-payload.ts) against it in the correct mode before submission.
8. Submit the review once with the correct GitHub review state.
9. For re-review, use [re-review-and-verdicts.md](./references/re-review-and-verdicts.md) before deciding whether older findings are resolved.

## Non-negotiable rules

- Do not approve a PR with an unresolved blocker.
- Do not post review comments without first checking the full diff and stated intent.
- Do not target unchanged lines for inline comments.
- Do not use relative hunk offsets when the API expects absolute target lines.
- Do not use `suggestion` blocks in file-level comments.
- Do not post vague comments that lack the defect, the impact, or the required correction.
- Do not soften critical defects into preference language.
- Do not turn architecture, security, accessibility, or test gaps into nits.
- Do not ignore repeated patterns across files just because the diff is large.
- Do not let frontend styling hacks through because "it works."
- Do not use inline styles.
- Do not accept ad hoc style props or `sx` shortcuts when a styled extension or shared component boundary is the correct fix.
- Do not invent one-off UI primitives when an existing framework or shared component should be extended.

## Review state selection

- `changes-requested`: use when the PR should not merge as-is because of blockers. Any open `P0`, `P1`, `P2`, or `P3` finding blocks approval by default.
- `comment`: use when the PR has non-blocking issues, questions, or future-facing recommendations.
- `approved`: use only when no blocker remains and the changed behavior is acceptable. Open `P4` items are the only findings that may remain on an autonomous approval path unless the PR author has explicitly acknowledged and deferred a higher-severity item and the reviewer judges that deferral safe.

For fundamentally unacceptable PRs, still use `changes-requested` and say directly that the current direction is not acceptable in the review body and inline findings.

State selection details and re-review expectations live in [re-review-and-verdicts.md](./references/re-review-and-verdicts.md).

## Required review content

Each real finding must be specific about:

- what is wrong
- why it matters
- what level of issue it is
- what should change

Use the exact title format and category scheme defined in [findings-and-comment-shape.md](./references/findings-and-comment-shape.md).

## Frontend and UI enforcement

For React, component systems, or UI-heavy PRs, read [review-standards.md](./references/review-standards.md) before writing comments.

Apply all of the following:

- accessibility defects are real defects
- semantic HTML and keyboard access matter
- framework misuse is a defect
- inline styling is a defect
- hardcoded one-off visual values are a defect when a shared token or component should own them
- shared UI concerns should move into a reusable component or styled extension, not copied into page files

Apply the same rigor to backend and API-heavy PRs:

- the API layer should ingest, validate, and orchestrate, not execute heavy external workflows inline
- Postgres and ORM code should be judged on the database plan it implies, not on whether the code looks tidy
- async code should be judged on runtime safety, bounded concurrency, and job durability, not just syntax

## Final response to the user

After posting the GitHub review, report only the essentials:

- final review state
- count of inline comments posted
- the main blockers or risks that drove the decision
- any reason the review had to fall back to a lower-priority interface

Keep that response tight. The substantive review belongs on the PR.

## References

- [github-routing.md](./references/github-routing.md)
- [findings-and-comment-shape.md](./references/findings-and-comment-shape.md)
- [review-standards.md](./references/review-standards.md)
- [re-review-and-verdicts.md](./references/re-review-and-verdicts.md)
- [review-body-template.md](./assets/review-body-template.md)
- [comment-payload-examples.json](./assets/comment-payload-examples.json)
- [comment-payload-examples-gh.json](./assets/comment-payload-examples-gh.json)
- [validate-review-payload.ts](./scripts/validate-review-payload.ts)