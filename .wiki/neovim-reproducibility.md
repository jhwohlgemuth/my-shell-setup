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

Ordinary Neovim startup is now network-free: when vim-plug is absent, the plugin layer is skipped with an informational message. The documented headless bootstrap sets `g:bootstrap_plugins`, downloads vim-plug, and runs `PlugInstall`; the Dockerfile's named `plugin-setup` stage exercises that path. Its plugin declarations still mostly follow moving branches, and the Dockerfile does not pin its base image or Neovim version. The current final Docker smoke also exposes a rolling `nvim-orgmode` incompatibility with Debian's Neovim 0.10.4, reinforcing the remaining version-set work.

## Acceptance criteria

Opening Neovim does not download code or change plugins. A documented setup command installs a versioned, reviewed plugin set; the container smoke test exercises that command.

# Execution phases

## NVP-02 — Pin completion, navigation, and editing plugins

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `neovim/.config/nvim/general/plugins.vim`, `neovim/Dockerfile`, `neovim/README.md`.
- Primary integration lock: Neovim plugin version set.
- Outcome: The plugin manager and completion, navigation, and editing plugins use tested revisions.
- Focused validation: Build the Neovim container from a clean cache and verify the pinned subset loads headlessly.
- Handoff: Record revision pins and the next unpinned groups.

## NVP-03 — Pin UI, language, and tool plugins

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: NVP-02.
- Exact write set: `neovim/.config/nvim/general/plugins.vim`, `neovim/Dockerfile`, `neovim/README.md`.
- Primary integration lock: Neovim plugin version set.
- Outcome: The remaining plugins use tested revisions and the update procedure is documented.
- Focused validation: Build the Neovim container from a clean cache and verify all configured plugins load headlessly.
- Handoff: Record the full revision set and upgrade procedure.
