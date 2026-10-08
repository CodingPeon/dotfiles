# NNNN: Decision Title

## Decision

We decided **option name** to mitigate **most important risk**. We accept **main trade-off**.

**option name** is the name from Options, copied as written.

## Context

State the problem, current constraints and verified facts. Link checked source revisions. Separate facts from assumptions.

Do not copy the functional-requirement catalog from `spec.md`. This ADR covers one decision. The spec covers every discovery facet.

## Applicable Requirements

Cite only the requirement IDs in `spec.md` this decision must satisfy. One line per ID: why this ADR owns it. Do not paste catalog rows or acceptance scenarios. `spec.md` stays the source.

- **FR-ID:** 

Requirements that are out of scope:

- **FR-ID:** out of this ADR

## Evaluation Criteria

Comparative dimensions. A criterion is not a restated functional requirement. They are used to grade options that meet the mandatory requirements. Score each criterion from 1 to 5. Base each score on a quantifiable measurement, and state what that measurement is. A binary criterion can only be either 2 or 4 points.

- **C1 - Criterion name:** **how to grade**
- **C2 - Criterion name:** **how to grade**

## Options

List every candidate once. Do not repeat the list per evaluation step.

1. **Option name:** 

## Evaluation

Explain only the differences that determine the outcome. Identify assumptions or missing evidence. The evaluation should make the decision understandable without relying on the author's preference.

### Against requirements

Compare every option against every applicable requirement ID. An option either can meet the requirement or cannot. Do not use stars here.


| Option   | FR-ID    | FR-ID       |
| -------- | -------- | ----------- |
| Option 1 | ✅       | ❌          |


An option that cannot meet an applicable requirement may stay in this table so the reader sees why it is out. It does not enter the criteria matrix.

### Against criteria

Score only options that can meet every applicable requirement. Compare every survivor against every criterion. A compact matrix is preferred.
The final column is the unweighted average of all criteria.

Use the same five-star scale as the IDE ADRs:

- `⭐⭐⭐⭐⭐ 5/5`: satisfies the criterion directly;
- `⭐⬜⬜⬜⬜ 1/5`: conflicts with it or requires substantial additional work.

Use the same criterion identifiers and names in the matrix:


| Option   | C1 Criterion name | C2 Criterion name | C3 Criterion name | Average |
| -------- | ----------------- | ----------------- | ----------------- | ------- |
| Option 1 | ⭐⭐⬜⬜⬜ 2/5         | ⭐⭐⭐⬜⬜ 3/5         | ⭐⭐⭐⭐⭐ 5/5         | 3.3/5 |


Define the rating terms and identify assumptions or missing evidence. The evaluation should make the decision understandable without relying on the author's preference.


## Consequences And Limitations

- **accepted cost, unresolved question, or failure mode**

