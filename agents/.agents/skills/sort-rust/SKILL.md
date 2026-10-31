---
name: sort-rust
description: |
  Reorder independent Rust declarations safely while keeping comments and attributes attached and preserving semantic order.
  USE FOR: Sort independent Rust declarations when ordering is requested.
  DO NOT USE FOR: Sort JavaScript imports.
license: MIT
---

# Sort Rust declarations

Adapted from the Acorn `sort` skill. Keep ordering changes within the requested scope. Sort independent declarations by the relevant identifier using a stable, case-insensitive lexical order unless the repository uses another convention.

- Move documentation comments, attributes, visibility, and conditional compilation with their declaration.
- Keep related `impl` blocks together by target type; use the full header as a tie-breaker.
- Group independent tests with their subject module; sort by test name when requested.
- Let `rustfmt` handle imports when the repository uses it. Do not add blank lines or section comments solely to advertise sorting.
- Preserve order when it affects behavior, dependencies, or explanation: match arms, pipeline stages, protocol fields, and progressive examples are common cases.
- Review the diff and run the relevant formatter or test after moving code.

## Example

Independent `fn alpha` and `fn zebra` may be alphabetized. A `match` with a catch-all arm stays in semantic order, even if its pattern sorts first.
