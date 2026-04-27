import { expect, test } from "bun:test";

test("required skill eval definitions validate", () => {
  const result = Bun.spawnSync(["bun", "scripts/validate-skill-evals.ts"], {
    cwd: `${import.meta.dir}/..`,
    stderr: "pipe",
    stdout: "pipe",
  });

  const stdout = Buffer.from(result.stdout).toString("utf8").trim();
  const stderr = Buffer.from(result.stderr).toString("utf8").trim();

  expect(result.exitCode).toBe(0);
  expect(stdout).toContain("Validated eval definitions");
  expect(stderr).toBe("");
});
