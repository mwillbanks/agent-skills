import { expect, test } from "bun:test";
import { readdirSync } from "node:fs";
import { join } from "node:path";

const repoRoot = join(import.meta.dir, "..");
const skillsRoot = join(repoRoot, ".agents", "skills");

test("all skills pass skills-ref validation", () => {
  const failures: string[] = [];
  const skillDirs = readdirSync(skillsRoot, { withFileTypes: true })
    .filter((entry) => entry.isDirectory())
    .map((entry) => join(skillsRoot, entry.name));

  for (const skillDir of skillDirs) {
    const result = Bun.spawnSync(["bunx", "skills-ref", "validate", skillDir], {
      cwd: repoRoot,
      stderr: "pipe",
      stdout: "pipe",
    });

    if (result.exitCode === 0) {
      continue;
    }

    const stdout = Buffer.from(result.stdout).toString("utf8").trim();
    const stderr = Buffer.from(result.stderr).toString("utf8").trim();
    const details = [stdout, stderr].filter(Boolean).join("\n");

    failures.push(`${skillDir}\n${details}`.trim());
  }

  expect(failures).toEqual([]);
});
