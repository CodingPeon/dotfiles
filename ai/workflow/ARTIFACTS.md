# ARTIFACTS — where everything lives, and how to find it

**Read this at the start of every phase**, together with `GROUND-RULES.md`. It is the canonical
description of artifact locations; your phase file adds only its own job on top.

## Vocabulary

- **`<area>`** — groups features that share a repo and a context (`ide`, `runtime`, …). A short
  human-chosen label, never derived. Usually one per project repo, but **a monorepo may host
  several under one remote**.
- **`<feature>`** — one body of work you frame as a unit. It's the key to everything below.
- **`<workspace>`** — `~/agile_dotfiles/ai/workflow_artifacts/<area>/<feature>/`
- **`<artifacts-root>`** — a repo-relative directory named in the feature's `manifest.md`
  (`repo` mode only), e.g. `extensions/examples/<ext>/documentation`.

## Locating the feature (runtime procedure)

The **confirmed** feature (see the startup gate in `GROUND-RULES.md`) is the key — **never select
by remote alone**, since several areas can share one:

1. Glob `~/agile_dotfiles/ai/workflow_artifacts/*/<feature>/manifest.md`.
   - one hit → the containing directory **is** its `<area>`;
   - several (same feature name under different areas) → **ask which**;
   - none → nothing is framed for it yet → **Frame** (Frame asks the user which area it belongs to).
2. Read that `manifest.md` — it gives `mode`, `artifacts-root`, and `repo-remote`.
3. **Verify** `git remote get-url origin` against `repo-remote`. **Mismatch = STOP** — wrong
   project, don't touch it. (`repo-remote` only *verifies*; it never *selects*.)
4. Resolve every path from `mode`, per the table below.

Repo root is always read live: `git rev-parse --show-toplevel`. Never store it.

## The all-or-nothing rule

These **five move together** — either all in the project repo or all in the workspace, never split:

> `SPEC.md` · `IMPLEMENTATION_NOTES.md` · `context/CONTEXT.md` · `plans/` · `plans/INDEX.md`

Why: repo files are **branch-scoped**, workspace files are **branch-agnostic**, and the two cannot
describe each other. A workspace `INDEX.md` saying a plan is `done` **lies the moment you check out
a branch where that work doesn't exist**; feature context describing branch-only files does the
same. Splitting guarantees incoherence.

**There is no promotion.** Every artifact has exactly one home — nothing is staged, copied, or
merged between homes. In `repo` mode phases write straight into the **repo working tree** and the
uncommitted `git diff` *is* the pending state; the human reviews and commits.

## Resolution by mode

| | `mode: repo` | `mode: local` |
|---|---|---|
| the five above | `<repo-root>/<artifacts-root>/` | `<workspace>/` |
| branch semantics | branch-scoped; merges through git like code | branch-agnostic, single timeline |
| suits | distributed/team development | solo, sequential development |
| project repo | carries the docs | carries no workflow docs at all |

**Always in the workspace, in both modes** — exactly two, each for a reason:
- **`<workspace>/manifest.md`** — the **locator**; it can't live inside what it locates, and must be
  readable before you know anything about the repo's state.
- **`<area>/CONTEXT.md`** — safe to pin because the main-branch rule (below) makes it
  branch-invariant.

The feature's `context/` does **not** stay put: it describes branch-scoped reality (file maps,
invariants, modules a feature added), so it follows the mode with everything else.

### Layout — `mode: local`
```
~/agile_dotfiles/ai/workflow_artifacts/
   <area>/
      CONTEXT.md                    # repo-wide facts (main-branch rule)
      <feature>/
         manifest.md                # mode: local
         SPEC.md                    # the WHAT
         IMPLEMENTATION_NOTES.md    # what's built, incl. accepted deviations
         context/
            CONTEXT.md              # this feature's working knowledge
            <diagrams, PDFs, source dumps…>
         plans/
            INDEX.md                # the plan registry (status lives ONLY here)
            <id>-<name>.md
<project repo>                      # untouched by the workflow
```

### Layout — `mode: repo`
```
~/agile_dotfiles/ai/workflow_artifacts/
   <area>/
      CONTEXT.md
      <feature>/
         manifest.md                # mode: repo + artifacts-root

<repo-root>/<artifacts-root>/
   SPEC.md                          # required
   IMPLEMENTATION_NOTES.md          # required
   context/CONTEXT.md               # required
   plans/INDEX.md                   # required
   plans/<id>-<name>.md
   <design diagrams>                # human-supplied, read-only to phases
```

**Minimum expected filenames** under `artifacts-root`: `SPEC.md`, `IMPLEMENTATION_NOTES.md`,
`context/CONTEXT.md`, `plans/INDEX.md`. `artifacts-root` is configurable; these four names are not —
phases resolve them by convention, so nothing guesses a filename.

## What each artifact is for

- **`SPEC.md`** — the WHAT. Living: sections get revised and removed, not just appended. Frame owns it.
- **`IMPLEMENTATION_NOTES.md`** — what's actually built, **including accepted deviations**. Implement
  writes it on close. This is what a *fresh* planner trusts, so skipping it is the main failure mode.
- **`context/CONTEXT.md`** — this feature's working knowledge: package name + concrete commands, file
  map, id/coordinate conventions, invariants, source material, traps.
- **`plans/`** + **`INDEX.md`** — how to build each thing, and the registry. Schema and status model:
  see `index.template.md`.
- **design diagrams** — human-supplied source material; read-only to every phase.

## Context cascade, and the main-branch rule

Read `<area>/CONTEXT.md` **then** `<feature>/context/CONTEXT.md`; **the feature file wins** on
conflict (same cascade as nested `CLAUDE.md`).

- **`<area>/CONTEXT.md` may state only facts already on `origin/main`.** It's shared by every feature
  and read from every branch, so a fact true only on one branch would mislead all the others.
- A new fact therefore **starts in feature context and graduates to area context once it merges to
  `main`** — Frame performs that graduation, verifying with read-only git
  (`git show origin/main:<path>`, `git log origin/main -- <path>`,
  `git merge-base --is-ancestor <commit> origin/main`). No `fetch` — it mutates refs, so
  `origin/main` may be stale. **When in doubt, leave the fact in feature context.**
- Command precedence when verifying: the **plan's Verification section** → **feature** context
  (concrete commands) → **area** context (the generic pattern).
