# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, Cursor, Copilot, etc.) when working with code in this repository.

## Repository Overview

A collection of skills for AI Agents (codex, copilot, claude, etc). Skills are packaged instructions and scripts that extend AI agent capabilities.

This repository also maintains spec-driven delivery artifacts under `.specify/`. When work is governed by a feature spec, update the existing spec, plan, and task artifacts in place rather than replacing them and erasing prior completed context.

## Creating a New Skill

### Directory Structure

```text
.agents/
  skills/
    {skill-name}/
      SKILL.md
      evals/                  # Recommended when behavior should be regression tested
        evals.json
      scripts/                # Optional executable helpers
        {script-name}.sh
      references/
        {reference-name}.md   # Optional progressive-disclosure references

.specify/
  constitution.md
  features/
    {feature-id}/
      feature-foundation.md
      spec.md
      plan.md
      tasks.md
      findings-closure.md
      validation.md
      review.md
      traceability.md
      post-mortem.md
```

### Naming Conventions

- **Skill directory**: `kebab-case` (e.g., `vercel-deploy`, `log-monitor`)
- **SKILL.md**: Always uppercase, always this exact filename
- **Scripts**: `kebab-case.sh` (e.g., `deploy.sh`, `fetch-logs.sh`)
- **Eval file**: `evals/evals.json` when the skill has objective or semi-objective behavior that should be regression tested
- **Zip file**: Must match directory name exactly: `{skill-name}.zip`

### SKILL.md Format

```markdown
---
name: {skill-name}
description: {One sentence describing when to use this skill. Include trigger phrases like "Deploy my app", "Check logs", etc.}
---

# {Skill Title}

{Brief description of what the skill does.}

## How It Works

{Numbered list explaining the skill's workflow}

## Usage

```bash
bash /mnt/skills/user/{skill-name}/scripts/{script}.sh [args]
```

**Arguments:**
- `arg1` - Description (defaults to X)

**Examples:**
{Show 2-3 common usage patterns}

## Output

{Show example output users will see}

## Present Results to User

{Template for how Claude should format results when presenting to users}

## Troubleshooting

{Common issues and solutions, especially network/permissions errors}
```

### Best Practices for Context Efficiency

Skills are loaded on-demand — only the skill name and description are loaded at startup. The full `SKILL.md` loads into context only when the agent decides the skill is relevant. To minimize context usage:

- **Keep SKILL.md under 500 lines** — put detailed reference material in separate files
- **Write specific descriptions** — helps the agent know exactly when to activate the skill
- **Use progressive disclosure** — reference supporting files that get read only when needed
- **Prefer scripts over inline code** — script execution doesn't consume context (only output does)
- **File references work one level deep** — link directly from SKILL.md to supporting files
- **Add eval coverage when the skill behavior should be regression checked**
- **Do not stop at eval definitions** — when using `skill-creator` or doing repo skill work without an explicit user opt-out, `evals/evals.json` is only the setup step. You must continue into the run-and-evaluate loop, surface results to a human with `eval-viewer/generate_review.py` when the environment supports it, and iterate before calling the skill update evaluated.

### Mandatory Skill Evaluation Loop

For new or materially changed skills with objective or semi-objective behavior:

1. Write or update `evals/evals.json`.
2. Run the test cases, including the correct baseline path when the environment supports it.
3. Generate the review viewer with `eval-viewer/generate_review.py` before revising the skill.
4. Collect or read human feedback.
5. Improve the skill and repeat as needed.

`evals/evals.json` by itself is not evidence that the skill was evaluated.
If this loop is skipped, the agent must record the exact user opt-out or environment blocker.

### Script Requirements

- Use `#!/bin/bash` shebang
- Use `set -e` for fail-fast behavior
- Write status messages to stderr: `echo "Message" >&2`
- Write machine-readable output (JSON) to stdout
- Include a cleanup trap for temp files
- Reference the script path as `/mnt/skills/user/{skill-name}/scripts/{script}.sh`

### Creating the Zip Package

After creating or updating a skill:

```bash
cd skills
zip -r {skill-name}.zip {skill-name}/
```

### End-User Installation

Document these two installation methods for users:

```bash
cp -r .agents/skills/{skill-name} ~/.agents/skills/
# codex
cp -r .agents/skills/{skill-name} ~/.codex/skills/
# claude
cp -r .agents/skills/{skill-name} ~/.claude/skills/
```
