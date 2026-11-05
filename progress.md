# Implementation progress

## Implementation — verified runtimes, plugin marketplace, and complete Neovim pins

- Plans: `.wiki/verified-bootstrap.md` and `.wiki/agent-skills-web-distribution.md` continue; `.wiki/neovim-reproducibility.md` retired; active phase: none; state: SEC-04 and NVP-03 complete, ASD-03 waiting on external validation.
- Authorized scope and decisions: Executed the three named phases concurrently, preserving their disjoint WASM installer, personal plugin identity, and Neovim plugin-version locks. ASD-03 was not promoted because its required clean-install runtime evidence is unavailable.
- Baseline and local work: Started from clean `main` at `812b318`, matching `origin/main`; no `.codegraph/` index is present. Standalone installers now own the fixed, verified Cosmonic, MoonBit, Scale, Spin, WasmCloud, WasmEdge, and Wasmtime artifacts; the WASM menu delegates to them and preserves its custom binary-directory argument. The Codex marketplace and CI gates resolve and verify the generated plugin. All 36 Neovim plugins are pinned.
- Verified state: Gold syntax, formatting, ShellCheck, corrupt-download rejection, and native macOS arm64 runtime smokes passed. Agent-skill packaging and marketplace structure checks passed with Codex CLI 0.166.0. A clean arm64 Neovim container build loaded the full config, Org parser, Markdown Preview, and Snacks; image manifest `sha256:1519fea244074f195b64b5a877262f8aa7eb8185a514635fa4a7b7ab5d25782e`.
- Remaining work: In a writable isolated Codex profile with GitHub and model access, install `personal-agent-skills@my-shell-setup`, start a new session, invoke `blank-test`, and inventory the installed cache. SEC-11 is the next independent local phase.
- Budget: SEC-04 and NVP-03 completed within their separate five-active-hour ceilings. ASD-03 implementation completed within budget; its external validation remains blocked.
- Blockers / failed approaches: Codex clean-profile installation attempted to write protected user config/cache and failed with `Operation not permitted`; the local live schema fetch also failed DNS resolution. The workflow performs the online schema check. Neovim was rebuilt on arm64 only; amd64 remains an explicitly unverified platform, and Orgmode resolves its grammar through upstream tag `2.0.4` rather than a separately recorded grammar commit.
- Next action: Validate ASD-03 in a writable isolated Codex profile and authenticated new session; SEC-11 may proceed independently when authorized.

## Implementation — verified WasmCloud, portable skill plugin, and pinned Neovim subset

- Plans: `.wiki/verified-bootstrap.md`, `.wiki/agent-skills-web-distribution.md`, and `.wiki/neovim-reproducibility.md`; active phase: none; state: complete within SEC-10, ASD-05 plus repair ASD-07, and NVP-02.
- Authorized scope and decisions: Execute SEC-10, ASD-05, and NVP-02 concurrently, preserving their disjoint WASM installer, generated plugin tree, and Neovim plugin-version locks; use bounded ASD-07 for the Stow validation defect.
- Baseline and local work: Clean `main` at `d5a53d6`, matching `origin/main`; changed the three phase write sets, `agents/.stow-local-ignore` for ASD-07, and portfolio/progress records. No `.codegraph/` index is present.
- Verified state: SEC-10 verifies official `wash` 2.12.0 binaries for Linux x86-64, arm64, and s390x; corrupt, unavailable, and unsupported-host paths fail before installation, and a Debian x86-64 smoke reported 2.12.0. ASD-05 generates portable plugin 0.1.0 at digest `9e2c4b7db03fdb9fa616c75b4faf39e1e3c1a0f46a5edd2103298bf9208897b1`; ASD-07 preserves the exact 15-file Stow inventory. NVP-02 pins vim-plug and 16 plugins, and its clean-cache Neovim 0.12.6 `pinned-subset` stage verifies commits and headless loading. All 24 agent tooling tests, plugin drift validation, Bash syntax, shfmt, ShellCheck, `make check`, wiki validation, and `git diff --check` passed.
- Remaining work: None within the authorized phases. SEC-04, ASD-03, and NVP-03 are ready but outside this authorization.
- Budget: SEC-10, ASD-05, ASD-07, and NVP-02 each completed within its separate five-active-hour ceiling.
- Blockers / failed approaches: ASD-05's initial Stow check exposed the source manifest leak, repaired by ASD-07. CodeCompanion's ACP workflow requires a newer Neovim baseline, so NVP-02 verifies against official Neovim 0.12.6; the full unpinned orgmode path still needs a C compiler and remains NVP-03 work. `gold/README.md` still describes WasmCloud's former Packagecloud route because it was outside SEC-10's exact write set.
- Next action: Review and commit the completed phases; execute SEC-04, ASD-03, or NVP-03 only when separately authorized.

## Implementation — parallel platform, bootstrap, packaging, extension, and Neovim phases

- Plans: `.wiki/installer-platforms.md` and `.wiki/extension-install.md` retired; `.wiki/verified-bootstrap.md`, `.wiki/agent-skills-web-distribution.md`, and `.wiki/neovim-reproducibility.md` continue; active phase: none; state: complete within the authorized phases.
- Authorized scope and decisions: Complete PLT-03, SEC-09, ASD-01, EXT-01, and NVP-01, starting PLT-03 and SEC-09 first and using disjoint write sets and integration locks for parallel work.
- Baseline and local work: Clean `main` at `4dc36cf`, matching `origin/main`; changed the five phase write sets plus portfolio and progress records. No `.codegraph/` index is present.
- Verified state: PLT-03 rejects unsupported distro, architecture, and UID combinations before mutation; SEC-09 verifies Scale CLI 0.2.0 and Spin 4.2.6 across their Linux/macOS x86-64/arm64 artifacts, with native macOS arm64 version smokes; ASD-01 packages all six runtime skills deterministically with seven focused tests and exact Stow-inventory agreement; EXT-01 passed direct, fallback, and partial-group failure mocks; NVP-01 passed a network-disabled clean-start smoke and built its explicit Docker plugin-setup stage. Bash syntax, shfmt, ShellCheck, all 20 agent tooling tests, `make check`, wiki validation, and `git diff --check` passed.
- Remaining work: None within the five authorized phases. SEC-10, ASD-05, and NVP-02 are ready but outside this authorization.
- Budget: Each phase completed in under one active hour (estimate), within its separate five-hour ceiling.
- Blockers / failed approaches: Scale's rolling endpoint has an invalid TLS certificate and its project is archived, so SEC-09 uses the official archived CLI 0.2.0 release and checksum manifest. A first Linux-binary smoke on macOS produced the expected format error; matching macOS arm64 artifacts passed. NVP-01's final rolling-plugin smoke exposes an existing `nvim-orgmode`/Neovim 0.10.4 incompatibility assigned to the remaining pinning phases.
- Next action: Review and commit the five completed phases; execute SEC-10, ASD-05, or NVP-02 only when separately authorized.

## Implementation — verified remote bootstrap inputs

- Plan: `.wiki/verified-bootstrap.md`; active phase: none; state: complete within the authorized phases.
- Authorized scope and decisions: Execute SEC-01, SEC-06, SEC-02, SEC-07, SEC-08, SEC-03, and SEC-05 as separate bounded phases. Preserve installer interfaces while replacing mutable or unchecked execution with fixed upstream identifiers and SHA-256 verification.
- Baseline and local work: `da8d548` on clean `main`, matching `origin/main`; upstream immutable inputs and hashes were resolved from official release or repository sources before implementation.
- Verified state: All seven authorized phases passed Bash syntax, shfmt diff, ShellCheck, and focused success/corrupt/failed-download validation. SEC-01 pins Nix 2.34.0; SEC-06 accepts only the recorded SDKMAN 5.24.0 payload; SEC-02 pins Homebrew installer commit `d6a2423c5973e04b45a5f17dc1948f6c9e5e651a`; SEC-07 installs verified choosenim 0.8.16 Linux artifacts; SEC-08 verifies zsh-in-docker 1.2.0; SEC-03 verifies Cosmonic 0.25.0 and MoonBit `0.10.19+bee578715` artifacts; and SEC-05 verifies Miniconda `py312_26.9.4-0`. An Ubuntu 24.04 amd64 build installed the real Miniconda input and reported Conda 26.9.4. The full `make check-gold` gate passed.
- Remaining work: None within the authorized phases. SEC-09 is ready; SEC-10, SEC-04, SEC-11, and SEC-12 remain behind its WASM-menu sequence and are outside this authorization.
- Budget: Each of SEC-01, SEC-06, SEC-02, SEC-07, SEC-08, SEC-03, and SEC-05 completed in under one active hour (estimates), within its separate five-hour ceiling.
- Blockers / failed approaches: MoonBit's obsolete `ubuntu_x86_64_moon_setup.sh` returned AccessDenied, so SEC-03 uses current official versioned toolchain and core archives directly. SDKMAN lacks a versioned generated-installer URL, so its payload embeds version 5.24.0 and is accepted only at the recorded digest. Two Docker builds on the default remote context lost their SSH transport; a stable alternate context completed the Ubuntu amd64 Miniconda smoke. The first smoke exposed Miniconda's `.sh` filename requirement, which the final temporary-directory implementation satisfies.
- Next action: Review and commit the seven completed phases; execute SEC-09 only when separately authorized.

## Implementation — reliable validation gates

- Plan: `.wiki/validation-gates.md` retired; active phase: none; state: complete.
- Authorized scope and decisions: Provision Stow in the hosted repository check, use the repaired hosted result to finish VAL-02, and retire the plan only after its acceptance criteria are evidenced.
- Baseline and local work: Started from `bd58345` on clean `main`; commit `0010826` added an Ubuntu APT step that installs Stow before the hosted `make check` invocation and was pushed to `main`.
- Verified state: Compatible Ruby/Psych assertions verified the `push`, `pull_request`, and `workflow_dispatch` triggers plus the Stow step; local GNU Stow 2.4.1 and `make check` passed with the expected 15-file agent inventory; and `git diff --check` passed. [Push-triggered GitHub Actions run `41754885682`](https://github.com/jhwohlgemuth/my-shell-setup/actions/runs/41754885682) for exact commit `0010826846245b46433cb129dabdab0920170740` completed successfully; its `Install Stow` and `Run repository checks` steps both passed.
- Remaining work: None within VAL-03 or VAL-02; both phases are complete and the plan is retired.
- Budget: VAL-03 and VAL-02 each completed in under one active hour (estimates), within their separate five-hour ceilings.
- Blockers / failed approaches: GitHub CLI authentication is invalid, so the public Actions API supplied the hosted evidence. The unauthenticated log-download endpoint returned 403, preventing extraction of the hosted APT package version; the job and step conclusions remain publicly verified.
- Next action: Review and commit the plan retirement and portfolio reconciliation.

## Implementation — platform guards, Prusti PATH, and Nushell history

- Plans: `.wiki/installer-platforms.md` (PLT-02 complete; PLT-03 remains), `.wiki/prusti-path.md` (retired), and `.wiki/nushell-history.md` (retired); active phase: none.
- Authorized scope: Execute PLT-02, PRU-01, and NUH-01. Preserve the supported Linux x86-64 installer artifacts, existing Prusti binaries, and the OneDrive path when available.
- Baseline and local work: `a931a43` on `main`; `.agents/` was already untracked from the requested planning-skill installation. Changed the three downloaded-binary installers, Prusti installer, and Nushell config; pruned or retired the completed wiki phases and reconciled portfolio links.
- Verified state: `make check-gold` and `make check-nushell` passed. Mocked Darwin x86-64 and Linux arm64 calls to each downloaded-binary installer failed before directory creation or download; Linux x86-64 reached the existing download route; bflat additionally rejected a non-glibc Linux host. A temporary-home double Prusti install removed the exact obsolete profile entry, preserved unrelated text, left one guarded `~/.local/bin` entry, and resolved both binaries in a fresh zsh. Nushell startup with temporary homes used the default history path without OneDrive and the expected custom path with its parent directory. Wiki validation and `git diff --check` passed. Live upstream installation was not run.
- Remaining work: PLT-03 is outside this authorization. SEC-05 may now edit `gold/install_conda` without a shared PLT-02 phase. VAL-03 is separately ready to repair missing Stow in hosted CI.
- Budget: Each phase finished in under one active hour (estimate), within its five-hour ceiling.
- Blockers / failed approaches: Initial test fixtures omitted bflat's working directory and compared noncanonical Nushell paths; corrected fixtures passed. A temporary Prusti test exposed that bare `mktemp` used an unwritable system cache directory here; the installer now creates its temporary profile file beside `.zshrc`.
- Next action: Review and commit these changes; run PLT-03 only when authorized.

## Implementation — validation gate and Gold platform matrix

- Plans: `.wiki/validation-gates.md` and `.wiki/installer-platforms.md`; active phase: none; state: VAL-02 waiting on hosted validation, PLT-01 complete and pruned.
- Authorized scope and decisions: Implement VAL-02, complete PLT-01, then make PLT-02 and PLT-03 ready alongside independent SEC phases. Do not commit, push, or start later implementation phases.
- Baseline and local work: `a12d479` on `main`; the worktree was clean. Added `.github/workflows/check.yml`, published the current support matrix in `gold/README.md`, and reconciled the plan index, dependency network, and parallel schedule.
- Verified state: The workflow targets pushes to `main`, pull requests, and manual dispatch; pins Mise 2026.10.24; provisions Nushell 0.116.1; and invokes `make check`. Compatible Ruby/Psych parsing confirmed the required triggers and command, isolated Mise provisioning reported Nushell 0.116.1, and `make check` passed. The support matrix accounts for all 39 `gold/install_*` commands and all 16 WASM choices.
- Remaining work: Obtain the first hosted VAL-02 run after commit/push. PLT-02 and PLT-03 are ready but were scheduled, not started; PLT-02 must serialize with SEC-05 while PLT-03 can run beside the independent SEC phases.
- Budget: VAL-02 completed its local implementation in under one active hour (estimate); PLT-01 completed within its five-hour ceiling.
- Blockers / failed approaches: VAL-02's hosted run requires a commit and push. The first YAML assertion used unavailable `YAML.safe_load_file`; the compatible `YAML.safe_load(File.read(...))` assertion passed.
- Next action: Commit and push the workflow, then inspect its first hosted run; execute the scheduled platform and SEC phases only when authorized.

## Implementation — installer repeatability

- Plan: `.wiki/installer-repeatability.md`; active phase: none; state: complete and plan retired.
- Authorized scope and decisions: Completed REP-01 through REP-04 while preserving unrelated profile content and the established target-user rules; corrected Cosmonic's related `/root` PATH to use `${HOME}`. Exact-line profile writes share the standalone `append_if_missing` Gold utility.
- Baseline and local work: `fcfb584` on `main`; the worktree was clean before implementation. Added `gold/append_if_missing` and its Makefile inventory entry; changed `gold/install_dotnet_jupyter_kernel`, `gold/install_java`, `gold/install_homebrew`, `gold/install_cuda_toolkit`, `gold/install_rocq`, and `gold/install_wasm_tools`; then reconciled the retired plan's wiki references.
- Verified state: Bash syntax, shfmt, and ShellCheck pass for every changed script; `make check-gold` and `make check-stow` pass. The standalone utility rejects missing arguments, preserves unrelated content, and appends an exact line only when absent. Temporary-home double runs leave one .NET, Homebrew, Rocq, and each CUDA line. Java removes visible, hidden, and nested entries only from SDKMAN `archives/` and `tmp/`, preserving candidate and configuration files. Double selections leave one each of the Emscripten, Cosmonic, and WasmEdge lines and one each of the two Wasmtime lines; Cosmonic uses `${HOME}/.cosmo/bin`.
- Remaining work: None within the REP plan.
- Budget: REP-01 through REP-04 each completed in under one active hour (estimates), within their separate five-hour ceilings.
- Blockers / failed approaches: Initial CUDA and WasmEdge mocks lacked host/installer fixtures; the corrected Debian/passwd and environment-file fixtures passed. The first full Gold gate emitted sandbox cache warnings, so the clean result was obtained outside the sandbox. No product blocker remains.
- Next action: Review and commit the completed plan.

## Implementation — correctness-tool menu

- Plan: `.wiki/correctness-choices.md`; active phase: none; state: complete and plan retired.
- Authorized scope and decisions: Execute COR-01 only; remove Lean until an installer exists and route Rocq to the existing `install_rocq` command.
- Baseline and local work: `44a9ae7` on `main`; the worktree was clean before implementation. Changed `gold/install_correctness_tools` and reconciled the completed plan's wiki references.
- Verified state: `bash -n`, shfmt diff, and ShellCheck with all checks enabled passed. A mocked Gum run verified that Lean is absent from the chooser and selecting Rocq calls `install_rocq`. A static audit verified all ten displayed choices map to executable `gold/install_*` commands. These checks used the current uncommitted worktree.
- Remaining work: None within COR-01.
- Budget: Completed in under one active hour (estimate), within the five-hour phase ceiling.
- Blockers / failed approaches: None.
- Next action: Review and commit the completed phase.

## Implementation — startup and bootstrap

- Plans: PSH-01 complete and retired; VAL-01, WIN-01, and PUB-01 complete. VAL-02 remains ready; WIN-02 and PUB-02 await hosted publication and verification.
- Authorized scope: Make PowerShell startup safe, add a nonmutating local validation gate, and add the Windows and Linux/macOS bootstrap sources. Hosted publication phases are outside this request.
- Baseline: `7218998` on `main`; worktree was clean before implementation.
- Verified state: The PowerShell profile parsed and loaded with optional commands hidden and no Prelude; a mocked McFly initialized exactly once and a policy-changing `Set-PSRepository` mock was never called. `make check` passed Bash syntax, shfmt, ShellCheck, Nushell load, PowerShell parse, agent Stow inventory (15 links), and all-package Stow simulation after both bootstrap sources were added; the tracked diff SHA-256 was unchanged across the final run. An invalid first Gold script made `make check-gold` exit 2. Temporary-home mocked Git/Stow tests passed for shell default, selected, comma-separated, invalid, rerun, wrong-origin, and wrong-branch cases. Temporary-home PowerShell tests passed both README invocation forms, default and selected packages, invalid input, `-WhatIf`, failed updates, wrong origin/branch, dirty copier, and missing Git. An actual-checkout Windows `-WhatIf` also passed without writes. Planning wiki validation passed. These checks used the current uncommitted worktree.
- Remaining work: None within the authorized local phases. VAL-02, WIN-02, and PUB-02 remain separate hosted phases; native Windows installation and hosted bytes have not been verified.
- Budget: All four authorized phases finished within their separate five-hour ceilings.
- Next action: After reviewing and committing this work, run VAL-02 in hosted CI and publish/verify the two bootstrap routes when deployment access is available.

## Implementation — Waza skill workflow

- Plan: `.wiki/waza-skill-workflow.md`; active phases: WAZ-01 through WAZ-04 plus GDR-02, SOR-02, and PIK-02; state: blocked on external validation.
- Authorized scope: Rename the copied Rust skills and reapply the Waza workflow to all five copied skills; keep model runs opt-in.
- Baseline: `fece2f4`; the user copied `guidelines`, `sort`, `pikchr-diagram`, `rust-best-practices`, and `rust-review` into `agents/.agents/skills/` as untracked sources.
- Verified state: The five imported skills use their complete Acorn source as the baseline. `guidelines-rust` and `sort-rust` differ only in metadata `name`; the other three entrypoints and runtime assets match Acorn. Waza mock, outcome/boundary, and routing suites remain beside the sources. The saved capability snapshot records 42 unchanged original sections; nine have linked behavioral Waza tasks and none has a saved real-agent result. `make -C agents ci WAZA=/tmp/my-shell-setup-waza`, the exhaustive `make -C agents stow-check` (15 intended runtime links), 13 tooling tests, wiki validation, and `git diff --check` passed. The Stow fixture confirms package-level scripts and evaluation files are excluded while skill-local scripts and references remain installed. A temporary manifest with one removed behavior mapping produced a `-1` report delta and strict exit 1. The report also rejects mock or stale results and flags unreviewed source changes and comparable pass-rate regressions. Waza reports the long original entrypoints above its preferred token budget; this advisory does not justify rewriting them. With `COPILOT_CLI_PATH=/opt/homebrew/bin/copilot`, `waza models` reported `not authenticated`.
- Remaining work: Run and inspect model-backed trials for all six skills, render and inspect a Pikchr output, and observe the hosted six-skill GitHub Actions gate.
- Budget: The blocked validation phases retain separate five-hour ceilings; active trial time has not started.
- Next action: With authenticated Copilot access and authorized model usage run `COPILOT_CLI_PATH=/path/to/copilot make -C agents assess AGENT_SKILL=guidelines-rust WAZA=/path/to/waza`. Record baseline results before proposing any instruction change.
