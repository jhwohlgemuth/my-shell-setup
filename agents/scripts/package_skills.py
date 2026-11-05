#!/usr/bin/env python3
"""Build deterministic runtime skill catalogs and repository-ready ZIP files."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
import sys
import zipfile
from dataclasses import dataclass
from pathlib import Path, PurePosixPath


SKILL_NAME = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
SEMANTIC_VERSION = re.compile(r"^(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)$")
PLUGIN_SCHEMA = "https://agent-plugins.org/schemas/1.0.0/plugin.schema.json"
PLUGIN_DIRECTORY = Path("plugins/personal-agent-skills")
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


def load_plugin_manifest(repo: Path) -> tuple[dict, bytes]:
    source = repo / "agents/plugin.json"
    try:
        contents = source.read_bytes()
        manifest = json.loads(contents)
    except OSError as error:
        raise ValueError(f"Cannot read {source}: {error}") from error
    except json.JSONDecodeError as error:
        raise ValueError(f"Invalid JSON in {source}: {error}") from error
    if not isinstance(manifest, dict):
        raise ValueError(f"Portable plugin manifest must be an object: {source}")
    if manifest.get("$schema") != PLUGIN_SCHEMA:
        raise ValueError(f"Portable plugin manifest must declare {PLUGIN_SCHEMA}")
    name = manifest.get("name")
    if not isinstance(name, str) or not SKILL_NAME.fullmatch(name):
        raise ValueError("Portable plugin name must be lowercase kebab-case")
    version = manifest.get("version")
    if not isinstance(version, str) or not SEMANTIC_VERSION.fullmatch(version):
        raise ValueError("Portable plugin version must be a three-part semantic version")
    description = manifest.get("description")
    if not isinstance(description, str) or not description.strip():
        raise ValueError("Portable plugin description must be a nonempty string")
    return manifest, contents


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


def plugin_files(
    repo: Path, skills: tuple[RuntimeSkill, ...] | None = None
) -> tuple[tuple[PurePosixPath, bytes], ...]:
    repo = repo.resolve()
    skills = skills or discover_skills(repo)
    _, manifest = load_plugin_manifest(repo)
    files = [(PurePosixPath("plugin.json"), manifest)]
    files.extend(
        (PurePosixPath("skills", skill.name, *path.parts), contents)
        for skill in skills
        for path, contents in skill.files
    )
    return tuple(files)


def write_plugin_tree(repo: Path) -> tuple[Path, str]:
    repo = repo.resolve()
    destination = repo / PLUGIN_DIRECTORY
    files = plugin_files(repo)
    if destination.is_symlink():
        raise ValueError(f"Generated plugin directory cannot be a symbolic link: {destination}")
    if destination.exists():
        if not destination.is_dir():
            raise ValueError(f"Generated plugin path is not a directory: {destination}")
        shutil.rmtree(destination)
    for path, contents in files:
        output = destination.joinpath(*path.parts)
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_bytes(contents)
    return destination, content_version(files)


def check_plugin_tree(repo: Path) -> str:
    repo = repo.resolve()
    destination = repo / PLUGIN_DIRECTORY
    expected = {path: contents for path, contents in plugin_files(repo)}
    if not destination.is_dir() or destination.is_symlink():
        raise ValueError(f"Generated plugin directory is missing or unsafe: {destination}")
    actual_paths = {
        PurePosixPath(path.relative_to(destination).as_posix())
        for path in destination.rglob("*")
        if path.is_file() or path.is_symlink()
    }
    expected_paths = set(expected)
    errors = []
    for path in sorted(expected_paths - actual_paths):
        errors.append(f"missing {path}")
    for path in sorted(actual_paths - expected_paths):
        errors.append(f"unexpected {path}")
    for path in sorted(expected_paths & actual_paths):
        source = destination.joinpath(*path.parts)
        if source.is_symlink():
            errors.append(f"symbolic link {path}")
        elif source.read_bytes() != expected[path]:
            errors.append(f"changed {path}")
    if errors:
        raise ValueError("Generated plugin tree is out of date: " + ", ".join(errors))
    return content_version(tuple((path, expected[path]) for path in sorted(expected)))


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
    targets = parser.add_mutually_exclusive_group(required=True)
    targets.add_argument("--output", type=Path)
    targets.add_argument("--write-plugin", action="store_true")
    targets.add_argument("--check-plugin", action="store_true")
    args = parser.parse_args()
    try:
        if args.write_plugin:
            destination, digest = write_plugin_tree(args.repo_root)
            manifest, _ = load_plugin_manifest(args.repo_root.resolve())
            print(f"{destination}\t{manifest['version']}\t{digest}")
            return 0
        if args.check_plugin:
            digest = check_plugin_tree(args.repo_root)
            manifest, _ = load_plugin_manifest(args.repo_root.resolve())
            print(f"{PLUGIN_DIRECTORY}\t{manifest['version']}\t{digest}")
            return 0
        skills = build(args.repo_root, args.output)
    except (OSError, ValueError, zipfile.BadZipFile) as error:
        print(f"Skill packaging error: {error}", file=sys.stderr)
        return 2
    for skill in skills:
        print(f"{skill.name}\t{skill.version}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
