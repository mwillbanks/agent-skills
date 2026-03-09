#!/usr/bin/env bun

import { mkdir, readFile, stat, writeFile } from "node:fs/promises";
import { dirname, join } from "node:path";

type Category =
  | "implementation"
  | "review"
  | "debugging"
  | "documentation"
  | "architecture"
  | "repo-operations"
  | "research";

const categories: Category[] = [
  "implementation",
  "review",
  "debugging",
  "documentation",
  "architecture",
  "repo-operations",
  "research",
];

function printUsage(): void {
  console.error("Usage: bun run prompt init <name> [category]");
  console.error(
    "Example: bun run prompt init production-implementation implementation",
  );
}

function toTitleCase(value: string): string {
  return value
    .split("-")
    .filter(Boolean)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join(" ");
}

function assertKebabCase(value: string): void {
  if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(value)) {
    throw new Error(
      "Prompt name must be kebab-case (letters, numbers, hyphens).",
    );
  }
}

async function exists(path: string): Promise<boolean> {
  try {
    await stat(path);
    return true;
  } catch {
    return false;
  }
}

async function loadTemplate(path: string): Promise<string> {
  return readFile(path, "utf8");
}

function applyReplacements(
  template: string,
  values: Record<string, string>,
): string {
  let output = template;
  for (const [key, value] of Object.entries(values)) {
    output = output.replaceAll(`<{${key}}>`, value);
    output = output.replaceAll(`<${key}>`, value);
    output = output.replaceAll(`{{${key}}}`, value);
  }
  return output;
}

async function main(): Promise<void> {
  const args = process.argv.slice(2);
  const [command, rawName, rawCategory] = args;

  if (command !== "init" || !rawName) {
    printUsage();
    process.exit(1);
  }

  assertKebabCase(rawName);

  const category = (rawCategory ?? "implementation") as Category;
  if (!categories.includes(category)) {
    console.error(`Invalid category: ${category}`);
    console.error(`Allowed categories: ${categories.join(", ")}`);
    process.exit(1);
  }

  const repoRoot = process.cwd();
  const promptTemplatePath = join(
    repoRoot,
    ".agents/prompts/templates/prompt-template.md",
  );
  const metadataTemplatePath = join(
    repoRoot,
    ".agents/prompts/templates/prompt-metadata-template.md",
  );

  const categoryDir = join(repoRoot, ".agents/prompts", category);
  const promptPath = join(categoryDir, `${rawName}.md`);
  const metadataPath = join(categoryDir, `${rawName}.metadata.md`);

  if (await exists(promptPath)) {
    throw new Error(`Prompt file already exists: ${promptPath}`);
  }
  if (await exists(metadataPath)) {
    throw new Error(`Metadata file already exists: ${metadataPath}`);
  }

  const promptTemplate = await loadTemplate(promptTemplatePath);
  const metadataTemplate = await loadTemplate(metadataTemplatePath);

  const replacements = {
    "Prompt Title": toTitleCase(rawName),
    "prompt-name": rawName,
    "implementation|review|debugging|documentation|architecture|repo-operations|research":
      category,
    "production|hardening|agentic-self-review|recommendation-review|general-review|prototype|design-only|architecture":
      "production",
    "one-sentence objective": `Implement ${toTitleCase(rawName)} completely and validate outcomes.`,
    "required input 1": "Task scope",
    "required input 2": "Target files/modules",
    "command 1": "bunx tsc --noEmit",
    "command 2": "bun test",
    "repo name": "mwillbanks/agent-skills",
    paths: "<fill-in-paths>",
    constraints: "Follow repository standards and no placeholders.",
    mode: "production",
  };

  await mkdir(dirname(promptPath), { recursive: true });

  const promptContent = applyReplacements(promptTemplate, replacements)
    .replace("<Prompt Title>", toTitleCase(rawName))
    .replace(
      "<Exactly what the agent must accomplish.>",
      `Complete ${toTitleCase(rawName)} in this repository.`,
    )
    .replace("<repo name>", "mwillbanks/agent-skills")
    .replace("<paths>", "<fill-in-paths>")
    .replace(
      "<constraints>",
      "Follow repository standards and avoid partial implementation.",
    )
    .replace("<mode>", "production")
    .replace("<command 1>", "bunx tsc --noEmit")
    .replace("<command 2>", "bun test");

  const metadataContent = applyReplacements(metadataTemplate, replacements)
    .replace("<prompt-name>", rawName)
    .replace(
      "<implementation|review|debugging|documentation|architecture|repo-operations|research>",
      category,
    )
    .replace(
      "<production|hardening|agentic-self-review|recommendation-review|general-review|prototype|design-only|architecture>",
      "production",
    )
    .replace(
      "<one-sentence objective>",
      `Implement ${toTitleCase(rawName)} with complete execution and validation evidence.`,
    )
    .replace("<required input 1>", "Task scope")
    .replace("<required input 2>", "Target files/modules")
    .replace("<command 1>", "bunx tsc --noEmit")
    .replace("<command 2>", "bun test");

  await writeFile(promptPath, promptContent, "utf8");
  await writeFile(metadataPath, metadataContent, "utf8");

  console.log(`Created prompt: ${promptPath}`);
  console.log(`Created metadata: ${metadataPath}`);
}

main().catch((error: unknown) => {
  const message = error instanceof Error ? error.message : String(error);
  console.error(`prompt init failed: ${message}`);
  process.exit(1);
});
