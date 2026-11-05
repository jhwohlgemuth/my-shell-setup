---
type: Plan
title: Publish the agents package skills for web installation
description: Distribute every runtime skill as web artifacts, a generated portable plugin, and verified release bundles.
difficulty: medium
impact: medium
package: [agents]
tags: [skills, distribution, plugins, github-pages, opencode]
status: planned
execution: phased
phase_budget_hours: 5
---

# Publish the agents package skills for web installation

## Current evidence and decisions

The Stow package installs runtime files from `agents/.agents/skills/` into `~/.agents/skills/`. It currently contains six skills: `blank-test`, `guidelines-rust`, `sort-rust`, `pikchr-diagram`, `rust-best-practices`, and `rust-review`. Waza evaluation fixtures live beside skill sources but `.stow-local-ignore` deliberately excludes `evals/`, `tests/`, `trigger_tests.yaml`, workflow metadata, and package README files from the runtime installation.

The standard-library `agents/scripts/package_skills.py` builder discovers every immediate child containing `SKILL.md`, applies the Stow runtime exclusions, retains runtime `references/`, `scripts/`, `assets/`, and agent metadata, and emits a deterministic OpenCode v2 catalog, raw trees, per-skill ZIPs, and an aggregate ZIP into a caller-selected empty directory. `make check-agent-skills` verifies deterministic metadata, safe paths, content-derived versions, and agreement with the Stow inventory; `make package-agent-skills AGENT_SKILLS_OUTPUT=<directory>` is the publishing interface. The repository still has no GitHub Pages publishing workflow, marketplace catalog, or tagged skill-release workflow. Preserve `agents/.agents/skills/` as the only maintained runtime source.

The source manifest `agents/plugin.json` declares portable plugin version 0.1.0. The builder's `--write-plugin` and `--check-plugin` modes generate and verify `plugins/personal-agent-skills/` with the six runtime skills and no Waza fixtures; its deterministic content digest is `9e2c4b7db03fdb9fa616c75b4faf39e1e3c1a0f46a5edd2103298bf9208897b1`. The source manifest is excluded from Stow, preserving the established 15-file runtime inventory.

OpenCode v2 natively accepts an HTTP skill-catalog base URL in the `skills` array of `opencode.json`. The base must serve `index.json`; every entry lists safe same-origin files beneath `<base>/<skill>/` and changes its string `version` when content changes. Make the Pages catalog directly consumable by OpenCode, using the full SHA-256 digest of each skill's sorted runtime paths and bytes as its version. OpenCode 1 remains supported through the Stow-installed `~/.agents/skills/` tree or by extracting a repository-ready ZIP.

Do not use `agents/.agents/` directly as the plugin root: its skill folders contain Waza fixtures that Stow omits but a plugin source checkout would retain. The checked-in generated mirror at `plugins/personal-agent-skills/` has root `plugin.json` and `skills/`, and its drift gate keeps the source inventory authoritative. The repo marketplace will point at this clean plugin tree. The planning skill is maintained in the separate `okf-plan-browser` project and is outside this package. This layout follows the [OpenAI Docs plugin packaging guide](https://developers.openai.com/plugins/build/plugins).

A read-only probe on 2026-10-30 found that the proposed `github.io` catalog URL redirected to `shell.jasonwohlgemuth.com/agent-skills/catalog.json` and returned 404; the repository Pages API also returned 404. Treat the catalog as unpublished. Configure this repository's project Pages with GitHub Actions and no custom domain, then verify the canonical project URL after deployment. The Pages artifact must have a top-level `index.html` and an `agent-skills/` subtree; [GitHub Pages requires a top-level entry file](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site).

ASD-02 will extend the completed builder for Pages output; ASD-03 consumes the generated portable plugin tree independently.

## Public interfaces

- OpenCode v2 catalog: `https://jhwohlgemuth.github.io/my-shell-setup/agent-skills/`, configured as `"skills": ["https://jhwohlgemuth.github.io/my-shell-setup/agent-skills/"]` in `opencode.json`; the base serves `index.json`.
- Latest raw entrypoint: `https://jhwohlgemuth.github.io/my-shell-setup/agent-skills/<skill>/SKILL.md`.
- Latest per-skill bundle: `https://jhwohlgemuth.github.io/my-shell-setup/agent-skills/<skill>-skill.zip`.
- Latest aggregate bundle: `https://jhwohlgemuth.github.io/my-shell-setup/agent-skills/agents-skills.zip`.
- Versioned assets: `https://github.com/jhwohlgemuth/my-shell-setup/releases/download/agents-vX.Y.Z/<skill>-skill.zip` and `agents-skills.zip`.
- Marketplace install: `codex plugin marketplace add jhwohlgemuth/my-shell-setup --ref main`, then `codex plugin add personal-agent-skills@my-shell-setup`; the marketplace entry resolves `./plugins/personal-agent-skills` relative to the repository root.

## Acceptance criteria

Every runtime skill beneath `agents/.agents/skills/` appears in the generated OpenCode v2 catalog, raw web tree, repository-ready individual ZIP, aggregate ZIP, and generated portable plugin without Waza-only fixtures. The ZIPs unpack to `.agents/skills/<skill>/`; the plugin uses root `plugin.json` and `skills/<skill>/`. Outputs are deterministic and derived from the same discovered inventory; each catalog version is content-derived and CI rejects drift in the checked-in plugin mirror. A clean OpenCode v2 configuration can load the catalog and invoke `@blank-test`; OpenCode 1 can discover the Stow-installed or extracted `.agents` tree. A clean Codex installation can add the repository marketplace, install the plugin, start a new session, and invoke `blank-test` with the exact `BLANK_TEST_SKILL_OK` response. A tagged `agents-vX.Y.Z` release publishes checksummed assets, and its assets and tag are immutable only after repository release immutability is enabled and the draft is published. Stow installation remains unchanged.

# Execution phases

## ASD-02 — Publish the latest web catalog

- Status: blocked
- Budget: 5 active hours maximum
- Prerequisites: this repository's Pages source set to GitHub Actions without a custom domain.
- Exact write set: `.github/workflows/agent-skills-pages.yml`, `agents/site/index.html`, `agents/scripts/package_skills.py`, `agents/scripts/test_package_skills.py`, `agents/README.md`.
- Primary integration lock: agent-skills Pages deployment.
- Outcome: Pushes to `main` that change the agents package publish a Pages artifact with root `index.html` and an OpenCode-compatible `agent-skills/index.json`, raw runtime trees, individual ZIPs, and aggregate ZIP beneath `/my-shell-setup/agent-skills/`; no `CNAME` is emitted.
- Focused validation: Build the Pages artifact locally, verify its top-level entrypoint, links and MIME-readable files, compare published ZIP contents with the source commit, then fetch `index.json` and every catalog file over HTTPS, configure a clean OpenCode v2 profile with the catalog base URL, invoke `@blank-test`, and confirm no redirect to the old host.
- Handoff: Preserve the workflow run, source commit, public URLs, OpenCode configuration and invocation result, catalog contents and versions, and artifact hashes.

## ASD-03 — Expose the package through a plugin marketplace

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `.agents/plugins/marketplace.json`, `.github/workflows/agent-skills-plugin-check.yml`, `agents/README.md`, `README.md`.
- Primary integration lock: personal-agent-skills plugin identity.
- Outcome: Marketplace `my-shell-setup` resolves the generated plugin tree and CI fails if that tree drifts from `agents/.agents/skills/`.
- Focused validation: Parse and schema-check the marketplace, regenerate the mirror and require a clean diff, verify it resolves `./plugins/personal-agent-skills`, install it in a clean Codex profile, invoke `blank-test` in a new session, and confirm Waza-only files are absent from the installed cache.
- Handoff: Record the manifest version, exact install commands, installed file inventory, discovery result, and required Codex version.

## ASD-04 — Publish versioned skill releases

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: ASD-03; use an `agents-vX.Y.Z` tag whose `X.Y.Z` matches `agents/plugin.json`.
- Exact write set: `.github/workflows/agent-skills-release.yml`, `agents/README.md`, `CONTRIBUTING.md`.
- Primary integration lock: agent-skills release identity.
- Outcome: An `agents-v*` tag validates the package and creates a draft release with every individual ZIP, the aggregate ZIP, and SHA-256 values; it rejects a tag that differs from the plugin version.
- Focused validation: Run the workflow against a test tag, inspect the draft asset set, download assets, verify checksums and deterministic contents, and install one individual ZIP in a temporary target.
- Handoff: Preserve the draft tag, workflow run, asset inventory, checksums, and source comparison.

## ASD-06 — Publish and verify an immutable release

- Status: blocked
- Budget: 5 active hours maximum
- Prerequisites: ASD-04 and repository release immutability enabled in GitHub settings before publication.
- Exact write set: `agents/README.md`; external system: `jhwohlgemuth/my-shell-setup` GitHub release settings and `agents-vX.Y.Z` draft release.
- Primary integration lock: agent-skills release publication.
- Outcome: The draft release is published only after all assets are attached; GitHub locks its assets and tag and the documentation points to the verified release.
- Focused validation: Confirm release immutability is enabled, publish the draft, verify the immutable badge or API state, download and verify checksums, and install the plugin from the matching tag.
- Handoff: Preserve the immutable release URL, tag, asset hashes, and plugin install result.
