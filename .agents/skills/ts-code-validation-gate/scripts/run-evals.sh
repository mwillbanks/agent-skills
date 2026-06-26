#!/bin/bash
set -euo pipefail

status() {
  echo "$1" >&2
}

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

status "Running ts-code-validation-gate evals against GPT-5.5 and GPT-5.4-mini"
python3 "$SCRIPT_DIR/run-evals.py"
