---
type: Plan
title: Import and refine the Rust coding guidelines skill
description: Rename the Acorn guidelines skill and make its Rust advice scoped and testable.
difficulty: medium
impact: medium
package: [agents]
tags: [skills, rust, guidelines]
status: planned
execution: phased
phase_budget_hours: 5
---

# Import and refine the Rust coding guidelines skill

## Current evidence and decision

Acorn's `/Users/o9w/dev/re/acorn/.agents/skills/guidelines/SKILL.md` is a single-file skill named `guidelines`. Its description says to use it for all coding, but much of the body is Rust-specific. It also mandates choices such as avoiding `?`, preferring `core` over `std`, and using an `exitcode` module regardless of project conventions. Import it as `guidelines-rust`, preserve attribution, and scope guidance to Rust tasks and repository policy. Do not copy claims that conflict with idiomatic error propagation or the target repository's instructions.

## Acceptance criteria

The installed skill is named `guidelines-rust`, triggers for relevant Rust implementation or review requests, stays out of unrelated shell and prose work, and offers actionable, idiomatic advice that respects explicit project conventions. Waza tasks demonstrate both routing and a concrete Rust improvement.

# Execution phases

## GDR-01 — Import and scope the Rust guidelines

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `agents/.agents/skills/guidelines-rust/SKILL.md`, `agents/README.md`.
- Primary integration lock: Rust guidelines skill body.
- Outcome: The source is copied with attribution, renamed in metadata and references, and narrowed to Rust-specific, project-aware advice.
- Focused validation: Review frontmatter and references; run `stow --simulate --no-folding` and `waza check` when available.
- Handoff: Record the source revision, retained principles, and removed blanket rules.

## GDR-02 — Add Waza routing and Rust outcome cases

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: GDR-01 and WAZ-01.
- Exact write set: `agents/.agents/skills/guidelines-rust/evals/eval.yaml`, `agents/.agents/skills/guidelines-rust/evals/real.yaml`, `agents/.agents/skills/guidelines-rust/evals/tasks/rust-error-handling.yaml`, `agents/.agents/skills/guidelines-rust/evals/tasks/project-convention.yaml`, `agents/.agents/skills/guidelines-rust/evals/tasks/non-rust.yaml`, `agents/.agents/skills/guidelines-rust/trigger_tests.yaml`, `agents/.agents/skills/guidelines-rust/SKILL.md`.
- Primary integration lock: Rust guidelines evaluation.
- Outcome: Positive, negative, and project-convention fixtures expose any over-triggering or incorrect Rust advice; the skill is refined against the failing case.
- Focused validation: `waza spec verify --fail`, preflight and mock runs, then opt-in model-backed trials scored for correct routing and no blanket rejection of `?`.
- Handoff: Record before/after trial evidence and remaining qualitative limitations.
