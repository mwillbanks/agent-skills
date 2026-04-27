# Constants and Organization Discipline

Use these rules when a change tempts you to move literals, helpers, or styles into nearby support files.

## Constants

- Keep one-off constants inline when they are easier to read there.
- Extract a constant only when the value is shared, semantically important, or part of a cross-file contract.
- Do not create a `constants` file for a single consumer.
- Do not rename a literal into a constant unless the name adds meaning beyond the value itself.
- Prefer shared ownership for shared constants. Place them in the layer that owns the concept.

## Helpers

- Keep one-off helper logic inline unless reuse or complexity justifies extraction.
- Do not move simple expressions into `utils` modules for neatness.
- Do not create helpers that only forward a single call or rename existing behavior.

## Styles and File Shape

- Keep local style declarations near the component when the styles are local.
- Promote styles to a shared primitive only when multiple components truly reuse them.
- Use descriptive filenames that communicate ownership and purpose.
- Avoid generic style buckets that exist only to reduce file length.
- Do not split a file unless the split makes ownership or reuse clearer.

## Practical Check

Before extracting anything, ask:

1. Is this used more than once?
2. Does the new name explain more than the literal or inline expression?
3. Does the new file establish a real boundary or just move code around?
4. Would the code be easier to read if left inline?

If the answer to the last question is yes, keep it inline.
