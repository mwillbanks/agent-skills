// evals/fixtures/already-remediated.ts
// Review of a file that previously had 12 resolveX helpers. Now cleaned up.
// Agent must recognize the remediation and approve (no new violations introduced).

import { z } from "zod";

const UserSchema = z.object({ email: z.string().email() });

export async function upsertUser(raw: unknown) {
  const data = UserSchema.parse(raw); // generalized lib, not per-entity resolve helpers
  // ... single call site to Prisma or repository
  return { id: "1", ...data };
}

// Previously: resolveUser, resolveProfile, resolveOrder, ... 12 variants. All removed.
