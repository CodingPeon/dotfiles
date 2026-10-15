> This file defines the structure of `spec.md`.
> Keep every heading.
> Replace each `<placeholder>` from the author's input.
> Leave this blockquote and the instruction bullets out of `spec.md`.

# Scope

Write one in-scope outcome per bullet.

- <outcome>

## Out of Scope

Write one excluded item per bullet.

- <excluded item>

# Functional Requirements

This section contains Catalog, Non-Functional Requirements, and Acceptance Criteria.

## Catalog

Write one row per functional requirement.

| ID | Capability | Teams |
| --- | --- | --- |
| <ID> | <one observable sentence> | <team>[, <team>] |

- The columns are `ID`, `Capability`, and `Teams`.
- `Capability` is one observable sentence.
- `Teams` names the teams that satisfy the row.
- An `ID` is a stable token.
- Write an `ID` as 2 to 4 uppercase words separated by hyphens.
- State what the requirement is about in those words.
- Do not use a serial number in an `ID`.

## Non-Functional Requirements

Write one row per non-functional requirement.

| ID | Constraint |
| --- | --- |
| <ID> | <one sentence> |

- The columns are `ID` and `Constraint`.
- `Constraint` is one sentence.
- Apply the Catalog `ID` rules to each row.

## Acceptance Criteria

- Write one `###` block for each `ID` in Catalog and in Non-Functional Requirements.
- Write one `ID` in each `###` block.
- Set the heading text to the `ID`.
- Repeat the block below once per `ID`.

### <ID>

```gherkin
Scenario: <example name>
  Given <precondition>
  And <precondition>
  When <action>
  Then <observable result>
  And <observable result>
```

- Open the fence with `gherkin` at column 0.
- Leave a blank line before the opening fence and after the closing fence.
- Do not put a `Feature:` line in the fence. The Catalog row, or the Non-Functional Requirements row, already states it.
- Add each example as a `Scenario:` in that same fence.
- Start a step with `Given`, `When`, `Then`, `And`, or `But`, then a space and the step text.
- Put a colon after `Scenario`.
- Put no colon after a step keyword.
- Add a `#` line only when the user asks for a note. Write it as its own line whose first non-space character is `#`, then the note text.
- A `#` line is not a step.
- Do not use `Note` or `Subclause` as keywords.

# Delivery Mapping

Write one delivery item per bullet.

- <delivery item>
