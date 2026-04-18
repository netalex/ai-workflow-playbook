# DOCX QA template

Use this when a DOCX file should be reviewed before extraction and chunking.

```markdown
# QA - <document title>

## Document metadata

- Source filename:
- Working copy filename:
- Drop or intake batch:
- QA date:
- Reviewer:
- Overall status: `not-started` | `in-progress` | `blocked` | `completed`
- Conversion risk: `low` | `medium` | `high`

## 1. Executive summary

### Overall assessment
-

### Main risks for conversion
-

### Main strengths
-

## 2. Formal structure review

### 2.1 Title and heading hierarchy
- [ ] Document title is clearly identifiable
- [ ] Heading 1 levels are coherent
- [ ] Heading 2 levels are coherent
- [ ] Heading 3+ levels are coherent
- [ ] No fake headings made only with bold or font size
- Notes:

### 2.2 Lists and numbering
- [ ] Ordered lists are real Word lists
- [ ] Bullet lists are real Word lists
- [ ] Nested lists are preserved correctly
- [ ] Numbering is not simulated manually
- Notes:

### 2.3 Tables
- [ ] Tables have recognizable headers
- [ ] No critical fake tables made with spaces or tabs
- [ ] Merged cells are limited or manageable
- [ ] No layout-only tables that may pollute extraction
- Estimated number of relevant tables:
- High-risk tables:
- Notes:

### 2.4 Images and screenshots
- [ ] Images are present in expected positions
- [ ] Screenshots appear functionally relevant
- [ ] Captions exist where useful
- [ ] Image anchoring seems stable enough
- Estimated number of images or screenshots:
- Key screenshots to preserve:
- Notes:

### 2.5 Text boxes, shapes, SmartArt, floating objects
- [ ] No text boxes detected
- [ ] No SmartArt detected
- [ ] No floating text objects with functional content detected
- Detected risky objects:
- Notes:

### 2.6 Headers, footers, page numbers, watermarks
- [ ] Header contains only ornamental or administrative info
- [ ] Footer contains only ornamental or administrative info
- [ ] No critical content appears only in header or footer
- [ ] Page numbering is present or useful
- Notes:

### 2.7 Breaks, sections, columns
- [ ] Section breaks are absent or manageable
- [ ] Page breaks are harmless
- [ ] Multi-column layout is absent
- Detected layout risks:
- Notes:

### 2.8 Comments, revisions, tracked changes
- [ ] No comments detected
- [ ] No tracked changes detected
- [ ] No unresolved revisions detected
- Detected review artifacts:
- Notes:

### 2.9 Hyperlinks, cross-references, bookmarks
- [ ] Hyperlinks are present and readable
- [ ] Internal cross-references are understandable
- [ ] Bookmarks do not carry critical hidden meaning
- Notes:

### 2.10 Special characters and encoding-sensitive content
- [ ] Apostrophes and quotes look normal
- [ ] Bullets and symbols look normal
- [ ] No suspicious encoding artifacts detected
- [ ] No copy-paste corruption visible
- Notes:

## 3. Content extraction relevance

### 3.1 Functional knowledge
- [ ] Functional flows are clearly readable
- [ ] Actors or roles are identifiable
- [ ] Business rules are identifiable
- [ ] Validation rules are identifiable
- Notes:

### 3.2 Technical knowledge
- [ ] Systems or components are identifiable
- [ ] Integration points are identifiable
- [ ] As-is vs to-be distinction is identifiable
- [ ] Historical or evolutionary notes are identifiable
- Notes:

### 3.3 UI or screenshot evidence
- [ ] Legacy screens are present
- [ ] Screens can be mapped to functions
- [ ] UI elements are interpretable from screenshots
- [ ] Screenshots are numerous enough to justify dedicated chunking
- Notes:

## 4. Recommended normalization before extraction

### Safe minimal edits on working copy
- [ ] None needed
- [ ] Normalize heading styles
- [ ] Fix fake lists
- [ ] Add or remove empty paragraphs
- [ ] Re-anchor critical images
- [ ] Flatten problematic text boxes manually
- [ ] Accept tracked changes on a dedicated duplicate copy only
- Notes:

## 5. Extraction strategy recommendation

### Pandoc
- Recommended: `yes` / `no`
- Notes:

### Docling
- Recommended: `yes` / `no`
- Notes:

### Mammoth QA pass
- Recommended: `yes` / `no`
- Notes:

### Manual screenshot inventory needed
- Recommended: `yes` / `no`
- Notes:

## 6. Chunking notes

### Proposed chunk families
- [ ] functional-requirements
- [ ] business-rules
- [ ] ui-legacy
- [ ] integrations
- [ ] architecture
- [ ] as-is
- [ ] to-be
- [ ] historical-context
- Notes:

### Candidate chunk boundaries
-

## 7. Findings log

### Confirmed facts
-

### Open questions
-

### Conflicts or ambiguities
-

## 8. Final QA verdict

- Ready for extraction: `yes` / `no`
- Ready for chunking after extraction: `yes` / `no`
- Manual remediation required before extraction: `yes` / `no`

### Final notes
-
```
