# NNNN: Decision Title

## Decision

We decided **option name** to mitigate **most important risk**. We accept **main trade-off**.

- Copy **option name** from Options.
- When one option has the highest average, write that option.
- When one option has the highest average, state the average.
- When two or more options share the highest average:
  1. Ask the user which option to adopt.
  2. Wait for the user's answer.
  3. Write the option the user names.
  4. Write the reason the user gives.
- NEVER choose a tied option.
- NEVER add a criterion to break a tie.

## Context

- State the problem.
- State the current constraints.
- State the verified facts.
- Link the checked source revisions.
- Do not copy the functional-requirement catalog from `spec.md`.
- This ADR covers one decision.
- `spec.md` covers every discovery facet.

### Glossary

- Define each term this ADR uses.
- One term per entry.

- **Term:** definition

### Assumptions

- State each assumption that applies to the whole decision.
- Keep these assumptions separate from the verified facts.
- Put an assumption about one option in that option's body.

- **assumption**

## Applicable Requirements

- Cite an ID only when the user includes it in this ADR.
- Copy a functional-requirement ID from the Functional Requirements catalog in `spec.md`.
- Copy that ID cell as written.
- Copy a non-functional-requirement ID from the Non-Functional Requirements table in `spec.md`.
- Copy that ID cell as written.
- Write one line per ID: why this ADR owns it.
- Do not paste catalog rows.
- Do not paste acceptance scenarios.
- `spec.md` stays the source.

- **FR-ID:**
- **NFR-ID:**

Requirements that are out of scope:

- List an ID the user excludes from this ADR.

- **FR-ID:** out of this ADR
- **NFR-ID:** out of this ADR

## Evaluation Criteria

- Record the criteria the user defines.
- A criterion is a comparative dimension.
- A criterion MUST NOT restate a requirement.
- A criterion grades options that meet every applicable requirement.
- Use one bullet per criterion.
- Use one subpoint per score.
- On each subpoint, state the measurement that earns that score.
- A binary criterion lists 2/5 and 4/5 only.

- **C1 - Criterion name:** what this criterion measures
  - **5/5:** description
  - **4/5:** description
  - **3/5:** description
  - **2/5:** description
  - **1/5:** description
- **C2 - Criterion name:** what this criterion measures
  - **4/5:** description
  - **2/5:** description

## Options

- List every candidate once.
- Use one heading per option.
- Do not repeat the option body in Evaluation.

### N. **Option name**

- **Mechanism:**
- **Flaw:**
- **Assumptions:**
- **Missing evidence:**

## Evaluation

- Explain only the differences that determine the outcome.
- Do not restate a criterion.
- Do not restate an option body.
- Show the scores in the matrix.
- The matrix MUST NOT record a tie-break.
- A cell shows the score under the assumption in that option's body.
- When an option assumption changes a cell score, state that assumption and the failed-assumption score.

### Against requirements

- Compare every option against every applicable requirement ID.
- An option meets the requirement, or it fails the requirement.
- Do not use stars in this table.
- Keep this table when every cell passes.

| Option   | FR-ID | NFR-ID |
| -------- | ----- | ------ |
| Option 1 | ✅    | ❌     |

- An option that fails an applicable requirement stays in this table.
- That option does not enter the criteria matrix.

### Against criteria

- Score only options that meet every applicable requirement.
- Compare every remaining option against every criterion.
- Use one matrix.
- The final column is the unweighted average of every criterion.
- Use the criterion identifiers and names from Evaluation Criteria.

| Option   | C1 Criterion name | C2 Criterion name | C3 Criterion name | Average |
| -------- | ----------------- | ----------------- | ----------------- | ------- |
| Option 1 | ⭐⭐⬜⬜⬜ 2/5     | ⭐⭐⭐⬜⬜ 3/5     | ⭐⭐⭐⭐⭐ 5/5     | 3.3/5   |

## Consequences And Limitations

- **accepted cost, unresolved question, or failure mode**
