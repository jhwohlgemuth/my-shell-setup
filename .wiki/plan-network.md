# Plan network

- [midas-cli.md](midas-cli.md): MID-01 → MID-02 → MID-03. Gold must install the replacement before this repository removes the shell command.
- [verified-bootstrap.md](verified-bootstrap.md): SEC-01, SEC-02, and SEC-05 are independent; SEC-03 → SEC-04 because both edit `gold/install_wasm_tools`.
- [validation-gates.md](validation-gates.md): VAL-01 → VAL-02 so CI invokes the final nonmutating check target.
- [correctness-choices.md](correctness-choices.md), [powershell-profile.md](powershell-profile.md), [prusti-path.md](prusti-path.md), [nushell-history.md](nushell-history.md), and [extension-install.md](extension-install.md) have no prerequisite on another plan.

The plans can merge independently except for the phase edges above.
