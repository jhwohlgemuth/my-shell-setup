---
type: Plan
title: Make Windows setup executable from documented commands
description: Provide a file-backed Windows bootstrap that can locate the checked-out package sources.
difficulty: medium
impact: high
package: [my-shell-setup]
tags: [windows, bootstrap, correctness]
status: planned
execution: phased
phase_budget_hours: 5
---

# Make Windows setup executable from documented commands

## Current evidence and decision

`README.md` documents `irm .../install.ps1 | iex` and a downloaded script block. `Invoke-WindowsSetup.ps1` copies from `$PSScriptRoot`, which is empty for a script block; a `-WhatIf` reproduction confirmed this. Keep the package copier file-backed. Put the Windows bootstrap source in this repository and make it download or update a checkout before invoking the local file.

## Acceptance criteria

The documented default and selected-package Windows commands locate real package sources. `-WhatIf` and unknown-package errors work without copying files. A clean-home test installs each supported package from a checkout.

# Execution phases

## WIN-01 — Add a file-backed Windows bootstrap

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `install.ps1`, `Invoke-WindowsSetup.ps1`, `README.md`.
- Primary integration lock: Windows bootstrap interface.
- Outcome: Documented Windows commands invoke the checked-in installer from a checkout with a valid `$PSScriptRoot`.
- Focused validation: Parse both scripts; mock Git, clone/update, and copy operations; test default, selected, invalid, and `-WhatIf` inputs.
- Handoff: Record the exact verified commands and checkout location.

## WIN-02 — Publish and verify the Windows bootstrap

- Status: blocked
- Budget: 5 active hours maximum
- Prerequisites: WIN-01 and access to the `shell.jasonwohlgemuth.me` deployment system.
- Exact write set: `README.md`; external system: `shell.jasonwohlgemuth.me` Windows bootstrap route.
- Primary integration lock: published Windows installer.
- Outcome: The hosted route serves the reviewed `install.ps1`, and the README command succeeds against that route.
- Focused validation: Compare deployed bytes with the checked-in file and run the documented command in an isolated Windows environment.
- Handoff: Record the deployed revision, checksum, and smoke-test result.
