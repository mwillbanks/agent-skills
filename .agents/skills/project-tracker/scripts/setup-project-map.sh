#!/bin/bash
set -euo pipefail

TMP_FILE="$(mktemp)"
cleanup() {
  rm -f "$TMP_FILE"
}
trap cleanup EXIT

status() {
  echo "$1" >&2
}

trim() {
  local value="$1"
  value="${value#${value%%[![:space:]]*}}"
  value="${value%${value##*[![:space:]]}}"
  printf '%s' "$value"
}

normalize_csv() {
  local input="$1"
  local output=""
  IFS=',' read -r -a parts <<< "$input"
  for item in "${parts[@]}"; do
    local trimmed
    trimmed="$(trim "$item")"
    if [ -n "$trimmed" ]; then
      if [ -n "$output" ]; then
        output+=","
      fi
      output+="$trimmed"
    fi
  done
  printf '%s' "$output"
}

contains_csv_value() {
  local csv="$1"
  local needle="$2"
  IFS=',' read -r -a parts <<< "$csv"
  for item in "${parts[@]}"; do
    if [ "$item" = "$needle" ]; then
      return 0
    fi
  done
  return 1
}

ask() {
  local prompt="$1"
  local default_value="${2-}"
  if [ -n "$default_value" ]; then
    status "$prompt [$default_value]"
  else
    status "$prompt"
  fi
  local reply
  IFS= read -r reply || true
  if [ -z "$reply" ]; then
    reply="$default_value"
  fi
  printf '%s' "$reply"
}

ask_yes_no() {
  local prompt="$1"
  local default_value="${2-yes}"
  local reply
  reply="$(ask "$prompt (yes/no)" "$default_value")"
  reply="$(printf '%s' "$reply" | tr '[:upper:]' '[:lower:]')"
  case "$reply" in
    y|yes|true|1)
      printf 'true'
      ;;
    *)
      printf 'false'
      ;;
  esac
}

yaml_quote() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  printf '"%s"' "$value"
}

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
PROJECT_NAME_DEFAULT="$(basename "$PROJECT_ROOT")"
GIT_ORIGIN_DEFAULT="$(git config --get remote.origin.url 2>/dev/null || true)"
MAP_FILE="$HOME/.agent-project-time-map.yaml"

status "Configuring project tracker mapping in $MAP_FILE"
PROJECT_NAME="$(ask "Project name" "$PROJECT_NAME_DEFAULT")"
PROJECT_PATH="$(ask "Canonical project path" "$PROJECT_ROOT")"
PROJECT_GIT="$(ask "Git origin" "$GIT_ORIGIN_DEFAULT")"

USE_TICKET_TRACKING="$(ask_yes_no "Use ticket tracking" "yes")"
TICKET_TRACKERS=""
PARENT_TRACKER=""

JIRA_USE_TIME_TRACKING="false"
JIRA_BASE_URL=""
JIRA_PROJECT_KEY=""
JIRA_IS_CHILD="false"
JIRA_KEY_PATTERN=""
JIRA_REPLICA_FIELD=""

CLICKUP_USE_TIME_TRACKING="false"
CLICKUP_FOLDER_ID=""
CLICKUP_DEFAULT_LIST_ID=""
CLICKUP_DEFAULT_LIST_TYPE="development"
CLICKUP_CUSTOM_ID_PREFIX=""
CLICKUP_IS_CHILD="false"
CLICKUP_OTHER_LISTS_RAW=""
OTHER_TICKET_TRACKERS_RAW=""

if [ "$USE_TICKET_TRACKING" = "true" ]; then
  TICKET_TRACKERS="$(normalize_csv "$(ask "Ticket trackers (comma-separated: jira,clickup,other)" "jira")")"
  PARENT_TRACKER="$(ask "Parent tracker (jira or clickup)" "jira")"

  if contains_csv_value "$TICKET_TRACKERS" "jira"; then
    JIRA_USE_TIME_TRACKING="$(ask_yes_no "Jira time tracking enabled" "no")"
    JIRA_BASE_URL="$(ask "Jira base URL (example: myteam.atlassian.net)" "")"
    JIRA_PROJECT_KEY="$(ask "Jira project key (example: AIA)" "")"
    JIRA_IS_CHILD="$(ask_yes_no "Is Jira a child tracker" "false")"
    if [ -n "$JIRA_PROJECT_KEY" ]; then
      JIRA_KEY_PATTERN="$(ask "Jira ticket pattern regex" "^${JIRA_PROJECT_KEY}-[0-9]+$")"
    fi
    JIRA_REPLICA_FIELD="$(ask "Jira custom field for child/replica ticket id (optional)" "")"
  fi

  if contains_csv_value "$TICKET_TRACKERS" "clickup"; then
    CLICKUP_USE_TIME_TRACKING="$(ask_yes_no "ClickUp time tracking enabled" "no")"
    CLICKUP_FOLDER_ID="$(ask "ClickUp folder id" "")"
    CLICKUP_DEFAULT_LIST_ID="$(ask "ClickUp default list id" "")"
    CLICKUP_DEFAULT_LIST_TYPE="$(ask "ClickUp default list type" "development")"
    CLICKUP_CUSTOM_ID_PREFIX="$(ask "ClickUp custom ID prefix (example: SL)" "")"
    CLICKUP_IS_CHILD="$(ask_yes_no "Is ClickUp a child tracker" "false")"
    CLICKUP_OTHER_LISTS_RAW="$(ask "Other lists (semicolon separated entries type:id:isDefault:subtype:useWhen)" "")"
  fi

  if contains_csv_value "$TICKET_TRACKERS" "other"; then
    OTHER_TICKET_TRACKERS_RAW="$(ask "Other ticket trackers (semicolon entries name:mcpServer:apiBase:useTimeTracking)" "")"
  fi
fi

USE_TIME_TRACKING="$(ask_yes_no "Use dedicated time tracking" "yes")"
TIME_TRACKING_PROVIDERS=""

EVERHOUR_WORKSPACE_ID=""
EVERHOUR_PROJECT_ID=""
EVERHOUR_API_BASE="https://api.everhour.com"
EVERHOUR_TOKEN_ENV="EVERHOUR_API_TOKEN"
OTHER_TIME_PROVIDERS_RAW=""

if [ "$USE_TIME_TRACKING" = "true" ]; then
  TIME_TRACKING_PROVIDERS="$(normalize_csv "$(ask "Time tracking providers (comma-separated: everhour,jira,clickup,internal,other)" "internal")")"
  if contains_csv_value "$TIME_TRACKING_PROVIDERS" "everhour"; then
    EVERHOUR_WORKSPACE_ID="$(ask "Everhour workspace id" "")"
    EVERHOUR_PROJECT_ID="$(ask "Everhour project id" "")"
    EVERHOUR_API_BASE="$(ask "Everhour API base" "$EVERHOUR_API_BASE")"
    EVERHOUR_TOKEN_ENV="$(ask "Everhour token env var name" "$EVERHOUR_TOKEN_ENV")"
  fi
  if contains_csv_value "$TIME_TRACKING_PROVIDERS" "other"; then
    OTHER_TIME_PROVIDERS_RAW="$(ask "Other time providers (semicolon entries name:mcpServer:apiBase:enabled)" "")"
  fi
fi

if [ ! -f "$MAP_FILE" ]; then
  status "Creating $MAP_FILE"
  cat > "$MAP_FILE" <<'YAML'
projects:
YAML
fi

if ! grep -q '^projects:' "$MAP_FILE"; then
  status "Existing map missing projects root. Rebuilding with projects root."
  {
    echo "projects:"
    cat "$MAP_FILE"
  } > "$TMP_FILE"
  cp "$TMP_FILE" "$MAP_FILE"
fi

BEGIN_MARKER="# BEGIN PROJECT_TRACKER ${PROJECT_NAME}"
END_MARKER="# END PROJECT_TRACKER ${PROJECT_NAME}"

awk -v begin_marker="$BEGIN_MARKER" -v end_marker="$END_MARKER" '
  BEGIN { skip=0 }
  $0 == begin_marker { skip=1; next }
  $0 == end_marker { skip=0; next }
  skip == 0 { print }
' "$MAP_FILE" > "$TMP_FILE"
cp "$TMP_FILE" "$MAP_FILE"

{
  echo "$BEGIN_MARKER"
  echo "  ${PROJECT_NAME}:"
  echo "    path: $(yaml_quote "$PROJECT_PATH")"
  echo "    git: $(yaml_quote "$PROJECT_GIT")"
  echo "    parentTracker: $(yaml_quote "$PARENT_TRACKER")"
  echo "    ticketTracking:"

  if [ "$USE_TICKET_TRACKING" = "true" ] && contains_csv_value "$TICKET_TRACKERS" "jira"; then
    echo "      jira:"
    echo "        useTimeTracking: ${JIRA_USE_TIME_TRACKING}"
    echo "        baseUrl: $(yaml_quote "$JIRA_BASE_URL")"
    echo "        project: $(yaml_quote "$JIRA_PROJECT_KEY")"
    echo "        isChild: ${JIRA_IS_CHILD}"
    echo "        ticketKeyPattern: $(yaml_quote "$JIRA_KEY_PATTERN")"
    if [ -n "$JIRA_REPLICA_FIELD" ]; then
      echo "        replicaIdField: $(yaml_quote "$JIRA_REPLICA_FIELD")"
    fi
  fi

  if [ "$USE_TICKET_TRACKING" = "true" ] && contains_csv_value "$TICKET_TRACKERS" "clickup"; then
    echo "      clickup:"
    echo "        useTimeTracking: ${CLICKUP_USE_TIME_TRACKING}"
    echo "        folder: $(yaml_quote "$CLICKUP_FOLDER_ID")"
    echo "        defaultList:"
    echo "          id: $(yaml_quote "$CLICKUP_DEFAULT_LIST_ID")"
    echo "          type: $(yaml_quote "$CLICKUP_DEFAULT_LIST_TYPE")"
    echo "        customIdPrefix: $(yaml_quote "$CLICKUP_CUSTOM_ID_PREFIX")"
    echo "        isChild: ${CLICKUP_IS_CHILD}"
    echo "        otherLists:"

    if [ -n "$CLICKUP_OTHER_LISTS_RAW" ]; then
      IFS=';' read -r -a list_entries <<< "$CLICKUP_OTHER_LISTS_RAW"
      for entry in "${list_entries[@]}"; do
        entry="$(trim "$entry")"
        [ -z "$entry" ] && continue
        IFS=':' read -r list_type list_id list_default list_subtype list_use_when <<< "$entry"
        list_type="$(trim "$list_type")"
        list_id="$(trim "$list_id")"
        list_default="$(trim "$list_default")"
        list_subtype="$(trim "$list_subtype")"
        list_use_when="$(trim "$list_use_when")"
        [ -z "$list_type" ] && list_type="general"
        [ -z "$list_id" ] && list_id=""
        [ -z "$list_default" ] && list_default="false"
        echo "          - type: $(yaml_quote "$list_type")"
        echo "            isDefault: ${list_default}"
        echo "            id: $(yaml_quote "$list_id")"
        if [ -n "$list_subtype" ]; then
          echo "            subtype: $(yaml_quote "$list_subtype")"
        fi
        if [ -n "$list_use_when" ]; then
          echo "            useWhen: $(yaml_quote "$list_use_when")"
        fi
      done
    fi
  fi

  echo "    timeTracking:"
  if [ "$USE_TIME_TRACKING" = "true" ] && contains_csv_value "$TIME_TRACKING_PROVIDERS" "everhour"; then
    echo "      everhour:"
    echo "        enabled: true"
    echo "        workspaceId: $(yaml_quote "$EVERHOUR_WORKSPACE_ID")"
    echo "        projectId: $(yaml_quote "$EVERHOUR_PROJECT_ID")"
    echo "        apiBase: $(yaml_quote "$EVERHOUR_API_BASE")"
    echo "        apiTokenEnv: $(yaml_quote "$EVERHOUR_TOKEN_ENV")"
  fi

  if [ "$USE_TIME_TRACKING" = "true" ] && contains_csv_value "$TIME_TRACKING_PROVIDERS" "jira"; then
    echo "      jiraWorklog:"
    echo "        enabled: true"
  fi

  if [ "$USE_TIME_TRACKING" = "true" ] && contains_csv_value "$TIME_TRACKING_PROVIDERS" "clickup"; then
    echo "      clickup:"
    echo "        enabled: true"
  fi

  if [ "$USE_TIME_TRACKING" = "true" ] && contains_csv_value "$TIME_TRACKING_PROVIDERS" "internal"; then
    echo "      internal:"
    echo "        enabled: true"
  fi

  if [ "$USE_TIME_TRACKING" = "false" ]; then
    echo "      internal:"
    echo "        enabled: true"
  fi

  echo "    integrations:"
  echo "      mcp:"
  echo "        atlassianRovo:"
  if [ "$USE_TICKET_TRACKING" = "true" ] && contains_csv_value "$TICKET_TRACKERS" "jira"; then
    echo "          required: true"
  else
    echo "          required: false"
  fi
  echo "          installed: false"
  echo "          authMode: $(yaml_quote "apiToken")"
  echo "          prefersNonInteractive: true"
  echo "          resolvedCloudId: $(yaml_quote "")"
  echo "        clickup:"
  if [ "$USE_TICKET_TRACKING" = "true" ] && contains_csv_value "$TICKET_TRACKERS" "clickup"; then
    echo "          required: true"
  else
    echo "          required: false"
  fi
  echo "          installed: false"
  echo "          prefersNonInteractive: true"
  echo "          resolvedWorkspaceId: $(yaml_quote "")"
  echo "        everhour:"
  if [ "$USE_TIME_TRACKING" = "true" ] && contains_csv_value "$TIME_TRACKING_PROVIDERS" "everhour"; then
    echo "          required: true"
  else
  echo "          required: false"
  fi
  echo "          installed: false"
  echo "          installHint: $(yaml_quote "everhour-direct-or-self-hosted-mcp")"
  echo "          sourceClass: $(yaml_quote "direct")"
  echo "          prefersNonInteractive: true"

  echo "      providers:"
  echo "        otherTicketSystems:"
  if [ -n "$OTHER_TICKET_TRACKERS_RAW" ]; then
    IFS=';' read -r -a ticket_provider_entries <<< "$OTHER_TICKET_TRACKERS_RAW"
    for entry in "${ticket_provider_entries[@]}"; do
      entry="$(trim "$entry")"
      [ -z "$entry" ] && continue
      IFS=':' read -r provider_name provider_mcp provider_api provider_use_tt <<< "$entry"
      provider_name="$(trim "$provider_name")"
      provider_mcp="$(trim "$provider_mcp")"
      provider_api="$(trim "$provider_api")"
      provider_use_tt="$(trim "$provider_use_tt")"
      [ -z "$provider_use_tt" ] && provider_use_tt="false"
      echo "          - name: $(yaml_quote "$provider_name")"
      echo "            enabled: true"
      echo "            mcpServer: $(yaml_quote "$provider_mcp")"
      echo "            sourceClass: $(yaml_quote "vendor")"
      echo "            apiBase: $(yaml_quote "$provider_api")"
      echo "            useTimeTracking: ${provider_use_tt}"
    done
  fi
  echo "        otherTimeSystems:"
  if [ -n "$OTHER_TIME_PROVIDERS_RAW" ]; then
    IFS=';' read -r -a time_provider_entries <<< "$OTHER_TIME_PROVIDERS_RAW"
    for entry in "${time_provider_entries[@]}"; do
      entry="$(trim "$entry")"
      [ -z "$entry" ] && continue
      IFS=':' read -r provider_name provider_mcp provider_api provider_enabled <<< "$entry"
      provider_name="$(trim "$provider_name")"
      provider_mcp="$(trim "$provider_mcp")"
      provider_api="$(trim "$provider_api")"
      provider_enabled="$(trim "$provider_enabled")"
      [ -z "$provider_enabled" ] && provider_enabled="true"
      echo "          - name: $(yaml_quote "$provider_name")"
      echo "            enabled: ${provider_enabled}"
      echo "            mcpServer: $(yaml_quote "$provider_mcp")"
      echo "            sourceClass: $(yaml_quote "vendor")"
      echo "            apiBase: $(yaml_quote "$provider_api")"
    done
  fi

  echo "$END_MARKER"
} >> "$MAP_FILE"

status "Project mapping saved."
printf '{"status":"ok","mapFile":"%s","project":"%s","path":"%s","git":"%s","ticketTrackers":"%s","timeTracking":"%s"}\n' \
  "$MAP_FILE" "$PROJECT_NAME" "$PROJECT_PATH" "$PROJECT_GIT" "$TICKET_TRACKERS" "$TIME_TRACKING_PROVIDERS"
