---
type: Plan
title: Replace midas with a Gold Rust CLI
description: Move dotfiles update commands into a safe Rust CLI owned by Gold and retire the shell script.
difficulty: medium
impact: high
package: [gold, my-shell-setup]
tags: [rust, cli, dotfiles, migration]
status: planned
execution: phased
phase_budget_hours: 5
---

# Replace midas with a Gold Rust CLI

## Current evidence and decision

`gold/midas` discards tracked edits with `git checkout -- .` before pulling. It accepts `update` or `gold` for the same operation and `opencode` for a separate Stow package. Gold has no Rust CLI crate today. `../gold/Dockerfile.terminal` installs these dotfiles before `../gold/Dockerfile` installs Rust.

Keep the command name `midas`, the three existing arguments, and `GOLD_DOTFILES` with its current default. Abort updates on a dirty worktree; use a fast-forward pull and invoke Git and Stow through Rust subprocess argument arrays. Stow `gold` into the user's `~/.local/bin`; keep `opencode` targeted at `HOME` and give a clear error when that package is absent. Build a Linux binary for each supported terminal-image architecture, then replace the old stowed `/usr/local/bin/midas` link with that binary after dotfiles setup.

## Acceptance criteria

The installed CLI updates a clean checkout, refuses a dirty checkout without changing it, reports Git or Stow failure, and preserves the documented command arguments. Gold's terminal image contains the CLI on amd64 and arm64. This repository no longer installs the shell `midas`.

# Execution phases

## MID-01 — Implement the safe CLI in Gold

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none
- Exact write set: Gold repository `/Users/o9w/dev/gold`, new Rust CLI crate and focused tests.
- Primary integration lock: `midas` command interface.
- Outcome: A testable CLI implements the existing commands with dirty-worktree protection and explicit subprocess errors.
- Focused validation: Run the new crate's `cargo fmt --check`, `cargo clippy`, and focused `cargo test` cases using temporary Git/Stow fixtures.
- Handoff: Record the crate path, command interface, and test results for image packaging.

## MID-02 — Package the CLI in Gold images

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: MID-01.
- Exact write set: Gold repository `/Users/o9w/dev/gold`, terminal image build and its focused build validation.
- Primary integration lock: terminal image build.
- Outcome: The terminal image builds the CLI separately and replaces the legacy stowed command after dotfiles setup without requiring a runtime Rust toolchain.
- Focused validation: Build or smoke-test terminal images for Linux amd64 and arm64 and run `midas --help` inside each.
- Handoff: Record the installed binary path and image build evidence before retiring the shell script.

## MID-03 — Retire the shell script

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: MID-02.
- Exact write set: `gold/midas`, `Makefile`, `README.md`.
- Primary integration lock: dotfiles command distribution.
- Outcome: Remove the shell implementation, its formatting-list entry, and replace its usage documentation with the Gold CLI.
- Focused validation: Run `make check` if available, otherwise ShellCheck and shfmt checks for remaining scripts; confirm the Gold image's `midas` command is the only installed implementation.
- Handoff: Record the Gold release or commit supplying the replacement and the local diff.
