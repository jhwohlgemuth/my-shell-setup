#!/usr/bin/env python3
"""Grade the guidelines-rust error-handling task from Waza's output on stdin."""

from __future__ import annotations

import re
import subprocess
import sys
import tempfile
from pathlib import Path


def extract_code(output: str) -> str:
    blocks = re.findall(r"(?ms)^```(?:rust)?[ \t]*\n(.*?)^```[ \t]*$", output)
    if len(blocks) > 1:
        raise ValueError("Expected one Rust function, found multiple code blocks")
    return (blocks[0] if blocks else output).strip()


def grade(output: str) -> tuple[bool, str]:
    try:
        code = extract_code(output)
    except ValueError as error:
        return False, str(error)
    if "?" in code:
        return False, "The generated Rust contains a question-mark operator"
    if not re.search(r"\bfn\s+parse_pair\s*\(", code):
        return False, "Missing parse_pair function"

    tests = """
#[test]
fn parses_both_values_and_propagates_each_error() {
    assert_eq!(parse_pair("7", "9"), Ok((7, 9)));
    assert!(parse_pair("bad", "9").is_err());
    assert!(parse_pair("7", "bad").is_err());
}
"""
    with tempfile.TemporaryDirectory(prefix="waza-rust-parse-") as directory:
        source = Path(directory) / "parse_pair.rs"
        binary = Path(directory) / "parse_pair_test"
        source.write_text(code + "\n" + tests, encoding="utf-8")
        try:
            compiled = subprocess.run(
                ["rustc", "--edition=2021", "--test", str(source), "-o", str(binary)],
                capture_output=True, text=True, timeout=45, check=False,
            )
            if compiled.returncode:
                return False, "Rust did not compile: " + compiled.stderr.strip()[:1000]
            tested = subprocess.run(
                [str(binary)], capture_output=True, text=True, timeout=10, check=False,
            )
        except (OSError, subprocess.TimeoutExpired) as error:
            return False, f"Could not run Rust check: {error}"
    if tested.returncode:
        return False, "Rust behavior check failed: " + tested.stdout.strip()[:1000]
    return True, "Rust compiles, handles both parse errors, and adds no question-mark operator"


def main() -> int:
    passed, message = grade(sys.stdin.read())
    print(message)
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
