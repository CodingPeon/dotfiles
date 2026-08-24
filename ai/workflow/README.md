# Agent workflow — phases

> **Audience: you (the human).** Phase agents do **not** read this file — each phase file is
> self-contained and repeats the rules it needs. This README is your map (which phase to drag
> in, how routing works) **and the canonical place to edit conventions** — when you change one
> here, mirror it into the affected phase file(s), which are what the agents actually obey.
>
> Two files here *are* read by agents, and only for scaffolding: **`manifest.template.md`** (Frame,
> for a new feature) and **`index.template.md`** (Plan, for a feature with no plan registry yet).

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
FRAME      (Opus)    problem + context  → SPEC (edited in place) + CONTEXT
PLAN       (Opus)    docs + INDEX       → plans/*.md + INDEX rows
IMPLEMENT  (Sonnet)  one plan + CONTEXT → code + verify → IMPLEMENTATION_NOTES + INDEX `done`

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

## Artifacts

### The all-or-nothing rule

Each artifact has exactly **one** home. **SPEC, NOTES, `plans/`, `plans/INDEX.md` and the feature's
`context/` move together** — either all in the project repo or all in the workspace, never split.

Why: repo files are **branch-scoped**, workspace files are **branch-agnostic**, and the two cannot
describe each other. A workspace `INDEX.md` saying plan 10 is `done` **lies the moment you check
out a branch where that work doesn't exist**. Splitting them guarantees incoherence.

Because every artifact has one home, **there is no promotion** — nothing is staged, copied, or
merged between homes. That also means no draft/canonical duality: in `repo` mode Frame edits the
repo SPEC directly and the uncommitted `git diff` *is* the pending state.

### The two modes (per feature, set in `manifest.md`)

| | `mode: repo` | `mode: local` |
|---|---|---|
| SPEC · NOTES · `plans/` · `INDEX.md` · `context/` | `<repo-root>/<artifacts-root>/` | `<workspace>/<area>/<feature>/` |
| branch semantics | branch-scoped; merges through git like code | branch-agnostic, single timeline |
| suits | **distributed development** — several people/branches; docs reviewed and merged | **local development** — solo, sequential; work simply builds on top, nothing to reconcile |
| project repo | carries the docs | carries no workflow docs at all |

Local development is sequential, so there's no need to reconcile competing specs/plans — the
single workspace copy is always the latest. Distributed development needs the opposite: artifacts
that branch, conflict, and merge exactly like the code they describe.

### What stays in the workspace regardless of mode

Exactly two things, each for a specific reason:

- **`<feature>/manifest.md`** — the **locator**. It can't live inside the thing it locates, and it
  must be readable before you know anything about the repo's state.
- **`<area>/CONTEXT.md`** — safe to pin because the **main-branch rule** (below) already makes it
  branch-invariant: it may only state facts already on `main`.

The feature's `context/` does **not** stay: it describes branch-scoped reality (file maps,
invariants, the modules a feature added), so pinning it would make it lie the moment you check out
a branch without that work. It follows the mode with everything else.

### Layout — `mode: local`

Everything lives in the workspace; the project repo carries no workflow docs at all.

```
~/agile_dotfiles/ai/workflow_artifacts/
   <area>/                          # ide | runtime — one per project repo
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
            <id>-<name>.md          # one plan = one implementable unit

<project repo>                      # untouched by the workflow
```

### Layout — `mode: repo`

The workspace keeps only the locator and the shared area context; everything else lives under
`artifacts-root` in the repo, branch-scoped.

```
~/agile_dotfiles/ai/workflow_artifacts/
   <area>/
      CONTEXT.md                    # repo-wide facts (main-branch rule)
      <feature>/
         manifest.md                # mode: repo + artifacts-root

<repo-root>/<artifacts-root>/       # e.g. extensions/examples/<ext>/documentation
   SPEC.md                          # required — the WHAT
   IMPLEMENTATION_NOTES.md          # required — what's built, incl. accepted deviations
   context/
      CONTEXT.md                    # required — this feature's working knowledge
      <supplementary material>
   plans/
      INDEX.md                      # required — the plan registry
      <id>-<name>.md                # one plan = one implementable unit
   <design diagrams>                # human-supplied source material, read-only to phases
```

**Minimum expected filenames** under `artifacts-root`: `SPEC.md`, `IMPLEMENTATION_NOTES.md`,
`context/CONTEXT.md`, `plans/INDEX.md`. `artifacts-root` is configurable per feature; these four
names are not — phases resolve them by convention, so nothing has to guess a filename. Anything
you don't want committed simply doesn't go here (or the feature uses `local` mode).

### Ownership

| artifact | written by | read by |
|---|---|---|
| `<area>/CONTEXT.md` | Frame (main-branch facts only) | all phases |
| `<feature>/context/CONTEXT.md` | Frame; Implement appends discovered invariants | all phases |
| `manifest.md` | Frame | Frame, Plan, Implement |
| **`SPEC.md`** — the WHAT | Frame, directly | Frame, Plan |
| **`IMPLEMENTATION_NOTES.md`** — what's built, incl. accepted deviations | Implement, on close | Frame, Plan |
| `plans/<id>-<name>.md` | Plan; frozen once `done` | Implement |
| `plans/INDEX.md` | Frame (`stale`/`superseded`), Plan (`draft`/`ready`), Implement (`done`) | all phases |
| design diagrams | you (human) | Frame |

- **NOTES is the file a *fresh* planner trusts** to know what already exists — so an accept that
  skips updating it is the workflow's main failure mode. It's also where **accepted deviations**
  belong: a deviation recorded only on a frozen plan file is invisible, because nothing reads a
  `done` plan.
- Boundary: **SPEC** = the WHAT · **NOTES** = what's built · **plan** = how to build one thing ·
  **CONTEXT** = working knowledge you'd otherwise re-derive each session.
- **No build report:** what-now-exists → NOTES, what-changed → git, verification output → chat.

### Context cascade, and the main-branch rule

Every phase reads `<area>/CONTEXT.md` **then** `<feature>/context/CONTEXT.md`; the feature file
wins on conflict (same cascade as nested `CLAUDE.md`).

- **`<area>/CONTEXT.md` states only facts already on `main`.** It's shared by every feature and
  read from every branch, so a fact that exists only on one feature branch would mislead all the
  others.
- Therefore a new fact **starts in feature context and graduates to area context once it merges to
  `main`.** That graduation is a real step someone performs — Frame does it.
- **feature** context = this feature only: package name + concrete commands, file map, id and
  coordinate conventions, invariants discovered while building, source material, traps.

## The startup gate (every phase, every session)

Before touching anything, a phase confirms **two** things with you and **stops** if either fails:

1. **Which feature** this session is for. Branch names and the working tree are *hints, never
   authority* — a phase confirms rather than infers, because the feature decides where every
   artifact lives.
2. **That the correct branch is checked out.** A phase reports `git branch --show-current` and asks
   you to confirm. **No phase ever creates, switches, or checks out a branch** — its job is to
   verify, and to stop if the answer is wrong. In `repo` mode the branch decides *which* SPEC,
   NOTES and INDEX exist at all, so a wrong branch produces confidently wrong work.

`<area>` is **one per project repo** (`ide`, `runtime`, …) — a short label you choose, not derived.
Phases find the existing one by matching `git remote get-url origin` against `repo-remote` in
`workflow_artifacts/*/*/manifest.md`, and ask you to name a new one.

## Invariants every phase obeys

Each phase file opens with a **GROUND RULES** block. The invariants below are the **universal
core**, restated in all four phase files (including the definition of *promote*, since agents
don't read this README) — **change one here and mirror it into all four.** Each phase then adds
its own rules on top (Frame: the manifest template; Plan: un-executed plans only; Implement: it
is the only phase that promotes), so a phase's GROUND RULES block is never identical to another's.

**Vocabulary:** *promote* means one thing only — write/merge a workspace artifact into the
project repo's **working tree** at its manifest path, then stop (never stage/commit). Recording
a durable fact into a `CONTEXT.md` is **not** promotion.

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

## INDEX conventions & the state model

> **Canonical schema: `index.template.md`.** `1-plan.md` carries a convenience summary of the row
> schema so routine row-writing needs no extra read — so **if you add or rename a column in the
> template, mirror it into that summary**, or the two will drift.

Row per plan: `id · group · title · status · covers · deps · reason`.
- `group` = sub-feature tag (path-like for nesting); a group may span many plans.
- `id` = integer in **tens-blocks per group** (10,11,12 … next group at 20). Never reused or
  renumbered; a group that overflows takes the next free block.
- `covers` = SPEC sections the plan implements — used to trace spec-change ripples.
- `reason` = required whenever status is `draft`/`stale`/`superseded`.

**Status lives ONLY in `INDEX.md`.** Plan-file YAML frontmatter carries **identity only**
(`id`, `group`, `title`, `covers`, `deps`) — no status, no reason. That's deliberate: duplicating
volatile state created a two-writer conflict and made a frozen `done` plan unmarkable.

| status | meaning | who may set it |
|---|---|---|
| `draft` | written, not cleared for Implement (needs a `reason`) | Plan |
| `ready` | cleared for Implement | Plan |
| `done` | built and accepted; the plan **file** is frozen | Implement |
| `stale` | *pending* plan invalidated by a spec change | **set** by Frame; **cleared** by Plan — rewriting the plan *is* the resolution, so it goes straight back to `ready` with no Frame round-trip |
| `superseded` | built, then its spec section was revised to contradict what it built | **Frame only, and permanent** — it replaces `done`, recording that the work was built and then invalidated; the resolution is a **new** plan, never a status change back |

- **Statuses are mutually exclusive — a row holds exactly one.** `stale` *replaces* `ready`;
  `superseded` *replaces* `done`. The dimensions were never independent (stale only attaches to
  pending work, superseded only to built work), so one column loses nothing.
- **`available` and `blocked` are derived, never stored** — `available` = `ready` + all `deps`
  `done`; `blocked` = `ready` + some dep not `done`. (No "not stale" test: a stale row isn't `ready`.) Computed at report time, since
  a stored value would lie the moment a dependency completes.
- **"Frozen" applies to the plan file, not its row.** Frame marks a `done` plan `superseded` in
  the INDEX; the file itself is never edited — it's the record of what was built.
- **Status is read-only** — it reports and recommends, and writes nothing, including flags.
- A **wave** is a conversational grouping of independent plans, not recorded state.
