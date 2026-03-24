# PR Review

Use this when you need a GitHub pull request reviewed against the stated intent and changed behavior.

## Prompt

Perform a `pr-review` pass.

Requirements:
1. Require a PR link.
2. Pull the PR diff and stated intent through GitHub MCP.
3. Review against correctness, architecture impact, regression risk, and test coverage.
4. Record candidate inline comments and suggestions in the review artifact.
5. Submit the final review state through GitHub MCP: `approved`, `changes-requested`, `comment`, or `rejected`.
6. On re-review, mark which prior findings were resolved before adding new findings.

Output:
- Review verdict
- Prioritized findings
- GitHub inline comment plan
- Final PR review state
- Residual risks