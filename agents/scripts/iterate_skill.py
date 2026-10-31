#!/usr/bin/env python3
"""Save one Waza skill assessment and compare it with the previous one."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path


SUITES = ("real.yaml", "routing.yaml")


def completed_runs(skill_dir: Path, skill: str) -> list[Path]:
    """Return numbered runs with a report and both source-bound result files."""
    return sorted(
        path for path in skill_dir.iterdir()
        if path.is_dir() and re.fullmatch(r"\d{4,}", path.name)
        and (path / "assessment.json").is_file()
        and (path / "coverage.json").is_file()
        and all((path / skill / f"{suite}.json").is_file() for suite in SUITES)
        and all((path / skill / f"{suite}.receipt.json").is_file() for suite in SUITES)
    )


def next_run(skill_dir: Path) -> Path:
    numbers = [int(path.name) for path in skill_dir.iterdir()
               if path.is_dir() and re.fullmatch(r"\d{4,}", path.name)]
    path = skill_dir / f"{max(numbers, default=0) + 1:04d}"
    path.mkdir()
    return path


def run_assessment(repo: Path, skill: str, runs_dir: Path, trials: int,
                   waza: str, make: str, effect: bool = False) -> Path:
    if not re.fullmatch(r"[a-z0-9-]+", skill):
        raise ValueError(f"Invalid skill name: {skill}")
    if trials < 1:
        raise ValueError("Trials must be at least 1")
    if not (repo / "agents/.agents/skills" / skill / "SKILL.md").is_file():
        raise ValueError(f"Unknown skill: {skill}")
    skill_dir = runs_dir.resolve() / skill
    skill_dir.mkdir(parents=True, exist_ok=True)
    previous_runs = completed_runs(skill_dir, skill)
    previous = previous_runs[-1] if previous_runs else None
    current = next_run(skill_dir)
    print(f"Assessment {current.name}: {skill} ({trials} trial(s) per task)", flush=True)
    print(f"Results: {current}", flush=True)

    subprocess.run(
        [make, "--no-print-directory", "real", f"AGENT_SKILL={skill}",
         f"AGENT_RESULTS_DIR={current}", f"AGENT_TRIALS={trials}", f"WAZA={waza}"],
        cwd=repo / "agents", check=True,
    )

    command = [sys.executable, str(repo / "agents/scripts/skill_coverage.py"),
               "--repo-root", str(repo), "--waza", waza,
               "--results-root", str(current), "--json-out", str(current / "coverage.json")]
    if previous:
        command += ["--previous", str(previous / "coverage.json")]
    with (current / "coverage.md").open("w", encoding="utf-8") as report:
        subprocess.run(command, cwd=repo, stdout=report, check=True)

    if effect:
        subprocess.run(
            [waza, "run", str(repo / "agents/.agents/skills" / skill / "evals/real.yaml"),
             "--baseline", "--no-cache", "--trials", str(trials),
             "--output", str(current / "effect.json")],
            cwd=repo / "agents", check=True,
        )

    (current / "assessment.json").write_text(json.dumps({
        "skill": skill,
        "created_utc": datetime.now(timezone.utc).isoformat(),
        "trials_per_task": trials,
        "skill_effect_run": effect,
        "previous": previous.name if previous else None,
    }, indent=2) + "\n", encoding="utf-8")

    if previous:
        print(f"Comparing {previous.name} → {current.name}", flush=True)
        for suite in SUITES:
            output = current / f"compare-{suite.removesuffix('.yaml')}.txt"
            with output.open("w", encoding="utf-8") as report:
                result = subprocess.run(
                    [waza, "compare", str(previous / skill / f"{suite}.json"),
                     str(current / skill / f"{suite}.json")],
                    cwd=repo, stdout=report, stderr=subprocess.STDOUT, check=False,
                )
            if result.returncode:
                print(f"Waza comparison failed; inspect {output}", file=sys.stderr)
            else:
                print(f"Task comparison: {output}")
    else:
        print("Baseline saved; edit the skill, then run this target again.")
    print(f"Coverage report: {current / 'coverage.md'}")
    return current


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo-root", type=Path, default=Path(__file__).resolve().parents[2])
    parser.add_argument("--skill", required=True)
    parser.add_argument("--runs-dir", type=Path, required=True)
    parser.add_argument("--trials", type=int, default=1)
    parser.add_argument("--waza", default="waza")
    parser.add_argument("--make", default="make")
    parser.add_argument("--effect", action="store_true",
                        help="Also run Waza's with-skill versus no-skill comparison")
    args = parser.parse_args()
    try:
        run_assessment(args.repo_root.resolve(), args.skill, args.runs_dir,
                       args.trials, args.waza, args.make, args.effect)
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        print(f"Skill assessment failed: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
