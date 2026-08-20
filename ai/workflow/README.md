# Agent workflow — phases

> **Audience: you (the human).** Phase agents do **not** read this file — each phase file is
> self-contained and repeats the rules it needs. This README is your map (which phase to drag
> in, how routing works) **and the canonical place to edit conventions** — when you change one
> here, mirror it into the affected phase file(s), which are what the agents actually obey.

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
      CONTEXT.md                   # repo-wide facts (any feature here benefits)
      <feature>/                   # a body of work you frame as a unit
         CONTEXT.md                # THIS feature's working knowledge
         manifest.md               # repo identity + what promotes into the project repo
         spec.md                   # this feature's draft slice (WHAT)
         plans/
            INDEX.md               # the plan registry
            <id>-<name>.md         # one plan = one implementable unit
         reports/                  # implement run notes
```

**Context cascades.** Every phase reads `<area>/CONTEXT.md` **then** `<feature>/CONTEXT.md`;
the feature file wins on conflict (same cascade as nested `CLAUDE.md`).
- **area** = true for any feature in the repo: toolchain + command patterns, host API surface
  and its drifts, schema locations, styling/token rules, git policy.
- **feature** = this feature only: its package name + concrete commands, its file map, id and
  coordinate conventions, invariants discovered while building, its source material, its traps.
- Boundary vs the rest: **SPEC** = the WHAT · **NOTES** = what's built · **plan** = how to build
  one thing · **CONTEXT** = working knowledge you'd otherwise re-derive each session.

Keeping these OUT of the project repo is the point: half-baked drafts never pollute it.
Only **promotion** (Implement, per the manifest) writes accepted content into the project
working tree.

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
| `stale` | *pending* plan invalidated by a spec change | **Frame only** |
| `superseded` | *`done`* plan the spec moved past; needs a **new** plan | **Frame only** |

- **`available` and `blocked` are derived, never stored** — `available` = `ready` + all `deps`
  `done` + not `stale`; `blocked` = `ready` + some dep not `done`. Computed at report time, since
  a stored value would lie the moment a dependency completes.
- **"Frozen" applies to the plan file, not its row.** Frame marks a `done` plan `superseded` in
  the INDEX; the file itself is never edited — it's the record of what was built.
- **Status is read-only** — it reports and recommends, and writes nothing, including flags.
- A **wave** is a conversational grouping of independent plans, not recorded state.
