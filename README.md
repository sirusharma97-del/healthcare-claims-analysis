# Healthcare Claims Analysis (Practice Data)

> **Key finding:** Denials are 16.6% of claims but 20.7% of billed dollars — and one fixable reason, “missing information,” causes 47.1% of all denials. Full write-up: [ANALYSIS.md](ANALYSIS.md).

SQL analysis of medical claims: how many claims are denied and why, which
payers deny most, how long unpaid claims have been sitting, and how paid
amounts compare with billed amounts.

**Practice data only.** Every table, payer name, and figure in this
project is sample/practice data created for portfolio purposes. No real
claims, patient information, or employer data is used anywhere in this
project.

## The questions it answers

1. What is the overall denial rate, and what share of billed dollars do
   denied claims represent?
2. Which denial reasons cause the most denials? (denial rate by reason)
3. Which payers deny most often? (denial rate by payer)
4. How old are the claims still unpaid? (aging buckets: 0–30, 31–60,
   61–90, 90+ days)
5. How do paid amounts compare with billed amounts, overall and by payer?
   (paid vs. billed)

## Table

- `claims` (claim_id, patient_ref, payer, service_date, billed_date,
  billed_amount, paid_amount, status, denial_reason)

`status` is one of `paid`, `denied`, `pending`. `denial_reason` is filled
only for denied claims (examples in the practice data: missing
information, eligibility, coding error, duplicate claim, timely filing).
Aging is measured from `billed_date` to the current date for claims still
in `pending` status.

## What was done

- Calculated the overall denial rate two ways — by claim count and by
  billed dollars — because the two tell different stories.
- Grouped denials by reason and by payer with conditional aggregation so
  each rate is computed from the same base table.
- Bucketed pending claims into standard AR aging ranges with a `CASE`
  expression and summed the billed dollars sitting in each bucket.
- Compared total paid vs. total billed overall and per payer, reporting
  the paid percentage rather than either figure alone.
- The same summaries are straightforward to reproduce in Excel from a
  claims extract: denial rate by reason/payer with COUNTIFS and SUMIFS
  over status and reason columns, and aging buckets with a helper column
  (`=TODAY()-billed_date`) feeding a pivot table.

## Skills shown

- SQL conditional aggregation for rate calculations
- Aging-bucket logic with `CASE`
- Reporting both count-based and dollar-based rates, and saying which is
  which
- Healthcare revenue-cycle vocabulary used correctly (denial, AR aging,
  paid vs. billed)

## Files

- `README.md` — this file
- `queries.sql` — the five claims queries, commented section by section
- `ANALYSIS.md` — business analysis run on the sample data: findings with figures and recommendations
- `data/claims.csv` — generated sample claims table (205 rows, service dates Jan–Oct 2026)
