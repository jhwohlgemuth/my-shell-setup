---
type: Plan
title: Validate the Rust coding guidelines skill
description: Confirm the renamed, scoped skill follows Rust conventions in model-backed trials.
difficulty: medium
impact: medium
package: [agents]
tags: [skills, rust, guidelines]
status: waiting-on-validation
execution: phased
phase_budget_hours: 5
---

# Validate the Rust coding guidelines skill

## Current evidence and decision

The copied Acorn skill is installed as `guidelines-rust`. Its entrypoint now focuses on small Rust edits, permits idiomatic `?`, and follows repository conventions instead of mandating `core` or an `exitcode` dependency. Waza 0.39.1 static checks, 3/3 spec coverage, preflight, and mock tasks pass locally. The model-backed outcome, boundary, and routing tasks are authored but unrun because the available Copilot CLI is not authenticated.

## Acceptance criteria

The installed skill is named `guidelines-rust`, triggers for focused Rust implementation, stays out of read-only reviews and unrelated work, and gives idiomatic advice that respects project conventions. Model-backed Waza tasks demonstrate routing, ordinary `?` propagation, and a project-convention boundary.

# Execution phases

## GDR-02 — Validate Rust guideline behavior

- Status: blocked
- Budget: 5 active hours maximum
- Prerequisites: authenticated Copilot access, configured model permission, and explicit opt-in to model usage.
- Exact write set: GitHub Copilot model runtime; revise `agents/.agents/skills/guidelines-rust/SKILL.md` or its real suites only for an observed defect.
- Primary integration lock: Rust guidelines evaluation.
- Outcome: Positive, negative, and project-convention trials show correct routing and no blanket rejection of `?`; refine any observed failure and rerun.
- Focused validation: `make agents-real AGENT_SKILL=guidelines-rust`; inspect each grader and transcript.
- Handoff: Record before/after trial evidence and remaining qualitative limitations.
