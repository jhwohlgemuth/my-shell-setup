#!/usr/bin/env python3
"""Build deterministic runtime skill catalogs and repository-ready ZIP files."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
import zipfile
from dataclasses import dataclass
from pathlib import Path, PurePosixPath


SKILL_NAME = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
ZIP_TIMESTAMP = (1980, 1, 1, 0, 0, 0)


@dataclass(frozen=True)
class RuntimeSkill:
    name: str
    files: tuple[tuple[PurePosixPath, bytes], ...]
    version: str


def load_ignore_patterns(package: Path) -> tuple[re.Pattern[str], ...]:
    ignore_file = package / ".stow-local-ignore"
    try:
        lines = ignore_file.read_text(encoding="utf-8").splitlines()
    except OSError as error:
        raise ValueError(f"Cannot read {ignore_file}: {error}") from error
    patterns = []
    for number, line in enumerate(lines, start=1):
        expression = line.strip()
        if not expression or expression.startswith("#"):
            continue
        try:
            patterns.append(re.compile(expression))
        except re.error as error:
            raise ValueError(
                f"Invalid Stow ignore expression at {ignore_file}:{number}: {error}"
            ) from error
    return tuple(patterns)


def safe_relative(path: PurePosixPath) -> bool:
    return (
        bool(path.parts)
        and not path.is_absolute()
        and all(part not in ("", ".", "..") for part in path.parts)
        and "\\" not in path.as_posix()
    )


def ignored_by_stow(path: PurePosixPath, patterns: tuple[re.Pattern[str], ...]) -> bool:
    candidates = [path, *path.parents]
    for candidate in candidates:
        if candidate == PurePosixPath("."):
            continue
        package_path = f"/{candidate.as_posix()}"
        if any(pattern.search(package_path) for pattern in patterns):
            return True
    return False


def content_version(files: tuple[tuple[PurePosixPath, bytes], ...]) -> str:
    digest = hashlib.sha256()
    for path, contents in files:
        digest.update(path.as_posix().encode("utf-8"))
        digest.update(b"\0")
        digest.update(contents)
        digest.update(b"\0")
    return digest.hexdigest()


def discover_skills(repo: Path) -> tuple[RuntimeSkill, ...]:
    package = repo / "agents"
    skills_root = package / ".agents/skills"
    patterns = load_ignore_patterns(package)
    if not skills_root.is_dir():
        raise ValueError(f"Skill source directory does not exist: {skills_root}")

    skills = []
    for skill_dir in sorted(path for path in skills_root.iterdir() if path.is_dir()):
        entrypoint = skill_dir / "SKILL.md"
        if not entrypoint.is_file():
            continue
        name = skill_dir.name
        if not SKILL_NAME.fullmatch(name):
            raise ValueError(f"Invalid skill directory name: {name}")
        runtime_files = []
        for source in sorted(skill_dir.rglob("*")):
            package_relative = PurePosixPath(source.relative_to(package).as_posix())
            if ignored_by_stow(package_relative, patterns):
                continue
            if source.is_symlink():
                raise ValueError(f"Runtime skill paths cannot be symbolic links: {source}")
            if source.is_dir():
                continue
            if not source.is_file():
                raise ValueError(f"Runtime skill path is not a regular file: {source}")
            skill_relative = PurePosixPath(source.relative_to(skill_dir).as_posix())
            if not safe_relative(skill_relative):
                raise ValueError(f"Unsafe runtime skill path: {skill_relative}")
            runtime_files.append((skill_relative, source.read_bytes()))
        files = tuple(runtime_files)
        if not any(path == PurePosixPath("SKILL.md") for path, _ in files):
            raise ValueError(f"Stow exclusions hide required entrypoint: {entrypoint}")
        skills.append(RuntimeSkill(name, files, content_version(files)))
    if not skills:
        raise ValueError(f"No skill entrypoints found beneath {skills_root}")
    return tuple(skills)


def zip_bytes(entries: tuple[tuple[PurePosixPath, bytes], ...], destination: Path) -> None:
    with zipfile.ZipFile(destination, "w", compression=zipfile.ZIP_STORED) as archive:
        for path, contents in entries:
            info = zipfile.ZipInfo(path.as_posix(), ZIP_TIMESTAMP)
            info.compress_type = zipfile.ZIP_STORED
            info.create_system = 3
            info.external_attr = 0o100644 << 16
            archive.writestr(info, contents)


def build(repo: Path, output: Path) -> tuple[RuntimeSkill, ...]:
    skills = discover_skills(repo.resolve())
    if output.exists() and any(output.iterdir()):
        raise ValueError(f"Output directory must be empty: {output}")
    output.mkdir(parents=True, exist_ok=True)

    aggregate_entries = []
    catalog = {"skills": []}
    for skill in skills:
        raw_root = output / skill.name
        for path, contents in skill.files:
            raw_path = raw_root.joinpath(*path.parts)
            raw_path.parent.mkdir(parents=True, exist_ok=True)
            raw_path.write_bytes(contents)

        archive_entries = tuple(
            (
                PurePosixPath(".agents", "skills", skill.name, *path.parts),
                contents,
            )
            for path, contents in skill.files
        )
        zip_bytes(archive_entries, output / f"{skill.name}-skill.zip")
        aggregate_entries.extend(archive_entries)
        catalog["skills"].append(
            {
                "files": [path.as_posix() for path, _ in skill.files],
                "name": skill.name,
                "version": skill.version,
            }
        )

    zip_bytes(tuple(aggregate_entries), output / "agents-skills.zip")
    (output / "index.json").write_text(
        json.dumps(catalog, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    return skills


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--repo-root", type=Path, default=Path(__file__).resolve().parents[2]
    )
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    try:
        skills = build(args.repo_root, args.output)
    except (OSError, ValueError, zipfile.BadZipFile) as error:
        print(f"Skill packaging error: {error}", file=sys.stderr)
        return 2
    for skill in skills:
        print(f"{skill.name}\t{skill.version}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
