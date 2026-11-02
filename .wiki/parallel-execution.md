# Parallel execution

Only ready phases appear below. Give each listed phase its primary integration lock; phases with a shared exact write set must merge sequentially even when their plan outcomes are independent.

The [Waza validation phases](waza-skill-workflow.md), [Rust guidelines](guidelines-rust-skill.md), [Rust sorting](sort-rust-skill.md), and [Pikchr diagram](pikchr-diagram-skill.md) validation phases await authenticated model access or a hosted CI run, so they are outside the ready-phase table.

| Ready phase | Primary integration lock | Shared-file exclusion |
| --- | --- | --- |
| [VAL-02](validation-gates.md) | General CI check workflow | none |
| [ASD-01](agent-skills-web-distribution.md) | Agents package build interface | none |
| [PLT-01](installer-platforms.md) | Gold platform documentation | none |
| [SEC-01](verified-bootstrap.md) | Nix installer | none |
| [SEC-06](verified-bootstrap.md) | Java installer | REP-02 |
| [SEC-02](verified-bootstrap.md) | Homebrew installer | REP-03 |
| [SEC-07](verified-bootstrap.md) | Nim installer | none |
| [SEC-08](verified-bootstrap.md) | Oh My Zsh installer | none |
| [SEC-03](verified-bootstrap.md) | WASM installer menu | REP-04; subsequent SEC menu phases |
| [SEC-05](verified-bootstrap.md) | Conda bootstrap | PLT-02 (`install_conda`) |
| [COR-01](correctness-choices.md) | Correctness-tool menu | none |
| [PRU-01](prusti-path.md) | Prusti installer | none |
| [NUH-01](nushell-history.md) | Nushell history configuration | none |
| [EXT-01](extension-install.md) | Code-server extension flow | none |
| [REP-01](installer-repeatability.md) | .NET Jupyter installer | none |
| [REP-02](installer-repeatability.md) | Java installer cleanup | SEC-06 (`install_java`) |
| [REP-03](installer-repeatability.md) | Single-tool shell initialization | SEC-02 (`install_homebrew`); PLT-03 (`install_cuda_toolkit`) |
| [REP-04](installer-repeatability.md) | WASM installer menu | SEC-03, SEC-09, SEC-10, SEC-04, SEC-11, and SEC-12 |
| [NVP-01](neovim-reproducibility.md) | Neovim plugin bootstrap | none |

After their prerequisites, schedule [WIN-02](windows-setup.md) and [PUB-02](published-bootstrap.md) only when the hosted deployment system is available. Schedule ASD-02 and ASD-05 after ASD-01, serializing their builder edits; ASD-03 after ASD-05, ASD-04 after ASD-03, and ASD-06 after ASD-04 and release immutability is enabled. Schedule PLT-02 and PLT-03 after PLT-01, NVP-02 after NVP-01, NVP-03 after NVP-02, and the SEC menu phases in network order. Run the six skill behavior suites when authenticated model access is available, and run WAZ-02 after the workflow is on a branch with hosted CI. Keep shared-file exclusions above when later phases become ready.
