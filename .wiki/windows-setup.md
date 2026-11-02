---
type: Plan
title: Make Windows setup executable from documented commands
description: Provide a file-backed Windows bootstrap that can locate the checked-out package sources.
difficulty: medium
impact: high
package: [my-shell-setup]
tags: [windows, bootstrap, correctness]
status: waiting-on-validation
execution: phased
phase_budget_hours: 5
---

# Make Windows setup executable from documented commands

## Current evidence and decision

The new repository-local `install.ps1` validates package selections before Git changes, clones or fast-forward updates a verified `main` checkout, and invokes the file-backed `Invoke-WindowsSetup.ps1`. It accepts this repository's HTTPS and SSH origins, including GitHub SSH over port 443, and refuses a locally modified copier. Both README invocation forms, default and selected packages, invalid input, `-WhatIf`, update failures, and runtime skill copying passed temporary-home mocked tests; both PowerShell scripts parse. A read-only `-WhatIf` against this checkout passed. The hosted route and a native Windows install remain unverified.

## Acceptance criteria

The hosted default and selected-package Windows commands serve the reviewed `install.ps1` and install from a checkout in an isolated Windows environment. Deployed bytes match the checked-in source.

# Execution phases

## WIN-02 — Publish and verify the Windows bootstrap

- Status: blocked
- Budget: 5 active hours maximum
- Prerequisites: a committed reviewed bootstrap revision, access to the `shell.jasonwohlgemuth.me` deployment system, and an isolated Windows host.
- Exact write set: `README.md`; external system: `shell.jasonwohlgemuth.me` Windows bootstrap route.
- Primary integration lock: published Windows installer.
- Outcome: The hosted route serves the reviewed `install.ps1`, and the README command succeeds against that route.
- Focused validation: Compare deployed bytes with the checked-in file and run the documented command in an isolated Windows environment.
- Handoff: Record the deployed revision, checksum, and smoke-test result.
