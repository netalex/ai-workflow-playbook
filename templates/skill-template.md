# Skill template

Use this when a repeated prompt should become a durable skill.

```markdown
---
title: <skill title>
type: skill
scope: <general | repo-specific | document-ingestion | repomix | review | bug-investigation>
status: active
owner: human-reviewed
---

# Purpose

Explain what repeated work this skill standardizes.

# Inputs

List the expected inputs.

# Procedure

1. Step one
2. Step two
3. Step three

# Output requirements

List the expected shape of the result.

# Guardrails

List the boundaries and things to avoid.

# Promotion rule

Explain when the result should be stored in the repository, in a running-knowledge vault, or in a historical-value vault.
```
