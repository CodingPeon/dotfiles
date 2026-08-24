# INDEX — <feature name>

> **Audience: the Plan phase**, when a feature has no registry yet — copy this to `plans/INDEX.md`
> at the **mode-resolved** location, alongside the first plan, then delete this banner and the
> example rows. **Plan owns the file**; Frame owns only the `stale`/`superseded` rows in it;
> Implement owns only the `ready` → `done` flip.

**This file is the only place plan status lives.** Plan-file YAML frontmatter carries **identity
only** (`id`, `group`, `title`, `covers`, `deps`) — no `status`, no `reason` — so there is nothing
to reconcile and no two-writer conflict.

## Conventions

- **`id`** — integer in **tens-blocks per group**: a new group takes the next free block
  (10, 20, 30…), plans within it increment (10, 11, 12). **Never reused, never renumbered**; a
  group that overflows its block takes the next free block and notes it.
- **`group`** — the sub-feature tag a plan belongs to; path-like for nesting
  (`dataflow/subtask`). One group may span many plans; one plan belongs to exactly one group.
- **`title`** — what the plan delivers, in a few words.
- **`covers`** — the SPEC **section ids** this plan implements (e.g. `§10.2, §3.2`), the same ids
  Frame assigns. Not free text, not sub-feature names. **Frame's ripple check matches on this**, so
  a spec change can only find the work it invalidates through this column.
- **`deps`** — **plan ids** that must be `done` before this one can start. `—` for none.
- **`reason`** — **required** whenever status is `draft`, `stale`, or `superseded`; `—` otherwise.

### Status — stored here, exactly one writer each

| status | meaning | set by |
|---|---|---|
| `draft` | written, but **not cleared** for Implement | Plan |
| `ready` | cleared for Implement | Plan |
| `done` | built and accepted; the plan **file** is frozen | Implement |
| `stale` | a *pending* plan a spec change invalidated → rewrite or drop | **set** by Frame; **cleared** by Plan (the rewrite *is* the resolution → back to `ready`) |
| `superseded` | built, then its spec section was revised to contradict what it built | **Frame only, permanent** — it stays done + superseded as history; the resolution is a **new** plan with its own row |

**Derived, never stored** — compute at report time, because a stored value lies the moment a
dependency completes:
- **available** = `ready` AND every `deps` entry is `done` AND not `stale`
- **blocked** = `ready` AND some `deps` entry isn't `done`

## Plans

One row per plan. A row exists **iff** a plan file exists.

| id | group | title | status | covers | deps | reason |
|----|-------|-------|--------|--------|------|--------|
| 10 | `<sub-feature>` | `<what it delivers>` | ready | §x, §y | — | — |
| 11 | `<sub-feature>` | `<what it delivers>` | draft | §z | 10 | needs Frame — `<the open question>` |

Add per-plan notes below the table when useful: a link to the plan file, the commit range it
landed in, or an **accepted deviation** (what the plan said vs. what was built, and why —
the durable record belongs in `IMPLEMENTATION_NOTES.md`, this is just a pointer).

## Backlog — not yet planned

Things the SPEC calls for that have **no plan yet**. A row in *Plans* means a plan file exists; an
entry here means it doesn't. Run **Plan** to turn one into plan file(s).

| group | title | covers | notes |
|-------|-------|--------|-------|
| `<sub-feature>` | `<what it is>` | §n | `<constraints or decisions worth remembering>` |

<!-- Optional: a "Done before this workflow existed" section, for features already built and
     recorded in IMPLEMENTATION_NOTES but with no plan file. Context only — no rows, since a row
     implies a plan. -->
