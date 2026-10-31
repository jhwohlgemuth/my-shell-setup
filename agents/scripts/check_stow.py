#!/usr/bin/env python3
"""Check the exact runtime file inventory produced by the agents Stow package."""

from __future__ import annotations

import argparse
import subprocess
import sys
import tempfile
from pathlib import Path


RUNTIME_DIRS = ("agents", "assets", "references", "scripts")
DEVELOPMENT_PARTS = {
    ".git", ".gitignore", ".gitattributes", ".gitmodules", ".svn", ".hg",
    ".DS_Store", "__pycache__", ".pytest_cache", ".mypy_cache",
    ".ruff_cache", ".coverage",
}


def runtime_source(path: Path) -> bool:
    name = path.name
    return (
        not any(part in DEVELOPMENT_PARTS for part in path.parts)
        and not name.endswith((".pyc", ".pyo", "~"))
        and not name.startswith(".#")
        and not (name.startswith("#") and name.endswith("#"))
    )


def expected_files(repo: Path) -> dict[Path, Path]:
    package = repo / "agents"
    skills_root = package / ".agents/skills"
    skills = sorted(path.parent for path in skills_root.glob("*/SKILL.md"))
    if not skills:
        raise ValueError("No skill entrypoints found in agents package")
    expected = {}
    for skill in skills:
        sources = [skill / "SKILL.md"]
        for directory in RUNTIME_DIRS:
            root = skill / directory
            if root.exists():
                sources.extend(path for path in root.rglob("*")
                               if path.is_file() and runtime_source(path.relative_to(skill)))
        for source in sources:
            relative = source.relative_to(package)
            expected[relative] = source
    return expected


def check(repo: Path, stow: str) -> list[str]:
    expected = expected_files(repo)
    errors = []
    with tempfile.TemporaryDirectory(prefix="agents-stow-check-") as temporary:
        target = Path(temporary)
        command = subprocess.run(
            [stow, "--no-folding", "--dir", str(repo), "--target", str(target),
             "--stow", "agents"],
            capture_output=True, text=True, check=False,
        )
        if command.returncode:
            return [f"Stow failed: {command.stderr.strip()}"]
        expected_paths = set(expected)
        for path in expected:
            expected_paths.update(path.parents)
        expected_paths.discard(Path("."))
        actual_paths = {path.relative_to(target) for path in target.rglob("*")}
        for path in sorted(actual_paths - expected_paths):
            errors.append(f"Unexpected installed path: {path}")
        for path, source in sorted(expected.items()):
            installed = target / path
            if not installed.is_symlink():
                errors.append(f"Missing runtime symlink: {path}")
            elif installed.resolve() != source.resolve():
                errors.append(f"Wrong runtime target: {path}")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo-root", type=Path, default=Path(__file__).resolve().parents[2])
    parser.add_argument("--stow", default="stow")
    args = parser.parse_args()
    try:
        repo = args.repo_root.resolve()
        errors = check(repo, args.stow)
    except (OSError, ValueError) as error:
        print(f"Stow inventory error: {error}", file=sys.stderr)
        return 2
    for error in errors:
        print(error, file=sys.stderr)
    if errors:
        return 1
    print(f"Stow inventory matched {len(expected_files(repo))} runtime files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
