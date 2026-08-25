# INDEX — <feature name>

> **Audience: the Plan phase**, when a feature has no registry yet — copy this to `plans/INDEX.md`
> at the **mode-resolved** location, alongside the first plan, then delete this banner and the
> example rows. **Plan owns the file**; Frame owns only the `stale`/`superseded` rows in it;
> Implement owns only the `ready` → `done` flip.

**This file is the single source of truth for every mutable fact about a plan** — `status`,
`reason`, `covers`, `deps`. Plan-file YAML frontmatter carries **bare identity only**: `id`,
`group`, `title`. Nothing is duplicated between the two, so there is nothing to reconcile and no
two-writer conflict. (`covers`/`deps` live here rather than in frontmatter because Frame's ripple
check scans this one table, and Frame must never open a plan file.)

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
- **`deps`** — **plan ids** that must be `done` before this one can start. `—` for none.
- **`reason`** — **required** whenever status is `draft`, `stale`, or `superseded`; `—` otherwise.

### Status — stored here, exactly one writer each

| status | meaning | set by |
|---|---|---|
| `draft` | written, but **not cleared** for Implement | Plan |
| `ready` | cleared for Implement | Plan |
| `done` | built and accepted; the plan **file** is frozen | Implement |
| `stale` | a *pending* plan a spec change invalidated → rewrite or drop | **set** by Frame; **cleared** by Plan (the rewrite *is* the resolution → back to `ready`) |
| `superseded` | built, then its spec section was revised to contradict what it built | **Frame only, permanent** — it replaces `done`, recording work that was built then invalidated; the resolution is a **new** plan with its own row |

**Statuses are mutually exclusive — a row holds exactly one.** `stale` *replaces* `ready`;
`superseded` *replaces* `done`.

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

Add per-plan notes below the table when useful: a link to the plan file, the commit range it
landed in, or an **accepted deviation** (what the plan said vs. what was built, and why —
the durable record belongs in `IMPLEMENTATION_NOTES.md`, this is just a pointer).

**Burned ids:** `—`

Ids of **dropped** plans go here. Dropping deletes the row *and* the plan file, which would
otherwise erase all evidence the id was ever used — and the next planner allocating "the next free
id" would reuse it. Recording it here is what makes the never-reuse rule enforceable.

## Backlog — not yet planned

Things the SPEC calls for that have **no plan yet**. A row in *Plans* means a plan file exists; an
entry here means it doesn't. Run **Plan** to turn one into plan file(s).

**Writers:** **Plan** owns this table — it adds entries for work it identifies but isn't planning
yet, and **removes an entry when it becomes a plan**. **Frame** may add an entry for something it
just specced but isn't planning, and may amend or remove one whose spec basis changed. Backlog
entries have **no status** — `stale`/`superseded` apply only to real plans — so a ripple that hits a
backlog entry is handled by editing or deleting the entry, not by flagging it.

| group | title | covers | notes |
|-------|-------|--------|-------|
| `<sub-feature>` | `<what it is>` | §n | `<constraints or decisions worth remembering>` |

<!-- Optional: a "Done before this workflow existed" section, for features already built and
     recorded in IMPLEMENTATION_NOTES but with no plan file. Context only — no rows, since a row
     implies a plan. -->
