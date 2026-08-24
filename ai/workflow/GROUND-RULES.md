# GROUND RULES — how every phase behaves

**Read this at the start of every phase**, together with `ARTIFACTS.md` (where things live). Your
phase file adds its own job and any phase-specific rules on top of these; if a phase file is
stricter, the stricter rule wins.

## 1. Startup gate — confirm both with the user before anything else; **STOP** if either fails

1. **Feature.** Ask which feature this session is for. The branch name and working tree are
   **hints, never authority** — confirm, don't infer. It decides where every artifact lives.
2. **Branch.** Report `git branch --show-current` and have the user confirm it's the right branch
   for this work. **Never create, switch, or check out a branch.** If it's wrong, **STOP** and ask
   the user to check out the correct one — your job is to verify, not to fix it.

**Before confirmation you MAY** list `~/agile_dotfiles/ai/workflow_artifacts/*/` and read
`manifest.md` files — enumerating candidates is how you ask the question well. **You may NOT** read
a feature's SPEC/NOTES/`context/`/`plans/`, and may not write anything, until both are confirmed.

> **Enumerate to *ask*; never consume to *assume*.**

Why it's a hard gate: in `repo` mode the branch decides *which* SPEC, NOTES and INDEX exist at all,
so a wrong branch doesn't produce an error — it produces confidently wrong work.

## 2. Git is human-only

**Never run** `add` · `commit` · `merge` · `push` · `rebase` · `reset` · `checkout` · branch-create.

Read-only git is fine, and expected, for orientation: `rev-parse --show-toplevel`,
`remote get-url origin`, `branch --show-current`, `status`, `diff`, `log`, `show`.

You **write files into the working tree** and then **stop** — the human reviews `git diff` and
commits. Never `fetch` either: it mutates refs.

## 3. What to read

- **Your phase file** — your job. Authoritative for what you produce.
- **`ARTIFACTS.md`** — where artifacts live and how to resolve them.
- **This file** — shared conduct.
- **`index.template.md`** — canonical INDEX schema + status model (read whenever you touch the
  registry; Plan also copies it to bootstrap a feature that has none).
- **`manifest.template.md`** — only when Frame scaffolds a **new** feature.
- **Not `README.md`** — it's human-facing (which phase to invoke, routing between phases) and
  irrelevant to your job.

## 4. Stay in your lane

Each phase owns a disjoint set of writes; the boundaries are stated in each phase's OUTPUTS. If the
work in front of you belongs to another phase, **stop and route the user there** rather than doing
it yourself:

- the WHAT is unclear, or an existing spec section must change → **Frame**
- a plan is missing, wrong, or `stale` → **Plan**
- code needs writing or a plan needs building → **Implement**

Reporting a problem you can't fix is always correct. Silently widening your scope is not.
