import hashlib
import json
import tempfile
import unittest
import zipfile
from pathlib import Path, PurePosixPath
from urllib.parse import urljoin, urlparse

import check_stow
import package_skills


class PackageSkillsTests(unittest.TestCase):
    def make_repo(self, root: Path) -> Path:
        package = root / "agents"
        source_ignore = Path(__file__).resolve().parents[1] / ".stow-local-ignore"
        package.mkdir(parents=True)
        (package / ".stow-local-ignore").write_bytes(source_ignore.read_bytes())
        (package / "plugin.json").write_text(
            json.dumps(
                {
                    "$schema": package_skills.PLUGIN_SCHEMA,
                    "name": "test-skills",
                    "version": "0.1.0",
                    "description": "Test runtime skills",
                },
                indent=2,
            )
            + "\n",
            encoding="utf-8",
        )
        for skill in ("alpha-skill", "beta-skill"):
            skill_root = package / ".agents/skills" / skill
            files = {
                "SKILL.md": f"---\nname: {skill}\ndescription: test\n---\n",
                "agents/openai.yaml": "interface: test\n",
                "assets/icon.svg": f"<{skill}/>\n",
                "references/guide.md": f"# {skill}\n",
                "scripts/run.sh": "#!/bin/sh\n",
                "evals/eval.yaml": "ignored\n",
                "tests/check.txt": "ignored\n",
                "trigger_tests.yaml": "ignored\n",
                "assets/.DS_Store": "ignored\n",
                "scripts/__pycache__/run.pyc": "ignored\n",
                "SKILL.md~": "ignored\n",
            }
            for relative, contents in files.items():
                path = skill_root / relative
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(contents, encoding="utf-8")
        return root

    def output_hashes(self, output: Path) -> dict[str, str]:
        return {
            path.relative_to(output).as_posix(): hashlib.sha256(path.read_bytes()).hexdigest()
            for path in sorted(output.rglob("*"))
            if path.is_file()
        }

    def catalog(self, output: Path) -> dict:
        return json.loads((output / "index.json").read_text(encoding="utf-8"))

    def test_build_is_deterministic_and_excludes_development_files(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            repo = self.make_repo(root / "repo")
            first = root / "first"
            second = root / "second"
            package_skills.build(repo, first)
            package_skills.build(repo, second)
            self.assertEqual(self.output_hashes(first), self.output_hashes(second))

            expected = [
                "SKILL.md",
                "agents/openai.yaml",
                "assets/icon.svg",
                "references/guide.md",
                "scripts/run.sh",
            ]
            for entry in self.catalog(first)["skills"]:
                self.assertEqual(entry["files"], expected)
                self.assertRegex(entry["version"], r"^[0-9a-f]{64}$")
                self.assertEqual(
                    sorted(
                        path.relative_to(first / entry["name"]).as_posix()
                        for path in (first / entry["name"]).rglob("*")
                        if path.is_file()
                    ),
                    expected,
                )

    def test_zip_roots_and_metadata_are_deterministic(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            repo = self.make_repo(root / "repo")
            output = root / "output"
            package_skills.build(repo, output)
            expected = {
                f".agents/skills/{skill}/{relative}"
                for skill in ("alpha-skill", "beta-skill")
                for relative in (
                    "SKILL.md",
                    "agents/openai.yaml",
                    "assets/icon.svg",
                    "references/guide.md",
                    "scripts/run.sh",
                )
            }
            with zipfile.ZipFile(output / "agents-skills.zip") as archive:
                self.assertEqual(set(archive.namelist()), expected)
                self.assertTrue(
                    all(info.date_time == package_skills.ZIP_TIMESTAMP for info in archive.infolist())
                )
            with zipfile.ZipFile(output / "alpha-skill-skill.zip") as archive:
                self.assertEqual(
                    set(archive.namelist()),
                    {name for name in expected if "/alpha-skill/" in name},
                )

    def test_catalog_paths_are_safe_and_same_origin(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            repo = self.make_repo(root / "repo")
            output = root / "output"
            package_skills.build(repo, output)
            base = "https://example.test/agent-skills/"
            for skill in self.catalog(output)["skills"]:
                for relative in skill["files"]:
                    path = PurePosixPath(relative)
                    self.assertTrue(package_skills.safe_relative(path))
                    url = urljoin(base, f"{skill['name']}/{relative}")
                    self.assertEqual(urlparse(url).netloc, "example.test")
                    self.assertTrue(url.startswith(f"{base}{skill['name']}/"))

    def test_content_change_updates_only_its_skill_version(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            repo = self.make_repo(root / "repo")
            first = root / "first"
            second = root / "second"
            package_skills.build(repo, first)
            changed = repo / "agents/.agents/skills/alpha-skill/references/guide.md"
            changed.write_text("changed\n", encoding="utf-8")
            package_skills.build(repo, second)
            before = {entry["name"]: entry["version"] for entry in self.catalog(first)["skills"]}
            after = {entry["name"]: entry["version"] for entry in self.catalog(second)["skills"]}
            self.assertNotEqual(before["alpha-skill"], after["alpha-skill"])
            self.assertEqual(before["beta-skill"], after["beta-skill"])

    def test_repository_inventory_matches_stow_runtime_inventory(self):
        repo = Path(__file__).resolve().parents[2]
        discovered = {
            PurePosixPath(".agents", "skills", skill.name, *relative.parts)
            for skill in package_skills.discover_skills(repo)
            for relative, _ in skill.files
        }
        expected = {
            PurePosixPath(path.as_posix()) for path in check_stow.expected_files(repo)
        }
        self.assertEqual(discovered, expected)

    def test_plugin_tree_matches_manifest_and_runtime_inventory(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            repo = self.make_repo(root / "repo")
            destination, digest = package_skills.write_plugin_tree(repo)
            self.assertEqual(digest, package_skills.check_plugin_tree(repo))
            self.assertEqual(
                (destination / "plugin.json").read_bytes(),
                (repo / "agents/plugin.json").read_bytes(),
            )
            expected = {
                PurePosixPath("plugin.json"),
                *{
                    PurePosixPath("skills", skill.name, *path.parts)
                    for skill in package_skills.discover_skills(repo)
                    for path, _ in skill.files
                },
            }
            actual = {
                PurePosixPath(path.relative_to(destination).as_posix())
                for path in destination.rglob("*")
                if path.is_file()
            }
            self.assertEqual(actual, expected)
            self.assertFalse(any("evals" in path.parts for path in actual))

    def test_plugin_tree_is_deterministic_and_repairs_drift(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            repo = self.make_repo(root / "repo")
            destination, first_digest = package_skills.write_plugin_tree(repo)
            first_hashes = self.output_hashes(destination)
            changed = destination / "skills/alpha-skill/SKILL.md"
            changed.write_text("changed\n", encoding="utf-8")
            (destination / "unexpected.txt").write_text("drift\n", encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "out of date"):
                package_skills.check_plugin_tree(repo)
            destination, second_digest = package_skills.write_plugin_tree(repo)
            self.assertEqual(first_digest, second_digest)
            self.assertEqual(first_hashes, self.output_hashes(destination))
            self.assertEqual(second_digest, package_skills.check_plugin_tree(repo))

    def test_plugin_manifest_requires_portable_schema_and_semver(self):
        with tempfile.TemporaryDirectory() as temporary:
            repo = self.make_repo(Path(temporary) / "repo")
            manifest_path = repo / "agents/plugin.json"
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
            manifest["$schema"] = "https://example.test/wrong-schema.json"
            manifest_path.write_text(json.dumps(manifest), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "must declare"):
                package_skills.load_plugin_manifest(repo)
            manifest["$schema"] = package_skills.PLUGIN_SCHEMA
            manifest["version"] = "latest"
            manifest_path.write_text(json.dumps(manifest), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "semantic version"):
                package_skills.load_plugin_manifest(repo)

    def test_repository_plugin_tree_is_current(self):
        repo = Path(__file__).resolve().parents[2]
        digest = package_skills.check_plugin_tree(repo)
        self.assertRegex(digest, r"^[0-9a-f]{64}$")

    def test_nonempty_output_is_rejected(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            repo = self.make_repo(root / "repo")
            output = root / "output"
            output.mkdir()
            (output / "keep.txt").write_text("keep", encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "must be empty"):
                package_skills.build(repo, output)
            self.assertEqual((output / "keep.txt").read_text(encoding="utf-8"), "keep")

    def test_symbolic_links_are_rejected(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            repo = self.make_repo(root / "repo")
            skill = repo / "agents/.agents/skills/alpha-skill"
            target = skill / "references/guide.md"
            link = skill / "references/link.md"
            try:
                link.symlink_to(target)
            except OSError as error:
                self.skipTest(f"symbolic links unavailable: {error}")
            with self.assertRaisesRegex(ValueError, "symbolic links"):
                package_skills.discover_skills(repo)


if __name__ == "__main__":
    unittest.main()
