---
type: Plan
title: Repair correctness installer choices
description: Make every offered correctness-tool choice invoke an existing installer.
difficulty: low
impact: medium
package: [gold]
tags: [correctness, installer, menu]
status: planned
execution: phased
phase_budget_hours: 5
---

# Repair correctness installer choices

## Current evidence and decision

`gold/install_correctness_tools` offers Lean but calls nonexistent `install_lean`; its Rocq choice calls nonexistent `install_coq`, while `install_rocq` exists. Remove Lean from the menu until it has an installer and route Rocq to `install_rocq`.

## Acceptance criteria

Every displayed choice resolves to a repository command. Selecting Rocq invokes `install_rocq`; Lean is not displayed as installable.

# Execution phases

## COR-01 — Align menu choices with installers

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_correctness_tools`.
- Primary integration lock: correctness-tool menu.
- Outcome: The menu contains only executable choices and routes Rocq correctly.
- Focused validation: ShellCheck, shfmt check, and a mocked Gum selection of Rocq.
- Handoff: Record the verified menu-to-command map.
