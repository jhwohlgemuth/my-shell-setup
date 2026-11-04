---
type: Plan
title: Add reliable validation gates
description: Separate formatting from nonmutating checks and run them in CI.
difficulty: low
impact: high
package: [my-shell-setup]
tags: [make, ci, validation]
status: in-progress
execution: phased
phase_budget_hours: 5
---

# Add reliable validation gates

## Current evidence and decision

`make format` remains the local rewriting command. `make check` runs Bash syntax, shfmt diff, and ShellCheck for the listed Gold scripts; loads Nushell configuration without user config or history; parses PowerShell scripts; checks the exact agent Stow inventory; and simulates all package links. `.github/workflows/check.yml` invokes that root gate for pull requests, pushes to `main`, and manual dispatch, using Mise 2026.10.24 and Nushell 0.116.1. The first hosted run at `a931a43` failed in `make -C agents stow-check` because the runner lacked `stow`. Local checks do not establish a passing hosted gate.

## Acceptance criteria

CI runs the nonmutating `make check` gate on every pull request and push to the main branch.

# Execution phases

## VAL-02 — Enforce checks in CI

- Status: blocked
- Budget: 5 active hours maximum
- Prerequisites: VAL-03 repairs hosted tool provisioning, then inspect a passing GitHub Actions run.
- Exact write set: `.github/workflows/check.yml`.
- Primary integration lock: CI check workflow.
- Outcome: Pull requests and main-branch pushes run the nonmutating check target.
- Focused validation: Validate workflow YAML, run `make check` in a clean environment, and inspect the repaired workflow run.
- Handoff: Record the passing workflow URL and any tool-version pins.

## VAL-03 — Provision Stow for the hosted gate

- Status: in-progress
- Budget: 5 active hours maximum
- Prerequisites: none; the first hosted run identified missing `stow`.
- Exact write set: `.github/workflows/check.yml`.
- Primary integration lock: CI check workflow.
- Outcome: Hosted `make check` can invoke both the agent inventory check and package Stow simulation.
- Focused validation: Validate workflow YAML, run the gate with workflow-provisioned tools, and inspect a hosted run.
- Handoff: Record the provisioning command, tool version, and hosted result.
