// evals/fixtures/prisma-resolve-parse-bloat.ts
// Scenario: Controller with multiple local resolve/parse variants for Prisma/ORM handling.
// This is the bad pattern the skill must reject.

import { PrismaClient } from "@prisma/client";
import type { Request, Response } from "express";

const prisma = new PrismaClient();

function parseUserInput(req: Request) {
  // one-off field parsing
  return {
    email: req.body.email?.toLowerCase().trim(),
    name: req.body.name?.trim(),
  };
}

function resolveUserData(input: any) {
  // maps parsed input to Prisma shape
  return {
    email: input.email,
    displayName: input.name,
    createdAt: new Date(),
  };
}

function parseProfileInput(req: Request) {
  return { bio: req.body.bio?.trim() };
}

function resolveProfileData(input: any) {
  return { bio: input.bio, userId: input.userId };
}

export async function registerUser(req: Request, res: Response) {
  const userInput = parseUserInput(req);
  const userData = resolveUserData(userInput);

  const profileInput = parseProfileInput(req);
  const profileData = resolveProfileData({ ...profileInput, userId: "??" });

  const user = await prisma.user.create({ data: userData });
  await prisma.profile.create({ data: { ...profileData, userId: user.id } });

  res.json({ ok: true });
}
