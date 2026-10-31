---
name: pikchr-diagram
description: Create or revise editable Pikchr flowcharts and workflow diagrams in the ACORN book style, with pastel process blocks, explicit role badges, clean routed arrows, and distinct NEW callouts. Use for process maps in documentation, PDFs, or presentations; not for quantitative plots or screenshot editing.
---

# Pikchr diagrams

Use the Sponsor Highlights workflow map as the visual reference, while adapting its steps and responsibilities to the requested process. Keep the editable `.pikchr` source as the authority and regenerate derived images and embedded copies from it.

## Reference assets

- Read [references/examples.md](references/examples.md) for complete, copyable code examples: a basic flow with roles, a correction branch with routed arrows and a manual milestone, and a standalone NEW callout. It also includes a minimal rendering setup.

- Read [assets/workflow-map.pikchr](assets/workflow-map.pikchr) for tested layout, arrow routing, role badges, and NEW syntax. Copy and adapt it rather than editing this skill's reference for a one-off diagram.
- Inspect [assets/workflow-map.svg](assets/workflow-map.svg) for the intended appearance. This is a style example, not evidence that the illustrated process exists in another project.

## Describe the process before drawing

Identify each action, its actor, inputs/outputs, optional branches, and automated work. Use specific verbs in boxes. Do not infer that an action is automated merely because software is involved. Split mixed responsibilities into separate steps: for example, automatic collection and a human downloading the collected file.

In ACORN workflows, all CLI actions belong to **DEVELOPER**, including stage, inspect, apply, optional `run --index`, and report. Users submit and correct highlights. Use **DEV / REVIEWER** for shared operator duties such as downloading exports or triggering a review milestone. For other domains, adapt role names to the actual actors rather than forcing these roles onto the diagram.

Preserve important distinctions from the underlying workflow: saved is not approved; a correction may retain the original; optional promotion is not required reporting; automatic notices and manually triggered milestones are different. Include only distinctions relevant to the requested process.

## Visual language

Use a white background, dark ink, rounded pastel blocks, and flat rectangular role badges. Role text must accompany color so responsibility remains readable without color perception.

| Meaning | Block fill | Badge fill |
| --- | --- | --- |
| User / contributor | `0xE8F1FB` | `0x205795` |
| Automated service | `0xE7F3E9` | `0x00662C` |
| Developer | `0xF3F0FF` | `0x62408A` |
| Developer / reviewer | `0xFFF4D6` | `0x805A0B` |

- Body ink: `0x183C43`. Badge text: `0xFFFFFF`.
- Solid process arrows: `0x00662C`; secondary dashed connectors: `0x506A70`.
- Default `scale = 1`, `fontscale = 1.15`; use Arial/Helvetica/sans-serif in the rendered SVG.
- Typical main block: `2.2in × 0.8in`, corner radius `0.08in`, no border. Short command steps can use `1.8in × 0.75in`. Expand blocks or shorten wording when content needs more space.
- Use a bold action title and one or two concise supporting lines. Avoid paragraphs, long paths, IDs, and implementation detail in blocks.
- Role badges are about `0.24in` tall with `0.06in` corner radius, centered on the top edge. Size width to the label; use bold small text.
- Keep text within a block visually separate from its badge. Do not shrink the whole diagram until labels become unreadable in its destination.

### NEW callouts

Use NEW only where the requested process needs that distinction; it is not a role. Keep it visually different from the common role-label design: a yellow **oval**, dark outline, and larger bold lettering at the upper-left edge. When a block also has a role badge, move that role badge toward the upper-right edge.

This decoration snippet assumes a process block named `S`; the [standalone example](references/examples.md#3-distinct-new-callout) includes its definition.

```pikchr
ellipse "NEW" bold wid 0.7in ht 0.34in fill 0xFFE466 color 0x754300 thickness 0.012in at S.nw+(0.4in,0)
box "USER" bold small wid 0.7in ht 0.24in rad 0.06in fill 0x205795 color 0xFFFFFF thickness 0 at S.ne+(-0.5in,0)
```

Pikchr stroke thickness uses diagram lengths. Specify a small explicit unit such as `0.012in`; a bare `1.5` is not a 1.5-point stroke and can overwhelm the drawing.

## Structure and connectors

Prefer left-to-right action sequences with related branches aligned in rows. The reference places the edit/correction branch above the new-submission path, developer commands below it, and shared notifications in a wide footer block. Reuse that structure when it fits; do not force unrelated processes into those exact rows.

- Name blocks (`S:`, `R:`, etc.) and position them relative to one another with `at S+(...)`.
- Keep comparable actions the same size. Use `same` carefully: it inherits the most recent compatible shape, so place decorative badges after the process blocks and arrows.
- Leave approximately `0.4–0.5in` between adjacent blocks and enough vertical space for badges and routed connectors.
- Attach arrows to block anchors (`.e`, `.w`, `.n`, `.s`). Use orthogonal routes through whitespace for returns or row changes; avoid diagonals through text, crossings, and long ambiguous lines.
- If a centered badge straddles the destination's top edge, end an incoming arrow at the badge's upper edge, such as `SL.n+(0,0.12in)`, so its arrowhead remains visible.
- Draw connectors before decorative badges. Check that badge layering does not hide arrowheads.
- Use solid arrows for the main process or data path. Use dashed arrows for secondary/manual notification paths only when a caption explains that meaning. Do not imply a dependency or notification trigger that the workflow does not have.
- For notifications, show both the trigger and destination/channel where known. Keep automatic confirmations separate from owner-triggered milestones.

## Render and distribute

Use a working Pikchr renderer available in the project. The reference was rendered with `mdbook` and `mdbook-pikchr`: a temporary book with a `pikchr` fenced block and `[preprocessor.pikchr]` in `book.toml`. Extract the resulting SVG, preserving its viewBox and setting an explicit sans-serif font. The preprocessor may emit `viewbox`; normalize it to `viewBox` before standalone SVG rasterization.

Prefer SVG for scalable documentation and slide use. Generate a high-resolution PNG when the target PDF pipeline requires it, keeping the white background and correct aspect ratio. Discover renderer/runtime locations instead of embedding machine-specific paths. A renderer failure or an error page is not a successful diagram; verify the generated SVG and its visible content.

When editing a diagram already embedded in multiple guides, locate its shared source and consumers, rebuild each requested copy, and retain consistent role meanings and labels. Select imported PDF pages by a stable title/bookmark where practical rather than a fragile page number. Do not modify screenshots, historical payloads, or acceptance records merely to match the new diagram.

Use the PDF skill for PDF authoring and final page checks when available. Keep this skill focused on the diagram; branding on page headers and footers should follow the surrounding document.

## Visual acceptance

Render and inspect the final diagram at its actual destination size, including every changed PDF or slide instance. Verify:

- Every action has the correct actor; all ACORN commands are labeled DEVELOPER.
- Role labels are explicit and colors agree across copies; NEW remains distinct and on the left.
- Titles, supporting text, and badges are legible with no collisions or clipping.
- Arrowheads are visible, routes have clear direction, and no connector crosses text.
- Required/optional branches, automated/human steps, and notice triggers match the source process.
- Exported images preserve aspect ratio, use a readable font, and do not contain stale diagrams or renderer error text.

Fix visual defects and re-render before delivery. Report which formats and embedded copies were updated; do not claim the diagram validates the operational system itself.
