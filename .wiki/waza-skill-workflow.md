---
type: Plan
title: Establish a Waza-backed skill improvement workflow
description: Separate offline harness checks from real behavior evaluation and gate skill changes with repeatable evidence.
difficulty: medium
impact: high
package: [agents]
tags: [waza, skills, evaluation]
status: planned
execution: phased
phase_budget_hours: 5
---

# Establish a Waza-backed skill improvement workflow

## Current evidence and decision

`agents` installs only `blank-test`; its `eval.yaml` uses `executor: mock` and grades whether prompts mention the skill, not the required `BLANK_TEST_SKILL_OK` response or routing behavior. `make agents-check` runs Waza static/spec checks and `agents-test` runs only the mock suite. Waza is absent from this machine. Follow the [official Waza workflow](https://microsoft.github.io/waza/guides/eval-yaml/): preflight and mock runs validate wiring; a model-backed executor and observable graders measure behavior. Use Waza 0.39.1 or newer as documented in `agents/README.md`. Keep paid real runs opt-in and use sanitized fixtures.

## Acceptance criteria

The canary has distinct offline and real-agent suites. Real trials verify exact output, positive and negative routing, and absence of tool calls; mock trials claim only harness health. Every imported skill has Waza coverage for its trigger, non-trigger, core outcome, and failure boundary. A documented test-first loop records baseline, one change, rerun, and regression result. CI runs credential-free checks; real runs remain explicit until credentials and usage policy are configured.

# Execution phases

## WAZ-01 — Separate canary harness and behavior evaluation

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none; obtain Waza 0.39.1 or newer using the documented installation method before validation.
- Exact write set: `Makefile`, `agents/README.md`, `agents/.agents/skills/blank-test/evals/eval.yaml`, `agents/.agents/skills/blank-test/evals/real.yaml`, `agents/.agents/skills/blank-test/evals/tasks/smoke.yaml`, `agents/.agents/skills/blank-test/evals/tasks/unrelated-testing.yaml`, `agents/.agents/skills/blank-test/trigger_tests.yaml`.
- Primary integration lock: Waza runner interface.
- Outcome: Offline and real-agent commands are distinct; the real suite grades exact canary output, routing, and zero tool calls.
- Focused validation: `waza check`, `waza spec verify --fail`, `waza preflight` for both suites, mock run, and one opt-in model-backed trial when authenticated.
- Handoff: Record CLI version, suite commands, grader evidence, and any external authentication prerequisite.

## WAZ-02 — Gate all skill suites offline in CI

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: WAZ-01, GDR-02, SOR-02, and PIK-02.
- Exact write set: `Makefile`, `agents/README.md`, `.github/workflows/skills.yml`.
- Primary integration lock: skill CI workflow.
- Outcome: A pinned Waza version checks all four installed skills with static checks, spec coverage, preflight, and mock suites where supplied.
- Focused validation: Run the aggregate target locally, inspect CI YAML, and verify a deliberately broken fixture makes the workflow fail.
- Handoff: Record the passing CI run and the command for an opt-in real-agent regression run.
