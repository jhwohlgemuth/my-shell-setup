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

`make format` rewrites every Gold shell script and runs ShellCheck in a loop without fail-fast behavior. This repository has no checked-in CI workflow. Read-only Bash syntax, ShellCheck, shfmt, Nushell load, PowerShell parse, and Stow simulation checks passed in the review, but they are not collected into one gate. Keep `format` for local writes; add a nonmutating `check` target and require all tools in CI.

## Acceptance criteria

`make check` leaves tracked files unchanged, checks shell and configuration syntax plus Stow layout, and returns nonzero for a deliberately invalid early script. CI runs the same check on every pull request and push to the main branch.

# Execution phases

## VAL-01 — Add a nonmutating local check

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `Makefile`.
- Primary integration lock: Makefile validation interface.
- Outcome: Formatting and validation are separate targets; the check includes Bash, shfmt, ShellCheck, Nushell, PowerShell, and Stow with reliable error propagation.
- Focused validation: Run `make check`, inspect `git diff`, and exercise one deliberately failing script in an isolated temporary copy.
- Handoff: Record required command versions and the check target's invocation.

## VAL-02 — Enforce checks in CI

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: VAL-01.
- Exact write set: `.github/workflows/check.yml`.
- Primary integration lock: CI check workflow.
- Outcome: Pull requests and main-branch pushes run the nonmutating check target.
- Focused validation: Validate workflow YAML, run `make check` in a clean environment, and inspect the first workflow run.
- Handoff: Record the passing workflow URL and any tool-version pins.
