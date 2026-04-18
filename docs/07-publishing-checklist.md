# Publishing checklist

Use this before making the repository public.

## Safety and privacy

- [ ] remove tokens, secrets, cookies, and keys
- [ ] remove private URLs or replace them with placeholders
- [ ] remove internal screenshots or diagrams
- [ ] replace personal filesystem paths where needed
- [ ] review prompt files for confidential wording
- [ ] ensure no proprietary code is embedded in examples
- [ ] review example `claude_desktop_config.json` paths
- [ ] review hook scripts for local-path assumptions

## Clarity

- [ ] README explains the workflow quickly
- [ ] VS Code is clearly identified as the execution base
- [ ] token-cost priorities are explicit
- [ ] docs do not assume hidden context
- [ ] each script is documented in the repository
- [ ] vault types are explained clearly
- [ ] human vs AI responsibility is explicit

## Maintainability

- [ ] repeated instructions live in templates, skills, or docs
- [ ] scripts are commented
- [ ] naming is consistent
- [ ] links between docs resolve correctly
- [ ] the changelog reflects the real content
- [ ] hook automation has an opt-out path

## Public-readiness

- [ ] license is present
- [ ] contribution guidelines exist
- [ ] issue templates exist
- [ ] pull request template exists
- [ ] acknowledgments and references are included
- [ ] no project-specific names remain in the generic playbook

## Final manual pass

Read the repository as if you were an external engineer seeing it for the first time.

If the workflow still depends on knowledge that exists only in your head, publishing is not done yet.
