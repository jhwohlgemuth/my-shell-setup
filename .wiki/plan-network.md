# Plan network

- [Windows setup](windows-setup.md): WIN-01 → WIN-02. Publishing also requires access to `shell.jasonwohlgemuth.me`.
- [Published shell bootstrap](published-bootstrap.md): PUB-01 → PUB-02. Publishing also requires access to `shell.jasonwohlgemuth.me`.
- [Installer platforms](installer-platforms.md): PLT-01 → PLT-02 and PLT-03 so guards match the documented support matrix.
- [Neovim reproducibility](neovim-reproducibility.md): NVP-01 → NVP-02 → NVP-03 so each tested plugin group builds on the prior one.
- [Verified bootstrap](verified-bootstrap.md): SEC-03 → SEC-09 → SEC-10 → SEC-04 → SEC-11 → SEC-12 for sequential edits to `gold/install_wasm_tools`; the single-installer phases are independent.
- [Validation gates](validation-gates.md): VAL-01 → VAL-02 so CI invokes the finished check target.
- [Waza workflow](waza-skill-workflow.md): WAZ-01 enables the real-agent test interface; WAZ-02 follows GDR-02, SOR-02, and PIK-02 so CI covers all installed skills.
- [Rust guidelines](guidelines-rust-skill.md): GDR-01 → GDR-02; the evaluation phase also requires WAZ-01.
- [Rust sorting](sort-rust-skill.md): SOR-01 → SOR-02; the evaluation phase also requires WAZ-01.
- [Pikchr diagrams](pikchr-diagram-skill.md): PIK-01 → PIK-02; the evaluation phase also requires WAZ-01.
- [Agents package distribution](agent-skills-web-distribution.md): ASD-01 builds the ZIPs and OpenCode HTTP catalog and enables ASD-02 and ASD-05; ASD-05 enables ASD-03, ASD-03 enables ASD-04, and ASD-04 enables ASD-06. ASD-02 and ASD-05 both edit the builder, so integrate them sequentially. Publishing ASD-06 also requires GitHub release immutability enabled. Imported skills are discovered automatically and are not semantic prerequisites.
- [PowerShell profile](powershell-profile.md), [correctness choices](correctness-choices.md), [Prusti PATH](prusti-path.md), [Nushell history](nushell-history.md), [extension installation](extension-install.md), and [installer repeatability](installer-repeatability.md) have no semantic prerequisite on another plan.

Shared-file work in `gold/install_conda`, `gold/install_java`, `gold/install_homebrew`, `gold/install_cuda_toolkit`, and `gold/install_wasm_tools` needs sequential integration even where phases have no semantic dependency. See [parallel execution](parallel-execution.md) for their primary locks.

WAZ-01, GDR-01, SOR-01, PIK-01, and ASD-01 all update `agents/README.md`; merge them sequentially. ASD-01 also shares the Makefile with VAL-01 and WAZ-01, while WAZ-02 later updates both files, so those changes require sequential integration.
