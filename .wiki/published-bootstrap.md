---
type: Plan
title: Track the published shell bootstrap
description: Make the Linux and macOS quick-start installer source reviewable in this repository.
difficulty: medium
impact: medium
package: [my-shell-setup]
tags: [bootstrap, provenance, documentation]
status: waiting-on-validation
execution: phased
phase_budget_hours: 5
---

# Track the published shell bootstrap

## Current evidence and decision

The new repository-local `install.sh` preserves the hosted route's default packages and Gold versus home Stow targets. It also validates separate and comma-separated names before Git changes, checks an existing checkout's origin and `main` branch, and updates by fast-forward only. Bash syntax, shfmt, ShellCheck, and isolated-home mocked default, selected, invalid, and rerun scenarios passed, including this repository's GitHub SSH-over-443 origin. The hosted route is reachable, but its bytes and behavior have not been brought into line with this source.

## Acceptance criteria

The hosted shell quick-start matches the checked-in source and its package selection behavior; its deployed bytes and an isolated Linux smoke test are verified against a reviewed revision.

# Execution phases

## PUB-02 — Publish and compare the shell bootstrap

- Status: blocked
- Budget: 5 active hours maximum
- Prerequisites: a committed reviewed bootstrap revision and access to the `shell.jasonwohlgemuth.me` deployment system.
- Exact write set: `README.md`; external system: `shell.jasonwohlgemuth.me` shell bootstrap route.
- Primary integration lock: published shell installer.
- Outcome: The hosted route serves reviewed source and its deployment procedure is documented.
- Focused validation: Compare hosted bytes with the checked-in revision and run the README quick start in an isolated Linux environment.
- Handoff: Record deployment revision, checksum, and smoke-test result.
