# DOCX preflight and dual extraction

## Why DOCX needs extra care

DOCX files can look orderly to a human while hiding a lot of structural risk for automated conversion.

Examples:

- fake headings created with font size and bold
- fake lists made with manual numbering
- tables used for layout
- floating images and text boxes
- tracked changes or comments
- Word-specific style noise in table-of-contents sections

A preflight does not eliminate those risks, but it lets you see them before they contaminate the chunk corpus.

## Preflight checklist

At minimum, inspect:

- title and heading hierarchy
- ordered and unordered lists
- tables and merged cells
- screenshots and captions
- text boxes, shapes, SmartArt, or floating objects
- headers and footers
- section breaks and columns
- comments and tracked changes
- hyperlinks and cross-references
- special characters or encoding-sensitive content

Use [templates/docx-qa-template.md](../templates/docx-qa-template.md) as a starting point.

## Why a dual extraction helps

A single DOCX conversion is often not enough for serious work.

A stronger pattern is to create two views.

### Probe extraction

The probe extraction is intentionally noisy.

Typical goals:

- detect custom styles such as TOC and list wrappers
- inspect whether tracked changes or comments are still present
- inventory media extraction behavior
- reveal how much post-processing may be needed

The probe output is for QA.

### Master extraction

The master extraction is the readable baseline.

Typical goals:

- continuous reading by humans
- first-pass normalization
- source review before chunking
- a stable baseline to compare against Docling or other structured outputs

The master output is still not automatically the final chunk corpus.

## Suggested tool roles

### Pandoc

Use it for:

- probe markdown
- master markdown
- media extraction
- deterministic local conversion

### Docling

Use it for:

- structured JSON
- a second structured markdown view
- document-aware metadata that can support chunking

### Mammoth

Use it for:

- semantic QA
- confirming whether lists and headings are real structure
- inspecting a semantic HTML view when the markdown looks suspicious

## Screenshot rule

If screenshots carry UI or workflow meaning, they should not disappear into a media folder without interpretation.

Create a deliberate inventory when needed.

Each important screenshot may deserve:

- source document
- source section
- short label
- visible UI elements
- apparent function
- open questions

## Common findings after a first probe

Typical examples include:

- a perfectly readable master markdown paired with a very noisy probe file
- real headings, but many custom Word list styles
- table-of-contents sections that should be stripped before chunking
- screenshot-heavy functional docs versus text-heavy technical docs
- a need to normalize image formats such as EMF before wider review

## What should become canonical

Not the originals.
Not the probe output.
Not the first raw converter result.

The canonical chunk corpus should be built only after:

1. preflight QA
2. extraction review
3. normalization
4. explicit chunking rules
5. spot checks against the source

## Related scripts in this repository

- [scripts/preflight-docx.py](../scripts/preflight-docx.py)
- [scripts/extract-official-sources.ps1](../scripts/extract-official-sources.ps1)
- [scripts/normalize-master-markdown.py](../scripts/normalize-master-markdown.py)
