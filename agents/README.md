# Agent skills

This Stow package installs reusable AI agent skills into `~/.agents` while keeping Waza development files in the repository.

The runtime path mapping is:

```text
agents/.agents/skills/<skill>/SKILL.md -> ~/.agents/skills/<skill>/SKILL.md
```

The package-local `.stow-local-ignore` excludes each skill's `evals/` directory and `trigger_tests.yaml` from the target. These files remain beside the skill source so Waza can use its standalone-skill workflow.

Run the repository targets from its root:

```shell
make agents-stow-check
make agents-install
make agents-check
make agents-test
make agents-dev
```

`agents-stow-check` uses a temporary target and does not change `~/.agents`. `agents-check` performs Waza's static and spec coverage checks. `agents-test` runs the credential-free mock evaluation; it verifies the Waza harness configuration, not model behavior. `agents-dev` starts Waza's interactive skill improvement workflow.

The Waza targets default to `blank-test`. Select another skill with the `AGENT_SKILL` Make variable:

```shell
make agents-check AGENT_SKILL=my-skill
make agents-test AGENT_SKILL=my-skill
make agents-dev AGENT_SKILL=my-skill
```

Waza 0.39.1 or newer is required so file paths work consistently with `waza dev`. Follow the [official Waza installation instructions](https://microsoft.github.io/waza/getting-started/#installation), then verify the CLI with `waza --version`.

To scaffold another standalone skill in this package:

```shell
waza new skill my-skill --output-dir agents/.agents/skills
```

Review the generated skill and eval files before running the checks. The Stow ignore list keeps Waza's `evals/`, `tests/`, root trigger fixtures, workflow metadata, and README files out of `~/.agents`; runtime assets such as `scripts/`, `references/`, and `assets/` remain part of the installed skill.

To remove only links owned by this package:

```shell
make agents-remove
```
