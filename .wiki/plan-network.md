# Plan network

- [Windows setup](windows-setup.md): WIN-02 awaits access to `shell.jasonwohlgemuth.me` and an isolated Windows host.
- [Published shell bootstrap](published-bootstrap.md): PUB-02 awaits access to `shell.jasonwohlgemuth.me`.
- [Installer platforms](installer-platforms.md): PLT-01 → PLT-02 and PLT-03 so guards match the documented support matrix.
- [Neovim reproducibility](neovim-reproducibility.md): NVP-01 → NVP-02 → NVP-03 so each tested plugin group builds on the prior one.
- [Verified bootstrap](verified-bootstrap.md): SEC-03 → SEC-09 → SEC-10 → SEC-04 → SEC-11 → SEC-12 for sequential edits to `gold/install_wasm_tools`; the single-installer phases are independent.
- [Validation gates](validation-gates.md): VAL-02 can invoke the finished `make check` target.
- [Waza workflow](waza-skill-workflow.md): WAZ-01, WAZ-03, and WAZ-04 await authenticated model trials; WAZ-02 awaits a hosted CI run covering all six installed skills.
- [Rust guidelines](guidelines-rust-skill.md): GDR-02 awaits an authenticated model trial.
- [Rust sorting](sort-rust-skill.md): SOR-02 awaits an authenticated model trial.
- [Pikchr diagrams](pikchr-diagram-skill.md): PIK-02 awaits an authenticated model trial; the generated diagram then needs visual acceptance.
- [Agents package distribution](agent-skills-web-distribution.md): ASD-01 builds the ZIPs and OpenCode HTTP catalog and enables ASD-02 and ASD-05; ASD-05 enables ASD-03, ASD-03 enables ASD-04, and ASD-04 enables ASD-06. ASD-02 and ASD-05 both edit the builder, so integrate them sequentially. Publishing ASD-06 also requires GitHub release immutability enabled. Imported skills are discovered automatically and are not semantic prerequisites.
- [Prusti PATH](prusti-path.md), [Nushell history](nushell-history.md), [extension installation](extension-install.md), and [installer repeatability](installer-repeatability.md) have no semantic prerequisite on another plan.

Shared-file work in `gold/install_conda`, `gold/install_java`, `gold/install_homebrew`, `gold/install_cuda_toolkit`, and `gold/install_wasm_tools` needs sequential integration even where phases have no semantic dependency. See [parallel execution](parallel-execution.md) for their primary locks.
