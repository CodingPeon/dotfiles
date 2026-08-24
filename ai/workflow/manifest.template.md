# Manifest — <feature name>

> **Audience: the Frame phase**, and only when scaffolding a **new** feature — copy this to
> `<area>/<feature>/manifest.md` and fill it in. Every other phase reads the **filled** manifest.
>
> The model behind these fields (all-or-nothing, the two modes, what stays in the workspace, the
> resolution procedure) lives in **`ARTIFACTS.md`** — this file is just the skeleton.

The manifest answers two things: **which repo** this feature belongs to, and **where its artifacts
live**. Anything a phase only *reads* (build commands, APIs, gotchas) belongs in
`context/CONTEXT.md` instead.

```yaml
feature: <human name>
area: <ide | runtime | …>       # groups features sharing a repo + context

repo-remote: <git remote URL>   # stable identity across any clone or worktree. Used only to
                                # VERIFY you're in the right repo (mismatch = STOP), never to
                                # select a feature. Root and branch are always read live.

mode: local                     # local | repo — see ARTIFACTS.md. Decides, all-or-nothing, where
                                # SPEC.md · IMPLEMENTATION_NOTES.md · context/CONTEXT.md ·
                                # plans/ · plans/INDEX.md live:
                                #   repo  → <repo-root>/<artifacts-root>/  (branch-scoped)
                                #   local → the workspace                 (branch-agnostic)

# artifacts-root: <repo-relative dir>   # REQUIRED for mode: repo; omit for local.
                                        # e.g. extensions/examples/<ext>/documentation
```

Field notes:
- **`mode`** — pick `repo` for distributed/team work (or work already committing its docs), `local`
  for solo sequential work where the project repo should carry no workflow docs at all.
- **`artifacts-root`** — only meaningful in `repo` mode. The four filenames beneath it are fixed by
  convention (`SPEC.md`, `IMPLEMENTATION_NOTES.md`, `context/CONTEXT.md`, `plans/INDEX.md`).
- **`manifest.md` and `<area>/CONTEXT.md` always stay in the workspace**, in both modes.
