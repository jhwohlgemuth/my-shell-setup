---
type: Plan
title: Verify remote bootstrap scripts
description: Replace unverified downloaded shell execution with pinned and checked installer inputs.
difficulty: medium
impact: high
package: [gold]
tags: [security, installers, provenance, "os:linux", "os:macos"]
status: planned
execution: phased
phase_budget_hours: 5
---

# Verify remote bootstrap scripts

## Current evidence and decision

The standalone Nix, Java, Conda, Homebrew, Nim, and Oh My Zsh installers now use fixed, SHA-256-verified bootstrap inputs. Cosmonic, MoonBit, Scale, and Spin do the same in `install_wasm_tools`; WasmCloud, WasmEdge, Wasmtime, Wazero, WANIX, and WWS still execute mutable downloaded scripts. Use a fixed release or commit and a checked SHA-256 for each remaining exact script or artifact, and fail before execution if download or verification fails. Preserve installer interfaces unless a pinned version requires a documented update. The repository's own hosted quick-start source is tracked in [published bootstrap](published-bootstrap.md) and [Windows setup](windows-setup.md).

`install_nix` now downloads the Nix 2.34.0 installer, verifies SHA-256 `78de59f69d95bdb7ba7d54949ddc402c9e98c1ba55c35c73704b21b432c66f8a`, and executes it only after verification.

`install_java` accepts the SDKMAN 5.24.0 installer payload only when it matches SHA-256 `d2ad12c3702fa42967e48114f01ebd266f0c901a53fa8fd739c9b6a007cc91d0`; a changed payload fails before Bash executes it.

`install_homebrew` downloads `install.sh` at commit `d6a2423c5973e04b45a5f17dc1948f6c9e5e651a`, verifies SHA-256 `5f333bbe53bc490e51e7ccb1df8779b3dd6ee73a1a7379efda216edb08ccb148`, and runs Bash only after verification.

`install_nim` installs choosenim 0.8.16 directly from its fixed GitHub release after selecting and verifying the Linux x86-64 or arm64 artifact; it no longer executes the rolling `init.sh` bootstrap.

`install_ohmyzsh` verifies the fixed zsh-in-docker 1.2.0 payload at SHA-256 `f74e5b08c295b6c3886654bb63c688e5ea16c58a4209435c4ddbab2c42fe9b41` before passing the existing plugin arguments to `sh`.

The Cosmonic choice installs verified 0.25.0 binaries for the four previously supported Linux/macOS x86-64/arm64 combinations. The MoonBit choice replaces its unavailable legacy bootstrap with verified Linux x86-64 toolchain and core archives for `0.10.19+bee578715`, then performs the official core bundle steps locally.

The Scale choice replaces its broken-TLS rolling endpoint with verified Scale CLI 0.2.0 release archives for Linux and macOS on x86-64 and arm64. Spin installs verified 4.2.6 release archives for the same host matrix. Native macOS arm64 smokes reported Scale 0.2.0 and Spin 4.2.6.

`install_conda` pins `Miniconda3-py312_26.9.4-0-Linux-x86_64.sh` at SHA-256 `9d95948a2f9ba5cc5e1c36d1e66e7607db3f3d21263f5fe812bc50e47b9bc289`; an Ubuntu 24.04 amd64 container smoke installed it and reported Conda 26.9.4.

## Acceptance criteria

None of the named scripts execute a mutable URL directly. Every downloaded installer has an explicit version or commit and verification step, and a corrupt or unavailable download fails without running.

# Execution phases

## SEC-10 — Verify the WasmCloud choice

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
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
