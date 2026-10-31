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

`README.md` describes Linux and macOS setup, but Gold installers such as `install_conda`, `install_code_server`, and `install_bflat` fetch Linux x86-64 artifacts. `install_cuda_toolkit` constructs a Debian x86-64 URL, and `install_dotnet` hardcodes Ubuntu 20.04. Gold remains a collection of individual commands; unsupported hosts should fail before download or mutation.

## Acceptance criteria

Gold documentation states the supported host for each installer family. The named installers reject unsupported OS, architecture, distro, or privilege combinations before changing the host, and supported combinations keep their existing interface.

# Execution phases

## PLT-01 — Publish the Gold support matrix

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/README.md`.
- Primary integration lock: Gold platform documentation.
- Outcome: A reader can identify the OS, architecture, privilege, and required package manager for each installer family.
- Focused validation: Compare every `gold/install_*` script with the matrix and verify all listed commands exist.
- Handoff: Record ambiguous upstream support requiring investigation in the relevant script phase.

## PLT-02 — Guard downloaded binary installers

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: PLT-01.
- Exact write set: `gold/install_conda`, `gold/install_code_server`, `gold/install_bflat`.
- Primary integration lock: downloaded binary installer guards.
- Outcome: These scripts select a supported artifact or fail before download with the detected host in the message.
- Focused validation: ShellCheck, shfmt diff, and mocked Linux x86-64, Linux arm64, and macOS detection.
- Handoff: Record supported artifact mappings and unsupported-host output.

## PLT-03 — Guard distro-specific system installers

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: PLT-01.
- Exact write set: `gold/install_cuda_toolkit`, `gold/install_dotnet`, `gold/install_docker`.
- Primary integration lock: distro-specific package installation.
- Outcome: These commands validate supported distro, architecture, and privilege before apt or repository changes.
- Focused validation: ShellCheck, shfmt diff, and mocked supported and unsupported `/etc/os-release`, architecture, and user-ID cases.
- Handoff: Record the verified supported matrix and error messages.
