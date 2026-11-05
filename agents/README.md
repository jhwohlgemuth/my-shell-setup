# Agent skills

This Stow package installs reusable AI agent skills into `~/.agents` while keeping Waza development files in the repository.

The Make targets use the root `mise.toml` for their Python, jq, and Waza commands. Install the toolchain as described in the [root README](../README.md#optional-developer-tools-with-mise) before running them.

The runtime path mapping is:

```text
agents/.agents/skills/<skill>/SKILL.md -> ~/.agents/skills/<skill>/SKILL.md
```

The package-local `.stow-local-ignore` excludes each skill's `evals/` and `tests/` directories and `trigger_tests.yaml`, plus the package-level Makefile, coverage manifest, and scripts, from the target. These files remain beside the skill source so Waza can use its standalone-skill workflow.

The package currently contains `blank-test`, `guidelines-rust`, `sort-rust`, `pikchr-diagram`, `rust-best-practices`, and `rust-review`. The imported Rust practice and review skills also retain their existing non-Waza evaluation fixtures under `evals/`.

The five imported skills use their full Acorn source as the official starting point. Only the metadata names of `guidelines-rust` and `sort-rust` differ from Acorn. Waza's token and readiness scores are advisory; preserve the source instructions while collecting behavioral evidence and review any proposed instruction change against that baseline.

Run the package targets from the repository root (or `cd agents` and omit `-C agents`):

```shell
make -C agents help
make -C agents stow-check
make -C agents install
make -C agents check
make -C agents preflight
make -C agents test
make -C agents ci
make -C agents coverage
make -C agents assess AGENT_SKILL=guidelines-rust
make -C agents dev
make check-agent-skills
```

`stow-check` uses a temporary target and compares every installed path with the expected runtime inventory without changing `~/.agents`. It catches leaked development files and missing references or scripts; `install` runs it before installation. `check` performs Waza's static and spec coverage checks. `preflight` checks every root suite for valid tasks and the expected executor. `test` runs only `evals/eval.yaml` with the mock executor; it verifies harness wiring, not model behavior. `ci` discovers every skill source with `SKILL.md` and runs all those offline checks. `dev` starts Waza's interactive skill improvement workflow. CI runs `ci`, the Stow inventory check, and the tooling tests without model credentials.

The Waza targets default to `blank-test`. Select another skill with the `AGENT_SKILL` Make variable:

```shell
make -C agents check AGENT_SKILL=my-skill
make -C agents preflight AGENT_SKILL=my-skill
make -C agents test AGENT_SKILL=my-skill
make -C agents dev AGENT_SKILL=my-skill
```

## Build distributable runtime skills

The standard-library packager discovers every immediate child of `agents/.agents/skills/` that contains `SKILL.md`. It applies the package's Stow exclusions so evaluation fixtures stay private while runtime `agents/`, `assets/`, `references/`, and `scripts/` remain available. The source skill directories are never modified.

Choose a new or empty output directory and run the root Make target:

```shell
output="$(mktemp -d /tmp/my-shell-setup-agent-skills.XXXXXX)"
make package-agent-skills AGENT_SKILLS_OUTPUT="${output}"
```

The output contains:

- `index.json`, an OpenCode v2 HTTP catalog;
- `<skill>/`, the raw same-origin files fetched for each catalog entry;
- `<skill>-skill.zip`, one repository-ready archive rooted at `.agents/skills/<skill>/`; and
- `agents-skills.zip`, an aggregate archive with every discovered runtime skill.

Catalog entries list safe paths relative to their skill directory and use the full SHA-256 digest of the sorted runtime paths and bytes as `version`. ZIP member order, timestamps, permissions, and storage are normalized so identical source produces identical artifact hashes. The packager refuses a nonempty output directory instead of deleting caller-owned files. Run `make check-agent-skills` to test deterministic output, path safety, content-derived version changes, and agreement with the Stow runtime inventory.

### Generate the portable plugin

The same builder generates the checked-in `plugins/personal-agent-skills/` tree from the runtime inventory. Its root `plugin.json` is copied from the validated source manifest at `agents/plugin.json`; each runtime skill appears under `skills/<skill>/`. This follows the [portable Agent Plugins structure](https://developers.openai.com/plugins/build/plugins) and keeps Waza-only fixtures out of the installed plugin.

Regenerate the canonical tree and verify that it has not drifted:

```shell
mise exec -- python3 agents/scripts/package_skills.py --write-plugin
mise exec -- python3 agents/scripts/package_skills.py --check-plugin
```

The write command replaces only the generated `plugins/personal-agent-skills/` directory. The check command is nonmutating and fails on missing, changed, unexpected, or symbolic-link files. Do not maintain files directly in the generated tree; update `agents/plugin.json` or the runtime skill source and regenerate it instead.

## Create, test, and improve a new skill

There is no Make target for scaffolding. From the repository root, create the skill with Waza and move its generated project evals into the layout used by this package:

```shell
mise exec -- waza new skill my-skill --output-dir agents/.agents/skills
mv agents/.agents/evals/my-skill agents/.agents/skills/my-skill/evals
mv agents/.agents/skills/my-skill/evals/eval.yaml agents/.agents/skills/my-skill/evals/real.yaml
```

Write the skill's `SKILL.md` with a clear description of when to use it and useful instructions. The generated eval is model-backed, so the last command names it `real.yaml`. Replace its generic tasks and graders with cases that check the skill's intended behavior and failure boundaries. Add `evals/eval.yaml` as a credential-free `mock` suite for harness wiring, and `evals/routing.yaml` as a `copilot-sdk` suite with both should-trigger and should-not-trigger tasks. Use `blank-test/evals/` as a layout example; adapt its prompts and graders to the new skill. Keep eval fixtures under `evals/` so they are not installed as runtime files.

Run the offline checks first. `check` needs `evals/eval.yaml`; `preflight` expects that file to use the mock executor and other root eval suites to use `copilot-sdk`:

```shell
make -C agents check AGENT_SKILL=my-skill
make -C agents preflight AGENT_SKILL=my-skill
make -C agents test AGENT_SKILL=my-skill
make -C agents stow-check
make -C agents ci
```

Then capture model-backed results before changing the skill. Inspect task results and transcripts for missed behavior or incorrect routing. After one focused edit, rerun the same suites with the same model, tasks, graders, and trial count, then compare results:

```shell
mise exec -- waza run agents/.agents/skills/my-skill/evals/real.yaml --no-cache --trials 5 --output /tmp/my-skill-real-before.json
mise exec -- waza run agents/.agents/skills/my-skill/evals/routing.yaml --no-cache --trials 5 --output /tmp/my-skill-routing-before.json
# Edit SKILL.md based on an observed failure.
mise exec -- waza run agents/.agents/skills/my-skill/evals/real.yaml --no-cache --trials 5 --output /tmp/my-skill-real-after.json
mise exec -- waza run agents/.agents/skills/my-skill/evals/routing.yaml --no-cache --trials 5 --output /tmp/my-skill-routing-after.json
mise exec -- waza compare /tmp/my-skill-real-before.json /tmp/my-skill-real-after.json
mise exec -- waza compare /tmp/my-skill-routing-before.json /tmp/my-skill-routing-after.json
```

Repeat the edit and comparison until the skill behaves reliably, then run `make -C agents ci` and `make -C agents install`. `make -C agents dev AGENT_SKILL=my-skill` opens Waza's interactive workflow at any point. A paired `waza run .../real.yaml --baseline --no-cache` adds a with-skill versus no-skill comparison. Model runs require authenticated Copilot access and can incur usage.

The numbered `assess` target and the source-bound `real` recorder currently accept only the five imported skills and `blank-test`. For a newly scaffolded skill, use the explicit Waza run/compare commands above until it is added to the coverage tooling.

Each existing skill has a mock harness suite, a model-backed outcome and boundary suite, and a model-backed positive and negative routing suite. The canary's `evals/real.yaml` checks the exact `BLANK_TEST_SKILL_OK` output and zero tool calls with the skill body supplied. Its `evals/routing.yaml` withholds the body so positive and negative cases can check actual skill invocation; only the positive case permits the `skill` tool, and neither permits unrelated tools. Model-backed suites are separate from mock suites and never run in CI. To run them deliberately with authenticated GitHub Copilot access and model permission:

```shell
make -C agents real AGENT_SKILL=blank-test
```

`real` runs all non-mock root eval suites for the selected skill and prints the temporary results directory. If Waza cannot initialize its embedded Copilot CLI, set `COPILOT_CLI_PATH` to an authenticated compatible CLI, for example `COPILOT_CLI_PATH=/path/to/copilot make -C agents real AGENT_SKILL=blank-test`. Check each task's grader results and transcript; a mock pass is never evidence of routing or output quality. Real runs can incur model usage. [Waza's executor guide](https://microsoft.github.io/waza/guides/eval-yaml/) describes the configuration and [authentication prerequisites](https://microsoft.github.io/waza/getting-started/#authenticate-before-real-execution).

For a proposed skill change, capture a focused baseline and identify an observed failure first. Review the proposed instruction change against the Acorn source, rerun the same task, then run the full real suites. For the canary's exact-output case:

```shell
mise exec -- waza run agents/.agents/skills/blank-test/evals/real.yaml --task blank-test-exact-response-001 --no-cache --output /tmp/blank-test-before.json
# Edit the skill or its grader.
mise exec -- waza run agents/.agents/skills/blank-test/evals/real.yaml --task blank-test-exact-response-001 --no-cache --output /tmp/blank-test-after.json
mise exec -- waza compare /tmp/blank-test-before.json /tmp/blank-test-after.json
make -C agents real AGENT_SKILL=blank-test
```

Record the CLI version, model, prompts, observed skill and tool calls, grader outcomes, and any regression. Keep fixtures sanitized and leave real runs opt-in.

## Repeat an assessment after each edit

`assess` runs the selected skill's real and routing suites, saves a source-bound coverage report, and compares each completed run with the preceding one. Run it once before editing, inspect the transcripts and graders, then run the same command after each focused change:

```shell
make -C agents assess AGENT_SKILL=guidelines-rust AGENT_TRIALS=5
# Inspect the printed run directory and revise the skill based on an observed failure.
make -C agents assess AGENT_SKILL=guidelines-rust AGENT_TRIALS=5
# Repeat after the next revision.
```

Each run is saved under `/tmp/my-shell-setup-waza-iterations/<skill>/<number>/` by default. Set `AGENT_ITERATIONS_DIR` to a controlled persistent directory if the history needs to survive temporary-file cleanup. `coverage.md` summarizes source retention and pass-rate changes; `compare-real.txt` and `compare-routing.txt` show Waza's task-level differences. By default, `effect.json` also records Waza's paired with-skill and no-skill comparison, which adds model calls. Set `AGENT_EFFECT=0` to skip it. Keep `AGENT_TRIALS`, model, and task definitions fixed for comparable runs. If a task or grader changes, the coverage report marks its pass rates incomparable. An interrupted run stays on disk and the next assessment compares with the last completed run.

The guidelines-rust error-handling task now asks for two fallible parses without telling the agent to avoid `?`; its routing suite also omits Waza's eval-only routing hint. Its program grader compiles the returned function with `rustc`, exercises both error paths, and rejects `?` in the generated code. This task requires `rustc` on the machine running real-agent evals. Inspect the transcript as well: a passing standalone function does not prove the agent will follow the rule during larger repository edits. Treat the original Acorn skill as the official baseline; review a source change and its observed effect before adding an `accepted_change` record and running the strict `make -C agents ci` gate. Saved raw results can contain prompts and outputs.

## Track capability coverage over time

`agents/coverage/capabilities.json` pins the original Acorn entrypoint sections by digest. It links a section to a Waza `real.yaml` or `routing.yaml` task only when that task checks a relevant behavior. The report distinguishes unchanged, modified, and missing source sections; mapped behavior and routing tests; and observed passes from saved real-agent results. It lists original sections without behavior evals so new tests can be chosen deliberately. The `blank-test` canary remains in the six-skill Waza gate but is outside the five-skill Acorn baseline.

```shell
make -C agents coverage WAZA=/path/to/waza
python3 agents/scripts/skill_coverage.py --waza /path/to/waza \
    --json-out /tmp/skill-coverage-before.json > /tmp/skill-coverage-before.md
```

The report currently maps 9 of 42 original sections to behavioral tasks. No section has a verified real-agent result yet. Mapping is a coarse index, not proof that every statement in a section is tested. Waza's built-in `coverage` grid measures a different thing: its `eval.yaml` grader diversity. The mock harness leaves all six skills `Partial` in that grid; adding a meaningless second mock grader would not improve behavioral evidence. `spec verify` similarly checks whether task text covers metadata requirements, not whether the skill works.

After authenticated model runs, keep results outside the installed package and produce a new report:

```shell
make -C agents real AGENT_SKILL=guidelines-rust \
    AGENT_RESULTS_DIR=/tmp/skill-trials WAZA=/path/to/waza
python3 agents/scripts/skill_coverage.py --waza /path/to/waza \
    --results-root /tmp/skill-trials \
    --previous /tmp/skill-coverage-before.json \
    --json-out /tmp/skill-coverage-after.json
```

`real` writes `real.yaml.json` and `routing.yaml.json` under `<results-dir>/<skill>/` and records source-bound receipts for the skill, suites, tasks, and result files. The report rejects mock or stale results as behavioral evidence. It compares pass rates only for the same task, grader/prompt file, suite, model, engine, and trial count; changed conditions are marked incomparable. Use `waza compare` on the saved result files to inspect per-task detail. For a candidate skill revision, run both original and candidate checkouts with the same model and task suite, then compare their report JSON files.

The current real suites use one trial per task. A passing result is one observation, not a reliable estimate of how often the skill succeeds. Increase `trials_per_task` in matched original and candidate suites before treating small score differences as a release decision.

The offline CI gate fails when an original section changes without a digest-bound `accepted_change` record, a mapped task disappears, or a PR loses mapped coverage. An accepted change records the current section SHA-256, a reason, and an evidence reference in `capabilities.json`; the original SHA-256 remains intact. Reviewers can inspect the exact source diff and Waza evidence before accepting it. CI adds a Markdown report to the run summary, compares a PR with its base checkout, and uploads both JSON snapshots. It cannot mark behavior verified until real-agent results are supplied separately.

For lasting history, commit selected sanitized report JSON snapshots under `agents/coverage/history/` after reviewing a real comparison. Raw Waza result files can contain prompts and outputs; keep them in a controlled artifact store and reference them from the review record. Git history preserves the manifest changes and report snapshots even after CI artifacts expire.

The initial snapshot is `agents/coverage/history/2026-10-31-acorn-baseline.json`. Pass it to `--previous` to compare a later report with the official starting point.

Waza 0.39.1 or newer is required so file paths work consistently with `waza dev`. The root `mise.toml` selects 0.39.1 and pins the Linux x64 SHA-256 used by CI. Run `mise exec -- waza --version` to verify it. Override `WAZA` when using a locally downloaded binary, for example `make -C agents ci WAZA=/path/to/waza`.

The Stow ignore list keeps each skill's `evals/`, `tests/`, and root `trigger_tests.yaml`, plus package-level development files, out of `~/.agents`; runtime `scripts/`, `references/`, `assets/`, and agent metadata remain installed.

To remove only links owned by this package:

```shell
make -C agents remove
```
