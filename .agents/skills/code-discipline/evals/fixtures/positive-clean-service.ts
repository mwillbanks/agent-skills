// evals/fixtures/positive-clean-service.ts
// Positive compliance case. Clean, disciplined code. Agent must explicitly approve and confirm no violations.

import { PrismaClient } from "@prisma/client";
import { z } from "zod";

const prisma = new PrismaClient();

const CreateUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1),
});

export async function createUser(input: unknown) {
  const data = CreateUserSchema.parse(input); // single library path, no custom parse/resolve helpers
  return prisma.user.create({
    data: { email: data.email.toLowerCase(), displayName: data.name },
  });
}

// No local helpers, no one-off constants extracted, arrow functions, proper async, library first.
