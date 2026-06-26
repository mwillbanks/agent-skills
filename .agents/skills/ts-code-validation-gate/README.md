# ts-code-validation-gate

Maintainer documentation for the `ts-code-validation-gate` skill.

> Runtime usage guidance for agents is intentionally kept in `SKILL.md`.
> Eval and measurement guidance lives here.

## Runtime command (agent execution)

```bash
bash /mnt/skills/user/ts-code-validation-gate/scripts/run-gate.sh
```

Optional repository root override:

```bash
bash /mnt/skills/user/ts-code-validation-gate/scripts/run-gate.sh /path/to/repo
```

## Fallow bootstrap behavior

`run-gate.sh` now handles common fallow setup failures:

- If `fallow` is not on PATH, it attempts `bunx`, `npx`, `pnpm dlx`, or `yarn dlx`.
- If neither `fallow.toml` nor `.fallowrc.json` exists, it runs `fallow init` before audit.

## Eval / measurement workflow

Eval assets are for skill measurement and iteration quality, not for runtime agent behavior.

- Eval definitions: `evals/evals.json`
- Eval runner: `scripts/run-evals.sh`
- Python harness: `scripts/run-evals.py`

Run:

```bash
bash .agents/skills/ts-code-validation-gate/scripts/run-evals.sh
```

Expected model coverage includes:

- `gpt-5.5`
- `gpt-5.4-mini`

## Viewer generation

Generate a static review page for a results iteration:

```bash
python3 .agents/skills/skill-creator/eval-viewer/generate_review.py \
  .agents/skills/ts-code-validation-gate/evals/results/iteration-<N> \
  --skill-name ts-code-validation-gate \
  --benchmark .agents/skills/ts-code-validation-gate/evals/results/iteration-<N>/benchmark.json \
  --static .agents/skills/ts-code-validation-gate/evals/results/iteration-<N>/review.html
```

## Packaging

```bash
cd .agents/skills
zip -r ts-code-validation-gate.zip ts-code-validation-gate/
```

## Installation paths

```bash
cp -r .agents/skills/ts-code-validation-gate ~/.agents/skills/
# codex
cp -r .agents/skills/ts-code-validation-gate ~/.codex/skills/
# claude
cp -r .agents/skills/ts-code-validation-gate ~/.claude/skills/
```
