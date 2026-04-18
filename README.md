# AI Workflow Playbook

An opinionated, human-in-the-loop workflow for using AI across documentation, coding, refactoring, debugging, and repository hygiene.

This repository documents a practical stack centered on:

- **Claude Desktop** for deep reasoning and project-level context
- **VS Code** for day-to-day development
- **Cline** and/or **GitHub Copilot** for in-editor execution
- **CtxVault** for durable local knowledge management
- **Repomix** for focused context bundles
- Optional MCP servers for filesystem access, debugging, browser automation, and domain-specific tooling

The workflow is designed for people who want strong AI assistance **without surrendering architectural control**.

## Why this exists

Most AI workflow write-ups are too generic. This one is built around a stricter model:

- the human stays accountable for decisions
- context is curated, not dumped
- maintainability beats flashy shortcuts
- repositories remain readable by humans first
- prompts are treated as operational assets
- every stable step should be documentable, reviewable, and commit-ready

## Who this is for

This playbook is especially useful if you:

- work on medium or large codebases
- need repeatable AI-assisted development patterns
- want to reduce context drift across sessions
- use Windows or mixed local tooling
- care about long-lived project memory
- prefer **AI as a senior assistant**, not as an autonomous agent

## Core principles

1. **Work backward from the deliverable**
2. **Feed only the context that matters**
3. **Prefer reviewable diffs over giant rewrites**
4. **Separate transient chat from durable knowledge**
5. **Keep prompts and procedures versioned**
6. **Treat AI outputs as drafts until verified**
7. **Standardize the handoff from reasoning to code**

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
│   │   ├── bug_report.md
│   │   └── feature_request.md
│   └── pull_request_template.md
├── docs/
│   ├── 01-overview.md
│   ├── 02-stack.md
│   ├── 03-setup-windows.md
│   ├── 04-daily-workflows.md
│   ├── 05-context-pipeline.md
│   ├── 06-prompting-policy.md
│   ├── 07-publishing-checklist.md
│   ├── 08-adoption-roadmap.md
│   └── 09-github-metadata.md
├── templates/
│   ├── system-prompt.md
│   ├── session-kickoff.md
│   ├── implementation-request.md
│   ├── review-request.md
│   └── commit-style.md
└── scripts/
    ├── check-tools.ps1
    └── pre-publish-checklist.ps1
```

## Quick start

1. Read [docs/01-overview.md](docs/01-overview.md)
2. Map your local toolchain with [docs/02-stack.md](docs/02-stack.md)
3. Configure the environment with [docs/03-setup-windows.md](docs/03-setup-windows.md)
4. Adopt one workflow from [docs/04-daily-workflows.md](docs/04-daily-workflows.md)
5. Version your prompts using [templates/](templates/)
6. Run the checks in [docs/07-publishing-checklist.md](docs/07-publishing-checklist.md)

## Recommended operating rhythm

### **Before a session**

- clarify the deliverable
- fetch only the relevant project context
- define the success conditions

### **During a session**

- keep the AI focused on one bounded task
- review partial outputs early
- preserve useful decisions in durable notes

### **At the end of a session**

- convert useful chat into repository assets
- update docs, prompts, and operational notes
- produce a clean commit or a clean stopping point

## What makes this workflow different

This is not a “one model replaces the team” setup.

It is a **layered workflow**:

- one tool for deep thinking
- one tool for code editing
- one system for durable memory
- one pipeline for targeted context preparation
- one human owner making final decisions

That separation keeps the stack understandable and replaceable.

## Publishing notes

This repository is intentionally documentation-first so it can be published as-is, forked, or adapted to a team-specific or company-specific workflow.

Before publishing publicly, review:

- personal names
- internal URLs
- company-specific paths
- secrets or tokens
- proprietary prompt text
- screenshots containing internal information

See [docs/07-publishing-checklist.md](docs/07-publishing-checklist.md).

## License

This repository currently ships with the MIT License for easy reuse. Replace it if you need a different licensing model.
