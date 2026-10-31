---
type: Plan
title: Track the published shell bootstrap
description: Make the Linux and macOS quick-start installer source reviewable in this repository.
difficulty: medium
impact: medium
package: [my-shell-setup]
tags: [bootstrap, provenance, documentation]
status: planned
execution: phased
phase_budget_hours: 5
---

# Track the published shell bootstrap

## Current evidence and decision

`README.md` runs `https://shell.jasonwohlgemuth.me/install.sh`, but this repository has no `install.sh` or deployment definition. Capture the hosted behavior in a checked-in script and document how a reviewed revision reaches the hosted route. This is separate from pinning upstream installers used by Gold.

## Acceptance criteria

The shell quick-start source and its package selection behavior are versioned here, and the deployed route is verified against a reviewed revision.

# Execution phases

## PUB-01 — Check in the shell bootstrap source

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `install.sh`, `README.md`.
- Primary integration lock: shell quick-start interface.
- Outcome: A checked-in script implements the documented default, separate, and comma-separated package selections.
- Focused validation: ShellCheck, shfmt diff, and isolated-home tests for default, selected, invalid, and repeat invocations.
- Handoff: Record the source revision and local usage command.

## PUB-02 — Publish and compare the shell bootstrap

- Status: blocked
- Budget: 5 active hours maximum
- Prerequisites: PUB-01 and access to the `shell.jasonwohlgemuth.me` deployment system.
- Exact write set: `README.md`; external system: `shell.jasonwohlgemuth.me` shell bootstrap route.
- Primary integration lock: published shell installer.
- Outcome: The hosted route serves reviewed source and its deployment procedure is documented.
- Focused validation: Compare hosted bytes with the checked-in revision and run the README quick start in an isolated Linux environment.
- Handoff: Record deployment revision, checksum, and smoke-test result.
