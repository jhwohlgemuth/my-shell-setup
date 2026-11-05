# Parallel execution

The canary and four of the five remaining model-backed validations passed. GDR-02 is blocked on a reviewed routing proposal; phases with a shared exact write set must still merge sequentially.

| Phase | State | Primary integration lock | Shared-file exclusion |
| --- | --- | --- | --- |
| [GDR-02](guidelines-rust-skill.md) | blocked pending reviewed proposal | Rust guidelines evaluation | none |

After these active validations complete, schedule [WIN-02](windows-setup.md) and [PUB-02](published-bootstrap.md) only when the hosted deployment system is available. [ASD-03](agent-skills-web-distribution.md) first needs a writable clean Codex profile, GitHub access, and an authenticated new-session `blank-test` invocation; schedule ASD-04 after that validation, and ASD-06 after ASD-04 and release immutability is enabled. ASD-02 remains separate until Pages is configured.
