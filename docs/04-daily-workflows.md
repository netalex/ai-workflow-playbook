# Daily workflows

## 1. New feature or enhancement

### Best when

You know the outcome, but the implementation path still needs structure.

### Sequence

1. define the deliverable
2. define the acceptance criteria
3. identify the smallest relevant code area
4. generate a focused repomix or select a vault subset
5. ask for analysis and options first
6. choose the preferred option yourself
7. execute in VS Code through Cline or Copilot
8. validate locally
9. preserve useful findings in docs or vaults
10. end in a commit-ready state

### Good output from AI

- implementation plan
- touched-files list
- trade-offs
- code draft
- validation checklist
- Conventional Commit suggestion

## 2. Refactor

### Best when

You want to improve structure without changing behavior.

### Sequence

1. state the behavioral boundary explicitly
2. capture the current file slice
3. ask for refactor options with trade-offs
4. select one option
5. implement in bounded steps
6. validate behavior after each step
7. record any new architectural rule or constraint

### Rule

Never start a refactor with only “clean this up.”

## 3. Bug investigation

### Best when

You have symptoms, logs, reproduction steps, or a failing test.

### Sequence

1. capture the symptom
2. capture expected behavior
3. capture actual behavior
4. isolate the likely subsystem
5. package only the relevant code and logs
6. ask for ranked hypotheses
7. verify the root cause locally
8. record the confirmed cause in durable notes

### Good prompt shape

- symptom
- expected behavior
- actual behavior
- reproduction steps
- relevant logs
- known exclusions

## 4. Documentation work

### Best when

You need to transform scattered material into structured, durable knowledge.

### Sequence

1. collect raw notes
2. decide whether the target belongs in the repo or in a vault
3. ask for structure first
4. ask for prose second
5. remove duplication
6. convert stable text into versioned documentation
7. turn repeated prompt patterns into templates or skills

### Useful outputs

- ADR draft
- architecture summary
- setup guide
- migration runbook
- taskboard
- open questions list
- reusable skill

## 5. Session recovery after interruption

### Sequence

1. read the latest durable notes
2. inspect the current Git diff
3. inspect the latest repomix output if relevant
4. read the last taskboard or open questions note
5. restate the original goal in one paragraph
6. decide the next smallest step
7. continue only after the scope is clear again

## 6. Official source drop or sensitive document workbench

### Best when

You receive official documentation that is large, sensitive, high-value, or structurally fragile.

### Sequence

1. freeze the originals in a dedicated workbench repo or workbench area
2. create working copies for technical normalization only
3. write confidentiality, source-priority, and encoding rules first
4. run DOCX preflight QA before conversion
5. run a probe extraction to surface styles, TOC noise, review artifacts, and media
6. run a cleaner master extraction for human reading
7. build canonical chunks from the reviewed outputs, not from raw documents
8. produce source maps, conflict registers, and screenshot inventories
9. promote only validated artifacts into the main project repo or a vault

### Rule

Do not treat the main project repository as the first landing zone for raw official source drops.

## 7. Document ingestion work

### Best when

You have new source documents that must become queryable knowledge.

### Sequence

1. store the raw documents in an ingestion drop
2. extract markdown using a controlled converter
3. normalize the markdown
4. chunk the documents
5. refine the chunks
6. build indexes and manifests
7. manually spot-check the chunk corpus
8. copy only pre-chunked material to staging
9. index the staged content into the correct vault

See [docs/11-document-ingestion-and-chunking.md](11-document-ingestion-and-chunking.md).

## 8. Repeated prompting work

### Rule

If a prompt or instruction affects repeated work, do not keep paying for it as transient chat.

Turn it into one of these:

- repository template
- vault note
- skill
- script comment
- hook behavior
