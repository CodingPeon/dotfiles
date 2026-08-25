# Agent workflow — phases

> **Audience: you (the human).** Agents never read this file. It's your map: which phase to drag in,
> where to go next, and where each rule actually lives. It **references** the other files rather than
> repeating them — so edit rules at their source, not here.

A loop for building features with a cheap-model implementer driven by an expensive-model planner,
using **durable files instead of long chat sessions** so each session stays short and context-free.
Knowledge lives in the artifacts; every session is fresh, single-purpose, and disposable.

## Drag a phase in to invoke it

Open a **fresh** session (short = cheap) and drag in one phase file. It reads the two shared files
from the same directory, resolves the artifacts, and does its one job.

| file | what it is | read by |
|---|---|---|
| `0-frame.md` | agree the **WHAT**; write SPEC + context | you drag it |
| `1-plan.md` | turn the WHAT into **plans** + INDEX rows | you drag it |
| `2-implement.md` | build **one plan**, verify, record what exists | you drag it |
| `status.md` | report what's available/blocked/stale — **anytime**, writes nothing | you drag it |
| `triage.md` | diagnose a *problem*: bug / spec wrong / not-a-defect, + a handoff brief — **anytime**, writes nothing | you drag it |
| **`GROUND-RULES.md`** | startup gate · git policy · what to read · stay in your lane | every phase |
| **`ARTIFACTS.md`** | vocabulary · locating the feature · modes · layouts · context cascade | every phase |
| **`index.template.md`** | INDEX schema + status model (**canonical**) | Plan; Implement/Status as needed |
| **`manifest.template.md`** | manifest skeleton | Frame, for a new feature |

Each rule has **exactly one home**. Phases reference rather than restate, so a convention change is
one edit. Recommended session model is noted at the top of each phase; filenames carry a
reading-order digit for the three doing-phases — `status` and `triage` are unprefixed because
they're **read-only utilities you drag in any time**, not steps in the loop.

## The loop

```
FRAME      (Opus)    problem + context  → SPEC (edited in place) + CONTEXT
PLAN       (Opus)    docs + INDEX       → plans/*.md + INDEX rows
IMPLEMENT  (Sonnet)  one plan + CONTEXT → code + verify → IMPLEMENTATION_NOTES + INDEX `done`

STATUS     (cheap, anytime)  read INDEX → available / blocked / stale + recommend next
TRIAGE     (cheap, anytime)  a problem  → verdict (bug / spec / not-a-defect) + handoff brief
```

Review is **you**, and acceptance is the default — you give feedback *inline during Implement*,
which fixes the code and updates the docs. There's no separate review or reconcile phase.

### Routing — where you go next

- After **Implement**: another plan queued → **Implement**; wave empty → **Plan**; new problem →
  **Frame**.
- **Correcting a mistake** depends on *how big* the fix is, not just which doc is wrong:
  - **Small — even a plan/spec slip caught mid-build → stay in Implement.** Fix inline; it writes
    the correction back into the plan/spec. Don't fix only the code.
  - **Big / needs planner or framer judgment → switch:** plan wrong → **Plan**; spec wrong →
    **Frame**. Invalidating an *already-built* spec section is always **Frame**.
  - Implementation bugs are always **Implement**.
- **Found bad behaviour and don't know which lane?** That's the common case — you usually can't tell
  a bug from a bad spec by looking. Drag in **`triage.md`**: it reads the governing SPEC section,
  NOTES and CONTEXT and returns a verdict (**not-a-defect** — an accepted deviation, a documented
  follow-up, or a known trap · **bug** · **spec problem** · **spec gap**) plus one of four lanes:
  **none** · **outside the workflow** (a trivial bug — not a phase; the phases are for planned work)
  · **Plan** · **Frame**.
  - It also hands back a **handoff brief** to paste into whichever session fixes it — which is what
    makes "just fix it outside the workflow" safe. Without it, a fresh agent can't tell a deliberate
    deviation from a defect and will "correct" it, undoing a decision you made on purpose.
  - You can skip it and guess; both entry points self-correct (Plan bounces a spec problem back to
    Frame with a `draft` row; Frame tells you it's really a bug). Triage just saves the round-trip.
- **Status and Triage sit outside this chain** — both read-only, drag either in any time.

## Choosing a mode (the one decision per feature)

Set in the feature's `manifest.md`; the full model is in **`ARTIFACTS.md`**.

- **`repo`** — SPEC, NOTES, `plans/`, `INDEX.md` and `context/` live **in the project repo**,
  branch-scoped, merging through git like the code they describe. For distributed/team work, or work
  already committing its docs.
- **`local`** — they live in the workspace, branch-agnostic; the project repo carries no workflow
  docs at all. For solo, sequential work.

**All-or-nothing** — never split that set across the two homes. A workspace `INDEX.md` claiming a
plan is `done` lies the moment you check out a branch without that work. (Rationale in
`ARTIFACTS.md`.)

## Practical notes

- **Batching increases `stale` risk.** A plan can only go `stale` in the window between *planned*
  and *built*, so planning a wave and implementing it over days is exactly when a spec change
  strands a plan. That's not an argument against batching — it's why `covers:` must be accurate,
  since it's the only link from a spec edit to the work it invalidated.
- **Never skip the write-back.** Code moving forward while `IMPLEMENTATION_NOTES` lags is the main
  failure mode: every session is fresh and trusts those docs, so the next agent inherits a lie.
- **You own all git.** No phase ever stages, commits, merges, or switches branches — they write into
  the working tree and stop, so every commit is a deliberate act of yours.
- **Cold-read a phase file after editing it.** Drag it into a fresh session and ask "what's unclear?"
  Most defects found this way were terms defined somewhere the agent couldn't see, or a new rule
  silently contradicting an older one.

## Where to edit what

| to change… | edit |
|---|---|
| the gate, git policy, conduct | `GROUND-RULES.md` |
| artifact locations, modes, layouts, cascade | `ARTIFACTS.md` |
| INDEX columns, status vocabulary/ownership | `index.template.md` |
| manifest fields | `manifest.template.md` |
| a phase's job, inputs, or outputs | that phase file |
| this map | here |
