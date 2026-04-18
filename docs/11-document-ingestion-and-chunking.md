# Document ingestion and chunking

## Why this pipeline exists

Raw documents are a poor default input for LLM retrieval.

A better workflow is:

1. inspect the source class
2. extract a reviewable text representation
3. normalize it
4. chunk it deliberately
5. refine it
6. index only the resulting pre-chunked corpus

That improves retrieval quality and reduces token waste.

## Non-negotiable rule

**Vaults must contain only pre-chunked material.**

That pre-chunking may be:

- produced by the ingestion workflow
- created manually for exceptional documents

But the indexed unit must already be chunk-shaped.

## Two ingestion modes

The repository now distinguishes between two valid modes.

### Mode A: standard document ingestion

Use this when the source set is small, relatively clean, and does not require a dedicated workbench.

```text
raw documents
  -> extraction
  -> normalized markdown
  -> chunk files
  -> refined chunk corpus
  -> indexes and manifests
  -> staging directory
  -> ctxvault index
```

### Mode B: official document workbench

Use this when the source set is official, sensitive, screenshot-heavy, or structurally fragile.

```text
official source drop
  -> immutable originals
  -> technical working copies
  -> DOCX preflight QA
  -> probe extraction
  -> master extraction
  -> normalization and evidence review
  -> canonical chunks + source maps + conflict register
  -> promotion into project repo and/or vault
```

See [docs/16-official-document-workbench.md](16-official-document-workbench.md).

## Recommended directory model

### Standard model

```text
documents-to-ingest/
  incoming/
  extracted/
  normalized/
  chunks/
  chunks-refined/
  indexes/
  staging/
```

## Scope of the bundled scripts

The scripts published in this repository start from **normalized markdown**.

That means the repository covers the pipeline from:

- `normalized/` -> chunking -> refinement -> indexes -> staging -> ctxvault indexing

Extraction from raw source documents is still part of the workflow, but it is intentionally left to tool-specific wrappers built around Docling, MarkItDown, Pandoc, or an equivalent converter.



### Workbench-oriented model

```text
workbench/
  sources/
    <drop>/
      original/
      working-copy/
      qa/
      extracted/
        markdown/
        docling/
        media/
        manifests/
  kb/
    chunks/
    indexes/
    source-map/
    conflict-register/
  authored/
    drafts/
    validated/
  exports/
    for-project-repo/
    for-sanitized-llm-use/
```

## Step 1 - Collect source documents

Put source files in an intake area (i.e. `documents-to-ingest/incoming/`).

Examples:

- DOCX
- PDF
- spreadsheets exported to markdown or CSV
- HTML exports
- static reference notes

Do not edit originals in place.

## Step 2 - Decide whether the source needs a workbench

A dedicated workbench is usually warranted when at least one of these is true:

- the sources are official or externally delivered
- the sources are confidential enough to keep out of public LLMs entirely until chunked
- the source set is large and heterogeneous
- the documents contain many screenshots, text boxes, or fragile Word structures
- the source set is likely to override or invalidate earlier internal documentation

## Step 3 - Run preflight QA before conversion

For DOCX-heavy work, a structural preflight should happen before the first extraction.

Check at least:

- title and heading hierarchy
- real vs fake lists
- tables
- images and screenshots
- text boxes, shapes, SmartArt, or floating objects
- headers and footers
- section breaks and columns
- comments, revisions, and tracked changes
- hyperlinks and cross-references
- suspicious encoding artifacts

A preflight does not have to be perfect. It has to be good enough to tell you whether the document is safe for direct extraction or requires working-copy remediation.

See [docs/17-docx-preflight-and-dual-extraction.md](17-docx-preflight-and-dual-extraction.md).

## Step 4 - Extract a reviewable representation

Use one or more local converters such as:

- Pandoc
- Docling
- MarkItDown
- Mammoth for semantic QA support

The goal is not perfect beauty. The goal is a stable reviewable base for downstream processing.

## Step 5 - Prefer dual extraction for official DOCX sets

For a sensitive or official DOCX drop, a dual extraction is often stronger than trusting one converter alone.

### Probe extraction

The probe extraction is intentionally noisy.

Use it to surface:

- custom Word styles
- table of contents artifacts
- review markers
- list formatting oddities
- media behavior

Probe output is for QA, not for final indexing.

### Master extraction

The master extraction is the readable baseline.

Use it to:

- read the document continuously
- inspect structure and references
- build the first normalization pass
- feed a canonical chunking step only after review

## Step 6 - Normalize markdown

Normalization should fix or standardize:

- heading consistency
- broken spacing
- repeated boilerplate
- encoding issues
- path references for images
- table-of-contents sections that would pollute chunking
- extraction artifacts such as custom-style wrappers when they are no longer useful

The output should be a stable master markdown suitable for chunking.

## Step 7 - Chunk by semantic boundaries

The default chunking strategy is heading-based, with document-specific split levels.

Typical split boundaries:

- level 1 and 2 for broad technical documents
- level 2 and 4 for long functional documents with repeated substructure

Each chunk should have:

- a stable chunk ID
- source file identity
- source heading path
- line origin when available
- a concise title
- a predictable filename

For official or screenshot-heavy documents, consider additional chunk families:

- functional requirements
- business rules
- integrations
- as-is
- to-be
- historical context
- legacy UI screenshots as first-class knowledge units

## Step 8 - Treat screenshots as knowledge when they carry meaning

Do not treat screenshots as decorative media when they show:

- legacy UI state
- workflow evidence
- field names and validation cues
- system relationships
- historically important behavior

When screenshots matter, create or enrich chunks with:

- source document
- source section
- related images
- interpretation notes
- open questions

## Step 9 - Refine the chunk corpus

Refinement can:

- remove empty chunks
- skip table-of-contents headings
- normalize titles
- extract image references
- extract captions
- add family or category labels
- estimate token size
- spot duplicate titles
- flag oversized chunks for secondary splitting

This step improves retrieval and review quality.

## Step 10 - Build indexes and manifests

Useful outputs include:

- chunk manifest CSV
- summary by family
- summary by source document
- duplicate-title report
- image or caption report
- markdown summary for manual QA
- source map
- conflict register if the new sources may override older internal docs

## Step 11 - Manual QA

Before indexing into a vault, spot-check:

- chunk titles
- chunk boundaries
- obvious duplication
- broken extraction artifacts
- giant chunks that should be split further
- tiny chunks that add no value
- screenshot references that lost context
- places where the source seems to contradict existing internal docs

## Step 12 - Stage only the pre-chunked output

Copy the refined chunk corpus into a staging directory that represents the final vault-facing material.

Do not stage the raw source files as the retrievable unit.

## Step 13 - Index into CtxVault

Index the staging directory with `ctxvault`.

That keeps the retrieval corpus aligned with the reviewed, pre-chunked material.

## Example scripts in this repository

### Standard ingestion support

- [scripts/run-ingestion-pipeline.ps1](../scripts/run-ingestion-pipeline.ps1)
- [scripts/test-ingestion-prerequisites.ps1](../scripts/test-ingestion-prerequisites.ps1)
- [scripts/build-kb-chunks.py](../scripts/build-kb-chunks.py)
- [scripts/refine-kb-chunks.py](../scripts/refine-kb-chunks.py)
- [scripts/build-chunk-index.py](../scripts/build-chunk-index.py)
- [scripts/sync-staging-to-ctxvault.ps1](../scripts/sync-staging-to-ctxvault.ps1)

### Official-DOCX support

- [scripts/preflight-docx.py](../scripts/preflight-docx.py)
- [scripts/extract-official-sources.ps1](../scripts/extract-official-sources.ps1)
- [scripts/normalize-master-markdown.py](../scripts/normalize-master-markdown.py)
- [templates/docx-qa-template.md](../templates/docx-qa-template.md)

## Vault types

The chunk corpus can land in two kinds of vault.

### Running-knowledge vault

Use when the content changes and should keep evolving.

Examples:

- active project notes
- changing procedural docs
- living architecture notes
- current taskboards

### Historical-value vault

Use when the content should remain queryable but mostly immutable.

Examples:

- archived versions
- obsolete code snapshots
- external official documents
- frozen reference material

See [docs/14-ctxvault-and-skills.md](14-ctxvault-and-skills.md).

## Chunking success criteria

A good chunk corpus is:

- identifiable
- reviewable
- queryable
- low-noise
- not too large
- not too tiny
- explicitly staged before indexing
- still traceable back to the source drop and section when the material came from an official source workbench
