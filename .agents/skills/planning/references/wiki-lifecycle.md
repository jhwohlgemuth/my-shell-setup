# Wiki lifecycle

## Add

Create one Markdown concept for one atomic outcome. Use either `some-plan.md` or `some-plan/index.md` as the Plan entrypoint. A folder-format plan may contain any number of adjacent Markdown files for supporting material. Keep non-Markdown plan assets in `some-plan/_assets/` and wiki-wide assets in `.wiki/_assets/`; use relative links from the file that contains them. Add the required Plan frontmatter, current evidence, boundaries, dependencies, decisions, validation, acceptance criteria, and five-hour execution phases. Link the entrypoint from the root and nearest indexes plus any existing dependency-network or parallel-scheduling guide.

## Review and maintain

At each planning session, check the plans in scope for currency. Follow the monthly portfolio-wide cadence in [portfolio-review.md](portfolio-review.md), including when no last-review date is known.

Verify claims against current code and tests before editing. Reconcile all affected surfaces in one change:

- metadata and status;
- current and implementation evidence;
- remaining phases and prerequisites;
- validation and acceptance criteria;
- directory and portfolio indexes;
- dependency-network edges, when the repository maintains them;
- parallel lanes and integration locks, when the repository maintains them.

Prune aggressively. Remove completed sections, phases, tasks, obsolete alternatives, satisfied prerequisites, and stale risk text. Do not retain `done` phases or checked task lists. Condense a completed fact into current evidence only when it still constrains remaining work. Preserve the stable IDs of unfinished phases even when earlier IDs disappear.

## Execute and hand off

Before starting a phase, recheck its prerequisites, exact write set, primary lock, and current code evidence. Mark only that phase `in-progress` and set the executable plan's status to `in-progress`. At completion, run focused validation, preserve durable implementation knowledge, remove the phase from the plan, and update the next phase to `ready` when its prerequisites are satisfied. If no remaining phase is `in-progress`, clear the plan's `in-progress` status; use `planned` for remaining queued work or `waiting-on-validation` when validation is genuinely pending.

If work stops incomplete, keep the phase and record a concise handoff with the verified state, changed files, commands run, failures, and exact next action. Do not claim completion.

## Retire

When no work remains, move durable material to code, tests, documentation, architecture records, or release history. Delete the plan entrypoint and its plan-specific sibling documents and `_assets` when no longer needed, and remove every index, dependency-network, and parallel-lane reference in the same change. Recalculate any maintained portfolio count and ranking rather than retaining a completed stub.
