# Execution Workflow

## Overview

This workflow applies only after the eligibility gate confirms that Speckit is the intended repository workflow.

The management agent owns continuity, validation, remediation, and artifact history across the entire Speckit flow.

Subagents may execute the individual skills, but they do not own workflow correctness.
The management agent does.

## Sequence

1. Amend constitution
2. Create specification
3. Run clarification loop
4. Generate implementation plan
5. Generate tasks
6. Run analyze loop
7. Return final summary

When reworking an existing feature, update the existing spec artifacts in place and preserve prior completed work unless no valid artifact exists to amend.

## Step expectations

### 1. Amend constitution

Purpose:

* ratify any new standing rules needed for this class of feature
* prevent future implementations from drifting or repeating mistakes

Validate:

* necessity
* scope
* durability
* versioning impact
* template impact
* alignment with feature intent

### 2. Create specification

Purpose:

* define the feature clearly enough to plan and implement

Validate:

* user stories
* requirements
* acceptance criteria
* non-goals
* boundaries
* interfaces
* implementation readiness

### 3. Clarification loop

Purpose:

* eliminate ambiguity before planning

Validate after each round:

* specification completeness
* ambiguity reduction
* consistency with prior decisions
* readiness for planning

### 4. Generate plan

Purpose:

* create an implementation-ready technical plan

Validate:

* architecture
* sequencing
* file impact
* contract changes
* migration considerations
* testing strategy
* operational safety
* implementation readiness

### 5. Generate tasks

Purpose:

* convert plan into executable ordered work

Validate:

* correct dependency order
* completeness
* test and validation coverage
* practicality for implementation agents

### 6. Analyze loop

Purpose:

* find contradictions, incompleteness, drift, weak assumptions, and execution risk

Validate:

* every issue was remediated
* remediation did not introduce new drift
* artifacts remain consistent after edits

### 7. Final summary

Purpose:

* communicate what changed and why
* make downstream execution easier

## Mandatory management behavior

* every step is blocked on validation
* weak output must be remediated before continuing
* clarification decisions should be made decisively when context supports them
* existing spec artifacts must be amended in place during rework rather than replaced
* analysis findings must be fully remediated, not merely noted
