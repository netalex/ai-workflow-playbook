# Official document workbench

## Why this pattern exists

Some document sets are too important to push directly into the normal project workflow.

Typical signs:

- they are official source material
- they carry confidentiality constraints
- they contain screenshots, diagrams, or historically layered information
- they are likely to override internal notes already written by the team
- they are structurally fragile in DOCX form

For those cases, a dedicated **document workbench** is often the safer design.

## Core idea

A workbench repo or workbench area is not the same thing as the main project repo.

The workbench is where you do the noisy, local, traceable processing work.

The main project repo is where you keep project-facing truth.

A useful way to think about it is:

- **workbench = source of processing truth**
- **main project repo = source of project truth**

## The four artifact levels

A strong official-document pipeline separates at least four levels.

### 1. Immutable source originals

These are frozen copies of the delivered files.

Examples:

- DOCX
- draw.io files
- spreadsheets
- static PDFs

Do not edit them in place.

### 2. Technical working copies

These exist only to support safe technical normalization.

Allowed actions may include:

- heading cleanup
- list normalization
- tracked-change handling on a dedicated duplicate copy
- image anchoring fixes when absolutely necessary

This is not editorial rewriting. It is structural remediation.

### 3. Extracted and chunk-ready working material

This includes:

- probe markdown
- master markdown
- structured JSON
- media extraction
- manifests
- QA reports

This layer is still noisy and should not automatically become project truth.

### 4. Promoted project-facing knowledge

This is the material that has survived review and is ready to become:

- validated docs in the main project repo
- curated chunks in a vault
- source maps
- screenshot inventories
- conflict registers
- architecture or requirements notes derived from the source set

## Recommended structure

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

## Governance files worth creating early

Before conversion, create at least these:

- confidentiality policy
- source priority rules
- ingestion rules
- QA template for the source type
- naming rules for chunks, media, and manifests

## Promotion rule

Do not “copy final files by feel” from the workbench into the project repo.

Promote artifacts deliberately.

A promoted artifact should carry enough provenance to answer:

- which drop it came from
- which source file it came from
- when it was extracted
- which script or pipeline produced it
- whether it is draft, validated, or superseded

## What usually stays in the workbench

- immutable originals
- technical working copies
- probe extraction output
- noisy manifests
- raw conversion comparisons
- QA notes that are useful operationally but not project-facing

## What usually gets promoted

- validated authored documentation
- stable chunk corpora
- source maps
- conflict registers
- curated screenshot knowledge units
- clean exports for the main project repo

## Workbench and LLM exposure

A workbench exists partly to reduce unnecessary exposure.

Good default:

- raw source drops stay local
- only selected exports become `ai-input/`
- only reviewed chunk corpora reach the vault
- only validated project-facing artifacts enter the main project repo

## When not to use a workbench

Do not create a dedicated workbench just because it sounds rigorous.

Skip it when:

- the document set is small
- the structure is already clean
- the confidentiality risk is low
- no special screenshot or source-conflict handling is required

## Success condition

The workbench is doing its job when:

- provenance is preserved
- noisy processing artifacts do not pollute the main repo
- official source material does not get pushed into LLMs prematurely
- the team can trace a promoted artifact back to the source drop and extraction path
