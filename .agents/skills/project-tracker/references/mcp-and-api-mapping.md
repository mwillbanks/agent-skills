# MCP and API Mapping

This skill must support both:

- built-in providers (Jira, ClickUp, Everhour)
- discovered providers from project mapping (other ticket/time systems)

Do not hardcode to Jira/ClickUp-only behavior.

## Provider discovery and capability mapping

For every provider configured in `~/.agent-project-time-map.yaml`:

1. Detect whether an MCP integration is already available in the active environment.
2. If not available, check whether an installable MCP exists.
3. If no MCP exists, check whether a direct API integration is configured in mapping.
4. Record capability result per provider:
   - `ticketOps`: supported/not-supported
   - `timeOps`: supported/not-supported
   - `sourceClass`: direct/vendor/self-hosted/third-party-bridge
   - `installationAttempted`: yes/no
   - `fallbackMode`: none/internal/api-only

When a provider is not one of the built-ins, attempt discovery before declaring unsupported.

Default policy:

- allow: `direct`, `vendor`, `self-hosted`
- block by default: `third-party-bridge` connectors that require new external account signup
- only use blocked class when user explicitly opts in

## Jira (Atlassian Rovo MCP)

Required capabilities:

- locate project/issue
- create/update issue
- transition issue status
- add comments
- add worklogs
- create issue links

Typical tool flow:

1. get cloud/site context
2. find project/issue
3. create subtask or linked issue if needed
4. transition status to in progress
5. add comment/worklog during closeout
6. transition to in review/done

## ClickUp MCP

Required capabilities:

- search task/list/folder
- create/update task/subtask
- start/stop timer or add time entry
- update status and assignees

Typical tool flow:

1. resolve list/folder from map file
2. find or create task/subtask
3. assign and set status in progress
4. start timer or add time entry
5. update status during closeout
6. stop timer / finalize entry

## Everhour

Preferred:

- use Everhour MCP if available and connected
- prefer direct/vendor/self-hosted Everhour MCP sources from marketplace/registry or existing internal deployment

Fallback:

- use Everhour REST API with token in env var from map file (`apiTokenEnv`)

Minimum API operations expected:

- identify project/task
- start or log time entry
- stop/finalize entry

## Missing connector policy

If a required connector is missing:

1. tell the user exactly which connector is missing
2. ask the user for permission to install/configure it now
3. if permission is granted:
   - discover compatible connector candidates
   - prioritize direct/vendor/self-hosted candidates
   - install/configure connector
   - verify connector tools are reachable
   - continue workflow using the newly installed connector
4. if permission is declined or install fails, apply fallback and report reduced automation

## Redundant prompt suppression

When project mapping exists and ticket identity is clear:

- do not prompt for project selection again
- do not prompt for ticket details already derivable from mapping + provided ID
- proceed directly to execution workflow

Only prompt when ambiguity is material or required permissions/connectors are missing.

Fallback policy:

- Everhour: MCP -> API -> internal elapsed-time tracking
- Jira/ClickUp: MCP required for ticket automation; if unavailable, report blocker and do not pretend ticket sync completed
- other providers: discovered MCP/API route if available, otherwise explicit degraded mode

## Connector installation procedure

Use this sequence:

1. Prompt: request permission to install/configure the missing MCP.
2. Discover candidate MCP servers from marketplace/registry and classify source.
3. Prefer direct/vendor/self-hosted connector candidates.
4. Install via the available skill or connector onboarding path.
5. Re-check tool availability in the active environment.
6. Persist provider mapping details in `~/.agent-project-time-map.yaml`.

Do not skip step 1.
Do not continue as if installation succeeded when it has not.
Do not auto-select third-party-bridge connectors unless the user explicitly approves that path.

## Interactive approval minimization

For tracker/time operations:

1. Prefer pre-authorized credentials and non-interactive auth flows.
2. Reuse known identifiers from mapping to avoid repeated discovery prompts.
3. Use direct action APIs/tools once targets are known instead of re-running broad discovery.
4. If external platform UX still enforces interactive approval, report that as a platform constraint and continue with the least-interruptive path.

## Time tracking gating

Before any timer or time-entry call:

1. Check `ticketTracking.<provider>.useTimeTracking` for ticket systems.
2. Check `timeTracking.<provider>.enabled` for dedicated time systems.
3. If false/disabled, do not call start timer for that provider.
4. Move to the next enabled provider or use internal elapsed-time fallback.

## Status mapping guidance

Because workflows vary by board/list, treat these as defaults only:

- Start work: `To Do` -> `In Progress`
- Review handoff: `In Progress` -> `In Review`
- Completed: `In Review` -> `Done` or `Complete`

Always fetch available transitions/statuses from the target system before applying changes.
