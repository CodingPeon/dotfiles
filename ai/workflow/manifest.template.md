# Manifest — <feature name>

> **Audience: the Frame phase**, and only when scaffolding a **new** feature — copy this to
> `<area>/<feature>/manifest.md` and fill it. Every other phase reads the **filled** manifest.

The manifest answers two things: **which repo** this feature belongs to, and **where its
artifacts live**. Nothing else — anything a phase only *reads* (build commands, APIs, gotchas)
belongs in `context/CONTEXT.md`.

```yaml
feature: <human name>
area: <ide | runtime>
repo-remote: <git remote URL>   # stable identity — matches feature↔repo across any clone or
                                # worktree. Root and branch are always read live, never stored.

# WHERE THE ARTIFACTS LIVE — all-or-nothing, never split. The set is:
#   SPEC.md · IMPLEMENTATION_NOTES.md · context/CONTEXT.md · plans/ · plans/INDEX.md
#   repo  = they live IN the project repo under artifacts-root, branch-scoped, merging through git
#           like the code they describe. For distributed/team work, or work already committing docs.
#   local = they live in the workspace, branch-agnostic; the project repo carries no workflow docs
#           at all. For solo, sequential development.
mode: local

# repo mode only — repo-relative directory the artifacts live under.
# artifacts-root: <e.g. extensions/examples/<ext>/documentation>
```

## Why all-or-nothing

Splitting the set across the two homes is incoherent: a workspace `INDEX.md` claiming a plan is
`done` **lies the moment you check out a branch where that work doesn't exist**. Branch-scoped
artifacts (repo) and branch-agnostic ones (workspace) cannot describe each other. So SPEC, NOTES,
`plans/` and `INDEX.md` move together.

## Always in the workspace, in both modes

Exactly two, each for a reason:
- **`manifest.md`** — the **locator**; it can't live inside the thing it locates, and it must be
  readable before you know anything about the repo's state.
- **`<area>/CONTEXT.md`** — safe to pin because it may only state facts already on `main`, which
  makes it branch-invariant by construction.

The feature's **`context/`** does *not* stay: it describes branch-scoped reality (file maps,
invariants, modules a feature added), so pinning it would make it lie on any branch without that
work. It follows the mode with SPEC, NOTES and plans. `context/` is a **folder** — `CONTEXT.md`
plus supplementary material (diagrams, PDFs, source dumps); keep anything you don't want committed
out of it, or use `local` mode.

## No promotion, in either mode

Each artifact has exactly **one** home, so nothing is ever staged, copied, or merged between the
two. In `repo` mode phases write straight into the **repo working tree**; the human reviews
`git diff` and commits. In `local` mode nothing touches the repo at all.
