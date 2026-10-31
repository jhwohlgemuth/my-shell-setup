# Improvement plans

This portfolio contains 17 executable plans, ordered by impact and remaining difficulty. The skill plans cover model-backed validation of five copied skills, the agents package distribution path, and the Waza evaluation workflow. The extension downloader and broad temporary-directory cleanup were repaired earlier and are not active plans.

| Priority | Plan | Impact | Difficulty | Next phase |
| --- | --- | --- | --- | --- |
| 1 | [Make PowerShell startup safe](powershell-profile.md) | High | Low | PSH-01 |
| 2 | [Add reliable validation gates](validation-gates.md) | High | Low | VAL-01 |
| 3 | [Make Windows setup executable](windows-setup.md) | High | Medium | WIN-01 |
| 4 | [Make installer platform support explicit](installer-platforms.md) | High | Medium | PLT-01 |
| 5 | [Verify remote bootstrap scripts](verified-bootstrap.md) | High | Medium | SEC-01 |
| 6 | [Validate Waza skill improvement](waza-skill-workflow.md) | High | Medium | WAZ-01, WAZ-03, and WAZ-04 await model access; WAZ-02 awaits hosted CI |
| 7 | [Repair correctness installer choices](correctness-choices.md) | Medium | Low | COR-01 |
| 8 | [Repair Prusti PATH setup](prusti-path.md) | Medium | Low | PRU-01 |
| 9 | [Make Nushell history portable](nushell-history.md) | Medium | Low | NUH-01 |
| 10 | [Validate Rust guidelines](guidelines-rust-skill.md) | Medium | Medium | GDR-02 awaits model access |
| 11 | [Validate Rust sorting](sort-rust-skill.md) | Medium | Medium | SOR-02 awaits model access |
| 12 | [Validate Pikchr diagrams](pikchr-diagram-skill.md) | Medium | Medium | PIK-02 awaits model access |
| 13 | [Publish agents package skills](agent-skills-web-distribution.md) | Medium | Medium | ASD-01 for OpenCode and Codex artifacts |
| 14 | [Flatten extension installation](extension-install.md) | Medium | Medium | EXT-01 |
| 15 | [Make installer reruns predictable](installer-repeatability.md) | Medium | Medium | REP-01 |
| 16 | [Track the published shell bootstrap](published-bootstrap.md) | Medium | Medium | PUB-01 |
| 17 | [Make Neovim plugin setup reproducible](neovim-reproducibility.md) | Medium | Medium | NVP-01 |

See [plan network](plan-network.md) for prerequisites and [parallel execution](parallel-execution.md) for integration locks. Published bootstrap verification requires access to `shell.jasonwohlgemuth.me`; local implementation phases remain ready.

## Portfolio currency review

- 2026-10-30 — Reviewed all 17 existing executable plans at `6792cb3` against their current evidence, target paths, recent repository history, and the uncommitted portfolio additions. No acceptance criterion or complete phase was established by current source changes, so no plan was pruned. External publication and host prerequisites remain explicit. Added the agents-package distribution plan after inspecting the Stow layout, Waza exclusions, existing skill/import plans, and absent Pages, plugin, marketplace, and release infrastructure; 18 executable outcomes remain.
- 2026-10-30 — Extended ASD-01 and ASD-02 after verifying OpenCode v2's native HTTP catalog contract: a base URL serving `index.json`, safe same-origin files, and a changed version for cache refresh. Existing phase readiness, shared-file exclusions, and external Pages prerequisites are unchanged.
- 2026-10-30 — Removed the repository-local planning skill and its unfinished improvement plan because planning will be maintained in the separate `okf-plan-browser` project. Removed its Waza prerequisite; 17 executable plans remain.
- 2026-10-30 — Implemented the Waza canary suites and dynamic offline CI gate. Local Waza 0.39.1 checks and a deliberately broken mock fixture confirmed the gate behavior. Real-agent validation, the three imported skill suites, and a hosted CI run remain outstanding.
- 2026-10-30 — Added Waza suites to five copied skills. The first pass shortened their entrypoints; that change was later reversed at the user's request.
- 2026-10-31 — Restored all five copied skills from the Acorn source as the official baseline, changing only the two requested metadata names. Reconciled Waza fixtures and plans with those originals. Model-backed trials and hosted CI remain outstanding.
- 2026-10-31 — Added an Acorn-section capability baseline and Waza-linked coverage report. Offline CI now reports source retention and behavior-test mapping deltas; model-backed result comparison remains unavailable until authenticated trials are saved.
