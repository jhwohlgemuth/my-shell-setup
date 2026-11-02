---
type: Plan
title: Add reliable validation gates
description: Separate formatting from nonmutating checks and run them in CI.
difficulty: low
impact: high
package: [my-shell-setup]
tags: [make, ci, validation]
status: planned
execution: phased
phase_budget_hours: 5
---

# Add reliable validation gates

## Current evidence and decision

`make format` remains the local rewriting command. `make check` now runs Bash syntax, shfmt diff, and ShellCheck for the listed Gold scripts; loads Nushell configuration without user config or history; parses PowerShell scripts; checks the exact agent Stow inventory; and simulates all package links. It passed locally, left tracked files unchanged, and rejected a deliberately invalid first Gold script. `.github/workflows/skills.yml` already checks the agents package, but no general workflow invokes the root gate.

## Acceptance criteria

CI runs the nonmutating `make check` gate on every pull request and push to the main branch.

# Execution phases

## VAL-02 — Enforce checks in CI

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none; `make check` is available.
- Exact write set: `.github/workflows/check.yml`.
- Primary integration lock: CI check workflow.
- Outcome: Pull requests and main-branch pushes run the nonmutating check target.
- Focused validation: Validate workflow YAML, run `make check` in a clean environment, and inspect the first workflow run.
- Handoff: Record the passing workflow URL and any tool-version pins.
