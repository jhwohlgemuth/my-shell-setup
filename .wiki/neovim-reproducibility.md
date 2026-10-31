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

`general/plugins.vim` downloads vim-plug from `master` and runs `PlugInstall` during ordinary startup. Its plugin declarations mostly follow moving branches. The Dockerfile exercises plugin installation but does not pin its base image or Neovim version. Keep first-run setup available as an explicit documented command and pin a tested plugin set.

## Acceptance criteria

Opening Neovim does not download code or change plugins. A documented setup command installs a versioned, reviewed plugin set; the container smoke test exercises that command.

# Execution phases

## NVP-01 — Separate editor startup from plugin installation

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `neovim/.config/nvim/general/plugins.vim`, `neovim/README.md`, `neovim/Dockerfile`.
- Primary integration lock: Neovim plugin bootstrap.
- Outcome: Normal startup is network-free and an explicit setup path installs plugins.
- Focused validation: Start Neovim headlessly without an installed plugin manager; run the Dockerfile's plugin setup smoke test.
- Handoff: Record the setup command and startup behavior.

## NVP-02 — Pin completion, navigation, and editing plugins

- Status: planned
- Budget: 5 active hours maximum
- Prerequisites: NVP-01.
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
