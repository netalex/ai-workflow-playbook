# Token cost policy

## Why token cost is a design concern

Token cost is not just a billing problem.

It affects:

- latency
- focus
- reviewability
- retrieval quality
- the temptation to dump too much context into the model

A sloppy context strategy wastes money and weakens answers at the same time.

## Core policy

Every task should try to answer:

**What is the smallest context that still preserves quality?**

## Cost-reduction priorities

1. prefer a narrow repomix over raw repository access
2. prefer staged `ai-input/` material over broad filesystem MCP access
3. prefer pre-chunked vault retrieval over raw document dumps
4. prefer structure-only context when full content is not necessary
5. prefer composite bundles over monolithic bundles
6. convert repeated prompting into templates or skills
7. archive historical material in a dedicated vault instead of dragging it into current prompts
8. for official source drops, do the noisy work in a local workbench before anything becomes part of the normal LLM-visible surface

## Practical rules

### Rule 1

Do not expose the entire repository to the LLM by default.

### Rule 2

Do not index raw documents directly into the vault.

### Rule 3

Do not include whole directories in repomix when a handful of files would do.

### Rule 4

Do not keep paying for the same instruction every session.

Convert it into:

- a template
- a skill
- a script
- a hook
- a documented policy

### Rule 5

Estimate bundle size and split when needed.

### Rule 6

Do not let probe extraction output become the canonical corpus for official documents.

Probe output is useful because it is noisy. It is cheap to inspect once and expensive to keep dragging into every future prompt.

### Rule 7

Treat screenshots and high-value figures selectively.

Do not dump every extracted image into an LLM session. Promote only the screenshots that actually carry workflow, UI, or system knowledge.

## Useful heuristics

- a structure-only bundle is often enough for planning
- a last-commit bundle is often enough for review
- a refined chunk corpus is often better than a single big document
- a skill is cheaper than repeating a long operational prompt forever
- a workbench repo is cheaper than mixing raw official drops into the main project surface too early

## Good question to ask the AI

```text
Given this task, suggest the minimum useful set of files or modules for a repomix bundle.
Also tell me what should stay structure-only, be excluded from the content pass, or be fully excluded to reduce token cost.
```

For official documents, a better version is:

```text
Given this source drop, which files should be treated as raw evidence only, which should become master markdown, and which chunk families deserve first-class promotion into the knowledge base?
```

## Success condition

The workflow is healthy when smaller inputs still produce high-quality outputs.
