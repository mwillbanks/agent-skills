# Modes

## Purpose

This file defines how to choose between `iterate` and `direct` modes and how to behave in each after the eligibility gate confirms that Speckit is the intended workflow.

## Iterate mode

Use iterate mode when the user wants to think through the feature before execution.

Signals:

* brainstorm
* iterate
* talk through
* pressure test
* shape the feature
* discuss first
* refine before running

### Iterate mode goals

* sharpen the feature
* expose missing constraints
* recommend stronger boundaries
* identify what must change and what must not change
* build a high-confidence feature foundation

### Iterate mode required output structure

Each iteration should include:

1. refined interpretation of the feature
2. recommendations
3. draft implementation-oriented foundation
4. selectable choice table

Required choice table columns:

- `Choice`
- `Name`
- `Reasoning`
- `Recommended`

Required option names:

- `Execute feature specification process`
- `Continue iterating (type what you want)`

You may add additional lettered rows or `Other` when useful, but the two required option names must always be present.

Mark exactly one recommended row with the green checkbox emoji `✅`.

## Direct mode

Use direct mode when the user wants immediate execution.

Signals:

* just do it
* go straight through Speckit
* generate the full workflow
* no iteration
* direct mode
* figure out the rest

### Direct mode goals

* infer what is missing without unnecessary back and forth
* construct the foundation immediately
* execute the workflow with strong management oversight
* preserve and update existing spec artifacts on rework instead of replacing them
* keep clarification bounded to a 3 to 10 round window when direct mode still needs ambiguity resolution

## Defaulting behavior

If no mode is specified, default to iterate mode.

## Switching behavior

You may switch from iterate to direct only when the user chooses:

`Execute feature specification process`

Do not implicitly switch earlier.
