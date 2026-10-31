# Agent skills

This Stow package installs reusable AI agent skills into `~/.agents` while keeping Waza development files in the repository.

The runtime path mapping is:

```text
agents/.agents/skills/<skill>/SKILL.md -> ~/.agents/skills/<skill>/SKILL.md
```

The package-local `.stow-local-ignore` excludes each skill's `evals/` directory and `trigger_tests.yaml` from the target. These files remain beside the skill source so Waza can use its standalone-skill workflow.

The package currently contains `blank-test`, `guidelines-rust`, `sort-rust`, `pikchr-diagram`, `rust-best-practices`, and `rust-review`. The imported Rust practice and review skills also retain their existing non-Waza evaluation fixtures under `evals/`.

Run the repository targets from its root:

```shell
make agents-stow-check
make agents-install
make agents-check
make agents-preflight
make agents-test
make agents-ci
make agents-dev
```

`agents-stow-check` uses a temporary target and verifies every skill without changing `~/.agents`. `agents-check` performs Waza's static and spec coverage checks. `agents-preflight` checks every root suite for valid tasks and the expected executor. `agents-test` runs only `evals/eval.yaml` with the mock executor; it verifies harness wiring, not model behavior. `agents-ci` discovers every skill source with `SKILL.md` and runs all those offline checks. `agents-dev` starts Waza's interactive skill improvement workflow. CI runs `agents-ci` without model credentials.

The Waza targets default to `blank-test`. Select another skill with the `AGENT_SKILL` Make variable:

```shell
make agents-check AGENT_SKILL=my-skill
make agents-preflight AGENT_SKILL=my-skill
make agents-test AGENT_SKILL=my-skill
make agents-dev AGENT_SKILL=my-skill
```

Each copied skill has a mock harness suite, a model-backed outcome and boundary suite, and a model-backed positive and negative routing suite. The canary's `evals/real.yaml` checks the exact `BLANK_TEST_SKILL_OK` output and zero tool calls with the skill body supplied. Its `evals/routing.yaml` withholds the body so positive and negative cases can check actual skill invocation; only the positive case permits the `skill` tool, and neither permits unrelated tools. Model-backed suites are separate from mock suites and never run in CI. To run them deliberately with authenticated GitHub Copilot access and model permission:

```shell
make agents-real AGENT_SKILL=blank-test
```

`agents-real` runs all non-mock root eval suites for the selected skill and prints the temporary results directory. If Waza cannot initialize its embedded Copilot CLI, set `COPILOT_CLI_PATH` to an authenticated compatible CLI, for example `COPILOT_CLI_PATH=/path/to/copilot make agents-real AGENT_SKILL=blank-test`. Check each task's grader results and transcript; a mock pass is never evidence of routing or output quality. Real runs can incur model usage. [Waza's executor guide](https://microsoft.github.io/waza/guides/eval-yaml/) describes the configuration and [authentication prerequisites](https://microsoft.github.io/waza/getting-started/#authenticate-before-real-execution).

For a skill change, capture a focused baseline before editing, make one change, rerun the same task, then run the full real suites. For the canary's exact-output case:

```shell
waza run agents/.agents/skills/blank-test/evals/real.yaml --task blank-test-exact-response-001 --no-cache --output /tmp/blank-test-before.json
# Edit the skill or its grader.
waza run agents/.agents/skills/blank-test/evals/real.yaml --task blank-test-exact-response-001 --no-cache --output /tmp/blank-test-after.json
waza compare /tmp/blank-test-before.json /tmp/blank-test-after.json
make agents-real AGENT_SKILL=blank-test
```

Record the CLI version, model, prompts, observed skill and tool calls, grader outcomes, and any regression. Keep fixtures sanitized and leave real runs opt-in.

Waza 0.39.1 or newer is required so file paths work consistently with `waza dev`. CI pins the 0.39.1 Linux binary and checks its SHA-256 before execution. Follow the [official Waza installation instructions](https://microsoft.github.io/waza/getting-started/#installation), then verify the CLI with `waza --version`. Override `WAZA` when using a locally downloaded binary, for example `make agents-ci WAZA=/path/to/waza`.

To scaffold another standalone skill in this package:

```shell
waza new skill my-skill --output-dir agents/.agents/skills
```

Review the generated skill and eval files before running the checks. The Stow ignore list keeps Waza's `evals/`, `tests/`, root trigger fixtures, workflow metadata, and README files out of `~/.agents`; runtime assets such as `scripts/`, `references/`, and `assets/` remain part of the installed skill.

To remove only links owned by this package:

```shell
make agents-remove
```
