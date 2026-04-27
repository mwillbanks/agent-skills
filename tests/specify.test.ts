import { expect, test } from "bun:test";
import { readdirSync } from "node:fs";
import { join } from "node:path";

test("specify artifacts validate", () => {
  const repoRoot = join(import.meta.dir, "..");
  const expectedCount = readdirSync(join(repoRoot, ".specify", "features"), {
    withFileTypes: true,
  }).filter((entry) => entry.isDirectory()).length;
  const result = Bun.spawnSync(["bun", "scripts/validate-specify.ts"], {
    cwd: repoRoot,
    stderr: "pipe",
    stdout: "pipe",
  });

  const stdout = Buffer.from(result.stdout).toString("utf8").trim();
  const stderr = Buffer.from(result.stderr).toString("utf8").trim();

  expect({
    exitCode: result.exitCode,
    stdout,
    stderr,
  }).toEqual({
    exitCode: 0,
    stdout: `Validated ${expectedCount} feature director${
      expectedCount === 1 ? "y" : "ies"
    } under .specify/features.`,
    stderr: "",
  });
});
