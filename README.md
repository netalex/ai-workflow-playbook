# AI Workflow Playbook

An opinionated, human-in-the-loop workflow for using AI across documentation, coding, refactoring, debugging, knowledge management, and repository hygiene.

This playbook is built around one primary idea: **use VS Code as the execution base, keep durable knowledge outside chat silos, and optimize every step for reviewability and token efficiency**.

## What this repository covers

- a **VS Code-first** operating model
- a split between **reasoning**, **execution**, **memory**, and **context packaging**
- a full **document ingestion and chunking pipeline**
- a stronger pattern for **official document workbenches** when sources are sensitive, high-value, or structurally complex
- **CtxVault** as durable local memory for both knowledge and custom skills
- **Repomix** as the main context-packaging layer
- **Claude Desktop**, **Cline**, **GitHub Copilot**, and **MCP servers** used in well-defined roles
- **PowerShell, Python, and Git hook automation** for repeatable daily work
- a strong bias toward **lower token cost**, smaller bundles, and deliberate context curation

## Why this exists

Many AI workflow write-ups stop at “use a chat app and an editor plugin.” That is not enough for real projects.

This repository documents a stricter model:

1. the human stays accountable for architecture and acceptance
2. context is **prepared**, not dumped
3. durable knowledge lives in **versioned docs or vaults**
4. code assistants work best when the context is **bounded and pre-filtered**
5. token cost is a first-class concern, not an afterthought
6. repeated work should become a **template, script, hook, or skill**
7. official source drops may deserve a **separate document workbench repository** before anything is promoted into the main project repo

## Core priorities

1. **Correctness before speed**
2. **Maintainability before cleverness**
3. **Token reduction before convenience dumping**
4. **Curated context before full-repo exposure**
5. **Human review before acceptance**
6. **Durable notes before chat memory**
7. **Small reviewable diffs before giant rewrites**

## Operating model in one view

```text
Task
  -> choose the smallest useful context
  -> package it with repomix or pre-chunked vault material
  -> reason in Claude Desktop
  -> execute in VS Code through Cline or Copilot
  -> validate locally
  -> preserve useful knowledge in docs or ctxvault
  -> commit with Conventional Commits best practices
```

For large official document sets, the workflow may branch into a more explicit path:

```text
Official source drop
  -> freeze originals in a workbench repo
  -> QA the DOCX structure before conversion
  -> run probe + master extraction locally
  -> build canonical chunks and indexes
  -> promote only validated artifacts into the project repo or vault
```

## Repository structure

```text
.
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── CHANGELOG.md
├── .editorconfig
├── .gitignore
├── .github/
│   ├── ISSUE_TEMPLATE/
│   ├── pull_request_template.md
├── .githooks/
│   ├── post-checkout
│   ├── post-commit
│   └── post-merge
├── ai-input/
│   └── README.md
├── config/
│   ├── claude/
│   │   └── claude_desktop_config.example.json
│   └── repomix/
│       └── issues/
│           └── repomix-config.example.json
├── docs/
│   ├── 01-overview.md
│   ├── 02-stack.md
│   ├── 03-setup-windows.md
│   ├── 03-setup-linux.md
│   ├── 04-daily-workflows.md
│   ├── 05-context-pipeline.md
│   ├── 06-prompting-policy.md
│   ├── 07-publishing-checklist.md
│   ├── 08-adoption-roadmap.md
│   ├── 09-github-metadata.md
│   ├── 10-tooling-and-mcp.md
│   ├── 11-document-ingestion-and-chunking.md
│   ├── 12-repomix-automation.md
│   ├── 13-human-vs-ai.md
│   ├── 14-ctxvault-and-skills.md
│   ├── 15-token-cost-policy.md
│   ├── 16-official-document-workbench.md
│   └── 17-docx-preflight-and-dual-extraction.md
├── scripts/
│   ├── build-chunk-index.py
│   ├── build-kb-chunks.py
│   ├── check-tools.ps1
│   ├── extract-official-sources.ps1
│   ├── install-git-hooks.ps1
│   ├── normalize-master-markdown.py
│   ├── pre-publish-checklist.ps1
│   ├── preflight-docx.py
│   ├── refresh-ai-input.ps1
│   ├── refine-kb-chunks.py
│   ├── repomix-compose.ps1
│   ├── run-ingestion-pipeline.ps1
│   ├── switch-claude-profile.ps1
│   ├── sync-staging-to-ctxvault.ps1
│   └── test-ingestion-prerequisites.ps1
└── templates/
    ├── commit-style.md
    ├── docx-qa-template.md
    ├── implementation-request.md
    ├── review-request.md
    ├── session-kickoff.md
    ├── skill-template.md
    └── system-prompt.md
```

## Quick start

1. Read [docs/01-overview.md](docs/01-overview.md).
2. Treat [docs/02-stack.md](docs/02-stack.md) as the architectural map.
3. Set up the environment from [docs/03-setup-windows.md](docs/03-setup-windows.md) or [docs/03-setup-linux.md](docs/03-setup-linux.md).
4. Configure Claude Desktop with the example in [config/claude/claude_desktop_config.example.json](config/claude/claude_desktop_config.example.json).
5. Install the Git hooks with `pwsh ./scripts/install-git-hooks.ps1`.
6. Read [docs/11-document-ingestion-and-chunking.md](docs/11-document-ingestion-and-chunking.md) before indexing any vault.
7. Read [docs/16-official-document-workbench.md](docs/16-official-document-workbench.md) if your sources are official, sensitive, or structurally fragile.
8. Read [docs/12-repomix-automation.md](docs/12-repomix-automation.md) before exposing repository context to an LLM.

## Recommended operating rhythm

### Before a session

- clarify the deliverable
- identify the smallest relevant code or document slice
- decide what belongs in the repository, what belongs in a vault, and what should stay transient
- prepare a focused repomix or pre-chunked vault subset

### During a session

- keep the AI on one bounded task
- ask for analysis before implementation when the work is non-trivial
- expose only the directories needed for the task
- capture stable findings as notes, docs, or skills

### At the end of a session

- refresh `ai-input/` if needed
- promote durable output into docs, code, or vaults
- update running knowledge
- leave a clean stopping point and a Conventional Commit-ready summary

## Human vs AI

The separation is deliberate.

### The human owns

- deliverable definition
- architecture decisions
- approval of prompts, skills, and hooks
- acceptance criteria
- review of code, docs, generated context, and official source interpretation
- final commit and publish decision

### The AI owns

- synthesis
- first-draft structure
- bounded code transformations
- summarization
- bundle suggestions
- proposed task decomposition
- candidate prompts, skills, and commit messages

See [docs/13-human-vs-ai.md](docs/13-human-vs-ai.md).

## Token cost is part of the architecture

This workflow assumes token waste is a real operational cost.

That changes the design:

- vaults contain **only pre-chunked material**
- large documents are normalized and chunked before indexing
- repomix is configured, not sprayed over the whole repository
- filesystem MCP can be restricted to `ai-input/` and a few safe directories
- repeated work becomes scripts, hooks, or skills instead of repeated prompting
- official source drops should often be processed in a **workbench repo** before anything is promoted into the main project knowledge surface

See [docs/15-token-cost-policy.md](docs/15-token-cost-policy.md).

## Security boundary: use `ai-input/`

A useful hardening pattern is to expose only a dedicated `ai-input/` directory to filesystem MCP, instead of the whole repository.

That gives you three benefits:

1. less accidental repository exposure
2. lower token usage
3. better control over what the LLM is allowed to read directly

The rest of the repository can still be reachable indirectly through repomix bundles, staged docs, or curated vault material.

See [ai-input/README.md](ai-input/README.md).

## Acknowledgments and references

This playbook stands on top of tools and open work created by others.

- **CtxVault** by **Filippo Venturini**: local semantic memory for knowledge and skills  
  <https://github.com/Filippo-Venturini/ctxvault>
- **Repomix** by **Yamada Shota and contributors**: repository packaging for AI-friendly context  
  <https://repomix.com/>  
  <https://github.com/yamadashy/repomix>
- **Cline**: open coding agent inside the editor  
  <https://cline.bot/>  
  <https://github.com/cline/cline>
- **GitHub Copilot**: inline and chat-based coding assistance in VS Code  
  <https://github.com/features/copilot>
- **Claude Desktop**: reasoning workspace and MCP host  
  <https://claude.ai/download>
- **Model Context Protocol (MCP)**: open protocol for connecting AI applications to tools and data  
  <https://modelcontextprotocol.io/>
- **Pandoc**, **Docling**, **Mammoth**, and related local document tooling are also central to the official-document pipeline described in this repository.

The workflow described here is an integration pattern built around those tools. The value is in the orchestration, not in pretending the underlying tools came from nowhere.

## Publishing note

This repository is intentionally generic and agnostic.

Before publishing your own fork publicly, review:

- personal names
- internal URLs
- company paths
- example config paths
- hidden proprietary prompt text
- documents, screenshots, and bundles that may contain private information

See [docs/07-publishing-checklist.md](docs/07-publishing-checklist.md).

## License

This repository currently ships with the MIT License for easy reuse. Replace it if you need a different licensing model.
