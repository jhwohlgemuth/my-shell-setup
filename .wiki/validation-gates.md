---
type: Plan
title: Add reliable validation gates
description: Separate formatting from nonmutating checks and run them in CI.
difficulty: low
impact: high
package: [my-shell-setup]
tags: [make, ci, validation]
status: waiting-on-validation
execution: phased
phase_budget_hours: 5
---

# Add reliable validation gates

## Current evidence and decision

`make format` remains the local rewriting command. `make check` runs Bash syntax, shfmt diff, and ShellCheck for the listed Gold scripts; loads Nushell configuration without user config or history; parses PowerShell scripts; checks the exact agent Stow inventory; and simulates all package links. `.github/workflows/check.yml` now invokes that root gate for pull requests, pushes to `main`, and manual dispatch, using Mise 2026.10.24 and Nushell 0.116.1. The workflow structure, isolated tool provisioning, and root gate pass locally; the first hosted run remains pending until the workflow is committed and pushed.

## Acceptance criteria

CI runs the nonmutating `make check` gate on every pull request and push to the main branch.

# Execution phases

## VAL-02 — Enforce checks in CI

- Status: blocked
- Budget: 5 active hours maximum
- Prerequisites: commit and push `.github/workflows/check.yml`, then inspect its first GitHub Actions run; local workflow validation and `make check` pass.
- Exact write set: `.github/workflows/check.yml`.
- Primary integration lock: CI check workflow.
- Outcome: Pull requests and main-branch pushes run the nonmutating check target.
- Focused validation: Validate workflow YAML, run `make check` in a clean environment, and inspect the first workflow run.
- Handoff: Record the passing workflow URL and any tool-version pins.
