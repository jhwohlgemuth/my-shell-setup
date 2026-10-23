---
type: Plan
title: Verify remote bootstrap scripts
description: Replace unverified downloaded shell execution with pinned and checked installer inputs.
difficulty: medium
impact: high
package: [gold]
tags: [security, installers, provenance]
status: planned
execution: phased
phase_budget_hours: 5
---

# Verify remote bootstrap scripts

## Current evidence and decision

`install_nix`, `install_java`, `install_conda`, `install_homebrew`, `install_nim`, `install_ohmyzsh`, and many choices in `install_wasm_tools` execute downloaded shell code. Review each upstream installer, use a fixed release or commit and a checked SHA-256 for the exact script or artifact, and fail before execution if download or verification fails. Keep each installer's existing user-facing command and defaults unless the pinned version requires a documented update.

## Acceptance criteria

None of the named scripts execute a mutable URL directly. Every downloaded installer has an explicit version or commit and verification step, and a corrupt or unavailable download fails without running.

# Execution phases

## SEC-01 — Pin Nix and Java bootstrap inputs

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_nix`, `gold/install_java`.
- Primary integration lock: Nix and Java bootstrap.
- Outcome: Both scripts verify a fixed installer before executing it.
- Focused validation: ShellCheck, shfmt check, and mocked successful, corrupt, and failed-download paths for both scripts.
- Handoff: Record pinned upstream identifiers and checksums in the scripts.

## SEC-02 — Pin shell and package-manager bootstrap inputs

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_homebrew`, `gold/install_nim`, `gold/install_ohmyzsh`.
- Primary integration lock: shell and package-manager bootstrap.
- Outcome: Each script executes only a verified fixed installer.
- Focused validation: ShellCheck, shfmt check, and mocked checksum-failure paths; run one container smoke test for each supported installer.
- Handoff: Record pinned upstream identifiers and focused test results.

## SEC-03 — Verify the first WASM installer choices

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_wasm_tools`.
- Primary integration lock: WASM installer menu.
- Outcome: Cosmonic, MoonBit, Scale, Spin, and WasmCloud use pinned, verified bootstrap inputs.
- Focused validation: ShellCheck, shfmt check, and mocked corrupt-download paths for the five choices.
- Handoff: Record pins and checksums for SEC-04 to preserve the same download pattern.

## SEC-04 — Verify the remaining WASM installer choices

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: SEC-03.
- Exact write set: `gold/install_wasm_tools`.
- Primary integration lock: WASM installer menu.
- Outcome: WasmEdge, Wasmtime, Wazero, WANIX, and WWS use pinned, verified bootstrap inputs.
- Focused validation: ShellCheck, shfmt check, and mocked corrupt-download paths for the five choices.
- Handoff: Record all remaining pins and an inventory showing no direct downloaded-script execution in scope.

## SEC-05 — Verify the Miniconda bootstrap input

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_conda`.
- Primary integration lock: Conda bootstrap.
- Outcome: The downloaded Miniconda installer is versioned and verified before Bash runs it.
- Focused validation: ShellCheck, shfmt check, and mocked successful, corrupt, and failed-download paths.
- Handoff: Record the installer version, checksum, and a container smoke-test result.
