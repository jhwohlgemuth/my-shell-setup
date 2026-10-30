---
name: blank-test
description: |
  USE FOR: Running the blank test skill; verifying that personal agent skills are installed; confirming that agent skill discovery works.
  DO NOT USE FOR: General test suites; application verification; dependency or unrelated setup checks.
---

# Blank test

This skill is a minimal canary for the personal agent skill setup.

When invoked, respond with exactly:

```text
BLANK_TEST_SKILL_OK
```

Do not run commands, inspect files, or add other text.

## Examples

- "Run the blank test skill."
- "Verify that my personal agent skills are discoverable."

## Troubleshooting

If this skill does not appear after installation, verify the Stow links with `make agents-stow-check` from the dotfiles repository.
