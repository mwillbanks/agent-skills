# Design-System and Theme Discipline

Use these rules when a frontend change touches tokens, theme values, or styling decisions that could become duplicated across screens.

## Reuse First

- Prefer existing semantic tokens over raw values.
- Prefer existing component variants before inventing new ones.
- Prefer existing spacing, color, typography, radius, elevation, and motion primitives before adding local constants.
- Reuse shared primitives even when the local literal would be faster to write.

## Promote Only When Shared Meaning Exists

- Promote a value into the theme only when it carries stable meaning across multiple consumers.
- Do not create a token for a one-off tweak.
- Do not create a token simply because the value appears in two places inside one file.
- Do not encode page-specific intent in the global theme.

## Naming Rules

- Use semantic names that describe the user-facing meaning.
- Avoid names that describe implementation details or screen-local hacks.
- Keep token names aligned with the rest of the theme vocabulary.

## Practical Check

Before adding a new token, ask:

1. Is there already a token or variant that expresses this?
2. Will this value likely be reused beyond the current file?
3. Does the name describe a stable concept or a local visual tweak?
4. Would keeping it inline be clearer?

If the answer to the last question is yes, keep it local.
