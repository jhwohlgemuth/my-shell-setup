# Parallel execution

Only ready phases appear below. Give each listed phase its primary integration lock; phases with a shared exact write set must merge sequentially even when their plan outcomes are independent.

The [Waza validation phases](waza-skill-workflow.md), [Rust guidelines](guidelines-rust-skill.md), [Rust sorting](sort-rust-skill.md), and [Pikchr diagram](pikchr-diagram-skill.md) validation phases await authenticated model access or a hosted CI run, so they are outside the ready-phase table.

| Ready phase | Primary integration lock | Shared-file exclusion |
| --- | --- | --- |
| [ASD-05](agent-skills-web-distribution.md) | Generated plugin tree | ASD-02 builder edits |
| [SEC-10](verified-bootstrap.md) | WASM installer menu | subsequent SEC menu phases |
| [NVP-02](neovim-reproducibility.md) | Neovim plugin version set | NVP-03 |

After their prerequisites, schedule [WIN-02](windows-setup.md) and [PUB-02](published-bootstrap.md) only when the hosted deployment system is available. Serialize ASD-02 and ASD-05 builder edits; schedule ASD-03 after ASD-05, ASD-04 after ASD-03, and ASD-06 after ASD-04 and release immutability is enabled. Schedule NVP-03 after NVP-02 and the SEC menu phases in network order. Run the six skill behavior suites when authenticated model access is available, and run WAZ-02 after the workflow is on a branch with hosted CI. Keep shared-file exclusions above when later phases become ready.
