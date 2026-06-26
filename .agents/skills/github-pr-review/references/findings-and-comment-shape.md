# Findings And Comment Shape

Every posted review comment must start with this exact markdown title format:

```markdown
### **PX(CATEGORY): Title**
```

`PX` must be one of `P0`, `P1`, `P2`, `P3`, or `P4`.

## Priority and category model

### P0

- `P0(SECURITY)`
- `P0(SYSTEM)`
- `P0(COMPLIANCE)`

Use for merge-blocking defects such as:

- injection or auth bypass risk
- secrets exposure
- broken migrations
- destructive data handling
- raw regulated data logging
- CI or deploy integrity failures

### P1

- `P1(ARCHITECTURE)`
- `P1(RELIABILITY)`
- `P1(EFFICIENCY)`
- `P1(TESTING)`

Use for severe correctness or design failures such as:

- race conditions
- crash paths
- blocking work on the main request path
- unstable boundaries
- missing critical tests
- expensive loops or unbounded scans

### P2

- `P2(UI)`
- `P2(TECH-DEBT)`
- `P2(READABILITY)`

Use when the issue is materially wrong and should block autonomous approval, but it is not a security, architecture, or hard reliability defect.

### P3

- `P3(MAINTAINABILITY)`
- `P3(OPERABILITY)`
- `P3(CONSISTENCY)`

Use when the issue is still real enough to block autonomous approval by default, but the risk is narrower and more localized than a `P2` finding.

Use for meaningful maintainability or UX issues such as:

- inline styles
- leaky local abstractions
- hardcoded strings or tokens
- prop design that will not scale

### P4

- `P4(STYLE)`
- `P4(DOCS)`
- `P4(PREFERENCE)`

Use only for true low-priority nits that do not materially affect behavior, maintainability, or merge safety.

## Approval threshold

- Any open `P0`, `P1`, `P2`, or `P3` finding blocks approval by default.
- Open `P4` findings may remain on an approval path.
- If a higher-severity finding was explicitly acknowledged and deferred by the PR author, the reviewer may still choose not to block, but only when the residual risk is clearly acceptable.

## Anchoring rules

- Target added or modified lines whenever possible.
- Use absolute target-file line numbers, not hunk-relative offsets.
- Use `line` for the ending line of a range comment.
- Add `start_line` and `start_side` for range comments.
- Use file-level comments only for file-wide concerns or when no safe line anchor exists.

## Suggestion rules

- Suggestion blocks are allowed only for line or range comments.
- Suggestion blocks must represent a deterministic correction.
- Do not attach a suggestion block to a file-level comment.
- Do not offer a suggestion when the correct fix requires broader design work or context not visible in the diff.

## Comment body rules

After the title line, keep the body direct:

1. state the defect
2. state the impact
3. state the required correction

Do not bury the point in preamble.

## Structural examples

See [comment-payload-examples.json](../assets/comment-payload-examples.json) for MCP-native payload shapes and [comment-payload-examples-gh.json](../assets/comment-payload-examples-gh.json) for gh REST payload shapes.