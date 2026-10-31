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

`install_nix`, `install_java`, `install_conda`, `install_homebrew`, `install_nim`, `install_ohmyzsh`, and many choices in `install_wasm_tools` execute downloaded shell code. Use a fixed release or commit and a checked SHA-256 for each exact script or artifact, and fail before execution if download or verification fails. Preserve installer interfaces unless a pinned version requires a documented update. The repository's own hosted quick-start source is tracked in [published bootstrap](published-bootstrap.md) and [Windows setup](windows-setup.md).

## Acceptance criteria

None of the named scripts execute a mutable URL directly. Every downloaded installer has an explicit version or commit and verification step, and a corrupt or unavailable download fails without running.

# Execution phases

## SEC-01 — Verify the Nix bootstrap input

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_nix`.
- Primary integration lock: Nix installer.
- Outcome: Nix executes only a verified fixed installer.
- Focused validation: ShellCheck, shfmt diff, and mocked successful, corrupt, and failed downloads.
- Handoff: Record the upstream identifier and checksum in the script.

## SEC-06 — Verify the Java bootstrap input

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_java`.
- Primary integration lock: Java installer.
- Outcome: SDKMAN executes only a verified fixed installer.
- Focused validation: ShellCheck, shfmt diff, and mocked successful, corrupt, and failed downloads.
- Handoff: Record the upstream identifier and checksum in the script.

## SEC-02 — Verify the Homebrew bootstrap input

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_homebrew`.
- Primary integration lock: Homebrew installer.
- Outcome: Homebrew executes only a verified fixed installer.
- Focused validation: ShellCheck, shfmt diff, mocked checksum failure, and a supported-host smoke test.
- Handoff: Record the upstream identifier and test result.

## SEC-07 — Verify the Nim bootstrap input

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_nim`.
- Primary integration lock: Nim installer.
- Outcome: Nim executes only a verified fixed installer.
- Focused validation: ShellCheck, shfmt diff, mocked checksum failure, and a supported-host smoke test.
- Handoff: Record the upstream identifier and test result.

## SEC-08 — Verify the Oh My Zsh bootstrap input

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_ohmyzsh`.
- Primary integration lock: Oh My Zsh installer.
- Outcome: Oh My Zsh executes only a verified fixed installer.
- Focused validation: ShellCheck, shfmt diff, mocked checksum failure, and a supported-host smoke test.
- Handoff: Record the upstream identifier and test result.

## SEC-03 — Verify Cosmonic and MoonBit choices

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_wasm_tools`.
- Primary integration lock: WASM installer menu.
- Outcome: Cosmonic and MoonBit use verified fixed bootstrap inputs.
- Focused validation: ShellCheck, shfmt diff, and mocked corrupt downloads for both choices.
- Handoff: Record pins and checksums for subsequent menu phases.

## SEC-09 — Verify Scale and Spin choices

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: SEC-03.
- Exact write set: `gold/install_wasm_tools`.
- Primary integration lock: WASM installer menu.
- Outcome: Scale and Spin use verified fixed bootstrap inputs.
- Focused validation: ShellCheck, shfmt diff, and mocked corrupt downloads for both choices.
- Handoff: Record both pins and checksums.

## SEC-10 — Verify the WasmCloud choice

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: SEC-09.
- Exact write set: `gold/install_wasm_tools`.
- Primary integration lock: WASM installer menu.
- Outcome: WasmCloud uses a verified fixed bootstrap input.
- Focused validation: ShellCheck, shfmt diff, and mocked corrupt and unavailable downloads.
- Handoff: Record the pinned input and checksum.

## SEC-04 — Verify WasmEdge and Wasmtime choices

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: SEC-10.
- Exact write set: `gold/install_wasm_tools`.
- Primary integration lock: WASM installer menu.
- Outcome: WasmEdge and Wasmtime use verified fixed bootstrap inputs.
- Focused validation: ShellCheck, shfmt diff, and mocked corrupt downloads for both choices.
- Handoff: Record both pins and checksums.

## SEC-11 — Verify Wazero and WANIX choices

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: SEC-04.
- Exact write set: `gold/install_wasm_tools`.
- Primary integration lock: WASM installer menu.
- Outcome: Wazero and WANIX use verified fixed bootstrap inputs.
- Focused validation: ShellCheck, shfmt diff, and mocked corrupt downloads for both choices.
- Handoff: Record both pins and checksums.

## SEC-12 — Verify the WWS choice

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: SEC-11.
- Exact write set: `gold/install_wasm_tools`.
- Primary integration lock: WASM installer menu.
- Outcome: WWS uses a verified fixed bootstrap input, completing the scoped remote-script choices.
- Focused validation: ShellCheck, shfmt diff, a mocked corrupt download, and an inventory of direct downloaded-script execution.
- Handoff: Record the final pin and the inventory result.

## SEC-05 — Verify the Miniconda bootstrap input

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_conda`.
- Primary integration lock: Conda bootstrap.
- Outcome: The downloaded Miniconda installer is versioned and verified before Bash runs it.
- Focused validation: ShellCheck, shfmt diff, and mocked successful, corrupt, and failed-download paths.
- Handoff: Record the installer version, checksum, and a container smoke-test result.
