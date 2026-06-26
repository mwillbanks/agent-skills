---
name: ts-code-validation-gate
description: Evaluates completed TypeScript changes before review using a fail-closed evidence gate across formatting/linting, unit tests, semgrep, osv-scanner, and fallow, and blocks new review attempts until prior remediation-ledger items are fully resolved.
license: Apache-2.0
metadata:
  author: Mike Willbanks
  repository: https://github.com/mwillbanks/agent-skills
  homepage: https://github.com/mwillbanks/agent-skills
  bugs: https://github.com/mwillbanks/agent-skills/issues
  purpose: Pre-review code validation gate with remediation lock discipline
---

# TS Code Validation Gate

Use this skill after implementation appears complete and before code review.

This skill enforces a single-pass evidence capture workflow across quality, test, and security checks, then blocks review if unresolved findings remain.

## When to use

Use this skill when prompts imply:

- “final check before review”
- “run validation gate”
- “collect lint/test/security evidence before PR review”
- “fail closed until remediation is complete”
- “do one pass and tell me what still blocks review”

## What this gate does

1. Ensures `.agents/.code-validation-gate/` is ignored via `.git/info/exclude`.
2. Creates a timestamped run folder:
   - `.agents/.code-validation-gate/YYYY-MM-DD_HHMMSS/`
3. Runs checks in one pass and writes evidence files:
   - Formatting/linting auto-detection:
     - Biome when `biome.json` or `biome.jsonc` exists at project root
     - ESLint when root `eslint` config exists
     - Prettier when root prettier config exists
   - Unit tests (bail first, failures-focused)
   - Semgrep auto scan
   - osv-scanner recursive scan
   - fallow compact audit with fail-on-issues
4. Emits machine-readable status JSON.
5. If any check fails, creates `remediation-ledger.md` and `needs-remediation.flag`.
6. On the next run, fails closed if the most recent unresolved ledger still contains unchecked items (`- [ ]`).

## Required execution command

```bash
bash /mnt/skills/user/ts-code-validation-gate/scripts/run-gate.sh
```

Optional repository root override:

```bash
bash /mnt/skills/user/ts-code-validation-gate/scripts/run-gate.sh /path/to/repo
```

## Evidence artifacts

The run folder contains:

- `status.json`
- `results.tsv`
- `biome.txt` (if biome detected)
- `eslint.json` (if eslint detected)
- `prettier.txt` (if prettier detected)
- `tests.txt`
- `semgrep.json`
- `osv.md`
- `fallow.txt`
- `remediation-ledger.md` (only when failures exist)
- `needs-remediation.flag` (only when failures exist)

## Remediation policy (fail closed)

- Any failing check is blocking for review readiness.
- The agent must remediate findings and update checklist items in `remediation-ledger.md` to `- [x]`.
- If a prior run remains unresolved, future runs fail closed and a new review is invalid.

## Agent output contract

When reporting gate results, always provide:

- overall gate state: `pass`, `fail`, or `fail-closed`
- run directory path
- failed checks list
- exact evidence file paths
- remediation ledger path when present
- explicit statement about whether review is currently valid

## Maintainer notes

Skill measurement guidance (including eval workflows) is documented in `README.md` in this skill directory, not in runtime agent instructions.

## Reference

Read `references/gate-contract.md` when you need exact behavior and failure semantics.
