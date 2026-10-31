# Copyable Pikchr examples

Each Pikchr block below is a complete diagram. Copy one into a `.pikchr` file or a Markdown `pikchr` fence. Adapt actions and role names to the real workflow. The examples illustrate layout; they do not assert deployment behavior.

## 1. Basic flow with explicit responsibilities

Create process blocks and connectors first, then add badges so `same` inherits the process block dimensions rather than a badge's dimensions.

```pikchr
scale = 1
fontscale = 1.15
color = 0x183C43
S: box "Submit highlight" bold "Describe the work" wid 2.2in ht 0.8in rad 0.08in fill 0xE8F1FB thickness 0
C: box "Collect receipts" bold "Preserve submitted content" same fill 0xE7F3E9 at S+(2.7in,0)
R: box "Stage + inspect" bold "Review proposed changes" same fill 0xF3F0FF at C+(2.7in,0)
arrow from S.e to C.w thick color 0x00662C
arrow from C.e to R.w thick color 0x00662C
box "USER" bold small wid 0.7in ht 0.24in rad 0.06in fill 0x205795 color 0xFFFFFF thickness 0 at S.n
box "AUTOMATED" bold small wid 1.25in ht 0.24in rad 0.06in fill 0x00662C color 0xFFFFFF thickness 0 at C.n
box "DEVELOPER" bold small wid 1.25in ht 0.24in rad 0.06in fill 0x62408A color 0xFFFFFF thickness 0 at R.n
```

## 2. Alternate entry, routed continuation, and manual milestone

The top row is an alternate correction entry, not a required step before submission. Both entries join collection. The return route stays in the gap between rows. The dashed connector is explicitly labeled as an owner-triggered milestone; it does not promise an automatic email after a CLI command.

```pikchr
scale = 1
fontscale = 1.15
color = 0x183C43
S: box "Submit highlight" bold "New content" wid 2.2in ht 0.8in rad 0.08in fill 0xE8F1FB thickness 0
C: box "Collect receipts" bold "Originals + corrections" same fill 0xE7F3E9 at S+(2.7in,0)
D: box "Download JSONL" bold "Check export freshness" same fill 0xFFF4D6 at C+(2.7in,0)
E: box "Save correction" bold "Link the previous receipt" same fill 0xE8F1FB at C+(0,1.15in)
R: box "Stage + inspect" bold "Review latest content" same fill 0xF3F0FF at S+(0,-1.45in)
A: box "Apply" bold "Confirm reviewed changes" same fill 0xF3F0FF at C+(0,-1.45in)
F: box "Report" bold "Generate local PDF" same fill 0xF3F0FF at D+(0,-1.45in)
N: box "OWNER-TRIGGERED MILESTONE" bold "Request review" "Email: reviewers" wid 3.4in ht 0.85in rad 0.08in fill 0xFFF4D6 thickness 0 at F+(0,-1.35in)
arrow from S.e to C.w thick color 0x00662C
arrow from E.s to C.n+(0,0.12in) thick color 0x00662C
arrow from C.e to D.w thick color 0x00662C
Route: line from D.e right 0.3in then down 0.65in color 0x00662C
arrow from Route.end to (R.x,Route.end.y) then to R.n+(0,0.12in) thick color 0x00662C
arrow from R.e to A.w thick color 0x00662C
arrow from A.e to F.w thick color 0x00662C
arrow from F.s to N.n+(0,0.12in) dashed color 0x506A70
box "USER" bold small wid 0.7in ht 0.24in rad 0.06in fill 0x205795 color 0xFFFFFF thickness 0 at S.n
box "USER" bold small wid 0.7in ht 0.24in rad 0.06in fill 0x205795 color 0xFFFFFF thickness 0 at E.n
box "AUTOMATED" bold small wid 1.25in ht 0.24in rad 0.06in fill 0x00662C color 0xFFFFFF thickness 0 at C.n
box "DEV / REVIEWER" bold small wid 1.65in ht 0.24in rad 0.06in fill 0x805A0B color 0xFFFFFF thickness 0 at D.n
box "DEVELOPER" bold small wid 1.25in ht 0.24in rad 0.06in fill 0x62408A color 0xFFFFFF thickness 0 at R.n
box "DEVELOPER" bold small wid 1.25in ht 0.24in rad 0.06in fill 0x62408A color 0xFFFFFF thickness 0 at A.n
box "DEVELOPER" bold small wid 1.25in ht 0.24in rad 0.06in fill 0x62408A color 0xFFFFFF thickness 0 at F.n
box "DEV / REVIEWER" bold small wid 1.65in ht 0.24in rad 0.06in fill 0x805A0B color 0xFFFFFF thickness 0 at N.n
```

## 3. Distinct NEW callout

Keep the yellow oval at the left and the role badge at the right. `NEW` describes the entry path here; it is not a responsibility label. Use an explicit small length for its border thickness.

```pikchr
scale = 1
fontscale = 1.15
color = 0x183C43
S: box "Submit highlight" bold "New highlight" wid 2.2in ht 0.8in rad 0.08in fill 0xE8F1FB thickness 0
ellipse "NEW" bold wid 0.7in ht 0.34in fill 0xFFE466 color 0x754300 thickness 0.012in at S.nw+(0.4in,0)
box "USER" bold small wid 0.7in ht 0.24in rad 0.06in fill 0x205795 color 0xFFFFFF thickness 0 at S.ne+(-0.5in,0)
```

## Render the examples with mdbook

With `mdbook` and `mdbook-pikchr` installed and on PATH, make a temporary book containing `book.toml`, `src/SUMMARY.md`, and `src/examples.md`. Copy this document into `src/examples.md`.

`book.toml`:

```toml
[book]
title = "Flowchart examples"

[preprocessor.pikchr]
command = "mdbook-pikchr"
```

`src/SUMMARY.md`:

```markdown
# Summary

- [Examples](examples.md)
```

Run from the temporary book directory:

```sh
mdbook build
```

Inspect `book/examples.html`. When extracting standalone SVG, preserve its dimensions, normalize `viewbox` to `viewBox` if necessary, and set `font-family:Arial,Helvetica,sans-serif`. Inspect at the destination size before embedding in a PDF or slide. A successful build alone does not establish readable text or unobstructed arrowheads.
