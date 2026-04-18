# Context pipeline

## Purpose

The context pipeline exists to answer one question well:

**What is the smallest useful context that still lets the AI do good work?**

This playbook uses two main lanes:

1. **repository context packaging** with repomix
2. **document knowledge packaging** with pre-chunked vault material

For especially sensitive or official source drops, the document lane often expands into a **workbench lane** that exists before either the main project repo or the vault.

## Core rule

Do not treat raw files, raw repositories, and raw documents as the default input format for LLMs.

Prepare context first.

## Lane A: repository context

Use this lane when the task is code-centric.

### Preferred order

1. collect the task boundary
2. identify the active module or files
3. generate a focused repomix
4. place the result in `ai-input/`
5. expose only the staged bundle to the reasoning tool when possible

### Why this helps

- smaller prompts
- repeatable context
- easier review
- less accidental leakage
- lower token cost

## Lane B: document knowledge context

Use this lane when the task depends on functional, architectural, procedural, or historical documentation.

### Preferred order

1. extract markdown from source documents
2. normalize structure
3. chunk by headings and semantic boundaries
4. refine the chunk corpus
5. build indexes and manifests
6. stage the pre-chunked output
7. index only that staged output into the vault

### Why this helps

- better retrieval quality
- better chunk identity
- less duplication
- better control over stale or immutable material
- lower token cost during retrieval

## Lane C: official document workbench

Use this lane when the sources are:

- official
- sensitive
- large
- screenshot-heavy
- likely to contain conflicting or historically layered information

### Preferred order

1. freeze originals in a workbench repo or workbench directory
2. create technical working copies
3. run DOCX preflight QA
4. run probe extraction and master extraction locally
5. inspect style noise, TOC artifacts, tracked changes, and media behavior
6. build canonical chunks, source maps, and conflict registers
7. promote only validated artifacts into the main project repo or vault

### Why this helps

- preserves provenance
- keeps raw official sources out of the normal LLM surface area
- separates noisy working material from project-facing truth
- gives you a place to handle screenshot inventories and source conflicts deliberately

## Material classes

### Transient

Transient material is short-lived and disposable.

Examples:

- scratch prompts
- one-off summaries
- temporary exports
- ad-hoc bundles for a single issue

### Durable

Durable material should survive the session.

Examples:

- README content
- operating notes
- taskboards
- open questions
- skills
- normalized chunk corpus
- commit-ready docs
- screenshot inventories for legacy UI evidence

## Durable destinations

Choose one deliberately.

### Repository docs

Use when the content is:

- part of the public or team-visible workflow
- versioned with the code
- useful to other humans

### Running-knowledge vault

Use when the content changes often.

Examples:

- current taskboard
- current snapshot
- in-progress operating notes
- evolving prompt rules

### Historical-value vault

Use when the content should remain queryable but should not mutate.

Examples:

- obsolete code snapshots
- archived designs
- immutable external documents
- prior-generation system references

### Workbench repository or workbench area

Use when the content is too raw, too sensitive, or too operationally noisy to belong yet in either the main project repo or a vault.

Examples:

- original official source drops
- working copies of DOCX files
- probe extraction output
- screenshot inventories still under review
- conflict registers comparing old internal docs against new official sources

See [docs/16-official-document-workbench.md](16-official-document-workbench.md).

## Filesystem MCP boundary

A practical safety pattern is:

- repomix or stage the needed input
- place it in `ai-input/`
- expose only `ai-input/` to filesystem MCP

This reduces both token cost and accidental overexposure.

The same principle applies to official document workbenches: do not expose the raw workbench by default just because it exists locally.

## Success condition

The pipeline is working when you can answer:

- why this context was chosen
- what was deliberately excluded
- where durable knowledge will be stored afterward
- whether the material first belongs in a workbench before it belongs in the main project surface
