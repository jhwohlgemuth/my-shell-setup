---
type: Plan
title: Make Nushell history portable
description: Use a working history location on Windows, Linux, and macOS.
difficulty: low
impact: medium
package: [nushell]
tags: [nushell, history, portability]
status: planned
execution: phased
phase_budget_hours: 5
---

# Make Nushell history portable

## Current evidence and decision

`nushell/.config/nushell/config.nu` sets a OneDrive/PowerShell history path unconditionally. Keep that path only when its parent directory exists; otherwise omit the custom path and let Nushell use its default data directory.

## Acceptance criteria

Nushell starts and saves history on a host without OneDrive; a host with the existing OneDrive directory retains the custom history path.

# Execution phases

## NUH-01 — Select history path by host state

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `nushell/.config/nushell/config.nu`.
- Primary integration lock: Nushell history configuration.
- Outcome: The custom path is configured only when its parent exists.
- Focused validation: `nu-check` and startup tests with temporary homes both with and without the OneDrive directory.
- Handoff: Record both observed history paths.
