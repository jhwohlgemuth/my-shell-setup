import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import skill_coverage


class SkillCoverageTests(unittest.TestCase):
    def test_fenced_heading_does_not_create_a_section(self):
        text = "# Skill\n## Real\n```markdown\n## Example only\n```\n## Next\n"
        self.assertEqual(
            [item["id"] for item in skill_coverage.sections(text)],
            ["intro", "real", "next"],
        )

    def test_source_change_requires_a_digest_bound_review(self):
        with tempfile.TemporaryDirectory() as temporary:
            repo = Path(temporary)
            skill_dir = repo / "agents/.agents/skills/sample"
            skill_dir.mkdir(parents=True)
            source = skill_dir / "SKILL.md"
            source.write_text("# Sample\n## Useful behavior\nKeep this.\n")
            original = skill_coverage.sections(source.read_text())
            manifest = {"schema_version": 1, "skills": {"sample": {"sections": [
                {**section, "behavior": ["sample-case"] if section["id"] != "intro" else [],
                 "routing": []} for section in original
            ]}}}
            with patch.object(skill_coverage, "preflight", return_value={"sample-case": "hash"}):
                baseline = skill_coverage.build_report(repo, manifest, "waza", None)
                self.assertEqual(baseline["issues"], [])
                source.write_text("# Sample\n## Useful behavior\nChanged guidance.\n")
                changed = skill_coverage.build_report(repo, manifest, "waza", None)
                self.assertIn("Unreviewed source modified: sample/useful-behavior", changed["issues"])
                manifest["skills"]["sample"]["sections"][1]["accepted_change"] = {
                    "sha256": skill_coverage.sections(source.read_text())[1]["sha256"],
                    "reason": "Reviewed replacement", "evidence": "comparison artifact",
                }
                reviewed = skill_coverage.build_report(repo, manifest, "waza", None)
                self.assertEqual(reviewed["issues"], [])
                source.write_text("# Sample\n")
                removed = skill_coverage.build_report(repo, manifest, "waza", None)
                self.assertIn("Unreviewed source missing: sample/useful-behavior", removed["issues"])

    def test_compare_detects_coverage_and_result_regressions(self):
        section = {"id": "behavior", "baseline_sha256": "original",
                   "behavior": ["one", "two"], "routing": [],
                   "source": "unchanged", "approved": False, "behavior_verified": True}
        metadata = {"engine": "copilot-sdk", "model": "fixed", "trials": 3,
                    "case_sha256": "case", "suite_sha256": "suite"}
        previous = {"summary": {"sections": 1, "behavior_mapped": 1,
                                "routing_mapped": 0, "behavior_verified": 1},
                    "skills": {"sample": {"sections": [section]}},
                    "tasks": {"sample/real.yaml/one": {**metadata, "pass_rate": 1.0}}}
        current = {"summary": {"sections": 1, "behavior_mapped": 1,
                               "routing_mapped": 0, "behavior_verified": 0},
                   "skills": {"sample": {"sections": [{**section, "behavior": ["one"]}]}},
                   "tasks": {"sample/real.yaml/one": {**metadata, "pass_rate": 0.5}}}
        comparison = skill_coverage.compare(previous, current)
        self.assertEqual(comparison["reduced_task_links"], ["sample/behavior/behavior"])
        self.assertEqual(comparison["regressed_tasks"], ["sample/real.yaml/one"])
        current["tasks"]["sample/real.yaml/one"]["model"] = "different"
        comparison = skill_coverage.compare(previous, current)
        self.assertEqual(comparison["regressed_tasks"], [])
        self.assertEqual(comparison["incomparable_tasks"], ["sample/real.yaml/one"])
        current["skills"]["sample"]["sections"] = []
        comparison = skill_coverage.compare(previous, current)
        self.assertEqual(comparison["removed_baseline_sections"], ["sample/behavior"])
        current["skills"]["sample"]["sections"] = [
            {**section, "baseline_sha256": "silently-rebased"}
        ]
        comparison = skill_coverage.compare(previous, current)
        self.assertEqual(comparison["changed_original_digests"], ["sample/behavior"])

    def test_mock_results_cannot_verify_behavior(self):
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "sample"
            path.mkdir()
            (path / "real.yaml.json").write_text(json.dumps({
                "skill": "sample", "config": {"engine_type": "mock", "model_id": "mock"},
                "tasks": [],
            }))
            with self.assertRaisesRegex(ValueError, "Mock or incomplete"):
                skill_coverage.results_for(Path(temporary), Path(temporary), "sample",
                                           "real.yaml", {})

    def test_real_result_receipt_rejects_stale_skill(self):
        with tempfile.TemporaryDirectory() as temporary:
            repo = Path(temporary)
            skill_dir = repo / "agents/.agents/skills/sample"
            (skill_dir / "evals").mkdir(parents=True)
            (skill_dir / "SKILL.md").write_text("# Original\n")
            results = repo / "results" / "sample"
            results.mkdir(parents=True)
            for suite in skill_coverage.SUITES.values():
                (skill_dir / "evals" / suite).write_text("name: sample\n")
                (results / f"{suite}.json").write_text(json.dumps({
                    "skill": "sample",
                    "config": {"engine_type": "copilot-sdk", "model_id": "fixed"},
                    "tasks": [{"test_id": "sample-case", "stats": {
                        "pass_rate": 1, "total_runs": 3,
                    }}],
                }))
            inventory = {"sample-case": "task-hash"}
            with patch.object(skill_coverage, "preflight", return_value=inventory):
                skill_coverage.record_results(repo, repo / "results", "sample", "waza")
            rates, _ = skill_coverage.results_for(repo / "results", repo, "sample",
                                                  "real.yaml", inventory)
            self.assertEqual(rates["sample-case"]["pass_rate"], 1)
            (skill_dir / "SKILL.md").write_text("# Changed\n")
            with self.assertRaisesRegex(ValueError, "Stale or altered"):
                skill_coverage.results_for(repo / "results", repo, "sample",
                                           "real.yaml", inventory)


if __name__ == "__main__":
    unittest.main()
