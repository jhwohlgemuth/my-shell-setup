import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from iterate_skill import run_assessment


class IterateSkillTests(unittest.TestCase):
    def test_repeated_assessments_keep_history_and_compare_last_completed_run(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            repo = root / "repo"
            skill = "guidelines-rust"
            source = repo / "agents/.agents/skills" / skill
            source.mkdir(parents=True)
            (source / "SKILL.md").write_text("---\nname: guidelines-rust\n---\n")
            runs = root / "runs"
            commands = []

            def fake_run(command, **kwargs):
                commands.append(command)
                if "real" in command:
                    self.assertEqual(kwargs["cwd"], repo / "agents")
                    result_root = Path(next(value.split("=", 1)[1] for value in command
                                            if value.startswith("AGENT_RESULTS_DIR=")))
                    result_skill = result_root / skill
                    result_skill.mkdir()
                    for suite in ("real.yaml", "routing.yaml"):
                        (result_skill / f"{suite}.json").write_text("{}")
                        (result_skill / f"{suite}.receipt.json").write_text("{}")
                elif "--json-out" in command:
                    Path(command[command.index("--json-out") + 1]).write_text("{}")
                    kwargs["stdout"].write("coverage report\n")
                elif "compare" in command:
                    kwargs["stdout"].write("task comparison\n")
                elif "--baseline" in command:
                    self.assertEqual(kwargs["cwd"], repo / "agents")
                    Path(command[command.index("--output") + 1]).write_text("{}")
                return type("Result", (), {"returncode": 0})()

            with patch("iterate_skill.subprocess.run", side_effect=fake_run):
                first = run_assessment(repo, skill, runs, 3, "waza", "make", effect=True)
                second = run_assessment(repo, skill, runs, 3, "waza", "make", effect=True)

            self.assertEqual((first.name, second.name), ("0001", "0002"))
            self.assertEqual(json.loads((second / "assessment.json").read_text())["previous"], "0001")
            self.assertTrue((first / "effect.json").is_file())
            self.assertTrue((second / "compare-real.txt").is_file())
            self.assertTrue((second / "compare-routing.txt").is_file())
            self.assertTrue(any("--previous" in command for command in commands))

    def test_rejects_invalid_trial_count_before_creating_history(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "repo/agents/.agents/skills/guidelines-rust"
            source.mkdir(parents=True)
            (source / "SKILL.md").write_text("skill")
            with self.assertRaisesRegex(ValueError, "at least 1"):
                run_assessment(root / "repo", "guidelines-rust", root / "runs",
                               0, "waza", "make")
            self.assertFalse((root / "runs").exists())


if __name__ == "__main__":
    unittest.main()
