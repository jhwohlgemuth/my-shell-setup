# Parallel execution

| Ready phase | Primary integration lock | Parallel with |
| --- | --- | --- |
| [MID-01](midas-cli.md) | Gold Rust CLI source and interface | All local-only phases |
| [SEC-01](verified-bootstrap.md) | Base bootstrap installers | SEC-02, COR-01, VAL-01, PSH-01, PRU-01, NUH-01, EXT-01 |
| [SEC-02](verified-bootstrap.md) | Language and shell bootstrap installers | SEC-01 and unrelated phases |
| [SEC-03](verified-bootstrap.md) | `gold/install_wasm_tools` | All phases except SEC-04 |
| [SEC-05](verified-bootstrap.md) | `gold/install_conda` | All unrelated phases |
| [COR-01](correctness-choices.md) | `gold/install_correctness_tools` | All unrelated phases |
| [VAL-01](validation-gates.md) | Makefile validation interface | All unrelated phases |
| [PSH-01](powershell-profile.md) | PowerShell startup profile | All unrelated phases |
| [PRU-01](prusti-path.md) | `gold/install_prusti` | All unrelated phases |
| [NUH-01](nushell-history.md) | Nushell history configuration | All unrelated phases |
| [EXT-01](extension-install.md) | `gold/install_extensions` | All unrelated phases |

Start MID-02 after MID-01, MID-03 after MID-02, SEC-04 after SEC-03, and VAL-02 after VAL-01.
