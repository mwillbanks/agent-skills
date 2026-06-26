#!/usr/bin/env bun

import { readFile } from "node:fs/promises";

type ReviewComment = {
  path?: string;
  subjectType?: string;
  subject_type?: string;
  line?: number;
  side?: string;
  start_line?: number;
  start_side?: string;
  body?: string;
};

type Mode = "mcp" | "gh";

const allowedCategories = new Set([
  "P0(SECURITY)",
  "P0(SYSTEM)",
  "P0(COMPLIANCE)",
  "P1(ARCHITECTURE)",
  "P1(RELIABILITY)",
  "P1(EFFICIENCY)",
  "P1(TESTING)",
  "P2(UI)",
  "P2(TECH-DEBT)",
  "P2(READABILITY)",
  "P3(MAINTAINABILITY)",
  "P3(OPERABILITY)",
  "P3(CONSISTENCY)",
  "P4(STYLE)",
  "P4(DOCS)",
  "P4(PREFERENCE)",
]);

function fail(message: string): never {
  throw new Error(message);
}

function hasSuggestion(body: string): boolean {
  return body.includes("```suggestion");
}

function validateTitle(body: string, index: number): void {
  const firstLine = body.split("\n", 1)[0] ?? "";
  const match = firstLine.match(/^### \*\*(P[0-4]\([A-Z-]+\)): .+\*\*$/);

  if (!match) {
    fail(`Comment ${index} is missing the required title format.`);
  }

  const category = match[1];

  if (!category || !allowedCategories.has(category)) {
    fail(
      `Comment ${index} uses an unsupported priority/category: ${category}.`,
    );
  }
}

function validateFileLevelSubject(
  comment: ReviewComment,
  index: number,
  mode: Mode,
): void {
  if (mode === "mcp") {
    if (comment.subjectType !== "FILE") {
      fail(
        `Comment ${index} is file-level and must set subjectType to FILE in mcp mode.`,
      );
    }
    if (comment.subject_type !== undefined) {
      fail(
        `Comment ${index} is file-level in mcp mode and must not set subject_type.`,
      );
    }
  }

  if (mode === "gh") {
    if (comment.subject_type !== "file") {
      fail(
        `Comment ${index} is file-level and must set subject_type to file in gh mode.`,
      );
    }
    if (comment.subjectType !== undefined) {
      fail(
        `Comment ${index} is file-level in gh mode and must not set subjectType.`,
      );
    }
  }
}

function validateComment(
  comment: ReviewComment,
  index: number,
  mode: Mode,
): void {
  if (!comment.path) {
    fail(`Comment ${index} is missing path.`);
  }

  if (!comment.body) {
    fail(`Comment ${index} is missing body.`);
  }

  validateTitle(comment.body, index);

  const isFileLevel =
    comment.line === undefined &&
    comment.side === undefined &&
    comment.start_line === undefined &&
    comment.start_side === undefined;

  if (isFileLevel) {
    validateFileLevelSubject(comment, index, mode);

    if (hasSuggestion(comment.body)) {
      fail(
        `Comment ${index} is file-level and cannot contain a suggestion block.`,
      );
    }

    return;
  }

  if (comment.subjectType !== undefined || comment.subject_type !== undefined) {
    fail(
      `Comment ${index} is line-anchored and must not set a file-level subject field.`,
    );
  }

  if (!Number.isInteger(comment.line)) {
    fail(
      `Comment ${index} must include an integer line for anchored comments.`,
    );
  }

  if (comment.side !== "RIGHT") {
    fail(`Comment ${index} must target side RIGHT.`);
  }

  const hasRangeStart =
    comment.start_line !== undefined || comment.start_side !== undefined;

  if (hasRangeStart) {
    if (!Number.isInteger(comment.start_line)) {
      fail(`Comment ${index} range comment must include integer start_line.`);
    }

    if (comment.start_side !== "RIGHT") {
      fail(`Comment ${index} range comment must include start_side RIGHT.`);
    }

    if ((comment.start_line ?? 0) > (comment.line ?? 0)) {
      fail(`Comment ${index} has start_line after line.`);
    }
  }
}

async function main(): Promise<void> {
  const args = process.argv.slice(2);
  let mode: Mode = "mcp";

  if (args[0] === "--mode") {
    const rawMode = args[1];

    if (rawMode !== "mcp" && rawMode !== "gh") {
      fail(`Unsupported mode: ${rawMode}`);
    }

    mode = rawMode;
    args.splice(0, 2);
  }

  const payloadPath = args[0];

  if (!payloadPath) {
    fail(
      "Usage: bun validate-review-payload.ts [--mode mcp|gh] <comments.json>",
    );
  }

  const raw = await readFile(payloadPath, "utf8");
  const payload = JSON.parse(raw) as unknown;

  if (!Array.isArray(payload)) {
    fail("Payload must be a JSON array of review comments.");
  }

  payload.forEach((entry, index) => {
    validateComment(entry as ReviewComment, index + 1, mode);
  });

  console.log(`Validated ${payload.length} review comments in ${mode} mode.`);
}

main().catch((error: unknown) => {
  const message = error instanceof Error ? error.message : String(error);
  console.error(message);
  process.exit(1);
});
