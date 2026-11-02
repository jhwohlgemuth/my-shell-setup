---
type: Plan
title: Make installer platform support explicit
description: Document and enforce operating-system, architecture, and privilege prerequisites for Gold installers.
difficulty: medium
impact: high
package: [gold]
tags: [portability, installers, platforms]
status: planned
execution: phased
phase_budget_hours: 5
---

# Make installer platform support explicit

## Current evidence and decision

`gold/README.md` now records the host, architecture, privilege or target, and package-manager or toolchain assumptions for all 39 `install_*` commands, including all 16 `install_wasm_tools` choices. It identifies upstream-defined or otherwise ambiguous support instead of claiming it. `install_conda`, `install_code_server`, and `install_bflat` still fetch Linux x86-64 artifacts without early guards; `install_cuda_toolkit`, `install_dotnet`, and `install_docker` still need explicit distro, architecture, and privilege checks before mutation.

## Acceptance criteria

Gold documentation states the supported host for each installer family. The named installers reject unsupported OS, architecture, distro, or privilege combinations before changing the host, and supported combinations keep their existing interface.

# Execution phases

## PLT-02 — Guard downloaded binary installers

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none; the Gold support matrix is published in `gold/README.md`.
- Exact write set: `gold/install_conda`, `gold/install_code_server`, `gold/install_bflat`.
- Primary integration lock: downloaded binary installer guards.
- Outcome: These scripts select a supported artifact or fail before download with the detected host in the message.
- Focused validation: ShellCheck, shfmt diff, and mocked Linux x86-64, Linux arm64, and macOS detection.
- Handoff: Record supported artifact mappings and unsupported-host output.

## PLT-03 — Guard distro-specific system installers

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none; the Gold support matrix is published in `gold/README.md`.
- Exact write set: `gold/install_cuda_toolkit`, `gold/install_dotnet`, `gold/install_docker`.
- Primary integration lock: distro-specific package installation.
- Outcome: These commands validate supported distro, architecture, and privilege before apt or repository changes.
- Focused validation: ShellCheck, shfmt diff, and mocked supported and unsupported `/etc/os-release`, architecture, and user-ID cases.
- Handoff: Record the verified supported matrix and error messages.
