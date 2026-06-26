#!/bin/bash
set -euo pipefail

status() {
  echo "$1" >&2
}

ROOT_DIR="${1:-$(pwd)}"
cd "$ROOT_DIR"

if [ ! -d ".git" ]; then
  status "Repository root with .git is required. Current path: $ROOT_DIR"
  printf '{"status":"error","reason":"not-a-git-repo","root":"%s"}\n' "$ROOT_DIR"
  exit 1
fi

GATE_ROOT=".agents/.code-validation-gate"
mkdir -p "$GATE_ROOT"
mkdir -p ".git/info"

if [ -f ".git/info/exclude" ]; then
  if ! grep -qxF ".agents/.code-validation-gate/" ".git/info/exclude"; then
    echo ".agents/.code-validation-gate/" >> ".git/info/exclude"
  fi
else
  echo ".agents/.code-validation-gate/" > ".git/info/exclude"
fi

latest_run() {
  local latest
  latest="$(ls -1dt "$GATE_ROOT"/*/ 2>/dev/null | head -1 || true)"
  latest="${latest%/}"
  printf '%s' "$latest"
}

prior_run="$(latest_run)"

has_unresolved_prior() {
  local run_dir="$1"
  [ -n "$run_dir" ] || return 1
  [ -d "$run_dir" ] || return 1
  [ -f "$run_dir/needs-remediation.flag" ] || return 1

  if [ ! -f "$run_dir/remediation-ledger.md" ]; then
    return 0
  fi

  grep -qE '^- \[ \]' "$run_dir/remediation-ledger.md"
}

TIMESTAMP="$(date +%F_%H%M%S)"
RUN_DIR="$GATE_ROOT/$TIMESTAMP"
mkdir -p "$RUN_DIR"

if has_unresolved_prior "$prior_run"; then
  status "Fail-closed: unresolved prior remediation ledger at $prior_run"
  cat > "$RUN_DIR/status.json" <<EOF
{
  "status": "fail-closed",
  "reason": "prior-remediation-unresolved",
  "prior_run": "$prior_run",
  "run_dir": "$RUN_DIR",
  "review_valid": false
}
EOF
  cat "$RUN_DIR/status.json"
  exit 3
fi

RESULTS_FILE="$RUN_DIR/results.tsv"
echo "check|status|exit_code|evidence" > "$RESULTS_FILE"

FAILED=0
TOTAL=0

run_check() {
  local check_name="$1"
  local command="$2"
  local evidence_file="$3"

  TOTAL=$((TOTAL + 1))
  : > "$evidence_file"

  status "Running: $check_name"
  set +e
  eval "$command"
  local rc=$?
  set -e

  local check_status="pass"
  if [ $rc -ne 0 ]; then
    check_status="fail"
    FAILED=$((FAILED + 1))
  fi

  printf "%s|%s|%s|%s\n" "$check_name" "$check_status" "$rc" "$evidence_file" >> "$RESULTS_FILE"
}

has_root_file() {
  [ -e "$1" ]
}

PACKAGE_RUNNER=""
if command -v bunx >/dev/null 2>&1; then
  PACKAGE_RUNNER='bunx --bun'
elif command -v npx >/dev/null 2>&1; then
  PACKAGE_RUNNER='npx --yes'
elif command -v pnpm >/dev/null 2>&1; then
  PACKAGE_RUNNER='pnpm dlx'
elif command -v yarn >/dev/null 2>&1; then
  PACKAGE_RUNNER='yarn dlx'
fi

package_cmd() {
  local package_name="$1"

  if [ -z "$PACKAGE_RUNNER" ]; then
    return 1
  fi

  printf '%s %s' "$PACKAGE_RUNNER" "$package_name"
}

resolve_tool_cmd() {
  local binary_name="$1"
  local package_name="$2"

  if command -v "$binary_name" >/dev/null 2>&1; then
    printf '%s' "$binary_name"
    return 0
  fi

  package_cmd "$package_name"
}

BIOME_LAUNCH="$(resolve_tool_cmd "biome" "@biomejs/biome" 2>/dev/null || true)"
ESLINT_LAUNCH="$(resolve_tool_cmd "eslint" "eslint" 2>/dev/null || true)"
PRETTIER_LAUNCH="$(resolve_tool_cmd "prettier" "prettier" 2>/dev/null || true)"
FALLOW_LAUNCH="$(resolve_tool_cmd "fallow" "fallow" 2>/dev/null || true)"

HAS_BIOME=0
HAS_ESLINT=0
HAS_PRETTIER=0

if has_root_file "biome.json" || has_root_file "biome.jsonc"; then
  HAS_BIOME=1
fi

for f in .eslintrc .eslintrc.js .eslintrc.cjs .eslintrc.mjs .eslintrc.json .eslintrc.yaml .eslintrc.yml eslint.config.js eslint.config.cjs eslint.config.mjs eslint.config.ts eslint.config.mts eslint.config.cts; do
  if has_root_file "$f"; then
    HAS_ESLINT=1
    break
  fi
done

for f in .prettierrc .prettierrc.js .prettierrc.cjs .prettierrc.mjs .prettierrc.json .prettierrc.yaml .prettierrc.yml prettier.config.js prettier.config.cjs prettier.config.mjs prettier.config.ts prettier.config.mts prettier.config.cts; do
  if has_root_file "$f"; then
    HAS_PRETTIER=1
    break
  fi
done

if [ "$HAS_BIOME" -eq 1 ]; then
  if [ -n "$BIOME_LAUNCH" ]; then
    run_check "biome-check" \
      "$BIOME_LAUNCH check --reporter=concise --error-on-warnings --no-errors-on-unmatched --reporter-file=\"$RUN_DIR/biome.txt\" 2>>\"$RUN_DIR/biome.txt\"" \
      "$RUN_DIR/biome.txt"
  else
    echo "Biome config detected but no launcher (bunx/npx/pnpm/yarn) available." > "$RUN_DIR/biome.txt"
    run_check "biome-check" "false" "$RUN_DIR/biome.txt"
  fi
fi

if [ "$HAS_ESLINT" -eq 1 ]; then
  if [ -n "$ESLINT_LAUNCH" ]; then
    run_check "eslint" \
      "$ESLINT_LAUNCH . --max-warnings 0 -f json -o \"$RUN_DIR/eslint.json\" 2>>\"$RUN_DIR/eslint.json\"" \
      "$RUN_DIR/eslint.json"
  else
    echo "ESLint config detected but eslint launcher is unavailable (eslint binary or bunx/npx/pnpm/yarn)." > "$RUN_DIR/eslint.json"
    run_check "eslint" "false" "$RUN_DIR/eslint.json"
  fi
fi

if [ "$HAS_PRETTIER" -eq 1 ]; then
  if [ -n "$PRETTIER_LAUNCH" ]; then
    run_check "prettier-check" \
      "$PRETTIER_LAUNCH . --check > \"$RUN_DIR/prettier.txt\" 2>&1" \
      "$RUN_DIR/prettier.txt"
  else
    echo "Prettier config detected but prettier launcher is unavailable (prettier binary or bunx/npx/pnpm/yarn)." > "$RUN_DIR/prettier.txt"
    run_check "prettier-check" "false" "$RUN_DIR/prettier.txt"
  fi
fi

if command -v bun >/dev/null 2>&1; then
  run_check "unit-tests" \
    "bun test --bail --only-failures > \"$RUN_DIR/tests.txt\" 2>&1" \
    "$RUN_DIR/tests.txt"
elif [ -f "package.json" ] && command -v npm >/dev/null 2>&1; then
  run_check "unit-tests" \
    "npm test -- --bail > \"$RUN_DIR/tests.txt\" 2>&1" \
    "$RUN_DIR/tests.txt"
else
  echo "No supported test runner detected (bun/npm)." > "$RUN_DIR/tests.txt"
  run_check "unit-tests" "false" "$RUN_DIR/tests.txt"
fi

if command -v semgrep >/dev/null 2>&1; then
  run_check "semgrep-auto" \
    "semgrep auto -q --json --json-output=\"$RUN_DIR/semgrep.json\" >/dev/null 2>>\"$RUN_DIR/semgrep.json\" || semgrep scan --config auto -q --json --output=\"$RUN_DIR/semgrep.json\" >/dev/null 2>>\"$RUN_DIR/semgrep.json\"" \
    "$RUN_DIR/semgrep.json"
else
  echo "semgrep not installed." > "$RUN_DIR/semgrep.json"
  run_check "semgrep-auto" "false" "$RUN_DIR/semgrep.json"
fi

if command -v osv-scanner >/dev/null 2>&1; then
  run_check "osv-scan" \
    "osv-scanner scan -r -f markdown --output-file \"$RUN_DIR/osv.md\" 2>>\"$RUN_DIR/osv.md\"" \
    "$RUN_DIR/osv.md"
else
  echo "osv-scanner not installed." > "$RUN_DIR/osv.md"
  run_check "osv-scan" "false" "$RUN_DIR/osv.md"
fi

if [ -n "$FALLOW_LAUNCH" ]; then
  FALLOW_PREP_CMD=""
  if ! has_root_file "fallow.toml" && ! has_root_file ".fallowrc.json"; then
    status "No fallow config detected; bootstrapping via fallow init"
    FALLOW_PREP_CMD="$FALLOW_LAUNCH init >/dev/null 2>>\"$RUN_DIR/fallow.txt\" && "
  fi

  run_check "fallow-audit" \
    "$FALLOW_PREP_CMD$FALLOW_LAUNCH audit -f compact -q --fail-on-issues -o \"$RUN_DIR/fallow.txt\" 2>>\"$RUN_DIR/fallow.txt\"" \
    "$RUN_DIR/fallow.txt"
else
  echo "fallow not installed and no package runner available (bunx/npx/pnpm/yarn)." > "$RUN_DIR/fallow.txt"
  run_check "fallow-audit" "false" "$RUN_DIR/fallow.txt"
fi

FAILED_CHECKS_JSON="$(awk -F'|' 'NR>1 && $2=="fail" { if (count++) printf ","; printf "\"%s\"", $1 }' "$RESULTS_FILE")"
if [ -z "$FAILED_CHECKS_JSON" ]; then
  FAILED_CHECKS_JSON=""
fi

STATUS="pass"
REVIEW_VALID=true
LEDGER_PATH=""

if [ "$FAILED" -gt 0 ]; then
  STATUS="fail"
  REVIEW_VALID=false
  touch "$RUN_DIR/needs-remediation.flag"
  LEDGER_PATH="$RUN_DIR/remediation-ledger.md"

  {
    echo "# Remediation Ledger"
    echo
    echo "- Run: \`$RUN_DIR\`"
    echo "- Created: \`$(date -u +"%Y-%m-%dT%H:%M:%SZ")\`"
    echo
    echo "## Blocking Findings"
    awk -F'|' 'NR>1 && $2=="fail" { printf("- [ ] `%s` — evidence: `%s`\n", $1, $4) }' "$RESULTS_FILE"
    echo
    echo "## Completion Rule"
    echo "All checklist entries must be marked \`[x]\` before the next review run is valid."
  } > "$LEDGER_PATH"
fi

cat > "$RUN_DIR/status.json" <<EOF
{
  "status": "$STATUS",
  "run_dir": "$RUN_DIR",
  "total_checks": $TOTAL,
  "failed_checks_count": $FAILED,
  "failed_checks": [${FAILED_CHECKS_JSON}],
  "remediation_ledger": "$( [ -n "$LEDGER_PATH" ] && echo "$LEDGER_PATH" || echo "" )",
  "review_valid": $REVIEW_VALID
}
EOF

cat "$RUN_DIR/status.json"

if [ "$FAILED" -gt 0 ]; then
  exit 2
fi
