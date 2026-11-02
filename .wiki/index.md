# Improvement plans

This portfolio contains 15 executable plans, ranked by impact, readiness, and remaining difficulty. Ready local work precedes phases awaiting hosted access or model validation.

| Priority | Plan | Impact | Difficulty | Next phase |
| --- | --- | --- | --- | --- |
| 1 | [Add reliable validation gates](validation-gates.md) | High | Low | VAL-02 |
| 2 | [Make installer platform support explicit](installer-platforms.md) | High | Medium | PLT-01 |
| 3 | [Verify remote bootstrap scripts](verified-bootstrap.md) | High | Medium | SEC-01 |
| 4 | [Repair Prusti PATH setup](prusti-path.md) | Medium | Low | PRU-01 |
| 5 | [Make Nushell history portable](nushell-history.md) | Medium | Low | NUH-01 |
| 6 | [Publish agents package skills](agent-skills-web-distribution.md) | Medium | Medium | ASD-01 for OpenCode and Codex artifacts |
| 7 | [Flatten extension installation](extension-install.md) | Medium | Medium | EXT-01 |
| 8 | [Make installer reruns predictable](installer-repeatability.md) | Medium | Medium | REP-01 |
| 9 | [Make Neovim plugin setup reproducible](neovim-reproducibility.md) | Medium | Medium | NVP-01 |
| 10 | [Make Windows setup executable](windows-setup.md) | High | Medium | WIN-02 awaits hosted publication and Windows validation |
| 11 | [Validate Waza skill improvement](waza-skill-workflow.md) | High | Medium | WAZ-01, WAZ-03, and WAZ-04 await model access; WAZ-02 awaits hosted CI |
| 12 | [Validate Rust guidelines](guidelines-rust-skill.md) | Medium | Medium | GDR-02 awaits model access |
| 13 | [Validate Rust sorting](sort-rust-skill.md) | Medium | Medium | SOR-02 awaits model access |
| 14 | [Validate Pikchr diagrams](pikchr-diagram-skill.md) | Medium | Medium | PIK-02 awaits model access |
| 15 | [Track the published shell bootstrap](published-bootstrap.md) | Medium | Medium | PUB-02 awaits hosted publication |

See [plan network](plan-network.md) for prerequisites and [parallel execution](parallel-execution.md) for integration locks. Published bootstrap verification requires access to `shell.jasonwohlgemuth.me`; local implementation phases remain ready.

## Portfolio currency review

- 2026-11-01 — Reviewed all 17 plans against `7218998`, the current worktree, and the selected phase checks. PowerShell startup is safe in a clean session and its only phase was retired. The nonmutating `make check` gate passes and rejects an invalid early Gold script; general hosted CI remains VAL-02. New repository-local Windows and shell bootstraps passed focused mocked tests and the integrated gate; their hosted publication phases remain blocked. Sixteen executable plans remain. Authenticated model validation is another external prerequisite.
- 2026-11-01 — COR-01 was verified against `44a9ae7` plus the current worktree and retired: the correctness menu no longer offers Lean, every remaining choice maps to an executable repository installer, and mocked Rocq selection invokes `install_rocq`. Fifteen executable plans remain; the earlier portfolio-wide blockers are unchanged.
