---
type: Plan
title: Validate the Rust coding guidelines skill
description: Validate the Acorn source skill under its renamed package identity without rewriting its guidance.
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

The Acorn `guidelines` skill is the official starting point. Its full instructions are restored in the package; only the metadata `name` is changed to `guidelines-rust`. The source applies to writing, reviewing, and refactoring code and retains its functional-programming and Rust-specific rules. Waza's 500-token advisory reports the original entrypoint as long; shortening it is not a prerequisite. Offline fixtures must reflect the original rules. Model-backed trials remain unrun because the available Copilot CLI is not authenticated.

## Acceptance criteria

The installed skill differs from Acorn's source only in its `name` field. Waza fixtures trigger on coding and review tasks, avoid non-code work, and test immutability, focused changes, and the source's rule against adding `?`. Any future instruction change starts from a recorded baseline, model-backed failure, and user-reviewed proposal.

# Execution phases

## GDR-02 — Validate Rust guideline behavior

- Status: blocked
- Budget: 5 active hours maximum
- Prerequisites: authenticated Copilot access, configured model permission, and explicit opt-in to model usage.
- Exact write set: GitHub Copilot model runtime; revise `agents/.agents/skills/guidelines-rust/SKILL.md` or its real suites only for an observed defect.
- Primary integration lock: Rust guidelines evaluation.
- Outcome: Positive and negative trials show source-aligned routing and functional Rust output. Record failures against the original instructions before proposing a change; do not rewrite the source solely to satisfy Waza's token score.
- Focused validation: `make -C agents real AGENT_SKILL=guidelines-rust`; inspect each grader and transcript.
- Handoff: Record before/after trial evidence and remaining qualitative limitations.
