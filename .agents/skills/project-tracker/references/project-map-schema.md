# Project Map Schema

The skill stores project-specific tracking integration in:

- `~/.agent-project-time-map.yaml`

## Schema

```yaml
projects:
  PROJECT_NAME:
    path: /absolute/project/path
    git: git@github.com:org/repo.git
    parentTracker: jira | clickup
    ticketTracking:
      jira:
        useTimeTracking: true | false
        baseUrl: yoursite.atlassian.net
        project: AIA
        isChild: false
        ticketKeyPattern: ^AIA-[0-9]+$
        replicaIdField: customfield_12345
      clickup:
        useTimeTracking: true | false
        folder: "123456"
        defaultList:
          id: "987654"
          type: development
        customIdPrefix: SL
        isChild: true
        otherLists:
          - type: design
            isDefault: false
            id: "112233"
            subtype: ux
            useWhen: Design updates only
    timeTracking:
      everhour:
        enabled: true
        workspaceId: "workspace-id"
        projectId: "project-id"
        apiBase: https://api.everhour.com
        apiTokenEnv: EVERHOUR_API_TOKEN
      jiraWorklog:
        enabled: true
      clickup:
        enabled: true
      internal:
        enabled: true
    integrations:
      mcp:
        atlassianRovo:
          required: true
          installed: true
          authMode: apiToken | oauth
          prefersNonInteractive: true
          resolvedCloudId: "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
        clickup:
          required: false
          installed: true
          prefersNonInteractive: true
          resolvedWorkspaceId: "1234567"
        everhour:
          required: false
          installed: false
          installHint: everhour-direct-or-self-hosted-mcp
          sourceClass: direct
          prefersNonInteractive: true
      providers:
        otherTicketSystems:
          - name: linear
            enabled: false
            mcpServer: ""
            sourceClass: vendor
            apiBase: ""
            useTimeTracking: false
        otherTimeSystems:
          - name: harvest
            enabled: false
            mcpServer: ""
            sourceClass: vendor
            apiBase: ""
```

## Matching rules

- First match by exact project `path`.
- If path mismatch, match by `git` origin.
- If still unresolved, match by `PROJECT_NAME` key.

## Ticket identity routing

- Use `ticketTracking.jira.ticketKeyPattern` for Jira key matching.
- Use `ticketTracking.clickup.customIdPrefix` for ClickUp custom-id matching.
- If both could match, use `parentTracker` and ask before override.

## Timer gating semantics

- `ticketTracking.<provider>.useTimeTracking: false` means the skill must not call timer/worklog start for that provider.
- `timeTracking.<provider>.enabled: false` means the skill must skip that provider entirely for time logging.
- If all provider-level time tracking flags are disabled, use internal elapsed-time fallback.

## Prompt suppression semantics

- If mapping exists and `resolvedCloudId` / `resolvedWorkspaceId` / provider IDs are present, the skill should skip repeated setup prompts.
- If ticket key is provided and matches configured patterns, the skill should proceed without additional detail prompts.

## Replication guidance

When parent and child trackers are both enabled:

- Create a parent ticket first.
- Create/locate child ticket.
- Store a durable cross-reference (`replicaIdField`, link, or custom field).
- Reuse existing linked child ticket if one already exists.
