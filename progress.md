# Implementation progress

## Implementation — Waza skill workflow

- Plan: `.wiki/waza-skill-workflow.md`; active phases: WAZ-01 through WAZ-04 plus GDR-02, SOR-02, and PIK-02; state: blocked on external validation.
- Authorized scope: Rename the copied Rust skills and reapply the Waza workflow to all five copied skills; keep model runs opt-in.
- Baseline: `fece2f4`; the user copied `guidelines`, `sort`, `pikchr-diagram`, `rust-best-practices`, and `rust-review` into `agents/.agents/skills/` as untracked sources.
- Verified state: `guidelines-rust` and `sort-rust` are renamed and scoped; all six installed skills have Waza mock, outcome/boundary, and routing suites. Waza 0.39.1 `make agents-ci WAZA=/tmp/my-shell-setup-waza` passed static checks, complete deterministic spec coverage, preflight of all 18 root suites, and all mock tasks. `make agents-stow-check` passed for all six. The earlier deliberately broken mock fixture made the aggregate gate fail. `mdbook` with `mdbook-pikchr` rendered the bundled Pikchr source in `/tmp/my-shell-setup-pikchr.OZ8ol3`; its SVG was extracted and inspected. With `COPILOT_CLI_PATH=/opt/homebrew/bin/copilot`, `waza models` reported `not authenticated`.
- Remaining work: Run and inspect model-backed trials for all six skills, render and inspect a Pikchr output, and observe the hosted six-skill GitHub Actions gate.
- Budget: The blocked validation phases retain separate five-hour ceilings; active trial time has not started.
- Next action: With authenticated Copilot access and authorized model usage, run `COPILOT_CLI_PATH=/path/to/copilot make agents-real AGENT_SKILL=guidelines-rust WAZA=/path/to/waza`, inspect its graders and transcript, then continue one skill at a time.
