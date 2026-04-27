#!/usr/bin/env bun

import { readdirSync, statSync } from "node:fs";
import { access, readFile } from "node:fs/promises";
import { join } from "node:path";

const repoRoot = join(import.meta.dir, "..");
const specifyRoot = join(repoRoot, ".specify");
const featuresRoot = join(specifyRoot, "features");
const requiredFeatureFiles = [
  "feature-foundation.md",
  "spec.md",
  "plan.md",
  "tasks.md",
  "findings-closure.md",
  "validation.md",
  "review.md",
  "traceability.md",
  "post-mortem.md",
];
const closeoutFiles = ["review.md", "traceability.md", "post-mortem.md"];
const pendingPattern =
  /Pending completion|pending final implementation review|Verdict:\s*pending|Review \d+\s*\n\n- Verdict:\s*pending|final independent review gate pending|rerun pending/i;

async function assertExists(path: string): Promise<void> {
  await access(path);
}

async function main(): Promise<void> {
  await assertExists(join(specifyRoot, "constitution.md"));
  const featureDirs = readdirSync(featuresRoot, { withFileTypes: true }).filter(
    (entry) => entry.isDirectory(),
  );

  if (featureDirs.length === 0) {
    throw new Error("No feature directories found under .specify/features.");
  }

  for (const featureDir of featureDirs) {
    const featurePath = join(featuresRoot, featureDir.name);
    if (!statSync(featurePath).isDirectory()) {
      throw new Error(`Feature path is not a directory: ${featurePath}`);
    }

    for (const filename of requiredFeatureFiles) {
      await assertExists(join(featurePath, filename));
    }

    const tasksPath = join(featurePath, "tasks.md");
    const tasksContent = await readFile(tasksPath, "utf8");
    const hasOpenTasks = /- \[ \]/.test(tasksContent);

    if (hasOpenTasks) {
      continue;
    }

    for (const filename of closeoutFiles) {
      const content = await readFile(join(featurePath, filename), "utf8");
      if (pendingPattern.test(content)) {
        throw new Error(
          `${featureDir.name}/${filename} contains pending or placeholder closeout text even though tasks.md has no open tasks.`,
        );
      }
    }
  }

  console.log(
    `Validated ${featureDirs.length} feature director${
      featureDirs.length === 1 ? "y" : "ies"
    } under .specify/features.`,
  );
}

main().catch((error: unknown) => {
  const message = error instanceof Error ? error.message : String(error);
  console.error(`specify validation failed: ${message}`);
  process.exit(1);
});
