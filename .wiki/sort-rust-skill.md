---
type: Plan
title: Validate the Rust sorting skill
description: Confirm deterministic ordering and semantic-order preservation in model-backed trials.
difficulty: medium
impact: medium
package: [agents]
tags: [skills, rust, sorting]
status: waiting-on-validation
execution: phased
phase_budget_hours: 5
---

# Validate the Rust sorting skill

## Current evidence and decision

The copied Acorn skill is installed as `sort-rust` and scoped to independent Rust declarations. Its instructions keep attached comments and attributes and preserve semantic order. Waza 0.39.1 static checks, 3/3 spec coverage, preflight, and mock tasks pass locally. Model-backed sorting and routing tasks are authored but unrun because the available Copilot CLI is not authenticated.

## Acceptance criteria

The installed skill is named `sort-rust`. It sorts independent Rust declarations deterministically when asked, preserves attached comments and attributes, and leaves semantic order and unrelated languages alone. Waza fixtures demonstrate all three cases.

# Execution phases

## SOR-02 — Validate Rust sorting behavior

- Status: blocked
- Budget: 5 active hours maximum
- Prerequisites: authenticated Copilot access, configured model permission, and explicit opt-in to model usage.
- Exact write set: GitHub Copilot model runtime; revise `agents/.agents/skills/sort-rust/SKILL.md` or its real suites only for an observed defect.
- Primary integration lock: Rust sorting evaluation.
- Outcome: Trials show deterministic ordering, attached attributes/comments, semantic-order preservation, and non-Rust non-triggering; refine observed failures and rerun.
- Focused validation: `make agents-real AGENT_SKILL=sort-rust`; inspect output order and each grader.
- Handoff: Record before/after trial results and any rule that could not be graded mechanically.
