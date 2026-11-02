# Portfolio review

## Currency cadence

At the start of each `.wiki` planning session, check the selected plans and their affected dependencies against current evidence. While planning work is active, review the entire portfolio at least once per calendar month. If the most recent portfolio review date is missing or unknown, run the full review now. Also run it after substantial repository changes that may satisfy several plans. Record the review date, evidence scope, and unresolved blockers concisely in the root portfolio index. A review date alone does not establish that a plan is current; verify the underlying evidence.

## Evidence pass

1. Record `git status`, current commit, and recent commits that overlap active plans.
2. Use any code-index or navigation tool required by the repository before falling back to text search.
3. Compare every plan's current evidence, status, remaining work, validation, and acceptance criteria with the tree.
4. Remove completed plans and prune completed sections, phases, tasks, dependencies, and risks.
5. Do not turn adjacent file changes into plan progress unless the required behavior and tests landed.

## Portfolio pass

- Derive the executable count from `execution: phased`; never hard-code it in tooling.
- Keep coordination records only when they organize multiple executable plans without duplicating their work.
- Rank by impact, remaining difficulty, value, readiness, and evidence quality.
- Ensure the dependency network names only genuine blockers and the parallel guide assigns one primary lock per ready phase.
- Keep blocked external validation separate from implementation-ready work.

## Completion pass

Delete a plan as soon as its acceptance criteria are satisfied and durable evidence exists. Remove its nearest-index, root-index, network, and lane references in the same change. Recalculate any maintained ranks and counts. Completed plan text, checked boxes, and phase logs do not remain in `.wiki`.
