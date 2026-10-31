import tempfile
import unittest
from pathlib import Path

import check_stow


class StowInventoryTests(unittest.TestCase):
    def make_package(self, repo: Path) -> Path:
        package = repo / "agents"
        ignore = Path(__file__).resolve().parents[1] / ".stow-local-ignore"
        (package / ".stow-local-ignore").parent.mkdir(parents=True)
        (package / ".stow-local-ignore").write_bytes(ignore.read_bytes())
        skill = package / ".agents/skills/demo"
        for name in ("SKILL.md", "scripts/runtime.sh", "assets/icon.svg",
                     "references/guide.md",
                     "references/README.md", "evals/eval.yaml", "tests/check.yaml",
                     "trigger_tests.yaml", "scripts/__pycache__/runtime.pyc",
                     "assets/.DS_Store", "SKILL.md~"):
            path = skill / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(name)
        for name in ("scripts/dev.py", "coverage/capabilities.json", "README.md",
                     ".github/ci.yml", ".gitignore", ".git/config",
                     "results/real.json"):
            path = package / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(name)
        return package

    def test_only_runtime_files_are_installed(self):
        with tempfile.TemporaryDirectory() as temporary:
            repo = Path(temporary)
            self.make_package(repo)
            self.assertEqual(check_stow.check(repo, "stow"), [])

    def test_unclassified_file_is_rejected(self):
        with tempfile.TemporaryDirectory() as temporary:
            repo = Path(temporary)
            package = self.make_package(repo)
            (package / "notes.txt").write_text("development notes")
            self.assertIn("Unexpected installed path: notes.txt",
                          check_stow.check(repo, "stow"))

    def test_ignored_runtime_reference_is_rejected(self):
        with tempfile.TemporaryDirectory() as temporary:
            repo = Path(temporary)
            package = self.make_package(repo)
            with (package / ".stow-local-ignore").open("a") as ignore:
                ignore.write("\nreferences\n")
            self.assertIn(
                "Missing runtime symlink: .agents/skills/demo/references/guide.md",
                check_stow.check(repo, "stow"),
            )


if __name__ == "__main__":
    unittest.main()
