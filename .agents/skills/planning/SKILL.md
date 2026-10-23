---
name: planning
description: Maintain a repository's .wiki planning portfolio and turn remaining work into independently mergeable phases that fit one five-hour agent window. Use when creating, reviewing, updating, executing, pruning, or retiring plans in .wiki.
---

# Planning

Keep `.wiki` aligned with the current repository and useful as a queue of remaining work. Plans are not historical ledgers: remove completed plans and prune completed sections, phases, and tasks after preserving durable evidence in code, tests, user documentation, architecture documentation, release history, or a concise current-evidence statement.

## Route the task

- Read [wiki-lifecycle.md](references/wiki-lifecycle.md) whenever adding, reviewing, pruning, or retiring plans.
- Read [five-hour-slices.md](references/five-hour-slices.md) whenever creating or executing phases.
- Use [templates.md](references/templates.md) when authoring plan or phase structure.
- Read [portfolio-review.md](references/portfolio-review.md) for portfolio-wide reviews, rankings, dependency changes, or parallel scheduling.
- Run `python3 <planning-skill>/scripts/validate_wiki.py <repository-root>` after changing `.wiki`, resolving `<planning-skill>` to this skill's installed directory.

## Required workflow

1. Inspect the current worktree, recent history, relevant code, tests, and documentation before trusting plan evidence. Use the repository's required code-navigation tools when present.
2. Separate completed facts from remaining work. Prune completed sections, phases, checked tasks, and stale dependencies; delete a plan when no work remains.
3. Express every remaining executable outcome as a phase with at most five active hours, one exact write set or named external system, one primary integration lock, focused validation, and a mergeable handoff.
4. Update plan metadata, current evidence, dependencies, acceptance criteria, nearest index, root index, dependency network, and parallel lane together when their truth changes.
5. Preserve stable IDs for unfinished phases after pruning. Never renumber remaining work merely to close gaps.
6. Validate the wiki and inspect the diff. Do not implement product work unless the user separately authorized implementation.

## Invariants

- Executable plans use `execution: phased` and `phase_budget_hours: 5`. Non-executable portfolio or coordination records use `execution: coordination` and contain no executable phases.
- Phase statuses are `planned`, `ready`, `blocked`, or `in-progress`. A completed phase is removed, not marked `done`.
- External waiting is a prerequisite, not active phase time.
- A validation defect becomes a new bounded repair phase; it does not silently expand the active phase.
- A finished plan is deleted with every index, network, and lane entry. Durable information must survive somewhere outside the active plan.
- Never retain checked-off task lists as planning history.
