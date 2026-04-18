# Repomix automation

## Why automate repomix

Manual bundling does not scale well.

The goal of automation is not “generate more bundles.” The goal is:

- faster context refresh
- consistent packaging
- lower token cost
- less prompt repetition
- smaller LLM-visible surface area

## Main scripts

### `scripts/repomix-compose.ps1`

Generates configurable, issue-focused repomix bundles from JSON configs.

Use it when:

- the LLM suggests a new bundle shape
- you want a composite output with structure and content separated
- you want named issue bundles that can be reused

### `scripts/refresh-ai-input.ps1`

Refreshes the `ai-input/` directory and workspace snapshot.

Use it when:

- starting a new session
- after a commit
- after branch switches or merges
- before handing the task to a reasoning tool

### `scripts/install-git-hooks.ps1`

Installs the repository hook path and enables automated refresh behavior.

## Composite repomix pattern

The repository includes a configurable pattern inspired by real-world usage:

1. generate a **structure-only** repomix for a broad area
2. generate a **content** repomix for the precise files
3. merge the two into a single issue-oriented context file

This keeps the shape of the repository visible without paying full token cost for every file.

## Config-driven bundles

The example config lives at:

- [config/repomix/issues/repomix-config.example.json](../config/repomix/issues/repomix-config.example.json)

A practical workflow is:

1. explain the task to the reasoning assistant
2. ask which modules, files, and exclusions should be active
3. encode that suggestion into a config file
4. run `repomix-compose.ps1`
5. place the output in `ai-input/`

## Git hooks in this repository

### `post-commit`

After each commit, refreshes `ai-input/` and generates small, task-relevant context artifacts.

### `post-checkout`

After changing branches or restoring files, refreshes the input snapshot.

### `post-merge`

After a merge, refreshes the input snapshot to avoid stale context.

## Why hooks are useful

They reduce three common failures:

- stale bundle content
- stale branch metadata
- forgetting to regenerate the current LLM input

## Hook safety rules

The hooks should be helpful, not intrusive.

Recommended safeguards:

- keep them fast
- allow skipping them with an environment variable
- make failure non-destructive
- regenerate small bundles, not giant exports

The bundled hooks use `AI_WORKFLOW_SKIP_HOOKS=1` as an opt-out.

## Manual usage examples

### Generate an issue bundle

```powershell
pwsh ./scripts/repomix-compose.ps1 -Slug example
```

### Generate an issue bundle with a timestamp

```powershell
pwsh ./scripts/repomix-compose.ps1 -Slug example -WithTimestamp
```

### Refresh `ai-input/`

```powershell
pwsh ./scripts/refresh-ai-input.ps1
```

### Install hooks

```powershell
pwsh ./scripts/install-git-hooks.ps1
```

## Documentation rule

If the automation changes what the LLM sees, document it in the repository.

That includes:

- generated bundle locations
- hook behavior
- skip rules
- config file conventions
