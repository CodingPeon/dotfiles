# INDEX — <feature name>

> **Audience: every phase.** This file is the **canonical** schema, status vocabulary and
> conventions for a plan registry — read it whenever you touch one.
>
> **Plan** also uses it to create a registry that doesn't exist yet — but takes **only the skeleton**:
> the two table headers (**Plans**, **Backlog**), the one-line **Burned ids** entry, and a one-line
> pointer back here. **No prose from this file is ever copied into a live `INDEX.md`** — not the
> Conventions, not the Status model, not the column definitions under each table: every phase already
> reads this file, so a per-feature copy is only N copies to keep in sync. A registry holds data; the
> schema lives here.
>
> This file defines **what** a registry contains. **Which phase may write each part is in that
> phase's own OUTPUTS**, never here.

**This file is the single source of truth for every mutable fact about a plan** — `status`,
`reason`, `covers`, `deps`. Plan-file YAML frontmatter carries **bare identity only**: `id`,
`group`, `title`. Nothing is duplicated between the two, so there is nothing to reconcile and no
two-writer conflict. (`covers`/`deps` live here rather than in frontmatter because Frame's ripple
check scans this one table, and Frame must never open a plan file.)

## Contents

A registry holds **rows, entries and ids**. It has these parts and no others:

| part | holds | present |
|---|---|---|
| the `# INDEX — <feature>` title, and under it a one-line pointer to `index.template.md` by filename | the registry's identity, and where its schema lives | always |
| `## Plans` | one row per plan file | always |
| `**Burned ids:**` | ids of dropped plans, comma-separated, or `—` | always |
| `## Backlog — specced, not yet planned` | one entry per specced unit that has no plan file | always |
| `## Done before this workflow existed` | prose only, no rows — a feature built before the workflow | optional |

A registry **NEVER** holds:

- what was built, how it was verified, or what deviated. `IMPLEMENTATION_NOTES.md` holds that, and every phase that needs it reads it.
- why a plan was split, why a `deps` or a `covers` is what it is, or what a plan leaves alone. The plan file's **Context** holds that.
- a note that corrects another note. Correct the original.

This is a property of the file. It holds at bootstrap and at every later edit.

A note under a table is admissible **only** to correct something wrong in that table.

**This file defines WHAT a registry contains.** Which phase may write each part is in that phase's
own **OUTPUTS**. The one exception is the `set by` column of the status model below, which is part of
what a status *means* — a status names the phase that acts next.

## Conventions

- **`id`** — integer in **tens-blocks per group**: a new group takes the next free block
  (10, 20, 30…), plans within it increment (10, 11, 12). **Never reused, never renumbered**; a
  group that overflows its block takes the next free block and notes it. An id from a **dropped**
  plan stays burned — never hand it to a different plan, or history stops meaning anything.
- **`group`** — a short free-form label for the sub-feature a plan belongs to (`§10 dataflow`,
  `add-modal`). Use a path-like form (`dataflow/subtask`) only if you actually need nesting. One
  group may span many plans; one plan belongs to exactly one group. **Mirror whatever convention
  the table already uses** rather than introducing a second one.
- **`title`** — what the plan delivers, in a few words.
- **`covers`** — the SPEC **section ids** this plan implements. **Frame's ripple check matches on
  this**, so a spec change can only find the work it invalidates through this column. Get the form
  wrong and invalidation fails *silently*.
  - **An id is the SPEC section's number.** Headings usually carry no `§` (`## 10.2 Triggers`), so
    the id there is `10.2`; write it `§10.2` here for readability and **match on the number**.
    Frame owns numbering and never renumbers, so a plain search for the number finds the section.
  - **Explicit, comma-separated ids only — ranges are NOT legal.** `§10.1–.5` will not match a
    search for `§10.3`. Write `§10.1, §10.2, §10.3, …` or use the parent (below).
  - **Matching runs in BOTH directions along the tree** — this is the rule the ripple check uses,
    and getting it one-directional means silent misses:
    - `covers: §10` matches a revision of `§10.3` (**ancestor** — the plan implements the whole
      section, so a change to any part of it hits the plan).
    - `covers: §10.3` matches a revision of `§10` (**descendant** — revising or deleting a parent
      changes its children too).
    - Formally: a revised `§A` matches `covers: §B` when `A == B`, or either is a prefix-ancestor of
      the other. Siblings never match (`§10.2` and `§10.3` are unrelated).
  - So when a plan implements a whole section, `§10` alone is enough — listing every child is
    redundant.
  - A plan may cover a section only **partly** — `covers` says "this plan touches §10.2", not
    "§10.2 is finished". Completeness lives in `IMPLEMENTATION_NOTES.md`.
  - **`covers` names the sections a row's LIVE work implements.** Many rows may name one section, but
    every one of them must still have live work in it. When a revision kills part of a row's work,
    `covers` narrows to what survives, so a section whose built work is still correct never loses its
    row.
  - **`nothing` is the one legal non-id value**, and it is an assertion, not an empty cell: *this
    plan's work no longer covers any section*. It is spelled out so that nothing deliberate is ever
    mistaken for something omitted — the same reason `still stands` is spelled `nothing`.
    **`covers: nothing` ⟺ `status: superseded`**, in both directions: a live plan that implements no
    section should not exist, and a superseded row that still lists ids orphans them.
  - **A section is covered when a row or a Backlog entry names it.** A dropped plan names nothing (its
    id is in `Burned ids`) and a superseded row names `nothing`, so the union of this column **is**
    the coverage — no status filter. Only **numbered** sections can be covered at all; unnumbered
    headings (`## Overview`) have no id.
- **`deps`** — **plan ids** that must be `done` before this one can start. `—` for none.
- **`reason`** — **required** whenever status is `draft`, `stale`, `to-be-superseded` or
  `superseded`; `—` otherwise. **When a status change means a reason is no longer required, set the
  cell back to `—`** (a rewritten `stale` row returning to `ready` keeps no reason) — the one
  exception is `to-be-superseded` → `superseded`, where the outcome is *appended* to the existing
  text.

  The **status** says *who acts next*; the `reason` must carry everything they need that isn't
  derivable from SPEC + NOTES + this table. Always `<cause> — <detail>`, and — since this is a **cell
  in a pipe table** — **always exactly one line**: no newlines, `;` between parts.

  **Not a summary of the spec change** — only what SPEC + NOTES + this table don't already hold:

  | status | required form |
  |---|---|
  | `draft` | `needs Frame — <the open question>` · `blocked on verification — <what's missing>` |
  | `stale` | `§<ids> revised — <what the plan now gets wrong>` or `§<ids> deleted — <what is no longer wanted>` |
  | `to-be-superseded` | the three-part form below |
  | `superseded` | the `to-be-superseded` reason **plus** ` → replaced by <id>[, <id>…]` or ` → deferred to backlog` |

  `revised` and `deleted` are not interchangeable: `revised` means rewrite, `deleted` means drop.

  **`to-be-superseded` — three parts, all mandatory**, one line, `;`-separated. Frame writes it; it
  is the brief for the replacement plan:

  `§<ids> revised|deleted — <what makes the code that was built wrong>; still stands: <what does NOT change>; follow-up: remove | rework`

  e.g. `§7.2 revised — chain lookup replaced by always-swap, so the built resolver is dead code;
  still stands: its §7.1 registration work; follow-up: remove`.

  - **`§<ids>`** — which of the row's `covers` ids actually changed.
  - **still stands** — a scope boundary: work the revision leaves intact. **`nothing`** when a
    deletion leaves none, so that an empty part is never mistaken for an omitted one.
  - **follow-up** — `remove` if the built code goes, `rework` if it changes shape. A deleted section
    is always `remove`.

  **Can't fill "what's now wrong" or choose `remove`/`rework`?** Frame: you aren't sure it's
  contradicted — don't flag, ask. Plan: leave the row at `to-be-superseded` and ask — `superseded` is
  permanent, so a guess is unrecoverable.

### Status — stored here; every transition has exactly one owner

**"Pending"** means `draft` or `ready` — a plan that exists but hasn't been built.

| status | meaning | set by |
|---|---|---|
| `draft` | written, but **not cleared** for Implement | Plan |
| `ready` | cleared for Implement | Plan |
| `done` | built and accepted; the plan **file** is frozen | Implement — **and** Plan, resolving a `to-be-superseded` row whose work partly survives — **and** Frame, *only* to undo its own mis-flag from `to-be-superseded` |
| `stale` | a *pending* plan a spec change invalidated → rewrite or drop | **set** by Frame; **cleared** by Plan — rewriting returns it to `ready` (or `draft` + `reason` if the rewrite is blocked); dropping deletes the row |
| `to-be-superseded` | built work a spec revision **contradicted**; the follow-up is not decided yet → **outstanding, Plan must resolve it** | **set** by Frame; **cleared** by Plan → `superseded` — *except* where the `reason` is too deficient to act on, in which case Plan leaves it and asks (see `reason`, above) |
| `superseded` | built, contradicted, **and resolved** — closed history | **set by Plan** when it resolves a `to-be-superseded` row. **Permanent** thereafter |

**Statuses are mutually exclusive — a row holds exactly one.** `stale` *replaces* `ready`;
`to-be-superseded` and then `superseded` *replace* `done`.

**The two flags are symmetric — Frame flags, Plan clears:**
- `stale` → Plan rewrites the plan → **`ready`** (the plan lives again), or drops it (below).
- `to-be-superseded` → Plan resolves it → **`superseded`** (the plan stays dead; history closes).

**One exception:** a flag whose `reason` is unusable **stays where it is** while Plan asks — an
unresolved row must keep showing as outstanding.

**Resolving a `to-be-superseded` row** — **narrow `covers` to the sections whose work still stands**,
then let the result decide the status:

| `covers` after narrowing | status | `reason` |
|---|---|---|
| one or more ids | `done` | `—` |
| `nothing` | `superseded` | Frame's brief, **plus** the appended outcome |

`still stands` is the input: `nothing` there yields `nothing` here. The row is at `to-be-superseded`
while this happens, so **no `done` row's columns are ever edited**.

On the `superseded` branch the outcome is **appended** to the existing `reason` (never replacing
Frame's three parts — they're the record of *why* it was superseded):
- a replacement (or removal) plan is written → `→ replaced by <id>[, <id>…]`
- the work is deferred → `→ deferred to backlog` (and the Backlog entry's `why not yet` reads
  `deferred from <this id>`)

On the `done` branch **the supersession leaves no trace in the table** — `reason` returns to `—`,
because the status says who acts next and nobody acts on a `done` row. What was contradicted, and by
which plan, is recorded in the **replacement plan's Context**. The table keeps only what its two
readers need: `covers` names live work, and the replacement's own row names the revised sections.

**`superseded` is permanent — never revert it.** Not when the replacement ships (that's the system
working; reverting would erase the record). The **only** correction is Frame undoing its own
mis-flag: if the spec never actually contradicted the work, Frame returns the row to `done` and says
why. Distinguishing the two is easy — *"we built the follow-up"* versus *"there was nothing to
follow up"*.

**Derived, never stored** — compute at report time, because a stored value lies the moment a
dependency completes:
- **available** = `ready` AND every `deps` entry is `done`
- **blocked** = `ready` AND some `deps` entry isn't `done`

(Neither needs a "not stale" test — a `stale` row isn't `ready`.)

## Plans

One row per plan. A row exists **iff** a plan file exists.

| id | group | title | status | covers | deps | reason |
|----|-------|-------|--------|--------|------|--------|
| 10 | `<sub-feature>` | `<what it delivers>` | ready | §x, §y | — | — |
| 11 | `<sub-feature>` | `<what it delivers>` | draft | §z | 10 | needs Frame — `<the open question>` |

Add a note below the table only to fix something wrong in the table itself.

**Burned ids:** `—`

Ids of **dropped** plans go here. Dropping deletes the row *and* the plan file, which would
otherwise erase all evidence the id was ever used — and the next planner allocating "the next free
id" would reuse it. Recording it here is what makes the never-reuse rule enforceable.

## Backlog — specced, not yet planned

Things the SPEC calls for that have **no plan yet** — the durable half of the Frame → Plan handoff. A
row in *Plans* means a plan file exists; an entry here means it doesn't.

**An entry and a row never coexist for the same work** — an entry is deleted at the moment it
becomes a plan.

Entries have **no status**, so a ripple that hits one is handled by editing or deleting it, not by
flagging it.

| group | title | covers | why not yet |
|-------|-------|--------|-------------|
| `<sub-feature>` or `—` | `<the SPEC heading text>` | §n | `unplanned` |

**One entry per *independently buildable* unit, not per heading** — ancestor matching means
`covers: §10` accounts for `§10.1`–`§10.3`, so use the parent where the children will be planned
together.

- **`covers`** — **required**, same `§`id form as Plans. Without it the entry is invisible to the
  cross-check.
- **`title`** — the SPEC heading text, shortened if long. Don't summarise the section; `covers`
  already points at it.
- **`group`** — as in Plans, but **`—` is legal**: inventing one would pre-empt Plan's grouping.
- **`why not yet`** — the one fact the SPEC can't give Plan: can this be planned *now*? Same
  `<cause> — <detail>` shape as `reason`, one line, from this **closed** set — bare causes take no
  detail, the rest require it.

  | cause | meaning | what Plan does |
  |---|---|---|
  | `unplanned` | nothing blocking; simply not planned yet. **The default for newly specced work.** | **plan it, unprompted** |
  | `deferred from <id>` | parked by a `to-be-superseded` resolution; nothing blocks it | **plan it, unprompted** |
  | `needs <id> built first — <what's unknown until then>` | epistemic dependency: can't be planned accurately until that plan's real output exists | leave it; report why |
  | `needs decision — <the question>` | an open question blocks planning | leave it; route the user to **Frame** |
  | `out of scope for now — <the boundary>` | deliberately deferred by the user | leave it |

  Add constraints or decisions worth remembering after the detail, `;`-separated, **only if they
  aren't already in the SPEC**.

## Done before this workflow existed

Optional. For a feature already built and recorded in `IMPLEMENTATION_NOTES.md` but with no plan
file. Prose only — **no rows**, since a row implies a plan.
