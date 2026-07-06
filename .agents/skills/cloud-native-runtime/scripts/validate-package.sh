#!/bin/bash
set -euo pipefail

if [[ "${1:-}" == "--help" ]]; then
  cat >&2 <<'HELP'
Validate the cloud-native-runtime skill package.

Usage:
  bash scripts/validate-package.sh [skill-dir]

Writes JSON to stdout and human status/errors to stderr.
HELP
  exit 0
fi

skill_dir="${1:-.}"
errors=()

log() { echo "$*" >&2; }
fail() { errors+=("$*"); }

log "Validating skill package at ${skill_dir}"

[[ -d "$skill_dir" ]] || fail "skill directory missing: $skill_dir"
[[ -f "$skill_dir/SKILL.md" ]] || fail "missing SKILL.md"

if [[ -f "$skill_dir/SKILL.md" ]]; then
  grep -q '^---$' "$skill_dir/SKILL.md" || fail "SKILL.md missing YAML frontmatter delimiter"
  grep -q '^name: cloud-native-runtime$' "$skill_dir/SKILL.md" || fail "frontmatter name must be cloud-native-runtime"
  grep -Eq '^description:($| )' "$skill_dir/SKILL.md" || fail "frontmatter description missing"
  grep -q '^license: Apache-2.0$' "$skill_dir/SKILL.md" || fail "frontmatter license must be Apache-2.0"
fi

for dir in references assets scripts evals agents; do
  [[ -d "$skill_dir/$dir" ]] || fail "missing directory: $dir"
done

required_refs=(
  architecture runtime-selection api-standards infrastructure background-processing scheduling
  file-uploads-media networking-caching observability security-secrets resilience-idempotency
  cost-cloud-equivalency review-checklist production-readiness
)
for ref in "${required_refs[@]}"; do
  [[ -f "$skill_dir/references/$ref.md" ]] || fail "missing reference: references/$ref.md"
done

required_assets=(
  implementation-checklist architecture-decision-tree cloud-mapping-matrix runtime-decision-matrix
  async-decision-matrix api-review-checklist code-review-checklist infrastructure-review-checklist
  production-readiness-checklist observability-checklist security-checklist
)
for asset in "${required_assets[@]}"; do
  [[ -f "$skill_dir/assets/$asset.md" ]] || fail "missing asset: assets/$asset.md"
done

[[ -f "$skill_dir/assets/trigger-evals.json" ]] || fail "missing assets/trigger-evals.json"
[[ -f "$skill_dir/assets/evaluation-rubric.json" ]] || fail "missing assets/evaluation-rubric.json"
[[ -f "$skill_dir/evals/evals.json" ]] || fail "missing evals/evals.json"
[[ -f "$skill_dir/agents/openai.yaml" ]] || fail "missing agents/openai.yaml"

python3 - "$skill_dir" <<'PY' || fail "JSON or link validation failed"
import json
import pathlib
import re
import sys
root = pathlib.Path(sys.argv[1])
for rel in ["assets/trigger-evals.json", "assets/evaluation-rubric.json", "evals/evals.json"]:
    with (root / rel).open() as fh:
        json.load(fh)
link_re = re.compile(r"\[[^\]]+\]\(([^)]+)\)")
missing = []
for md in root.rglob("*.md"):
    text = md.read_text()
    for target in link_re.findall(text):
        if "://" in target or target.startswith("#") or target.startswith("mailto:"):
            continue
        clean = target.split("#", 1)[0]
        if clean and not (md.parent / clean).resolve().exists():
            missing.append(f"{md.relative_to(root)} -> {target}")
if missing:
    raise SystemExit("missing markdown links: " + "; ".join(missing))
PY

if [[ -f "$skill_dir/evals/evals.json" ]]; then
  python3 - "$skill_dir/evals/evals.json" <<'PY' || fail "evals schema validation failed"
import json
import sys
with open(sys.argv[1]) as fh:
    data = json.load(fh)
assert data["skill_name"] == "cloud-native-runtime"
assert isinstance(data["evals"], list) and len(data["evals"]) >= 2
for item in data["evals"]:
    assert isinstance(item["id"], int)
    assert item["prompt"].strip()
    assert item["expected_output"].strip()
PY
fi

if ((${#errors[@]})); then
  printf '{"status":"fail","errors":['
  for i in "${!errors[@]}"; do
    escaped=${errors[$i]//\/\\}
    escaped=${escaped//\"/\\\"}
    [[ $i -gt 0 ]] && printf ','
    printf '"%s"' "$escaped"
  done
  printf ']}'
  printf '\n'
  exit 1
fi

printf '{"status":"pass","skill":"cloud-native-runtime","path":"%s"}\n' "$skill_dir"
