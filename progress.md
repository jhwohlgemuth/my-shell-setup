# Implementation progress

## Implementation — correctness-tool menu

- Plan: `.wiki/correctness-choices.md`; active phase: none; state: complete and plan retired.
- Authorized scope and decisions: Execute COR-01 only; remove Lean until an installer exists and route Rocq to the existing `install_rocq` command.
- Baseline and local work: `44a9ae7` on `main`; the worktree was clean before implementation. Changed `gold/install_correctness_tools` and reconciled the completed plan's wiki references.
- Verified state: `bash -n`, shfmt diff, and ShellCheck with all checks enabled passed. A mocked Gum run verified that Lean is absent from the chooser and selecting Rocq calls `install_rocq`. A static audit verified all ten displayed choices map to executable `gold/install_*` commands. These checks used the current uncommitted worktree.
- Remaining work: None within COR-01.
- Budget: Completed in under one active hour (estimate), within the five-hour phase ceiling.
- Blockers / failed approaches: None.
- Next action: Review and commit the completed phase.

## Implementation — startup and bootstrap

- Plans: PSH-01 complete and retired; VAL-01, WIN-01, and PUB-01 complete. VAL-02 remains ready; WIN-02 and PUB-02 await hosted publication and verification.
- Authorized scope: Make PowerShell startup safe, add a nonmutating local validation gate, and add the Windows and Linux/macOS bootstrap sources. Hosted publication phases are outside this request.
- Baseline: `7218998` on `main`; worktree was clean before implementation.
- Verified state: The PowerShell profile parsed and loaded with optional commands hidden and no Prelude; a mocked McFly initialized exactly once and a policy-changing `Set-PSRepository` mock was never called. `make check` passed Bash syntax, shfmt, ShellCheck, Nushell load, PowerShell parse, agent Stow inventory (15 links), and all-package Stow simulation after both bootstrap sources were added; the tracked diff SHA-256 was unchanged across the final run. An invalid first Gold script made `make check-gold` exit 2. Temporary-home mocked Git/Stow tests passed for shell default, selected, comma-separated, invalid, rerun, wrong-origin, and wrong-branch cases. Temporary-home PowerShell tests passed both README invocation forms, default and selected packages, invalid input, `-WhatIf`, failed updates, wrong origin/branch, dirty copier, and missing Git. An actual-checkout Windows `-WhatIf` also passed without writes. Planning wiki validation passed. These checks used the current uncommitted worktree.
- Remaining work: None within the authorized local phases. VAL-02, WIN-02, and PUB-02 remain separate hosted phases; native Windows installation and hosted bytes have not been verified.
- Budget: All four authorized phases finished within their separate five-hour ceilings.
- Next action: After reviewing and committing this work, run VAL-02 in hosted CI and publish/verify the two bootstrap routes when deployment access is available.

## Implementation — Waza skill workflow

- Plan: `.wiki/waza-skill-workflow.md`; active phases: WAZ-01 through WAZ-04 plus GDR-02, SOR-02, and PIK-02; state: blocked on external validation.
- Authorized scope: Rename the copied Rust skills and reapply the Waza workflow to all five copied skills; keep model runs opt-in.
- Baseline: `fece2f4`; the user copied `guidelines`, `sort`, `pikchr-diagram`, `rust-best-practices`, and `rust-review` into `agents/.agents/skills/` as untracked sources.
- Verified state: The five imported skills use their complete Acorn source as the baseline. `guidelines-rust` and `sort-rust` differ only in metadata `name`; the other three entrypoints and runtime assets match Acorn. Waza mock, outcome/boundary, and routing suites remain beside the sources. The saved capability snapshot records 42 unchanged original sections; nine have linked behavioral Waza tasks and none has a saved real-agent result. `make -C agents ci WAZA=/tmp/my-shell-setup-waza`, the exhaustive `make -C agents stow-check` (15 intended runtime links), 13 tooling tests, wiki validation, and `git diff --check` passed. The Stow fixture confirms package-level scripts and evaluation files are excluded while skill-local scripts and references remain installed. A temporary manifest with one removed behavior mapping produced a `-1` report delta and strict exit 1. The report also rejects mock or stale results and flags unreviewed source changes and comparable pass-rate regressions. Waza reports the long original entrypoints above its preferred token budget; this advisory does not justify rewriting them. With `COPILOT_CLI_PATH=/opt/homebrew/bin/copilot`, `waza models` reported `not authenticated`.
- Remaining work: Run and inspect model-backed trials for all six skills, render and inspect a Pikchr output, and observe the hosted six-skill GitHub Actions gate.
- Budget: The blocked validation phases retain separate five-hour ceilings; active trial time has not started.
- Next action: With authenticated Copilot access and authorized model usage run `COPILOT_CLI_PATH=/path/to/copilot make -C agents assess AGENT_SKILL=guidelines-rust WAZA=/path/to/waza`. Record baseline results before proposing any instruction change.
