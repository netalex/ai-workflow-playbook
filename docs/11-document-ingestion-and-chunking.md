# Document ingestion and chunking

## Why this pipeline exists

Raw documents are a poor default input for LLM retrieval.

A better workflow is:

1. extract markdown
2. normalize it
3. chunk it
4. refine it
5. index only the resulting pre-chunked corpus

That improves retrieval quality and reduces token waste.

## Non-negotiable rule

**Vaults must contain only pre-chunked material.**

That pre-chunking may be:

- produced by the ingestion workflow
- created manually for exceptional documents

But the indexed unit must already be chunk-shaped.

## Pipeline overview

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

## Recommended directory model

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

## Step 1 - Collect source documents

Put source files in `documents-to-ingest/incoming/`.

Examples:

- DOCX
- PDF
- spreadsheets exported to markdown or CSV
- HTML exports
- static reference notes

Do not edit originals in place.

## Step 2 - Extract markdown

Use a converter such as:

- Docling
- MarkItDown
- Pandoc

The goal is not perfect beauty. The goal is a stable markdown base for downstream processing.

## Step 3 - Normalize markdown

Normalization should fix or standardize:

- heading consistency
- broken spacing
- repeated boilerplate
- encoding issues
- path references for images if needed

The output should be “master markdown” suitable for chunking.

The bundled automation starts here.

## Step 4 - Chunk by semantic boundaries

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

## Step 5 - Refine the chunk corpus

Refinement can:

- remove empty chunks
- skip table-of-contents headings
- normalize titles
- extract image references
- extract captions
- add family or category labels
- estimate token size
- spot duplicate titles

This step improves retrieval and review quality.

## Step 6 - Build indexes and manifests

Useful outputs include:

- chunk manifest CSV
- summary by family
- summary by source document
- duplicate-title report
- image or caption report
- markdown summary for manual QA

## Step 7 - Manual QA

Before indexing into a vault, spot-check:

- chunk titles
- chunk boundaries
- obvious duplication
- broken extraction artifacts
- giant chunks that should be split further
- tiny chunks that add no value

## Step 8 - Stage only the pre-chunked output

Copy the refined chunk corpus into a staging directory that represents the final vault-facing material.

Do not stage the raw source files as the retrievable unit.

## Step 9 - Index into CtxVault

Index the staging directory with `ctxvault`.

That keeps the retrieval corpus aligned with the reviewed, pre-chunked material.

## Example scripts in this repository

- [scripts/run-ingestion-pipeline.ps1](../scripts/run-ingestion-pipeline.ps1)
- [scripts/test-ingestion-prerequisites.ps1](../scripts/test-ingestion-prerequisites.ps1)
- [scripts/build-kb-chunks.py](../scripts/build-kb-chunks.py)
- [scripts/refine-kb-chunks.py](../scripts/refine-kb-chunks.py)
- [scripts/build-chunk-index.py](../scripts/build-chunk-index.py)
- [scripts/sync-staging-to-ctxvault.ps1](../scripts/sync-staging-to-ctxvault.ps1)

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
