# Daily workflows

## 1. New feature or enhancement

### Best when
You know the target outcome but need help structuring the work.

### Sequence
1. define the deliverable
2. identify the smallest relevant code area
3. package focused context
4. ask the reasoning tool for a plan
5. move to the editor agent for implementation
6. validate locally
7. convert useful conclusions into docs or notes
8. end on a clean commit-ready state

### Good output from AI
- implementation plan
- touched files list
- risk notes
- test checklist
- commit suggestion

## 2. Refactor

### Best when
You want to improve structure without changing behavior.

### Sequence
1. state the behavioral boundary clearly
2. gather the current code slice
3. ask for refactor options with trade-offs
4. choose one path explicitly
5. apply in small reviewable steps
6. compare before/after behavior
7. document any new architectural rule

### Rule
Never start a refactor with “clean this up” as the only instruction.

## 3. Bug investigation

### Best when
You have symptoms, logs, or a failing flow.

### Sequence
1. capture the symptom
2. capture reproduction steps
3. isolate the likely subsystem
4. give the AI only the relevant evidence
5. ask for hypotheses ranked by probability
6. validate one hypothesis at a time
7. record the actual root cause once confirmed

### Good prompt shape
- symptom
- expected behavior
- actual behavior
- constraints
- relevant files
- logs or traces

## 4. Documentation work

### Best when
You need to transform scattered material into structured, durable knowledge.

### Sequence
1. collect raw notes
2. identify the target doc type
3. ask for structure first, prose second
4. review terminology
5. publish only after cleanup and deduplication

### Useful outputs
- ADR draft
- architecture summary
- setup guide
- taskboard snapshot
- open questions list

## 5. Session recovery after interruption

### Sequence
1. read the latest durable notes
2. review the current git diff
3. recover the original goal
4. restate the next smallest step
5. continue only after the state is understandable again

## End-of-session checklist

- current task is named clearly
- useful findings are written down
- transient chat is distilled into durable notes
- repository is left in a readable state
- next action is obvious
