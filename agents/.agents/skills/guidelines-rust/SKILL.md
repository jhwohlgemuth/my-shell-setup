---
name: guidelines-rust
description: |
  Apply minimal project-aware Rust editing guidance that favors clear control flow without imposing blanket style rules.
  USE FOR: Simplify Rust error handling in small code changes.
  DO NOT USE FOR: Read-only Rust reviews.
license: MIT
---

# Rust coding guidelines

Apply these guidelines to the Rust change the user requested. Match the repository's conventions and keep the diff focused. This skill adapts the imported Acorn `guidelines` skill, which credits Andrej Karpathy's observations on coding mistakes; it does not impose a project-wide style.

- State an assumption only when it changes the implementation. Resolve routine choices from the codebase.
- Prefer the simplest design that meets the request. Avoid speculative abstractions and unrelated cleanup.
- Favor immutable data and small functions when they make the code clearer; use `mut`, loops, and early returns when those are the clearer Rust choice.
- Use `Result` and `?` for ordinary error propagation. Add context at a boundary where callers need it; handle or transform errors when the task requires that behavior.
- Use `std` normally. Choose `core` or `alloc` for an actual `no_std` requirement. Follow the project's exit-code convention rather than adding a new dependency.
- Verify the changed behavior with the smallest relevant test or build check and report any limit in that evidence.

## Example

For a fallible parser, return `Result<T, E>` and use `?` for a nested parse. Add an explicit `match` when different errors need different recovery paths.
