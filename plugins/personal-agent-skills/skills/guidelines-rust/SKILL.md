---
name: guidelines-rust
description: Behavioral guidelines to reduce common LLM coding mistakes. Use when writing, reviewing, or refactoring code to avoid overcomplication, make surgical changes, surface assumptions, and define verifiable success criteria. These guidelines should be applied to all coding tasks. Functional programming (FP) principles should be used whenever code is involved. FP emphasizes immutability, composability, and purity to create clearer, more predictable code. This skill should be applied whenever writing or modifying code, especially when it can lead to simpler and more maintainable solutions. *Use this skill whenever code is involved*
license: MIT
---

# Coding Guidelines

Behavioral guidelines to reduce common LLM coding mistakes, derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 0. Always prefer functional programming style when possible

**Minimize moving parts. Avoid mutable state and side effects.**

- Prioritize the 3 T's of functional programming:
  1. Immutability
  2. Composability
  3. Purity
- Avoid mutable state and side effects.
- Minimize use of `return` statements and early exits. Instead, structure code to flow naturally from inputs to outputs.
- Favor pure functions that take inputs and return outputs without modifying external state.
- Use immutable data structures and avoid shared mutable state.
- This leads to clearer, more predictable code that is easier to test and debug.

OOP makes code understandable by encapsulating moving parts. Functional Programming makes code understandable by minimizing moving parts.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.
- In general, do not add carriage returns before new code - do not separate code by carriage returns for "readability".
- Do not add "block comments" to create sections in the code. If you want to add a comment, add it directly above the line of code it is describing - ***DO NOT ADD COMMENTS THAT RESTATE OBVIOUS PURPOSE***, if the purpose of code can be inferred from names, it does not need a comment. Do not add extra lines to create "sections" in the code.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 5. Rust-Specific Guidelines

**Apply functional programming principles to leverage Rust's strengths. Emphasize immutability, composability, and purity to create clearer, more predictable code.**

- Avoid adding `?` to the code — always handle errors properly. This promotes better error handling and prevents silent failures.
- Import modules at the top of the file, not inside functions. This keeps dependencies clear and avoids unnecessary imports.
  - BAD: `acorn::io::database::clear_cache()` inside a function.
  - GOOD: `use acorn::io::database;` at the top, then `database::clear_cache()` in the function (or even just `clear_cache()` if imported directly).
- Avoid using `mut` unless necessary. Emphasize immutability to enhance code safety and readability.
- Use iterators and functional combinators (like `map`, `filter`, `fold`) instead of loops and mutable state. This promotes a more declarative style of programming.
- Leverage Rust's powerful type system to create abstractions that promote immutability and composability, such as using `Option` and `Result` types for error handling instead of mutable state.
- Always prefer `core` over `std` when possible, as it is more lightweight and promotes a functional programming style by avoiding unnecessary dependencies and side effects.
- Use `exitcode` module to pass exit codes instead of `0`, `1`, etc. This improves readability and maintainability by providing meaningful names for exit codes.

## General Guidelines
- Do NOT insert blank lines between code blocks. Avoid adding extra whitespace that does not serve a clear purpose.