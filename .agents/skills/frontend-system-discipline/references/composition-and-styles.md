# Composition and Styles Discipline

Use these rules when frontend code starts growing helper layers, wrapper components, or style files that do not clearly improve ownership.

## Composition

- Keep simple composition inline when it is easy to read.
- Prefer prop-driven composition before introducing a wrapper.
- Add a shared component only when multiple consumers need the same behavior or policy.
- Do not create a wrapper that only forwards props to a child.
- Do not extract a helper that only reshapes data once.

## Constants and Helpers

- Keep one-off literals near their use when that is clearer.
- Extract a constant only when it has shared meaning or repeated use.
- Do not create a `constants` file for a single value.
- Do not create a helper module that only renames or forwards behavior.

## Style File Organization

- Keep component-local styles with the component unless reuse forces a split.
- Use shared style primitives only when the same styling appears in multiple places.
- Name style files after the owning component or shared primitive.
- Avoid catch-all style folders that flatten ownership.
- Keep style overrides close to the component until they become system-wide concerns.

## Practical Check

Before extracting composition or styles, ask:

1. Is this reused?
2. Does the new file define a real boundary?
3. Is the inline form already readable?
4. Would the split make ownership clearer?

If the split only makes the tree look tidier, do not split it.
