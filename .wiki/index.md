# Improvement plans

This portfolio contains 14 executable plans, ranked by impact, readiness, and remaining difficulty. Ready local work precedes phases awaiting hosted access or model validation.

| Priority | Plan | Impact | Difficulty | Next phase |
| --- | --- | --- | --- | --- |
| 1 | [Make installer platform support explicit](installer-platforms.md) | High | Medium | PLT-02 and PLT-03; serialize PLT-02 with SEC-05 |
| 2 | [Verify remote bootstrap scripts](verified-bootstrap.md) | High | Medium | SEC-01 |
| 3 | [Repair Prusti PATH setup](prusti-path.md) | Medium | Low | PRU-01 |
| 4 | [Make Nushell history portable](nushell-history.md) | Medium | Low | NUH-01 |
| 5 | [Publish agents package skills](agent-skills-web-distribution.md) | Medium | Medium | ASD-01 for OpenCode and Codex artifacts |
| 6 | [Flatten extension installation](extension-install.md) | Medium | Medium | EXT-01 |
| 7 | [Make Neovim plugin setup reproducible](neovim-reproducibility.md) | Medium | Medium | NVP-01 |
| 8 | [Add reliable validation gates](validation-gates.md) | High | Low | VAL-02 awaits its first hosted workflow run |
| 9 | [Make Windows setup executable](windows-setup.md) | High | Medium | WIN-02 awaits hosted publication and Windows validation |
| 10 | [Validate Waza skill improvement](waza-skill-workflow.md) | High | Medium | WAZ-01, WAZ-03, and WAZ-04 await model access; WAZ-02 awaits hosted CI |
| 11 | [Validate Rust guidelines](guidelines-rust-skill.md) | Medium | Medium | GDR-02 awaits model access |
| 12 | [Validate Rust sorting](sort-rust-skill.md) | Medium | Medium | SOR-02 awaits model access |
| 13 | [Validate Pikchr diagrams](pikchr-diagram-skill.md) | Medium | Medium | PIK-02 awaits model access |
| 14 | [Track the published shell bootstrap](published-bootstrap.md) | Medium | Medium | PUB-02 awaits hosted publication |

See [plan network](plan-network.md) for prerequisites and [parallel execution](parallel-execution.md) for integration locks. Published bootstrap verification requires access to `shell.jasonwohlgemuth.me`; local implementation phases remain ready.

## Portfolio currency review

- 2026-11-01 — VAL-02 added a root `make check` workflow for pull requests and pushes to `main`; local workflow, tool-provisioning, and gate validation pass, while the first hosted run awaits commit and push. PLT-01 documented all 39 Gold installers and all 16 WASM choices, then retired. PLT-02 and PLT-03 are ready alongside the independent SEC phases; PLT-02 and SEC-05 must serialize their shared `gold/install_conda` edit.
- 2026-11-01 — Reviewed all 17 plans against `7218998`, the current worktree, and the selected phase checks. PowerShell startup is safe in a clean session and its only phase was retired. The nonmutating `make check` gate passes and rejects an invalid early Gold script; general hosted CI remains VAL-02. New repository-local Windows and shell bootstraps passed focused mocked tests and the integrated gate; their hosted publication phases remain blocked. Sixteen executable plans remain. Authenticated model validation is another external prerequisite.
- 2026-11-01 — COR-01 was verified against `44a9ae7` plus the current worktree and retired: the correctness menu no longer offers Lean, every remaining choice maps to an executable repository installer, and mocked Rocq selection invokes `install_rocq`. Fifteen executable plans remain; the earlier portfolio-wide blockers are unchanged.
- 2026-11-01 — REP-01 through REP-04 were verified against `fcfb584` plus the current worktree and retired. Temporary-home double runs cover every affected profile writer, representative Java cache cleanup preserves non-cache SDKMAN content, and `make check-gold` passes. Fourteen executable plans remain; the earlier portfolio-wide blockers are unchanged.
