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

`agents` contains six installed skill sources: the canary, `guidelines-rust`, `sort-rust`, `pikchr-diagram`, `rust-best-practices`, and `rust-review`. The five imported Acorn skills are the official starting point: their full entrypoints and supporting assets are restored, with only the two requested metadata names changed. Each has an offline mock harness, a model-backed outcome/boundary suite, and a positive/negative routing suite. Waza's token/readiness score is advisory and does not authorize rewriting the source. The repository workflow pins and checksum-verifies the CLI, but a hosted run remains unverified. `waza models` with the available Copilot CLI reported `not authenticated`; no model-backed trial has run. Follow the [official Waza workflow](https://microsoft.github.io/waza/guides/eval-yaml/) and keep real runs explicit with sanitized fixtures.

The capability baseline now records each original Acorn section's digest and links it to relevant real Waza tasks. `make agents-coverage` reports source retention and test mapping. The initial sanitized snapshot at `agents/coverage/history/2026-10-31-acorn-baseline.json` has 42 unchanged original sections, nine with behavioral task mappings, and zero verified by real-agent results. A changed section requires a digest-bound review record with reason and evidence. The report compares PRs with their base checkout and, when source-bound real result snapshots are supplied, compares pass rates only under matching task, suite, model, engine, and trial conditions. `make agents-assess` now saves numbered real-agent runs and compares each revision with the last completed run; optional paired no-skill trials measure the skill's effect. The guidelines-rust error task no longer repeats the rule in its prompt, tests valid and invalid parses with `rustc`, and measures routing without Waza's eval-only hint. Offline validation passes; authenticated model trials remain outstanding. The package-local Stow ignore rules now exclude development files by anchored paths; an exhaustive temporary install confirms 15 runtime links, including skill resources, and CI runs that inventory check. The built-in Waza `coverage` grid classifies all six `eval.yaml` mock suites as partial; that structural metric is not a measure of behavioral usefulness.

## Acceptance criteria

The canary has distinct offline and real-agent suites. Real trials verify exact output, positive and negative routing, and absence of tool calls; mock trials claim only harness health. All five copied skills have source-aligned Waza coverage for trigger, non-trigger, core outcome, and failure boundary. A documented test-first loop records the original source baseline, an observed failure, a proposed change, rerun, and regression result. Instruction changes require review against that baseline; Waza advisory scores alone are not grounds for altering it. Hosted CI checks all six skills without model credentials; real behavior is validated only with explicit authenticated runs.

The capability report identifies every original section as unchanged, reviewed change, or unreviewed change; lists unmapped sections; and shows mapping gains or losses against the previous report. A missing mapped task or unreviewed source edit fails the offline gate. Saved real-agent results can mark mapped behaviors verified, and comparable pass-rate regressions fail the comparison gate. Mock results never count as behavioral verification.

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
- Outcome: Saved trials show Rust writing and review routing, fallible parser output without panic, and respect for an explicit loop convention; record failures against the original source before proposing changes.
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
