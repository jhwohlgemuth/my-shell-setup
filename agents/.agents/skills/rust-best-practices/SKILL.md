---
name: rust-best-practices
description: |
  Guide Rust implementation with project-aware choices about ownership, errors, APIs, tests, and documentation.
  USE FOR: Implement idiomatic Rust code and APIs.
  DO NOT USE FOR: Read-only Rust reviews.
---

# Rust best practices

Use the rules relevant to the requested Rust work. Follow the repository's edition, MSRV, API stability, and conventions; avoid applying every checklist item to a small edit. Prefer clear ownership and types, propagate expected errors with `Result` and `?`, and keep public API changes deliberate. Test behavior and use `cargo fmt`, Clippy, and `cargo test` where the project supports them.

Read [detailed guidance](references/detailed-guidance.md) for task-specific rules and tradeoffs. Consult the source digest that matches the decision: [Rust API Guidelines](references/rust-api-guidelines.md) for public APIs, [Effective Rust](references/effective-rust.md) for implementation choices, [Rust Design Patterns](references/rust-design-patterns.md) for idioms, [Microsoft Rust Guidelines](references/microsoft-rust-guidelines.md) for safety and errors, or the [Google Rust Style Guide](references/google-rust-style-guide.md) for style. Treat project instructions and the user's task as higher priority than a digest.
