# Parallel execution

Only ready phases appear below. Give each listed phase its primary integration lock; phases with a shared exact write set must merge sequentially even when their plan outcomes are independent.

| Ready phase | Primary integration lock | Shared-file exclusion |
| --- | --- | --- |
| [PSH-01](powershell-profile.md) | PowerShell startup profile | none |
| [VAL-01](validation-gates.md) | Makefile validation interface | WAZ-01, ASD-01 (`Makefile`) |
| [WAZ-01](waza-skill-workflow.md) | Waza runner interface | GDR-01, SOR-01, PIK-01, ASD-01 (`agents/README.md`); VAL-01, ASD-01 (`Makefile`) |
| [GDR-01](guidelines-rust-skill.md) | Rust guidelines skill body | WAZ-01, SOR-01, PIK-01, ASD-01 (`agents/README.md`) |
| [SOR-01](sort-rust-skill.md) | Rust sorting skill body | WAZ-01, GDR-01, PIK-01, ASD-01 (`agents/README.md`) |
| [PIK-01](pikchr-diagram-skill.md) | Pikchr skill package | WAZ-01, GDR-01, SOR-01, ASD-01 (`agents/README.md`) |
| [ASD-01](agent-skills-web-distribution.md) | Agents package build interface | VAL-01, WAZ-01 (`Makefile`); WAZ-01, GDR-01, SOR-01, PIK-01 (`agents/README.md`) |
| [WIN-01](windows-setup.md) | Windows bootstrap interface | none |
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
| [PUB-01](published-bootstrap.md) | Shell quick-start interface | none |
| [NVP-01](neovim-reproducibility.md) | Neovim plugin bootstrap | none |

After their prerequisites, schedule WIN-02 and PUB-02 only when the hosted deployment system is available. Schedule VAL-02 after VAL-01; ASD-02 and ASD-05 after ASD-01, serializing their builder edits; ASD-03 after ASD-05, ASD-04 after ASD-03, and ASD-06 after ASD-04 and release immutability is enabled. Schedule PLT-02 and PLT-03 after PLT-01, NVP-02 after NVP-01, NVP-03 after NVP-02, and the SEC menu phases in network order. Run each skill's evaluation phase after its import and WAZ-01; run WAZ-02 after all three imported-skill evaluation phases. Keep shared-file exclusions above when later phases become ready.
