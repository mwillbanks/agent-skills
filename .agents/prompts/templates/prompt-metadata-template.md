---
name: <prompt-name>
category: <implementation|review|debugging|documentation|architecture|repo-operations|research>
mode: <production|hardening|agentic-self-review|recommendation-review|general-review|prototype|design-only|architecture>
intent: <one-sentence objective>
required_skills:
  - agent-execution-mode
  - repo-standards-enforcement
inputs:
  - <required input 1>
  - <required input 2>
validation:
  - <command 1>
  - <command 2>
output_contract:
  - scope_completed
  - files_changed
  - validation_results
  - docs_updated
  - blockers
---
