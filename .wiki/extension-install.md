---
type: Plan
title: Flatten extension installation
description: Use one bounded fallback attempt per extension and report failures to callers.
difficulty: medium
impact: medium
package: [gold]
tags: [extensions, code-server, installer]
status: planned
execution: phased
phase_budget_hours: 5
---

# Flatten extension installation

## Current evidence and decision

`gold/install_extensions` installs group members by reinvoking itself, downloads the listing on each invocation, sets an `ERR` trap for direct IDs, and suppresses group failures with `|| true`. Resolve groups once, then use one function per extension: try the marketplace, download one VSIX with `download_extensions` on failure, install that local file, and return a failure if both attempts fail. Remove only the VSIX created by that attempt.

## Acceptance criteria

Each group member is attempted once through the direct path and at most once through the VSIX fallback. Any failed member causes a nonzero overall result with its ID in the error output; successful members still install.

# Execution phases

## EXT-01 — Replace recursive script calls with a bounded installer

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_extensions`.
- Primary integration lock: code-server extension flow.
- Outcome: Group and direct IDs share one installer with accurate failure reporting.
- Focused validation: ShellCheck, shfmt check, and mocked direct-success, fallback-success, and group-partial-failure runs.
- Handoff: Record call counts and exit statuses for all three paths.
