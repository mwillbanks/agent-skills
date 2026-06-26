# Feature-First Boundary Rules

Use these rules when the new work reveals that the current module shape, API shape, or schema layout is not the right one.

## Boundary signals

- Judge a god file by intent, ownership, and change cadence, not raw line count.
- A cohesive large domain aggregate can stay together if it has one owner and one lifecycle.
- Mixed concerns, split ownership, or unrelated change cadence are the real signals to split.
- For ORM schema files, keep table definitions, relation wiring, validation, and query or adapter logic in the layer that owns them.
- Do not bridge every schema concern into one feature file just because the feature touches them all.

## Refactor-first rule

- If the feature exposes a better boundary, take the better boundary now.
- Do not preserve a poor architecture only to reduce diff size.
- Prefer the change that lowers future complexity, bug risk, and security risk when it is still inside the task scope.

## Function shape rules

- Prefer arrow functions for local function values and callbacks by default.
- Use function declarations only when hoisting, named recursion, or module ergonomics make them clearer.
- Prefer object parameters when a function has multiple optionals, many booleans, or likely variance over time.
- Keep a small fixed positional signature when it is stable, obvious, and clearer than an options object.

## Composition over inheritance

- Prefer composition, higher-order functions, and closures over ES6 class inheritance when you are extending behavior.
- Use classes only when identity, lifecycle, or encapsulated mutable state is the real abstraction.

## Maintainability and security

- Prefer platform primitives and trusted libraries before custom code.
- When a safer library or primitive already exists, favor the safer path unless the custom code has a clearly stronger justification.
