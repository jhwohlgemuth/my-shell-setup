# Plan network

- [verified-bootstrap.md](verified-bootstrap.md): SEC-01, SEC-02, and SEC-05 are independent; SEC-03 → SEC-04 because both edit `gold/install_wasm_tools`.
- [validation-gates.md](validation-gates.md): VAL-01 → VAL-02 so CI invokes the final nonmutating check target.
- [correctness-choices.md](correctness-choices.md), [powershell-profile.md](powershell-profile.md), [prusti-path.md](prusti-path.md), [nushell-history.md](nushell-history.md), and [extension-install.md](extension-install.md) have no prerequisite on another plan.

The plans can merge independently except for the phase edges above.
