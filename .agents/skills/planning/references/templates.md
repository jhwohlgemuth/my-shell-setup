# Templates

## Plan layout

```text
.wiki/
  index.md                 # portfolio index
  _assets/                 # wiki-wide non-Markdown artifacts
  some-plan.md             # single-file option
  another-plan/
    index.md               # folder-format Plan entrypoint
    notes.md               # any number of adjacent Markdown documents
    _assets/               # this plan's images and other non-Markdown artifacts
```

When moving `some-plan.md` to `some-plan/index.md`, update inbound links and index, network, and lane references. Link from `index.md` to `notes.md` or `_assets/image.png` with paths relative to `index.md`.

## Executable plan metadata

```yaml
---
type: Plan
title: Short outcome
description: One-sentence remaining outcome.
difficulty: low | medium | high | mixed | not-assessed
impact: low | medium | high | critical | mixed | not-assessed
package: [non-empty, owners]
tags: [focused, terms, os:linux]
status: planned | in-progress | waiting-on-validation
execution: phased
phase_budget_hours: 5
---
```

Use `in-progress` only while at least one remaining execution phase has `- Status: in-progress`. A plan with only `ready`, `planned`, or `blocked` phases is not in progress; keep its plan status `planned` unless validation is genuinely pending.

Use canonical `os:<name>` tags only when work or validation is platform-conditioned. The supported
labels are listed in `SKILL.md`; architecture and package formats remain ordinary tags.

## Coordination metadata

An Epic is a non-executable plan of plans. Use `execution: coordination`, omit `phase_budget_hours`, and include no execution phases. State the shared outcome, what the linked plans cover, current decisions and blockers, and how completion will be recognized. Link to atomic executable child plans with relative `.md` links. The browser also displays older plans with zero parsed phases as Epics; add coordination metadata when maintaining those files. Epic time is excluded from portfolio effort totals so child estimates are not counted twice.

```yaml
---
type: Plan
title: Shared outcome
description: One-sentence outcome across linked plans.
status: planned
execution: coordination
---
```

```markdown
# Outcome

What this Epic coordinates and the completion condition.

# Child plans

- [First executable plan](./first-plan.md) — what it delivers.
- [Second executable plan](./second-plan.md) — what it delivers.

# Current coordination

Decisions, dependencies, and blockers that affect more than one child plan.
```

## Execution phase

```markdown
# Execution phases

## EXP-01 — Single mergeable outcome

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: none
- Exact write set: `path/to/file.rs`, `path/to/tests.rs`
- Primary integration lock: library API
- Outcome: One observable result.
- Focused validation: `cargo test -p package focused_test`
- Handoff: Evidence to record and the next eligible phase.
```

Use a named external system instead of paths for operational validation. Remove this entire block after completion; do not change its status to `done`.

## Incomplete handoff

```markdown
## Handoff

- Verified baseline: commit and relevant evidence.
- Changed files: exact paths.
- Validation run: commands and outcomes.
- Remaining defect: precise failure or missing prerequisite.
- Next action: one executable step.
```
