This file governs how an agent edits **phase agent** files and **artifacts**, **templates** and **ground rules** files they share.
This is not part of the workflow and no phase agent reads it.

The **phase agent** are different independent roles in a development workflow. They operate only on
the **context** they are given as input and may write **artifiacts**. These **artifacts** serve as
input **context** of another **phase agent**. The files are:

- 0-frame.md
- 1-plan.md
- 2-implement.md
- status.md
- triage.md

The **templates** are:

- index.template.md
- manifest.template.md

The **ground rules** files are:

- GROUND-RULES.md

The **artifacts** file are:

- ARTIFACTS.md

# Agent Writing Style Guidelines

## 1. Grammatical Voice & Structure
- Use the imperative for actions and prohibitions.
- Use the declarative for properties, definitions, and ownership — anything true independent of the current action. A property still answers the cases you didn't think to write down.
- Start every procedural instruction with a strong action verb (e.g., "Extract," "Verify," "Format").
- Use short, single-variable sentences to prevent LLM context drifting.
- Where a passage carries more than one point, write it as a list, not a paragraph.
    - One point per item. Never two points in one item.
    - Keep an item's conditions and exceptions inside that item; do not promote them to peer items.
    - Number a list only when the order is load-bearing. Bullet it when the items are alternatives or independent.

## 2. Word Choice & Precision
- Use absolute, deterministic language (e.g., "MUST," "SHALL," "ALWAYS," "NEVER").
- Ban ambiguous, passive, or suggestive verbs (e.g., avoid "should," "might," "try to," "ensure that").
- Eliminate qualitative descriptors (e.g., "efficiently," "carefully") in favor of quantitative limits.

## 3. Formatting & Visual Hygiene
- Use Markdown headers (#, ##, ###) to establish strict informational hierarchy.
- Wrap all code snippets, data payloads, and structural schemas in explicit triple-backtick blocks (```).
- Use distinct visual markers (e.g., XML tags <data></data> or JSON objects) to separate data from logic.

## 4. De-Bloating & Content Minimization
- Eradicate conversational filler, polite greetings, and introductory/concluding remarks.
- Keep the prompt token-dense; every sentence must introduce new, actionable operational logic.


# Editing the workflow files in this directory


## Reachability

Each phase reads only its own file plus the shared ones (`GROUND-RULES.md` §3 has the list).
**A fact a phase needs must be reachable from that set** — a rule stated only in another phase file
is unreachable, however obvious it looks from here.

Refer to other files **by filename, never by path**.

## What a sentence has to earn

- **Never narrate another phase, the reader, or the user.** Not "Plan will open the SPEC", not "the
  next planner picks it up", not "the user carries nothing between sessions". State the rule; the
  other agent already has its own instructions.
- **Name the user only when the agent must act on them** — ask, confirm, wait, report. Never to
  describe what they will do, should do, or shouldn't have to do.
- **No design commentary and no anticipated excuses.** Why the workflow is shaped this way belongs in
  `README.md`, which agents never read.

## One home per rule

Do not repeat yourself.

- Common information that the **phase agents** have are documented in **template**, **ground rules**, **artifacts**

## Structure

Each phase agent file starts with the following headers

1. Sumamry: A few words that summarize what the agent does at a **high** level, in layman terms.
2. Inputs: what files it can read; if it expects input from the users.
3. Ouputs: what files it may update; if it will hand off information to the users and what
   information.

## Before you finish

1. **Cold-read it.** Hand a fresh session the phase file plus its shared files *only*, and ask what's
   unclear and where it would have to guess. Its guesses are your defects; fix those, not its praise.
2. **Check reachability** of every fact you added — can the phase that needs it actually read it?
3. **Grep for what you cut.** A removed rule leaves dangling references to it.

