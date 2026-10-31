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

The Acorn `sort` skill is the official starting point. Its full instructions are restored in the package; only the metadata `name` is changed to `sort-rust`. Its description applies to code changes broadly, and its body details Rust grouping, implementation blocks, and tests. Waza's 500-token advisory reports the original entrypoint as long; shortening it is not a prerequisite. Model-backed trials remain unrun because the available Copilot CLI is not authenticated.

## Acceptance criteria

The installed skill differs from Acorn's source only in its `name` field. Waza fixtures check deterministic ordering, attached comments and attributes, semantic-order preservation, code-task routing, and avoidance of non-code tasks. Any instruction change starts from a recorded baseline, model-backed failure, and user-reviewed proposal.

# Execution phases

## SOR-02 — Validate Rust sorting behavior

- Status: blocked
- Budget: 5 active hours maximum
- Prerequisites: authenticated Copilot access, configured model permission, and explicit opt-in to model usage.
- Exact write set: GitHub Copilot model runtime; revise `agents/.agents/skills/sort-rust/SKILL.md` or its real suites only for an observed defect.
- Primary integration lock: Rust sorting evaluation.
- Outcome: Trials show deterministic ordering, attached attributes/comments, semantic-order preservation, and non-code non-triggering. Record failures against the original instructions before proposing a change.
- Focused validation: `make agents-real AGENT_SKILL=sort-rust`; inspect output order and each grader.
- Handoff: Record before/after trial results and any rule that could not be graded mechanically.
