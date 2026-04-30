---
name: project-tracker
description: Coordinate ticket tracking and time tracking before, during, and after implementation work. Use whenever a prompt starts with `/ProjectTracker`, includes Jira keys like `AIA-123`, includes ClickUp custom IDs like `SL-7007`, or asks to sync work across parent and child boards while logging time.
license: Apache-2.0
metadata:
  author: Mike Willbanks
  repository: https://github.com/mwillbanks/agent-skills
  homepage: https://github.com/mwillbanks/agent-skills
  bugs: https://github.com/mwillbanks/agent-skills/issues
---

# Project Tracker

Use this skill to make project execution operationally complete across two systems:

- ticket tracking (Jira, ClickUp, or both)
- time tracking (Everhour, Jira worklog, ClickUp tracking, other providers, or internal timer fallback)

The goal is to remove manual workflow drift. When this skill is active, the agent must not start implementation work before ticket/time context is resolved.

## When to use

Activate this skill when the user:

- starts a prompt with `/ProjectTracker`
- asks to work under a ticket, sprint, board, epic, story, or subtask
- asks to keep parent and child ticket systems synchronized
- asks to track, start, stop, or log time with project/ticket linkage
- gives ticket-like IDs such as `AIA-123` or `SL-7007`

## Non-negotiable rules

- Do not begin implementation before project mapping exists in `~/.agent-project-time-map.yaml`.
- Do not guess tracker ownership when both Jira and ClickUp are configured.
- Do not create child tickets unless the mapping indicates replication is enabled.
- Do not start any tracker timer unless the selected system has `useTimeTracking: true` or equivalent provider-level enablement in the project map.
- Do not start a timer without first binding it to a concrete task/ticket.
- Do not close execution without transitioning ticket status and stopping/logging time.
- If required MCP connectors are missing, first ask the user for permission to install them, then install/configure them when permission is granted.
- Do not ask the user for details that are already unambiguous from existing mapping plus provided ticket context.
- Do not require user intervention for routine ticket/time actions when the agent can execute them directly.

## Required setup command

Run this setup script when mapping does not exist for the current project:

```bash
bash /mnt/skills/user/project-tracker/scripts/setup-project-map.sh
```

Local repo path while authoring/testing this skill:

```bash
bash .agents/skills/project-tracker/scripts/setup-project-map.sh
```

## Supported systems

Primary built-in support:

- Jira via Atlassian Rovo MCP
- ClickUp via ClickUp MCP
- Everhour via direct/vendor/self-hosted MCP if available, or API-backed configuration

Do not default to MCP bridges that require third-party aggregator account signup. Prefer direct Everhour MCP providers from the MCP marketplace/registry or self-hosted Everhour MCP servers, then Everhour API, then internal fallback.

This skill must also support additional trackers/time systems by discovery:

- detect configured providers from `~/.agent-project-time-map.yaml`
- discover available MCP/API support for each configured provider
- map newly discovered providers into routing rules instead of assuming only Jira/ClickUp/Everhour

## Workflow

Follow this exact sequence.

### 1. Resolve project and mapping

1. Determine canonical project identity using, in order:
   - current git root path
   - git origin
   - configured `PROJECT_NAME` key in `~/.agent-project-time-map.yaml`
2. Load project entry from the map.
3. If missing, run setup script and collect mapping details.
4. Confirm active trackers/time providers before continuing.
5. Build a capability matrix for configured providers:
   - provider name
   - MCP available now
   - MCP source class (`direct`, `vendor`, `self-hosted`, or `third-party-bridge`)
   - API fallback available
   - time tracking enabled flag(s)
6. If mapping exists and matches current project, do not re-run setup questions.

### 2. Resolve task intent and ticket selection

1. Parse `/ProjectTracker` invocation payload.
2. If a ticket ID is present, match it against configured patterns:
   - Jira default pattern: `^[A-Z][A-Z0-9]+-[0-9]+$`
   - ClickUp custom ID pattern from mapping for ClickUp custom-id matching (for example `^SL-[0-9]+$`)
3. If no ticket ID is present, ask the user what work item to use or create.
4. If both trackers can match, use `parentTracker` from mapping and ask before override.
5. If mapping exists and ticket identity is clear, do not ask additional clarifying questions.

### 3. Prepare or create work items

1. Locate parent ticket/task in the configured tracker.
2. Decide whether to reuse the parent ticket or create subtasks:
   - reuse parent for self-contained bugfixes
   - create subtasks for multi-step implementation
3. If replication is configured, create/locate child ticket and store a durable cross-reference linkage:
   - Jira: issue link, remote link, or configured custom field
   - ClickUp: custom field, task link, or description marker
4. Assign current user and move task status to in-progress state.
5. Ensure current sprint/list placement is correct when the system supports it.

### 4. Start time tracking

Timer gating policy is mandatory:

- if `ticketTracking.<provider>.useTimeTracking: false`, do not attempt that provider's timer/worklog start
- if provider-level time tracking is disabled and no enabled fallback provider exists, track elapsed time internally only
- always record and report why timer start was skipped when disabled by configuration

1. Select time provider from mapping.
2. Filter providers to those enabled by configuration:
   - dedicated `timeTracking.*.enabled` providers
   - ticket systems with `useTimeTracking: true`
3. Prefer provider-native tracking in this order:
   - Everhour MCP or Everhour API
   - configured dedicated time-tracking MCP/API provider
   - Jira worklog/timer workflow when `ticketTracking.jira.useTimeTracking: true`
   - ClickUp timer when `ticketTracking.clickup.useTimeTracking: true`
4. If no live timer exists for the selected enabled provider, start one.
5. If no enabled provider supports live timers, record internal `started_at` timestamp and continue.

### 5. Execute user-requested implementation work

1. Perform the requested engineering task.
2. Keep ticket states and replication links in sync if work scope changes.
3. If additional subtasks emerge, create them under the active parent and move to in progress only when started.
4. Keep not-started subtasks in todo/backlog state.

### 6. Close operational workflow

This phase is the workflow closeout and must keep parent/child tracker states synchronized.

1. Transition tickets from in-progress to target state (`In Review`, `Done`, `Complete`, etc.) based on project workflow.
2. Stop timer or add explicit time log entry with ticket/task association.
3. Add final work notes/comments linking code changes and validation evidence.
4. Report final operational state:
   - parent ticket
   - child ticket(s)
   - status transition results
   - time logged or fallback timing used

## MCP and API routing

Use [references/mcp-and-api-mapping.md](references/mcp-and-api-mapping.md) for provider-specific tool routing.

If a required connector is not available:

1. tell the user exactly which connector is missing
2. ask for permission to install/configure it now
3. if permission granted, install/configure it and verify tool availability
4. if installation fails or is declined, use approved fallback and report degraded automation scope explicitly

## Automation posture

Default posture is autonomous execution for tracker/time actions.

- Automatically execute create/update/transition/log-time operations when scope and target are clear.
- Do not ask for confirmation on routine tracker/time operations.
- Ask the user only when one of the following is true:
  - required connector is missing and installation permission is needed
  - target project/ticket cannot be resolved confidently
  - workflow transition is unknown or invalid in the current board/list
  - action fails and safe retry strategy is unclear

## UI prompt minimization policy

The skill should avoid avoidable end-user approval interruptions for tracker/time actions.

- Prefer pre-configured, non-interactive auth paths where possible.
- Prefer deterministic tool calls over exploratory flows that trigger repeated approval UX.
- Cache/reuse resolved project identifiers (`cloudId`, workspace/list IDs, provider IDs) from mapping to reduce interactive churn.
- If a platform-controlled approval widget still appears and cannot be suppressed by available configuration, continue with the least-interruptive path and report the blocker once.

## Map schema

Map format is defined in [references/project-map-schema.md](references/project-map-schema.md).

## Final output contract

When this skill is used, report:

- mapped project identity used (`name`, `path`, `git`)
- selected parent tracker and ticket
- whether subtasks/replicas were created
- ticket transitions performed
- explicit timer gating decisions (`enabled` or `skipped`) per provider checked
- time tracking provider used and duration logged
- any fallback taken due to missing MCP/API access

## References

- `references/project-map-schema.md`
- `references/mcp-and-api-mapping.md`
- `evals/evals.json`
- `scripts/setup-project-map.sh`
