// evals/fixtures/borderline-god-mixed.ts
// 280-line file that mixes two distinct concerns (User aggregate + reporting queries).
// Should be split per one-file-per-purpose even if under arbitrary line limit.

export const userSchema =
  /* ... 140 lines of user types, resolvers, relations ... */ null;
export const reportingQueries =
  /* ... 140 lines of ad-hoc report resolvers mixed in ... */ null;

// Developer says "it's only 280 lines, keep together".
// Skill must still enforce split: user.* + reporting.* separate.
