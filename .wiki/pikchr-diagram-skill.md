---
type: Plan
title: Validate the reusable Pikchr diagram skill
description: Confirm source-grounded roles and visually checked output in a non-Acorn workflow.
difficulty: medium
impact: medium
package: [agents]
tags: [skills, diagrams, pikchr]
status: waiting-on-validation
execution: phased
phase_budget_hours: 5
---

# Validate the reusable Pikchr diagram skill

## Current evidence and decision

The Acorn skill is the official starting point. Its full `SKILL.md`, examples, Pikchr source, SVG, and agent metadata are restored unchanged. The original entrypoint includes ACORN actor guidance and explicitly says to adapt roles for other domains. Waza's 500-token advisory reports the original entrypoint as long; shortening it is not a prerequisite. Stow preserves runtime assets while excluding evals. `mdbook` and `mdbook-pikchr` rendered the bundled source in a temporary book, and its SVG was inspected; model-generated output remains unverified because the available Copilot CLI is not authenticated.

## Acceptance criteria

The installed skill matches Acorn's source. Waza fixtures check an editable Pikchr source for a non-ACORN process with source-grounded roles, and avoid quantitative plotting and screenshot editing. Rendered output is visually checked, and references and assets are present after Stow installation. Any instruction change starts from a recorded baseline, model-backed failure, and user-reviewed proposal.

# Execution phases

## PIK-02 — Validate diagrams outside the source domain

- Status: blocked
- Budget: 5 active hours maximum
- Prerequisites: authenticated Copilot access, configured model permission, and explicit opt-in to model usage.
- Exact write set: GitHub Copilot model runtime and a rendered evaluation artifact; revise `agents/.agents/skills/pikchr-diagram/SKILL.md` or its real suites only for an observed defect.
- Primary integration lock: Pikchr diagram evaluation.
- Outcome: Waza trials show correct routing and role fidelity on a non-Acorn process, and the generated diagram is rendered and inspected at destination size.
- Focused validation: `make agents-real AGENT_SKILL=pikchr-diagram`; render and inspect the generated `.pikchr` output.
- Handoff: Record trial scores, rendered artifact checks, and any visual judgment requiring human review.
