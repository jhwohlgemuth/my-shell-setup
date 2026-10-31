---
type: Plan
title: Import and refine the Rust sorting skill
description: Rename the Acorn sort skill and test safe, semantics-preserving ordering.
difficulty: medium
impact: medium
package: [agents]
tags: [skills, rust, sorting]
status: planned
execution: phased
phase_budget_hours: 5
---

# Import and refine the Rust sorting skill

## Current evidence and decision

Acorn's `/Users/o9w/dev/re/acorn/.agents/skills/sort/SKILL.md` is a single-file skill named `sort`. Its description requests use whenever code is involved, while its ordering rules are Rust-specific. Import it as `sort-rust`. Keep the safety rule that source order with behavior or explanatory meaning must not be changed; avoid reordering outside a requested Rust edit.

## Acceptance criteria

The installed skill is named `sort-rust`. It sorts independent Rust declarations deterministically when asked, preserves attached comments and attributes, and leaves semantic order and unrelated languages alone. Waza fixtures demonstrate all three cases.

# Execution phases

## SOR-01 — Import and scope the Rust sorting rules

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `agents/.agents/skills/sort-rust/SKILL.md`, `agents/README.md`.
- Primary integration lock: Rust sorting skill body.
- Outcome: The source is copied with attribution, renamed in metadata, and routed only to Rust sorting or nearby Rust edits where order is relevant.
- Focused validation: Review frontmatter and examples; run Stow simulation and `waza check` when available.
- Handoff: Record preserved source rules and narrowed trigger wording.

## SOR-02 — Add Waza ordering and boundary cases

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: SOR-01 and WAZ-01.
- Exact write set: `agents/.agents/skills/sort-rust/evals/eval.yaml`, `agents/.agents/skills/sort-rust/evals/real.yaml`, `agents/.agents/skills/sort-rust/evals/tasks/independent-declarations.yaml`, `agents/.agents/skills/sort-rust/evals/tasks/semantic-order.yaml`, `agents/.agents/skills/sort-rust/evals/tasks/non-rust.yaml`, `agents/.agents/skills/sort-rust/trigger_tests.yaml`, `agents/.agents/skills/sort-rust/SKILL.md`.
- Primary integration lock: Rust sorting evaluation.
- Outcome: Cases check deterministic ordering, attached attributes/comments, semantic-order preservation, and non-Rust routing; refine only observed failures.
- Focused validation: `waza spec verify --fail`, preflight, mock, and opt-in model-backed trials with deterministic file-diff graders.
- Handoff: Record before/after trial results and any rule that could not be graded mechanically.
