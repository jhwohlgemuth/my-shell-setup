---
type: Plan
title: Validate the Waza-backed skill improvement workflow
description: Confirm model-backed behavior for installed skills and the offline gate in hosted CI.
difficulty: medium
impact: high
package: [agents]
tags: [waza, skills, evaluation]
status: waiting-on-validation
execution: phased
phase_budget_hours: 5
---

# Validate the Waza-backed skill improvement workflow

## Current evidence and decision

`agents` contains six installed skill sources: the canary, `guidelines-rust`, `sort-rust`, `pikchr-diagram`, `rust-best-practices`, and `rust-review`. Each has an offline mock harness, a model-backed outcome/boundary suite, and a positive/negative routing suite. `make agents-ci` discovers all six and passes Waza 0.39.1 static checks, deterministic spec coverage, preflight, and mock runs locally. The repository workflow pins and checksum-verifies the CLI, but a hosted run remains unverified. `waza models` with the available Copilot CLI reported `not authenticated`; no model-backed trial has run. Follow the [official Waza workflow](https://microsoft.github.io/waza/guides/eval-yaml/) and keep real runs explicit with sanitized fixtures.

## Acceptance criteria

The canary has distinct offline and real-agent suites. Real trials verify exact output, positive and negative routing, and absence of tool calls; mock trials claim only harness health. All five copied skills have Waza coverage for trigger, non-trigger, core outcome, and failure boundary. A documented test-first loop records baseline, one change, rerun, and regression result. Hosted CI checks all six skills without model credentials; real behavior is validated only with explicit authenticated runs.

# Execution phases

## WAZ-01 — Validate canary behavior on an authenticated agent

- Status: blocked
- Budget: 5 active hours maximum
- Prerequisites: explicit opt-in for model usage, authenticated GitHub Copilot access, and permission for the configured model.
- Exact write set: GitHub Copilot model runtime; revise the canary suite only if the observed failure is a fixture or grader defect.
- Primary integration lock: canary real-agent evidence.
- Outcome: The saved trial results show exact output, zero tool calls in the output suite, correct positive and negative routing, and no auxiliary calls in the routing suite.
- Focused validation: `make agents-real AGENT_SKILL=blank-test`; inspect every task's grader verdict and transcript.
- Handoff: Record the CLI and model versions, result paths, verdicts, and any observed defect requiring a bounded repair phase.

## WAZ-02 — Validate the imported skill gate in hosted CI

- Status: blocked
- Budget: 5 active hours maximum
- Prerequisites: the workflow changes are committed to a branch with GitHub Actions enabled; access to the hosted run.
- Exact write set: GitHub Actions `Agent skill checks` workflow run; revise the workflow or imported suite only if hosted evidence exposes a defect.
- Primary integration lock: skill CI workflow.
- Outcome: A hosted run with all six installed skills passes static checks, spec coverage, preflight, and mock suites, and a broken fixture fails the gate.
- Focused validation: Inspect the hosted CI log and confirm all six skill names and pinned Waza version appear with passing results.
- Handoff: Record the passing CI run and the command for an opt-in real-agent regression run.

## WAZ-03 — Validate Rust best-practices behavior

- Status: blocked
- Budget: 5 active hours maximum
- Prerequisites: authenticated Copilot access, configured model permission, and explicit opt-in to model usage.
- Exact write set: GitHub Copilot model runtime; revise `agents/.agents/skills/rust-best-practices/SKILL.md` or its real suites only for an observed defect.
- Primary integration lock: Rust implementation skill evaluation.
- Outcome: Saved trials show correct implementation routing, fallible parser output without panic, and respect for a project's explicit loop convention; refine and rerun observed failures.
- Focused validation: `make agents-real AGENT_SKILL=rust-best-practices`; inspect each grader and transcript.
- Handoff: Record before/after trial evidence, model version, and any remaining qualitative limit.

## WAZ-04 — Validate Rust review behavior

- Status: blocked
- Budget: 5 active hours maximum
- Prerequisites: authenticated Copilot access, configured model permission, and explicit opt-in to model usage.
- Exact write set: GitHub Copilot model runtime; revise `agents/.agents/skills/rust-review/SKILL.md` or its real suites only for an observed defect.
- Primary integration lock: Rust review skill evaluation.
- Outcome: Saved trials show correct review routing, a located high-priority panic finding, no invented critical issue, and no code edits; refine and rerun observed failures.
- Focused validation: `make agents-real AGENT_SKILL=rust-review`; inspect each grader and transcript.
- Handoff: Record before/after trial evidence, model version, and any remaining qualitative limit.
