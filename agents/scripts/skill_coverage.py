#!/usr/bin/env python3
"""Report source retention, behavioral eval mapping, and Waza result deltas."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import sys
from pathlib import Path


IMPORTED = {
    "guidelines-rust": "guidelines",
    "sort-rust": "sort",
    "pikchr-diagram": "pikchr-diagram",
    "rust-best-practices": "rust-best-practices",
    "rust-review": "rust-review",
}
SUITES = {"behavior": "real.yaml", "routing": "routing.yaml"}


def digest(value: str) -> str:
    return hashlib.sha256(value.encode("utf-8")).hexdigest()


def file_digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def slug(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-") or "section"


def sections(markdown: str) -> list[dict[str, str]]:
    """Split at level-two headings outside fenced examples; retain exact text."""
    lines = markdown.splitlines(keepends=True)
    starts: list[tuple[int, str]] = [(0, "Introduction")]
    fence: str | None = None
    for index, line in enumerate(lines):
        match = re.match(r"^\s*(`{3,}|~{3,})", line)
        if match:
            marker = match.group(1)
            if fence is None:
                fence = marker[0]
            elif marker[0] == fence:
                fence = None
            continue
        if fence is None and line.startswith("## "):
            starts.append((index, line[3:].strip()))
    output = []
    seen: dict[str, int] = {}
    for position, (start, heading) in enumerate(starts):
        end = starts[position + 1][0] if position + 1 < len(starts) else len(lines)
        base = "intro" if position == 0 else slug(heading)
        seen[base] = seen.get(base, 0) + 1
        identifier = base if seen[base] == 1 else f"{base}-{seen[base]}"
        output.append({"id": identifier, "heading": heading, "sha256": digest("".join(lines[start:end]))})
    return output


def capture_baseline(repo: Path, manifest_path: Path) -> None:
    if manifest_path.exists():
        raise ValueError(f"Refusing to replace original baseline: {manifest_path}")
    skills = {}
    for name, source in IMPORTED.items():
        skill_file = repo / "agents/.agents/skills" / name / "SKILL.md"
        skills[name] = {
            "acorn_source": source,
            "sections": [
                {**section, "behavior": [], "routing": []}
                for section in sections(skill_file.read_text(encoding="utf-8"))
            ],
        }
    manifest_path.parent.mkdir(parents=True, exist_ok=True)
    manifest_path.write_text(
        json.dumps(
            {"schema_version": 1, "baseline": "Imported Acorn skills", "skills": skills},
            indent=2,
        ) + "\n",
        encoding="utf-8",
    )


def preflight(repo: Path, waza: str, skill: str, filename: str) -> dict[str, str]:
    suite = repo / "agents/.agents/skills" / skill / "evals" / filename
    command = subprocess.run(
        [waza, "preflight", str(suite), "--format", "json"],
        cwd=repo,
        capture_output=True,
        text=True,
        check=False,
    )
    if command.returncode:
        raise ValueError(f"Waza preflight failed for {suite}: {command.stderr.strip()}")
    result = json.loads(command.stdout)
    if result.get("complete") is not True or result.get("executor") != "copilot-sdk":
        raise ValueError(f"Expected a complete copilot-sdk suite: {suite}")
    return {
        task["id"]: digest(Path(task["source"]).read_text(encoding="utf-8"))
        for task in result["tasks"] if task.get("enabled")
    }


def record_results(repo: Path, root: Path, skill: str, waza: str) -> None:
    skill_dir = repo / "agents/.agents/skills" / skill
    for suite in SUITES.values():
        result_path = root / skill / f"{suite}.json"
        if not result_path.exists():
            raise ValueError(f"Missing real-agent result: {result_path}")
        inventory = preflight(repo, waza, skill, suite)
        receipt = {
            "schema_version": 1,
            "result_sha256": file_digest(result_path),
            "skill_sha256": file_digest(skill_dir / "SKILL.md"),
            "suite_sha256": file_digest(skill_dir / "evals" / suite),
            "tasks": inventory,
        }
        path = root / skill / f"{suite}.receipt.json"
        path.write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")


def results_for(root: Path | None, repo: Path, skill: str, suite: str,
                inventory: dict[str, str]) -> tuple[dict[str, dict], dict[str, str]]:
    if root is None:
        return {}, {}
    path = root / skill / f"{suite}.json"
    if not path.exists():
        return {}, {}
    value = json.loads(path.read_text(encoding="utf-8"))
    if value.get("skill") != skill:
        raise ValueError(f"Result skill mismatch in {path}")
    config = value.get("config", {})
    engine = config.get("engine_type")
    model = config.get("model_id")
    if not engine or engine == "mock" or not model or model == "mock":
        raise ValueError(f"Mock or incomplete result cannot prove behavior: {path}")
    receipt_path = root / skill / f"{suite}.receipt.json"
    if not receipt_path.exists():
        raise ValueError(f"Missing source-bound result receipt: {receipt_path}")
    receipt = json.loads(receipt_path.read_text(encoding="utf-8"))
    skill_dir = repo / "agents/.agents/skills" / skill
    expected = {
        "schema_version": 1,
        "result_sha256": file_digest(path),
        "skill_sha256": file_digest(skill_dir / "SKILL.md"),
        "suite_sha256": file_digest(skill_dir / "evals" / suite),
        "tasks": inventory,
    }
    if receipt != expected:
        raise ValueError(f"Stale or altered real-agent result: {path}")
    rates = {}
    for task in value.get("tasks", []):
        task_id = task.get("test_id")
        stats = task.get("stats", {})
        rate = stats.get("pass_rate")
        trials = stats.get("total_runs")
        if not task_id or not isinstance(rate, (int, float)) or not 0 <= rate <= 1:
            raise ValueError(f"Missing task identity or pass rate in {path}")
        if not isinstance(trials, int) or trials < 1:
            raise ValueError(f"Missing trial count in {path}")
        if task_id in rates:
            raise ValueError(f"Duplicate task {task_id} in {path}")
        rates[task_id] = {"pass_rate": float(rate), "trials": trials}
    return rates, {"engine": engine, "model": model,
                   "skill_sha256": receipt["skill_sha256"]}


def build_report(repo: Path, manifest: dict, waza: str, results_root: Path | None) -> dict:
    if manifest.get("schema_version") != 1 or not isinstance(manifest.get("skills"), dict):
        raise ValueError("Unsupported capability manifest")
    report: dict = {"schema_version": 1, "skills": {}, "tasks": {}, "issues": []}
    installed = {p.parent.name for p in (repo / "agents/.agents/skills").glob("*/SKILL.md")}
    untracked = sorted(installed - {"blank-test"} - set(manifest["skills"]))
    if untracked:
        report["issues"].append("Skills without capability baseline: " + ", ".join(untracked))
    totals = {"sections": 0, "unchanged": 0, "modified": 0, "missing": 0,
              "behavior_mapped": 0, "routing_mapped": 0, "behavior_verified": 0}
    for skill, definition in sorted(manifest["skills"].items()):
        if not re.fullmatch(r"[a-z0-9-]+", skill):
            raise ValueError(f"Unsafe skill name: {skill}")
        path = repo / "agents/.agents/skills" / skill / "SKILL.md"
        current = {item["id"]: item for item in sections(path.read_text(encoding="utf-8"))}
        inventories = {kind: preflight(repo, waza, skill, filename)
                       for kind, filename in SUITES.items()}
        observed = {kind: results_for(results_root, repo, skill, filename, inventories[kind])
                    for kind, filename in SUITES.items()}
        original_ids = set()
        entries = []
        for item in definition["sections"]:
            section_id = item["id"]
            if section_id in original_ids:
                raise ValueError(f"Duplicate baseline section: {skill}/{section_id}")
            original_ids.add(section_id)
            now = current.get(section_id)
            status = "missing" if now is None else (
                "unchanged" if now["sha256"] == item["sha256"] else "modified")
            approval = item.get("accepted_change")
            approved = bool(
                approval and approval.get("sha256") == (now or {}).get("sha256")
                and approval.get("reason") and approval.get("evidence")
            )
            if status != "unchanged" and not approved:
                report["issues"].append(f"Unreviewed source {status}: {skill}/{section_id}")
            totals["sections"] += 1
            totals[status] += 1
            links = {}
            for kind, filename in SUITES.items():
                ids = item.get(kind, [])
                if not isinstance(ids, list) or len(ids) != len(set(ids)):
                    raise ValueError(f"Invalid {kind} task list: {skill}/{section_id}")
                missing = sorted(set(ids) - set(inventories[kind]))
                if missing:
                    report["issues"].append(
                        f"Missing {kind} task for {skill}/{section_id}: {', '.join(missing)}")
                valid = sorted(set(ids) & set(inventories[kind]))
                links[kind] = valid
                if valid:
                    totals[f"{kind}_mapped"] += 1
                rates, metadata = observed[kind]
                for task_id in valid:
                    if task_id in rates:
                        report["tasks"][f"{skill}/{filename}/{task_id}"] = {
                            **rates[task_id], **metadata,
                            "case_sha256": inventories[kind][task_id],
                            "suite_sha256": digest((repo / "agents/.agents/skills" / skill /
                                                    "evals" / filename).read_text(encoding="utf-8")),
                        }
            verified = bool(links["behavior"]) and all(
                f"{skill}/real.yaml/{task_id}" in report["tasks"]
                and report["tasks"][f"{skill}/real.yaml/{task_id}"]["pass_rate"] == 1
                for task_id in links["behavior"]
            )
            if verified:
                totals["behavior_verified"] += 1
            entries.append({"id": section_id, "heading": item["heading"],
                            "source": status, "approved": approved,
                            "baseline_sha256": item["sha256"],
                            "current_sha256": now["sha256"] if now else None,
                            **links,
                            "behavior_verified": verified})
        report["skills"][skill] = {
            "sections": entries,
            "added_sections": sorted(set(current) - original_ids),
        }
    report["summary"] = totals
    return report


def compare(previous: dict, current: dict) -> dict:
    before = previous["summary"]
    after = current["summary"]
    delta = {key: after[key] - before[key] for key in
             ("sections", "behavior_mapped", "routing_mapped", "behavior_verified")}
    old_sections = {f"{skill}/{s['id']}": s for skill, data in previous["skills"].items()
                    for s in data["sections"]}
    new_sections = {f"{skill}/{s['id']}": s for skill, data in current["skills"].items()
                    for s in data["sections"]}
    removed_sections = sorted(old_sections.keys() - new_sections.keys())
    changed_original_digests = sorted(
        key for key in old_sections.keys() & new_sections.keys()
        if old_sections[key].get("baseline_sha256") != new_sections[key].get("baseline_sha256")
    )
    lost = sorted(key for key, old in old_sections.items()
                  if old["behavior"] and (key not in new_sections or not new_sections[key]["behavior"]))
    gained = sorted(key for key, now in new_sections.items()
                    if now["behavior"] and (key not in old_sections or not old_sections[key]["behavior"]))
    reduced_links = sorted(
        f"{key}/{kind}" for key, old in old_sections.items()
        for kind in SUITES
        if len(new_sections.get(key, {}).get(kind, [])) < len(old[kind])
    )
    changed_links = sorted(
        f"{key}/{kind}" for key in old_sections.keys() & new_sections.keys()
        for kind in SUITES
        if set(old_sections[key][kind]) != set(new_sections[key][kind])
    )
    regressed, improved, incomparable = [], [], []
    for task_id, old in previous.get("tasks", {}).items():
        now = current.get("tasks", {}).get(task_id)
        if now is None:
            continue
        comparable_fields = ("engine", "model", "trials", "case_sha256", "suite_sha256")
        if any(old.get(field) != now.get(field) for field in comparable_fields):
            incomparable.append(task_id)
        elif now["pass_rate"] < old["pass_rate"]:
            regressed.append(task_id)
        elif now["pass_rate"] > old["pass_rate"]:
            improved.append(task_id)
    return {"counts": delta, "removed_baseline_sections": removed_sections,
            "changed_original_digests": changed_original_digests,
            "lost_behavior_mapping": lost,
            "gained_behavior_mapping": gained, "reduced_task_links": reduced_links,
            "changed_task_links": changed_links, "regressed_tasks": regressed,
            "improved_tasks": improved, "incomparable_tasks": incomparable}


def markdown(report: dict) -> str:
    summary = report["summary"]
    lines = ["# Skill capability coverage", "",
             "Source retention is measured against the imported Acorn sections. "
             "Mapped tests are potential coverage; saved real-agent results show observed passes.", "",
             "| Skill | Original sections | Unchanged | Changed | Missing | Behavior mapped | Routing mapped | Observed real passes |",
             "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |"]
    for skill, data in report["skills"].items():
        entries = data["sections"]
        count = lambda field, value: sum(s[field] == value for s in entries)
        lines.append(
            f"| {skill} | {len(entries)} | {count('source', 'unchanged')} | "
            f"{count('source', 'modified')} | {count('source', 'missing')} | "
            f"{sum(bool(s['behavior']) for s in entries)} | "
            f"{sum(bool(s['routing']) for s in entries)} | "
            f"{sum(s['behavior_verified'] for s in entries)} |"
        )
    lines += ["", f"Behavior mapping: {summary['behavior_mapped']}/{summary['sections']} "
              "original sections. Real passes require authenticated Waza results."]
    unmapped = {
        skill: [s["heading"] for s in data["sections"] if not s["behavior"]]
        for skill, data in report["skills"].items()
    }
    lines += ["", "## Original sections without behavior evals", ""]
    lines += [f"- {skill}: {', '.join(headings)}" for skill, headings in unmapped.items()
              if headings]
    changed = [f"{skill}/{s['id']} ({s['source']}{', reviewed' if s['approved'] else ''})"
               for skill, data in report["skills"].items() for s in data["sections"]
               if s["source"] != "unchanged"]
    if changed:
        lines += ["", "Source changes: " + ", ".join(changed)]
    added = [f"{skill}/{section_id}" for skill, data in report["skills"].items()
             for section_id in data["added_sections"]]
    if added:
        lines += ["", "New sections: " + ", ".join(added)]
    if report.get("comparison"):
        c = report["comparison"]
        lines += ["", "## Change from previous report", "",
                  f"Behavior mapping: {c['counts']['behavior_mapped']:+d}; "
                  f"routing mapping: {c['counts']['routing_mapped']:+d}; "
                  f"verified sections: {c['counts']['behavior_verified']:+d}."]
        for key, label in (("removed_baseline_sections", "Removed baseline section"),
                           ("changed_original_digests", "Changed original digest"),
                           ("lost_behavior_mapping", "Lost behavior mapping"),
                           ("gained_behavior_mapping", "Gained behavior mapping"),
                           ("reduced_task_links", "Reduced task links"),
                           ("changed_task_links", "Changed task links"),
                           ("regressed_tasks", "Regressed task pass rate"),
                           ("improved_tasks", "Improved task pass rate"),
                           ("incomparable_tasks", "Different model or engine")):
            if c[key]:
                lines.append(f"- {label}: {', '.join(c[key])}")
    if report["issues"]:
        lines += ["", "## Review required", ""]
        lines += [f"- {issue}" for issue in report["issues"]]
    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo-root", type=Path, default=Path(__file__).resolve().parents[2])
    parser.add_argument("--manifest", type=Path)
    parser.add_argument("--waza", default="waza")
    parser.add_argument("--results-root", type=Path)
    parser.add_argument("--previous", type=Path, help="Previous report JSON")
    parser.add_argument("--json-out", type=Path)
    parser.add_argument("--format", choices=("markdown", "json"), default="markdown")
    parser.add_argument("--strict", action="store_true", help="Fail on unreviewed changes or regressions")
    parser.add_argument("--capture-baseline", action="store_true")
    parser.add_argument("--record-skill", help="Bind saved real results to current sources")
    args = parser.parse_args()
    repo = args.repo_root.resolve()
    manifest_path = args.manifest or repo / "agents/coverage/capabilities.json"
    try:
        if args.capture_baseline:
            capture_baseline(repo, manifest_path)
            print(f"Captured original skill sections in {manifest_path}")
            return 0
        if args.record_skill:
            if args.results_root is None:
                raise ValueError("--record-skill requires --results-root")
            if args.record_skill not in IMPORTED and args.record_skill != "blank-test":
                raise ValueError(f"Unknown skill: {args.record_skill}")
            record_results(repo, args.results_root, args.record_skill, args.waza)
            print(f"Recorded source-bound results for {args.record_skill}")
            return 0
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        report = build_report(repo, manifest, args.waza, args.results_root)
        if args.previous:
            previous = json.loads(args.previous.read_text(encoding="utf-8"))
            report["comparison"] = compare(previous, report)
        if args.json_out:
            args.json_out.parent.mkdir(parents=True, exist_ok=True)
            args.json_out.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
        print(json.dumps(report, indent=2) if args.format == "json" else markdown(report), end="")
        if args.strict:
            comparison = report.get("comparison", {})
            if (report["issues"] or comparison.get("removed_baseline_sections")
                    or comparison.get("changed_original_digests")
                    or comparison.get("reduced_task_links")
                    or comparison.get("regressed_tasks")):
                return 1
        return 0
    except (OSError, ValueError, KeyError, json.JSONDecodeError) as error:
        print(f"Skill coverage error: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
