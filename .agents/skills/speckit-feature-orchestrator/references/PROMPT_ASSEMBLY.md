# Prompt Assembly

## Goal

Construct strong prompts for the management-agent execution process using the feature foundation as the source of truth.

## Placeholder assembly

### `{{FEATURE_NAME}}`

Use a short, implementation-oriented name.
It should be specific enough to identify the feature unambiguously.

### `{{FEATURE_CONTEXT}}`

This is the highest value context block.
It should include:

* what the feature is
* why it matters
* current behavior
* what must change
* what must not change
* architectural recommendations
* API or interface guidance
* UX guidance where relevant
* performance and safety guidance
* repository-specific implementation hints
* testing expectations
* assumptions already resolved by management judgment

### `{{CONSTITUTION_AMENDMENT_PROMPT}}`

Write this as a concrete amendment request.
It should:

* explain the class of feature
* explain why constitutional reinforcement is needed
* state the desired standing rule changes
* avoid vague or ceremonial wording
* focus on future enforcement value

### `{{SPECIFY_PROMPT}}`

Write this to produce a strong feature specification.
It should:

* encode explicit requirements
* define boundaries and non-goals
* define acceptance criteria
* call out interface, UX, or API expectations as needed
* keep the feature stable and implementable

### `{{PLAN_PROMPT}}`

Write this to produce an implementation-ready plan.
It should:

* constrain architecture to repository norms
* require file-level and contract-level thinking where appropriate
* require testing strategy
* require migration and operational considerations when relevant
* avoid open-ended exploration unless the feature actually requires it

### `{{CLARIFY_MAX_ROUNDS}}`

Default to `3`.
Increase only when the feature is unusually ambiguous and additional rounds are justified.

## Prompt quality rules

Prefer:

* explicit constraints
* deterministic behavior
* concrete requirements
* testable acceptance criteria
* strong non-goals
* repository-aware guidance

Avoid:

* vague aspirations
* broad exploration language
* implied requirements without boundaries
* prompts that allow drift into unrelated refactors

## Output expectation

The assembled management prompt should be ready to run without further interpretation.
