// evals/fixtures/library-edge-platform-suffices.ts
// Prompt scenario (or decision file): Team wants to add 'query-string' or 'qs' for URL parsing.
// Platform URLSearchParams already solves it. Skill must prefer platform, reject dep.

export function buildSearch(params: Record<string, string>) {
  const usp = new URLSearchParams(params);
  return usp.toString();
}

// No need for extra dep. Custom wrapper or dep would be non-compliant.
