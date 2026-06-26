# Re-Review And Verdicts

## Review states

### approved

Use only when:

- no open `P0`, `P1`, `P2`, or `P3` finding remains unless the PR author explicitly acknowledged and deferred it and the reviewer judges that deferral safe
- prior blocking findings are resolved
- the diff still matches the intended behavior
- the test and validation story is credible

### changes-requested

Use when any blocker remains. This is the default for unresolved P0 or P1 findings and for substantial P2 issues that make the PR materially weaker or harder to own.

### comment

Use when the PR can merge but still has non-blocking issues, design notes, or future-facing cleanup recommendations.

If the PR direction is fundamentally unacceptable, still use `changes-requested` and say that directly in the review body and inline findings. GitHub review submission does not support a separate rejected state.

## Re-review workflow

On a later pass:

1. fetch existing review threads or prior findings
2. verify each previously blocking issue against the latest diff
3. mark what is resolved before introducing new findings
4. only downgrade severity when the new diff truly changes the risk

Do not ignore unresolved older blockers because the author pushed more commits.

## Approval discipline

- One unresolved blocker means no approval.
- Open `P4` items may remain on an approval path; open `P0` through `P3` items do not.
- A good direction with bad execution is still `changes-requested`.
- Briefly acknowledge strong improvements when a re-review materially fixed prior defects.
- Do not turn approval into encouragement. Approval means the PR is acceptable to merge.