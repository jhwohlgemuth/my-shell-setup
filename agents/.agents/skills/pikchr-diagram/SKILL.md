---
name: pikchr-diagram
description: |
  Create editable Pikchr flowcharts grounded in the user's process, then render and inspect their visual output.
  USE FOR: Create editable Pikchr workflow diagrams with role labels.
  DO NOT USE FOR: Quantitative scatter plots.
---

# Pikchr diagrams

Create the `.pikchr` source first, then render and inspect the output at its destination size. Use the process supplied by the user or its source documents to identify actions, actors, branches, and automatic steps. Do not import actors or workflow facts from an example diagram.

- Keep role names visible in text as well as color. Split mixed human and automated responsibilities into distinct actions.
- Use clear action verbs, readable labels, visible arrowheads, and connectors that do not cross text.
- Keep the source as the authority and regenerate derived images and requested embedded copies from it.
- If no renderer is available, report the missing rendering step; do not claim visual verification.

Read [diagram guidance](references/diagram-guide.md) for layout, styling, rendering, and visual checks. Use [copyable examples](references/examples.md) and the [Pikchr source](assets/workflow-map.pikchr) with its [rendered SVG](assets/workflow-map.svg) as style references, adapting roles and process facts to the task.
