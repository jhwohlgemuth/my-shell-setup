# Parallel execution

Only ready phases appear below. Give each listed phase its primary integration lock; phases with a shared exact write set must merge sequentially even when their plan outcomes are independent.

The [Waza validation phases](waza-skill-workflow.md), [Rust guidelines](guidelines-rust-skill.md), [Rust sorting](sort-rust-skill.md), and [Pikchr diagram](pikchr-diagram-skill.md) validation phases await authenticated model access or a hosted CI run, so they are outside the ready-phase table.

| Ready phase | Primary integration lock | Shared-file exclusion |
| --- | --- | --- |
| [SEC-11](verified-bootstrap.md) | WASM installer menu | SEC-12 |

After their prerequisites, schedule [WIN-02](windows-setup.md) and [PUB-02](published-bootstrap.md) only when the hosted deployment system is available. [ASD-03](agent-skills-web-distribution.md) first needs a writable clean Codex profile, GitHub access, and an authenticated new-session `blank-test` invocation; schedule ASD-04 after that validation, and ASD-06 after ASD-04 and release immutability is enabled. ASD-02 remains separate until Pages is configured. Schedule the SEC menu phases in network order. Run the six skill behavior suites when authenticated model access is available, and reconcile WAZ-02 against the successful hosted run. Keep shared-file exclusions above when later phases become ready.
