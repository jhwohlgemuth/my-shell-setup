# Plan network

- [Windows setup](windows-setup.md): WIN-02 awaits access to `shell.jasonwohlgemuth.me` and an isolated Windows host.
- [Published shell bootstrap](published-bootstrap.md): PUB-02 awaits access to `shell.jasonwohlgemuth.me`.
- [Neovim reproducibility](neovim-reproducibility.md): NVP-02 → NVP-03 so each tested plugin group builds on the prior one.
- [Verified bootstrap](verified-bootstrap.md): SEC-10 → SEC-04 → SEC-11 → SEC-12 for sequential edits to `gold/install_wasm_tools`.
- [Waza workflow](waza-skill-workflow.md): WAZ-01, WAZ-03, and WAZ-04 await authenticated model trials; WAZ-02 awaits a hosted CI run covering all six installed skills.
- [Rust guidelines](guidelines-rust-skill.md): GDR-02 awaits an authenticated model trial.
- [Rust sorting](sort-rust-skill.md): SOR-02 awaits an authenticated model trial.
- [Pikchr diagrams](pikchr-diagram-skill.md): PIK-02 awaits an authenticated model trial; the generated diagram then needs visual acceptance.
- [Agents package distribution](agent-skills-web-distribution.md): ASD-05 is ready and enables ASD-03; ASD-02 separately awaits Pages configuration. ASD-02 and ASD-05 both edit the builder, so integrate them sequentially. ASD-03 enables ASD-04, and ASD-04 enables ASD-06; publishing ASD-06 also requires GitHub release immutability enabled. Imported skills are discovered automatically and are not semantic prerequisites.

See [parallel execution](parallel-execution.md) for the ready phases' primary locks.
