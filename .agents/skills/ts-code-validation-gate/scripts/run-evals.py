#!/usr/bin/env python3
import json
import re
import subprocess
import time
from datetime import datetime, timezone
from pathlib import Path

MODELS = ["gpt-5.5", "gpt-5.4-mini"]


def slugify(value: str) -> str:
    return re.sub(r"[^a-zA-Z0-9._-]+", "-", value).strip("-")


def snippet_for_expectation(response: str, expectation: str) -> str:
    text = response.strip()
    if not text:
        return "No response output captured."

    low = text.lower()
    needle = expectation.lower()
    idx = low.find(needle)
    if idx == -1:
        return "Expectation phrase not found in response."

    start = max(0, idx - 60)
    end = min(len(text), idx + len(expectation) + 60)
    return text[start:end].replace("\n", " ")


def next_iteration_dir(results_root: Path) -> Path:
    results_root.mkdir(parents=True, exist_ok=True)
    existing = []
    for child in results_root.iterdir():
        if child.is_dir() and child.name.startswith("iteration-"):
            try:
                existing.append(int(child.name.split("-")[-1]))
            except ValueError:
                pass
    n = (max(existing) + 1) if existing else 1
    out = results_root / f"iteration-{n}"
    out.mkdir(parents=True, exist_ok=False)
    return out


def main() -> int:
    script_path = Path(__file__).resolve()
    skill_root = script_path.parent.parent
    repo_root = skill_root.parent.parent.parent

    evals_path = skill_root / "evals" / "evals.json"
    evals_data = json.loads(evals_path.read_text())
    evals = evals_data["evals"]

    results_root = skill_root / "evals" / "results"
    iteration_dir = next_iteration_dir(results_root)

    all_runs = []
    total_tokens = 0
    total_duration_ms = 0

    for case in evals:
        eval_id = case["id"]
        prompt = case["prompt"].strip()
        expectations = case.get("expectations", [])
        eval_name = f"eval-{eval_id}"

        case_dir = iteration_dir / f"eval-{eval_id}"
        case_dir.mkdir(parents=True, exist_ok=True)

        for model in MODELS:
            model_dir = case_dir / slugify(model)
            outputs_dir = model_dir / "outputs"
            outputs_dir.mkdir(parents=True, exist_ok=True)

            response_path = outputs_dir / "response.md"
            transcript_path = outputs_dir / "transcript.txt"

            eval_metadata = {
                "eval_id": eval_id,
                "eval_name": eval_name,
                "model": model,
                "prompt": prompt,
                "assertions": expectations,
            }
            (model_dir / "eval_metadata.json").write_text(
                json.dumps(eval_metadata, indent=2) + "\n"
            )

            composed_prompt = (
                "You are being evaluated for skill behavior.\n"
                "Use the ts-code-validation-gate skill instructions from this repository.\n"
                "Answer in concise markdown.\n\n"
                f"Prompt:\n{prompt}"
            )

            cmd = [
                "codex",
                "exec",
                "-m",
                model,
                "--sandbox",
                "read-only",
                "--skip-git-repo-check",
                "--ephemeral",
                "-C",
                str(repo_root),
                "--output-last-message",
                str(response_path),
                composed_prompt,
            ]

            started = time.time()
            proc = subprocess.run(cmd, capture_output=True, text=True)
            duration_ms = int((time.time() - started) * 1000)
            total_duration_ms += duration_ms

            stdout = proc.stdout or ""
            stderr = proc.stderr or ""
            transcript_path.write_text(
                "# stdout\n\n" + stdout + "\n\n# stderr\n\n" + stderr
            )

            if not response_path.exists():
                response_path.write_text("(No response file captured)\n")

            response_text = response_path.read_text(errors="replace")

            token_match = re.search(
                r"tokens used\\s*([0-9,]+)",
                stdout + "\n" + stderr,
                flags=re.IGNORECASE,
            )
            tokens = int(token_match.group(1).replace(",", "")) if token_match else 0
            total_tokens += tokens

            expectation_rows = []
            passed = 0
            for expectation in expectations:
                ok = expectation.lower() in response_text.lower()
                if ok:
                    passed += 1
                expectation_rows.append(
                    {
                        "text": expectation,
                        "passed": ok,
                        "evidence": snippet_for_expectation(response_text, expectation),
                    }
                )

            total = len(expectations)
            pass_rate = (passed / total) if total > 0 else 1.0

            grading = {
                "model": model,
                "expectations": expectation_rows,
                "summary": {
                    "passed": passed,
                    "failed": total - passed,
                    "total": total,
                    "pass_rate": round(pass_rate, 2),
                },
                "timing": {
                    "duration_ms": duration_ms,
                    "duration_seconds": round(duration_ms / 1000, 2),
                },
                "execution": {
                    "exit_code": proc.returncode,
                    "tokens": tokens,
                },
            }
            (model_dir / "grading.json").write_text(
                json.dumps(grading, indent=2) + "\n"
            )

            all_runs.append(
                {
                    "eval_id": eval_id,
                    "eval_name": eval_name,
                    "model": model,
                    "exit_code": proc.returncode,
                    "result": {
                        "pass_rate": round(pass_rate, 2),
                        "passed": passed,
                        "failed": total - passed,
                        "total": total,
                        "time_seconds": round(duration_ms / 1000, 2),
                        "tokens": tokens,
                        "errors": 0 if proc.returncode == 0 else 1,
                    },
                }
            )

    per_model = {}
    for model in MODELS:
        model_runs = [r for r in all_runs if r["model"] == model]
        pass_rates = [r["result"]["pass_rate"] for r in model_runs]
        times = [r["result"]["time_seconds"] for r in model_runs]
        tokens = [r["result"]["tokens"] for r in model_runs]
        per_model[model] = {
            "runs": len(model_runs),
            "avg_pass_rate": round(sum(pass_rates) / len(pass_rates), 2)
            if pass_rates
            else 0,
            "avg_time_seconds": round(sum(times) / len(times), 2) if times else 0,
            "avg_tokens": int(sum(tokens) / len(tokens)) if tokens else 0,
        }

    summary = {
        "metadata": {
            "skill_name": evals_data.get("skill_name", "ts-code-validation-gate"),
            "skill_path": str(skill_root),
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "models": MODELS,
            "evals_run": [c["id"] for c in evals],
            "runs_per_model": 1,
        },
        "runs": all_runs,
        "summary_by_model": per_model,
    }
    (iteration_dir / "benchmark.json").write_text(json.dumps(summary, indent=2) + "\n")

    timing = {
        "captured": True,
        "total_duration_seconds": round(total_duration_ms / 1000, 2),
        "total_tokens": total_tokens,
    }
    (iteration_dir / "timing.json").write_text(json.dumps(timing, indent=2) + "\n")

    print(
        json.dumps(
            {
                "status": "ok",
                "iteration_dir": str(iteration_dir),
                "models": MODELS,
                "eval_count": len(evals),
            }
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
