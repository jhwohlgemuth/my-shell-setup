---
type: Plan
title: Repair Prusti PATH setup
description: Point the shell at retained Prusti binaries after the source checkout is removed.
difficulty: low
impact: medium
package: [gold]
tags: [prusti, path, installer]
status: planned
execution: phased
phase_budget_hours: 5
---

# Repair Prusti PATH setup

## Current evidence and decision

`gold/install_prusti` moves binaries to `~/.local/bin`, adds `~/prusti/bin` to `.zshrc`, and then deletes `~/prusti`. Keep the cleanup and add `~/.local/bin` to PATH only if needed.

## Acceptance criteria

After installation and a fresh shell, `prusti-rustc` and `cargo-prusti` resolve from retained paths and no PATH entry names the deleted checkout.

# Execution phases

## PRU-01 — Fix the retained binary path

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_prusti`.
- Primary integration lock: Prusti installer.
- Outcome: The script's PATH setup matches its retained files and does not duplicate an existing entry.
- Focused validation: ShellCheck, shfmt check, and a temporary-HOME shell test of the PATH edit; smoke-test installed commands where toolchain prerequisites are available.
- Handoff: Record the final binary path and command checks.
