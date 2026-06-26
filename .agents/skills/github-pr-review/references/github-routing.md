# GitHub Routing

Use the highest-fidelity interface available in this order:

1. GitHub remote MCP
2. local or Docker GitHub MCP
3. local git inspection for confirmation and fallback diff reading
4. `gh` CLI

## Required collection order

Before drafting review comments, gather all of the following:

1. repository owner and name
2. PR number
3. PR title and description
4. stated intent or claimed behavior change
5. head commit SHA
6. changed files list
7. full unified diff
8. existing review threads when doing re-review

Do not comment from a partial diff.

## MCP-first workflow

When GitHub MCP is available, prefer native pull request tools that can:

- fetch PR metadata
- fetch the unified diff
- fetch review threads or existing comments
- create a pull request review with batched comments

Use the review-creation capability to submit exactly one review event per pass unless the platform rejects the payload.

## Local git confirmation

If you need to verify the diff locally, use the merge base between the target branch and the PR head rather than a naive `HEAD~1` comparison.

Preferred local checks:

- `git diff <base>...<head>`
- `git diff --name-only <base>...<head>`
- `git show <head> --stat`

Use local git as supporting evidence, not as a substitute for GitHub review context when GitHub access exists.

## gh CLI fallback

If MCP is unavailable, use `gh`.

Core commands:

```bash
gh pr view <PR_NUMBER> --repo <OWNER>/<REPO> --json number,title,body,headRefOid,baseRefName,headRefName
gh pr diff <PR_NUMBER> --repo <OWNER>/<REPO>
gh api repos/<OWNER>/<REPO>/pulls/<PR_NUMBER>/reviews
```

If the review payload is complex, write JSON to a local file and submit it through `gh api` rather than trying to shell-escape multiline bodies.

For file-level comments, the payload shape depends on the interface:

- MCP-native payloads may use `subjectType: FILE`
- gh REST payloads must use `subject_type: file`

Do not send an MCP-shaped file comment payload through `gh api` unchanged.

## Submission rules

- Batch inline comments into a single review event.
- Use the latest head commit SHA when creating the review.
- Prefer `RIGHT` side comments on the new version of the file.
- File-level comments are valid only when no safe line anchor exists or the issue is file-wide.
- When the GitHub interface supports it, express file-wide comments with the platform's file-level subject field instead of faking a line anchor.

## Failure handling

If a higher-priority interface is unavailable:

- fall back immediately to the next interface
- do not stop the review unless all GitHub-capable paths fail
- report the fallback in the final user message

If all GitHub-capable paths fail, provide the prepared review payload and say the submission step was blocked by tooling access, not by review completion.