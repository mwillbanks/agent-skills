# Architecture Implementation

Use this when implementation requires architecture-level decisions and reusable boundaries.

## Prompt

Execute this task in `architecture` mode.

Requirements:
1. Define architecture decisions before coding where needed.
2. Prefer reusable modules/components over one-off local hacks.
3. Document key tradeoffs and constraints.
4. Implement concrete code, not architecture prose only, when feasible.
5. Update docs/ADR notes for meaningful architecture changes.
6. Validate that implementation and architecture remain aligned.
7. After stating completion, run `agentic-self-review` and fix obvious safe issues before concluding.

Deliver:
- Decision summary
- Implementation summary
- Files changed
- Validation results
- Docs updated
