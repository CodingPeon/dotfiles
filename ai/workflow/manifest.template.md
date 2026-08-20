# Manifest — <feature name>

> **Audience: the Frame phase**, and only when scaffolding a **new** feature — copy this to
> `<area>/<feature>/manifest.md` and fill it. Every other phase reads the **filled** manifest in
> the feature folder, never this template.

Per-feature config. Its only job: **repo identity + what promotes into the project repo.**
Anything a phase only *reads* (build commands, schema locations, APIs) belongs in the
`<area>/CONTEXT.md`, not here.

```yaml
feature: <human name>
area: <ide | runtime>
repo-remote: <git remote URL>        # stable identity; matches this feature to the repo
                                      # across any clone/worktree. Root + branch are read live.
target: <sub-path variable, e.g. the extension name>   # optional, for the paths below

# Artifacts DUPLICATED into the project repo (Implement promotes on close by writing/merging
# into the WORKING TREE — never commits). Omit an artifact → it stays ephemeral (workspace only).
#   mode: merge   → fold this feature's slice into the existing repo file (shared docs)
#         replace → overwrite a file this feature solely owns
duplicate-to-repo: []
#   - { artifact: spec,  path: <repo-relative path>, mode: merge }
#   - { artifact: notes, path: <repo-relative path>, mode: merge }
```

Notes:
- **Default is empty** → nothing ever leaves the workspace; the project repo stays clean.
- The `path`s double as the **canonical sources** Frame/Plan read to build on top of prior work.
- No `commit` and no `branch` fields — humans own all git; the agent uses whatever branch is
  checked out and never commits.
