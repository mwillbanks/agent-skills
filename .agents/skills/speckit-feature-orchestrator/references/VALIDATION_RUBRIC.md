# Validation Rubric

Use this rubric after every major phase.

## Universal checks

Every artifact must be checked for:

* alignment with original feature intent
* alignment with current repository constraints
* alignment with constitution and amendments
* preservation of existing spec history when the work is a rework
* completeness for the current phase
* internal consistency
* technical feasibility
* safety and boundary compliance
* readiness for the next phase
* absence of scope drift

## Constitution amendment checks

* Is the amendment actually needed?
* Does it create stable guidance rather than feature-specific clutter?
* Does it strengthen future implementation quality?
* Does it remain aligned with repository direction?

## Specification checks

* Are requirements testable?
* Are non-goals explicit enough to prevent drift?
* Are acceptance criteria concrete?
* Are interface implications documented?
* Is the feature framed clearly enough for planning?

## Clarification checks

* Did the round reduce ambiguity materially?
* Were decisions grounded in context rather than speculation?
* Does the updated spec remain coherent?
* Is further clarification genuinely needed?

## Plan checks

* Is architecture consistent with repository patterns?
* Is sequencing realistic?
* Are contracts and state changes identified?
* Are testing and migrations addressed?
* Can an implementation agent execute this without avoidable guesswork?

## Task checks

* Are tasks ordered correctly?
* Do tasks reflect the plan accurately?
* Are validations embedded where needed?
* Are tasks concrete enough to execute?

## Analyze remediation checks

* Was every issue resolved?
* Did fixes preserve original intent?
* Were existing artifacts amended in place rather than replaced when history needed to be preserved?
* Did remediation create contradictions elsewhere?
* Is the workflow now clean enough to hand to implementation?

## Failure rule

If any material check fails:

* stop
* remediate
* revalidate
* continue only after the artifact passes
