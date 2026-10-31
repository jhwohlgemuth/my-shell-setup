---
name: rust-review
description: |
  Assess requested Rust code without editing it, prioritizing correctness and API impact and explaining fixes with locations.
  USE FOR: Review existing Rust modules for correctness and API design.
  DO NOT USE FOR: Implement new Rust code.
---

# Rust review

Review the scope the user named and report prioritized findings with a location, consequence, and concrete fix. Do not edit code during a review unless asked. Distinguish correctness and soundness risks from API costs and style preferences. Respect the project's edition, MSRV, and conventions; state when tools were unavailable or not run.

Use [the review checklist](references/review-checklist.md) for deeper Rust checks and report shape. When the separately installed `rust-best-practices` skill is available, read only its relevant source digest for a finding that needs it. Avoid generic lint recommendations unrelated to observed findings.
