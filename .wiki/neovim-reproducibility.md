---
type: Plan
title: Make Neovim plugin setup reproducible
description: Keep plugin installation explicit and pin the tested editor baseline.
difficulty: medium
impact: medium
package: [neovim]
tags: [neovim, plugins, reproducibility]
status: planned
execution: phased
phase_budget_hours: 5
---

# Make Neovim plugin setup reproducible

## Current evidence and decision

Ordinary Neovim startup is network-free: when vim-plug is absent, the plugin layer is skipped with an informational message. The documented headless bootstrap sets `g:bootstrap_plugins`, downloads vim-plug at a fixed commit, and runs `PlugInstall`. Completion, navigation, and editing plugins now use 16 immutable commits. The Dockerfile installs checksum-verified Neovim 0.12.6 archives and its clean-cache `pinned-subset` stage verifies every Git HEAD and loads that subset headlessly. UI, Git, language-specific, and tool plugins remain moving; a full-config smoke reaches rolling orgmode and fails because its tree-sitter grammar installation needs a C compiler, which belongs to the remaining pinning phase.

## Acceptance criteria

Opening Neovim does not download code or change plugins. A documented setup command installs a versioned, reviewed plugin set; the container smoke test exercises that command.

# Execution phases

## NVP-03 — Pin UI, language, and tool plugins

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `neovim/.config/nvim/general/plugins.vim`, `neovim/Dockerfile`, `neovim/README.md`.
- Primary integration lock: Neovim plugin version set.
- Outcome: The remaining plugins use tested revisions and the update procedure is documented.
- Focused validation: Build the Neovim container from a clean cache and verify all configured plugins load headlessly.
- Handoff: Record the full revision set and upgrade procedure.
