// evals/fixtures/async-compliant.ts
// Scenario: Positive case - correctly written async with try/catch, logging every error, OTEL spans.
// The skill must APPROVE this (no changes suggested).

import { trace } from "@opentelemetry/api";
import { migrate } from "some-db-lib"; // well-maintained lib already chosen after assessment

const tracer = trace.getTracer("migration");

export async function runMigration() {
  const span = tracer.startSpan("db.migration.run");
  try {
    const config = await fetchConfig();
    const db = await connectToDb();

    await migrate(db, config); // properly awaited

    span.setStatus({ code: 1 /* OK */ });
  } catch (err: any) {
    console.error("Migration failed", { error: err.message, stack: err.stack });
    span.recordException(err);
    span.setStatus({ code: 2 /* ERROR */ });
    throw err;
  } finally {
    span.end();
  }
}

async function fetchConfig() {
  const res = await fetch("/config");
  if (!res.ok) throw new Error(`Config fetch failed: ${res.status}`);
  return res.json();
}

async function connectToDb() {
  // real connection...
  return { query: async () => {}, close: async () => {} };
}
