---
name: code-discipline
description: Prevent trivial helpers, wrapper layers, rename-only utilities, duplicate constants, and local reinvention. Enforce reuse of platform primitives, framework capabilities, shared utilities, and proven libraries. Use when adding or reviewing helper sprawl, object-vs-positional parameter decisions, arrow-vs-declaration choices, class-vs-functional design, god-file boundaries, schema-file boundaries, security/maintainability hardening, or UI structure so the agent keeps code disciplined and avoids technical debt.
license: Apache-2.0
metadata:
  author: Mike Willbanks
  repository: https://github.com/mwillbanks/agent-skills
  homepage: https://github.com/mwillbanks/agent-skills
  bugs: https://github.com/mwillbanks/agent-skills/issues
---

# Code Discipline

Use this skill whenever a task involves adding or modifying logic, helper sprawl, unnecessary wrappers, duplicate utilities, duplicate constants, abstraction bloat, god files, schema boundaries, class-vs-composition choices, arrow-vs-declaration decisions, object-vs-positional parameter decisions, or security/maintainability hardening.

This is an anti-laziness skill. It prevents agents from "solving" tasks by inventing new files, helpers, and indirection when existing primitives already solve the problem. If a feature reveals a better boundary, refactor to it now when the change stays within current task scope and is justified by the Admission Gate below.

Default assumption:

- The user wants maintainable code with minimal abstraction surface area. When the feature exposes a clearly better boundary, take it now instead of preserving an inferior shape for diff size alone, including cases where short-term surface area increases are required to reduce long-term complexity and are justified by the Admission Gate.
- The user does not want renamed duplicates of existing behavior. Apply the same discipline to ORM schema boundaries, class inheritance, function signatures, and security-sensitive decisions.
- New helpers, wrappers, constants modules, and style-only indirection are disallowed unless justified by clear architectural value.
- These rules apply to abstractions, helpers, utilities, and indirection layers. New first-class domain files (for example, route handlers, entities, page components, test files) are governed by `repo-standards-enforcement`, not by the Admission Gate. Do not apply the Admission Gate to files whose primary purpose is domain logic rather than shared infrastructure.

## When to Use

Invoke this skill for:

- feature implementation that introduces new logic
- refactors that add utility or service layers
- UI changes where component-local helpers may proliferate
- frontend work where constants, tokens, or styled files may be needlessly split apart
- bug fixes that tempt quick wrapper-based patches
- code review focused on maintainability and reuse discipline

Use together with `agent-execution-mode` and `repo-standards-enforcement` for production implementation work.

If any reference file listed in this skill is unavailable, apply the rules stated inline in this document as the authoritative fallback, do not block progress waiting for missing references, and note unavailable references in the Output Contract report.
When all reference files are unavailable, the inline rules in this document are complete and sufficient. The reference files provide examples and elaboration only; no rule depends exclusively on a reference file to be actionable. Proceed using inline rules without degraded confidence.

## Core Enforcement Policy

This skill operates in enforcement mode. For Hard Rules, reject non-compliant code without negotiation. For Soft Rules, generate the written rationale in the Output Contract and proceed; do not solicit rationale from the user unless operating in interactive review mode.

Single decision flow for each candidate abstraction: (1) run Mandatory Evaluation Order steps 1-6 for reuse-first evaluation, (2) only if step 6 cannot be used, continue to step 7 and apply the New Abstraction Admission Gate allow/reject checks, and (3) after implementation, verify Definition of Done criteria.

### Hard Rules - never override

- Do not create a helper if the logic is trivial and used once.
- Do not create a wrapper that only forwards calls.
- Do not create renamed duplicates of existing utilities.
- Do not add service, hook, or adapter layers that add indirection unless at least one Admission Gate condition is satisfied and explicitly justified.
- Do not reimplement platform or standard library behavior.
- Do not duplicate utility logic across packages.
- Do not extract one-off constants into a module just to reduce line count.
- Do not create a `constants`, `helpers`, `utils`, or `shared` file unless ownership and reuse are real.
- Do not split styles into separate files when the styles are local and the split adds no ownership value.

Hard Rules are never contestable.

Rule precedence when rules conflict: (1) Hard Rules, (2) Monorepo and Workspace Rules, (3) Admission Gate decisions, (4) Feature-First Boundary Rules, (5) all remaining Soft Rules and domain-specific rules in order of specificity.

## Mandatory Evaluation Order

Before adding any helper, hook, service, wrapper, adapter, formatter, parser, transformer, constant module, token, or utility, evaluate in this exact order:

1. language or runtime primitives
2. standard library APIs
3. framework-native features
4. existing repository utilities
5. existing installed dependencies
6. if an existing utility partially covers the need, prefer adapting it at the call site (for example, composition or a thin adapter at the call site only) over creating a new shared abstraction; if multiple existing utilities each partially cover the need, prefer the one whose domain ownership most closely matches the call site, and if ownership is equal, prefer composition at the call site over adapting either one; if adapting the utility would change its public signature, alter behavior for any existing caller, or require callers outside the current task scope to update, continue to step 7 with explicit justification of why the partial match cannot be reused and document the composition/adaptation rationale in the Output Contract
7. new abstraction with justification

Skipping this order is non-compliant behavior.

For every candidate abstraction, execute this checklist in order: (1) complete the Mandatory Evaluation Order steps 1-7, (2) if step 7 is reached, apply the New Abstraction Admission Gate, and (3) after implementation, verify the Definition of Done criteria.

## New Abstraction Admission Gate

A new abstraction, helper, constant module, or shared style boundary is allowed only if at least one is true:

- it enforces domain invariants or policy
- it encapsulates logic that (a) exceeds a single expression in complexity, and (b) appears at 3 or more distinct call sites verbatim or near-verbatim, and (c) a future change to that logic would require editing each call site independently
- it isolates an infrastructure boundary
- it provides correctness, validation, or security guarantees
- it improves testability of genuinely complex behavior
- it creates a shared source of truth for a value that must stay synchronized across multiple consumers

A new abstraction is rejected if it only:

- renames existing behavior
- forwards calls one-to-one
- wraps a single primitive or single library call
- exists for style preference only
- hides a one-off literal that is clearer inline

## Feature-First Boundary Rules

Read `references/feature-refactor-first.md` when the change touches file layout, API shape, schema organization, or class-vs-composition choices. Use it when a feature reveals a better boundary and the work is still in scope for the current implementation. If `references/feature-refactor-first.md` is not available, prefer restructuring to the better boundary now only when the change stays within task scope, does not expand beyond the feature boundary, and is justified by the Admission Gate.

## Soft Rules - require written justification to override

Treat these as automatic scrutiny triggers:

- names starting with `normalize`, `format`, `parse`, `transform`, `sanitize`, `safe`, `to`
- names starting with `build`, `make`, `create`, `get`, `set`, `use`, or `manage` when they only wrap a single operation
- services whose entire public interface maps one-to-one to repository or SDK method signatures and add no error handling, policy, validation, or transformation beyond argument forwarding
- hooks that only call another hook and return the same shape
- helpers used once in a single file
- utility modules that only contain one-line wrappers
- constants modules with a single consumer
- style files that only move declarations without changing ownership or reuse

Smells are not always wrong, but they require explicit defense. When a Soft Rule applies, the agent must generate an explicit written rationale in the Output Contract before proceeding. If operating autonomously without user interaction, include the rationale inline and continue; do not block execution waiting for external approval. Hard Rules are never contestable.

## Component Logic Rules

- Keep simple display and one-off transformations inline.
- Extract only when complexity or reuse justifies extraction.
- Do not grow component files into local utility libraries.
- Move reusable logic to the correct shared layer, not the nearest file.
- Keep one-off constants inline unless they are part of a shared contract or repeated across files.
- Keep component-local styled declarations local unless repeated styling proves the need for a shared primitive.

## Constant Placement Rules

- Keep one-off literals near their use when that improves readability.
- Promote a constant only when it carries shared meaning, is reused, or is part of a public or cross-file contract.
- Do not create a module just to host a single constant.
- Do not move a literal into `const X = ...` if the new name adds no meaning.
- Put shared design tokens in the theme or design-system layer, not in page-local files.
- Put shared UI constants in the owning domain or shared layer, not in a convenience bucket.

## File and Style Organization Rules

- Keep helpers, constants, and styles in the narrowest correct owner.
- Prefer colocated component styles for component-local concerns.
- Prefer shared style primitives only when multiple components truly share them.
- Avoid generic catch-all folders that exist only to hide structure.
- Avoid re-export barrels that add no boundary or reuse value.
- Keep styled file names descriptive of ownership, not generic (`Button.styles.ts` is clearer than `styles.ts`).
- Split a styled file only when the split makes ownership, reuse, or maintenance clearer.
- Do not create a separate file for a tiny style fragment that is used once.

## Monorepo and Workspace Rules

- do not duplicate helpers across packages
- promote shared logic to the correct shared package when reuse exists
- do not import a utility from package A into package B if package B is not listed as a dependent of package A in the workspace dependency graph; if the boundary is unclear, ask before importing
- do not bypass boundaries through convenience imports
- do not apply deduplication or removal rules to files that are outputs of code generators (for example, ORM migrations, schema clients, or build artifacts); identify generated files by header comments, tool conventions, or generated/ and __generated__/ directories

## Review and Refactor Enforcement

When active in review/refactor mode, agents must:

- flag unnecessary helpers and wrappers
- remove trivial abstractions where safe
- consolidate duplicate utilities
- replace handwritten logic with platform/library primitives where appropriate
- explain each removal or consolidation with maintainability rationale

## Definition of Done

This skill is satisfied only when all are true:

- no newly introduced trivial helper/wrapper layers remain
- no duplicate utility logic remains in changed scope
- no one-off constants were extracted without a shared-meaning reason
- new abstractions (if any) are justified by the admission gate
- platform/framework/internal utilities were preferred over reinvention
- changed scope is simpler in long-term maintenance burden; short-term surface-area increases are allowed only when they are required by an in-scope better-boundary refactor justified by the admission gate

## Output Contract

When responding after this skill is used, report only the categories that are non-empty. In implementation mode, report on changes made in this task. In review mode, report on the submitted code under review. If no abstraction candidates were considered, omit that item. If no constants were kept inline, omit that item. Always report at least one item.

If no abstraction candidates were evaluated and no consolidations were performed, report: "No abstraction candidates were identified. Existing primitives were used directly with no new helpers introduced."

- what abstraction/helper candidates were considered
- what existing primitive/utility was reused
- what abstractions were rejected and why
- what consolidations/removals were performed
- any new abstraction added and which admission-gate condition allowed it
- where constants and styles were kept inline instead of being extracted
- which reference files were unavailable (if any)

## References

Use the reference guides for examples and elaboration:

- `references/helper-functions.md`
- `references/abstraction-patterns.md`
- `references/library-preference.md`
- `references/feature-refactor-first.md`
- `references/component-logic.md`
- `references/constants-and-organization.md`
