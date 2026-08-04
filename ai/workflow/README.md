# Agent workflow — phases

A repo-agnostic loop for building features with a cheap-model implementer driven by
an expensive-model planner, using **durable files instead of long chat sessions** so
each session stays short and context-free.

## Drag a phase in to invoke it

Each phase file is a self-contained prompt. Open a **fresh** session (short = cheap), drag in
the phase file, and it reads the right artifacts and does its one job. Recommended session
model is noted at the top of each phase. Filenames carry a reading-order digit (`0-`,`1-`,`2-`)
for the three doing-phases; **`status` is unprefixed — it's an anytime utility, not a step.**

## The loop

```
FRAME      (Opus)    problem + context  → SPEC/CONTEXT (drafts, workspace)
PLAN       (Opus)    docs + INDEX       → plans/*.md + INDEX rows
IMPLEMENT  (Sonnet)  one plan + CONTEXT → code + verify + update docs + promote per manifest

STATUS     (cheap, anytime)  read INDEX → available / blocked / stale + recommend next
```

Review is **you** — acceptance is the default; you give feedback *inline during Implement*,
which fixes the code and updates the docs. There is no separate review/reconcile phase.

### Routing (where you go next)
- After **Implement** (accepted): another plan queued → **Implement**; wave empty → **Plan**;
  new problem or a rejection that revealed the WHAT was wrong → **Frame**.
- **Correcting a mistake** depends on *how big* the fix is, not just which doc is wrong:
  - **Small — even a plan/spec slip caught mid-build → stay in Implement.** Fix inline; it
    propagates the correction into the plan/spec on accept (neither is `done`/frozen yet, and
    SPEC is living). Don't fix only the code — write the correction back to the doc too.
  - **Big / needs planner or framer judgment → reject and switch:** plan wrong → **Plan**,
    spec wrong → **Frame**. Invalidating an *already-`done`* spec section is always **Frame**.
  - Implementation bugs are always handled in **Implement**.
- **Status** is not in this chain — drag it in any time to see what's available.

## Artifacts (durable, versioned in the dotfiles repo — NOT the project repo)

```
~/agile_dotfiles/ai/workflow_artifacts/
   <area>/                         # ide | runtime — one per project repo
      CONTEXT.md                   # repo/env facts, shared across features
      <feature>/                   # a body of work you frame as a unit
         manifest.md               # repo identity + what promotes into the project repo
         spec.md                   # this feature's draft slice (WHAT)
         plans/
            INDEX.md               # the plan registry
            <id>-<name>.md         # one plan = one implementable unit
         reports/                  # implement run notes
```

Keeping these OUT of the project repo is the point: half-baked drafts never pollute it.
Only **promotion** (Implement, per the manifest) writes accepted content into the project
working tree.

## Invariants every phase obeys

- **Git is human-only.** No phase ever runs `add`/`commit`/`merge`/`push`/`rebase`/`reset`/
  `checkout`/branch-create. Read-only git for orientation only (`rev-parse --show-toplevel`,
  `remote get-url`, `branch --show-current`, `status`, `diff`).
- **Operate on the repo you're in.** Root = `git rev-parse --show-toplevel` at runtime.
  The manifest's `repo-remote` only *confirms identity*; if the current repo's remote
  doesn't match the feature's manifest, **stop** — you're in the wrong project.
- **Default ephemeral.** Nothing reaches the project repo unless the manifest's
  `duplicate-to-repo` says so. Promotion **writes/merges into the working tree, then stops**
  and asks the human to review `git diff` and commit.
- **SPEC/NOTES are living; plans are immutable once `done`.** New requirements → new plans.
  A `done` plan is history — never edit it.

## INDEX conventions

Row per plan: `id · group · title · status · covers · deps`.
- `group` = sub-feature tag (path-like for nesting); a group may span many plans.
- `covers` = SPEC sections the plan implements — used to trace spec-change ripples.
- `status` ∈ `draft · ready · in-progress · done · blocked · stale · superseded`.
  - `stale` = pending plan invalidated by a spec change → re-plan/drop.
  - `superseded` = `done` plan the spec has since moved past → stays done, a **new** plan
    modifies the built code.
- **Available to implement** = `ready` AND all `deps` are `done` AND not `stale`.
