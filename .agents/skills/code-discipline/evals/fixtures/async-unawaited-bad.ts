// evals/fixtures/async-unawaited-bad.ts
// Scenario: Async migration with unawaited promises and missing try/catch + logging.
// Skill must flag unawaited, require full try/catch + every error logged, check for lib first, suggest OTEL.

import { migrate } from "some-db-lib";

export async function runMigration() {
  const config = fetchConfig(); // unawaited promise!

  const db = await connectToDb();

  migrate(db, config); // fire-and-forget, no await, no error handling

  // critical path with no try/catch
  db.query("UPDATE ...");
  db.close();
}

function fetchConfig() {
  return fetch("/config").then((r) => r.json());
}

async function connectToDb() {
  return { query: async (_q: string) => {}, close: async () => {} };
}
