#!/usr/bin/env bun

import { readFile } from "node:fs/promises";
import { join } from "node:path";

type EvalDefinition = {
  id: number;
  prompt: string;
  expected_output: string;
  files?: string[];
  expectations?: string[];
};

type EvalFile = {
  skill_name: string;
  evals: EvalDefinition[];
};

const repoRoot = join(import.meta.dir, "..");
const requiredSkillDirs = [
  "agent-execution-mode",
  "code-discipline",
  "execution-alignment-gate",
  "skill-creator",
  "speckit-feature-orchestrator",
  "review-remediation-gate",
  "requirements-traceability-matrix",
  "spec-change-governance",
  "frontend-system-discipline",
];

async function readJson(path: string): Promise<EvalFile> {
  return JSON.parse(await readFile(path, "utf8")) as EvalFile;
}

async function main(): Promise<void> {
  for (const skillDir of requiredSkillDirs) {
    const skillRoot = join(repoRoot, ".agents", "skills", skillDir);
    const skillPath = join(skillRoot, "SKILL.md");
    const evalPath = join(skillRoot, "evals", "evals.json");
    const skillMarkdown = await readFile(skillPath, "utf8");
    const nameMatch = skillMarkdown.match(/^name:\s+(.+)$/m);

    if (!nameMatch) {
      throw new Error(`Missing frontmatter name in ${skillPath}`);
    }

    const skillName = nameMatch[1]?.trim();
    const evalFile = await readJson(evalPath);

    if (evalFile.skill_name !== skillName) {
      throw new Error(
        `Skill name mismatch for ${skillDir}: evals.json has ${evalFile.skill_name}, SKILL.md has ${skillName}`,
      );
    }

    if (!Array.isArray(evalFile.evals) || evalFile.evals.length < 2) {
      throw new Error(`${evalPath} must contain at least 2 evals.`);
    }

    for (const evalEntry of evalFile.evals) {
      if (!Number.isInteger(evalEntry.id)) {
        throw new Error(`${evalPath} has a non-integer eval id.`);
      }
      if (!evalEntry.prompt.trim()) {
        throw new Error(`${evalPath} has an empty prompt.`);
      }
      if (!evalEntry.expected_output.trim()) {
        throw new Error(`${evalPath} has an empty expected_output.`);
      }
    }
  }

  console.log(
    `Validated eval definitions for ${requiredSkillDirs.length} skills.`,
  );
}

main().catch((error: unknown) => {
  const message = error instanceof Error ? error.message : String(error);
  console.error(`skill eval validation failed: ${message}`);
  process.exit(1);
});
