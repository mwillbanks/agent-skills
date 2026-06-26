// evals/fixtures/cohesive-large-domain.ts
// Positive case: 450-line file that is ONE cohesive domain aggregate with clear internal structure.
// No GOD smell. Skill should accept (no forced split).

// User aggregate root + its value objects, invariants, command handlers, all in one file because they share ownership and lifecycle.
// Relations are in user.relations.ts (already separated).
// This demonstrates "intent matters more than line count".

export const userDomain = {
  // 400+ lines of tightly related domain logic...
  createUser: () => {},
  changeEmail: () => {},
  applyEvent: () => {},
  // ...
};
