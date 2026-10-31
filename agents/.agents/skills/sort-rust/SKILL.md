---
name: sort-rust
description: Deterministic sorting behavior for code that improves readability. This skill should be applied whenever writing or modifying code, especially when it can lead to simpler and more maintainable solutions. *Use this skill whenever code is involved, especially when adding new code*
license: MIT
---

# Sorting

Apply deterministic ordering only within the scope of the requested change. Preserve comments, attributes, visibility, and implementation bodies while reordering.

## Alphabetic Sorting

- Sort by the relevant identifier using case-insensitive lexical order unless the language or repository convention requires another order.
- Sort only constructs whose source order does not carry behavior, dependency, or explanatory meaning.
- Keep a declaration's documentation comments, attributes, and attached conditional-compilation attributes with that declaration.
- Preserve intentional semantic ordering, such as match arms whose order determines behavior, ordered pipeline stages, protocol fields, or examples that build on one another.

## Construct Grouping

Group like constructs together before applying alphabetic sorting:

- Imports: Do not edit imports as Rust fmt will sort them automatically.
- Type aliases, constants, structs, enums, traits, implementations, free functions, and tests: keep each construct kind contiguous when reorganizing a file.
- Tests: group tests with their subject module or feature; sort independent tests alphabetically by test name.
- Rust `impl` blocks: group by implemented target type as described below.

Do not create empty narrative sections or extra blank lines solely to sort code. Preserve the file's existing spacing style.

## Order of Grouping for Rust Constructs

Sort the groups in the following order, with each group sorted alphabetically by the relevant identifier:
0. Imports (should always be at top of file, sorted by rustfmt)
1. Constants
2. Type aliases
3. Traits
4. Enums
5. Structs
6. Implementations
7. Free functions
8. Tests

Add one blank line after imports and before tests. Do not add extra blank lines between other groups.

## Rust Implementations

Sort top-level `impl` blocks alphabetically by their implemented target type:

- `impl Foo` sorts under `Foo`.
- `impl Bar for Foo` also sorts under `Foo`, not under `Bar`.
- Group every implementation for the same target type together.
- Within a target-type group, sort by the complete `impl` header as a deterministic tie-breaker.
- Keep preceding attributes, such as `#[cfg(...)]`, attached to the implementation block they modify.

For example, order these blocks by `Document`:

```rust
impl Document { ... }
impl From<Input> for Document { ... }
impl MarkdownSupport for Document { ... }
```

## Test Modules

- `tests` modules should be declared at end of a module
  ```rust

  #[cfg(test)]
  mod tests; <-- last line of module
  ```
- Test function names should start with `test_` to clearly indicate their purpose.
- Test functions should be sorted alphabetically by their names within the `tests` module.
- Do NOT add any blank lines between test functions within the `tests` module.
- `proptest` blocks should be first item directly before other test functions within the `tests` module.