---
type: Plan
title: Make PowerShell startup safe
description: Remove global repository-policy mutation and optional-module dependency from profile loading.
difficulty: low
impact: high
package: [powershell]
tags: [powershell, profile, startup]
status: planned
execution: phased
phase_budget_hours: 5
---

# Make PowerShell startup safe

## Current evidence and decision

The profile marks PSGallery trusted on every startup, calls `Test-Command` without defining it locally, and initializes McFly twice. Remove the trust mutation from startup, use built-in `Get-Command` checks, and initialize McFly once. Document optional PSGallery trust as an explicit setup action.

## Acceptance criteria

A fresh `pwsh` profile loads without Prelude or external commands installed, does not change PSGallery policy, and initializes each available tool once.

# Execution phases

## PSH-01 — Make startup idempotent and dependency-safe

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `powershell/.config/powershell/Microsoft.PowerShell_profile.ps1`, `README.md`.
- Primary integration lock: PowerShell profile startup.
- Outcome: Profile loading has no implicit repository-policy change or missing helper dependency.
- Focused validation: Parse both PowerShell scripts and load the profile in a clean PowerShell session with optional commands absent.
- Handoff: Record startup results and the documented optional trust command.
