// evals/fixtures/one-off-constants.ts
// Scenario: Developer extracted one-off literals into a constants file for a single consumer.
// Violates constant placement rules. Skill must reject and keep inline.

export const MAX_RETRIES = 3;
export const DEFAULT_TIMEOUT = 5000;
export const FEATURE_FLAG_X = true;

// Used in only one place: apiClient.ts
// apiClient.ts does: if (retries > MAX_RETRIES) ...
