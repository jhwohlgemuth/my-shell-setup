---
type: Plan
title: Import and generalize the Pikchr diagram skill
description: Preserve editable diagram examples while removing ACORN-only defaults from cross-project use.
difficulty: medium
impact: medium
package: [agents]
tags: [skills, diagrams, pikchr]
status: planned
execution: phased
phase_budget_hours: 5
---

# Import and generalize the Pikchr diagram skill

## Current evidence and decision

Acorn's `/Users/o9w/dev/re/acorn/.agents/skills/pikchr-diagram` contains a skill, examples, an editable `.pikchr` asset, its SVG, and agent metadata. The core workflow is reusable, but ACORN-specific actor assignments and process distinctions should remain examples rather than defaults. Keep source assets and relative references intact; the target repository has no Pikchr renderer on PATH, so rendering is a documented prerequisite for visual acceptance.

## Acceptance criteria

The installed skill creates an editable Pikchr source and a visually checked output for a supplied process, assigns roles from that process rather than ACORN defaults, and does not trigger for quantitative plotting or screenshot editing. Its reference files and assets are present after Stow installation.

# Execution phases

## PIK-01 — Import reusable Pikchr instructions and assets

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `agents/.agents/skills/pikchr-diagram/SKILL.md`, `agents/.agents/skills/pikchr-diagram/agents/openai.yaml`, `agents/.agents/skills/pikchr-diagram/assets/workflow-map.pikchr`, `agents/.agents/skills/pikchr-diagram/assets/workflow-map.svg`, `agents/.agents/skills/pikchr-diagram/references/examples.md`, `agents/README.md`.
- Primary integration lock: Pikchr skill package.
- Outcome: The complete source skill is copied and its general instructions separate source-grounded roles from ACORN examples.
- Focused validation: Check every relative link and asset, simulate Stow, and render the bundled example with a documented renderer.
- Handoff: Record source revision, renderer command, and inspected example output.

## PIK-02 — Evaluate diagrams outside the source domain

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: PIK-01 and WAZ-01.
- Exact write set: `agents/.agents/skills/pikchr-diagram/evals/eval.yaml`, `agents/.agents/skills/pikchr-diagram/evals/real.yaml`, `agents/.agents/skills/pikchr-diagram/evals/tasks/generic-workflow.yaml`, `agents/.agents/skills/pikchr-diagram/evals/tasks/role-correction.yaml`, `agents/.agents/skills/pikchr-diagram/evals/tasks/non-diagram.yaml`, `agents/.agents/skills/pikchr-diagram/trigger_tests.yaml`, `agents/.agents/skills/pikchr-diagram/SKILL.md`.
- Primary integration lock: Pikchr diagram evaluation.
- Outcome: Waza tests routing and role fidelity on a non-ACORN process; the skill is refined against observed errors.
- Focused validation: `waza spec verify --fail`, preflight, mock, and opt-in model-backed trials; render and inspect final diagrams at destination size.
- Handoff: Record trial scores, rendered artifact checks, and any visual judgment requiring human review.
