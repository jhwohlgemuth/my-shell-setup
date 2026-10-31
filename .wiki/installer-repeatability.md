---
type: Plan
title: Make installer reruns predictable
description: Prevent duplicate profile edits and repair user-specific PATH and cleanup behavior.
difficulty: medium
impact: medium
package: [gold]
tags: [installers, idempotence, paths]
status: planned
execution: phased
phase_budget_hours: 5
---

# Make installer reruns predictable

## Current evidence and decision

`install_dotnet_jupyter_kernel` appends a `/root` PATH entry for the current user. `install_homebrew`, `install_cuda_toolkit`, `install_rocq`, and `install_wasm_tools` append shell lines on every run. `install_java` quotes cache wildcards, so its intended cleanup has no matches. Fix each installer without rewriting unrelated user profile content.

## Acceptance criteria

Each named command can be run twice without duplicate shell configuration; installed binaries resolve for the intended user; Java cache cleanup removes only the intended cache entries.

# Execution phases

## REP-01 — Repair .NET user PATH

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_dotnet_jupyter_kernel`.
- Primary integration lock: .NET Jupyter installer.
- Outcome: .NET uses the active user's tool directory at most once.
- Focused validation: ShellCheck, shfmt diff, and a temporary-home double-run with mocked .NET commands.
- Handoff: Record the resulting PATH line and command resolution.

## REP-02 — Repair Java cache cleanup

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_java`.
- Primary integration lock: Java installer cleanup.
- Outcome: Cache cleanup removes the intended archives and temporary files without touching other SDKMAN content.
- Focused validation: ShellCheck, shfmt diff, and a temporary-home run with mocked SDKMAN setup and representative cache entries.
- Handoff: Record removed and retained file examples.

## REP-03 — Deduplicate single-tool shell edits

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_homebrew`, `gold/install_cuda_toolkit`, `gold/install_rocq`.
- Primary integration lock: single-tool shell initialization.
- Outcome: Each script writes its initialization to the correct user's shell file at most once.
- Focused validation: ShellCheck, shfmt diff, and temporary-home double-run tests with install steps mocked.
- Handoff: Record the resulting profile snippets and target-user rules.

## REP-04 — Deduplicate WASM tool shell edits

- Status: ready
- Budget: 5 active hours maximum
- Prerequisites: none.
- Exact write set: `gold/install_wasm_tools`.
- Primary integration lock: WASM installer menu.
- Outcome: Repeating any selected WASM installation does not add duplicate PATH or environment lines.
- Focused validation: ShellCheck, shfmt diff, and mocked double selections for each profile-writing choice.
- Handoff: Record the menu choices and resulting profile line counts.
