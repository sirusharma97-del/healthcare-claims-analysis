# Analysis — Healthcare Claims (Practice Data)

**Practice data only.** Every figure below was computed from the generated
sample dataset in `data/claims.csv` (205 claims, service dates Jan–Oct
2026; payer names are fictional). No real claims or patient data are used.
Aging is measured from billed date to 2026-10-31. In this sample: 137
claims paid, 34 denied, 34 still pending.

## Business questions

1. How big is the denial problem — in claims and in dollars?
2. Which denial reasons should be fixed first, and why?
3. Which payers are hardest to collect from?
4. How much money is sitting in unpaid claims, and for how long?
5. Of what was billed and decided, how much was actually recovered?

## Key findings

1. **Denials hit dollars harder than counts.** 34 of 205 claims were
   denied (16.6% of claims), but those claims carried $11,492.33 of the
   $55,567.89 billed — 20.7% of billed dollars. Denied claims skew larger
   than average, so a count-only denial rate understates the problem.
2. **One fixable reason causes nearly half of all denials.** "Missing
   information" accounts for 16 of 34 denials (47.1%, $4,755.81 billed).
   Add "Eligibility" (7 denials, 20.6%) and two front-end checks —
   complete information and eligibility verification before submission —
   cover 67.6% of all denials. By contrast, "Timely filing" is only 4
   denials but the largest denied claims on average ($529.73 each).
3. **Denial behavior differs sharply by payer.** MedShield PPO denied
   28.9% of its claims (11 of 38) and BlueRiver Health Plan 20.0% (11 of
   55), while SummitCare Health denied just 5.4% (3 of 56). The gap
   between best and worst payer is more than fivefold on the same claim
   mix process.
4. **A third of pending money is already old.** 34 claims worth
   $8,987.28 are still pending. 13 of them (38.2%), worth $2,934.32, have
   been waiting 61+ days, and 5 claims worth $1,025.43 are past 90 days
   (averaging 128.6 days since billed) — the zone where recovery odds
   fall and timely-filing risk grows.
5. **Recovery on decided claims is 64.1% — and denials, not
   underpayment, are the cause.** Of $46,580.61 billed on decided claims,
   $29,843.27 was paid. Claims that were paid recovered 85.1% of their
   billed amount, so the 35.9-point gap is mostly claims paid at $0
   (denials), not payers shaving paid claims. SummitCare pairs the lowest
   denial rate with the highest paid share (77.5% of billed); MedShield
   is lowest at 51.7%.

## What this means

This is primarily a front-end quality problem, not a payer-negotiation
problem. Two-thirds of denials come from information and eligibility
issues that are checkable before a claim ever leaves the door, and the
recovery math says a claim that survives submission gets paid at 85.1%
of billed. Every denied claim prevented is worth more than the same
claim appealed later — appeals also burn staff time against a 90+ day
aging backlog.

## Recommendations

1. **Fix "Missing information" first.** It is 47.1% of denials and the
   most preventable: add a pre-submission completeness checklist (or an
   edit in the clearinghouse scrubber) for the fields that drive it.
   Halving just this one reason would cut the overall denial rate by
   roughly a quarter.
2. **Verify eligibility at scheduling, not at billing.** Eligibility is
   another 20.6% of denials and is knowable before the service happens;
   a coverage check at intake removes the denial instead of working it
   afterward.
3. **Work the 61+ day pending queue this week.** 13 claims / $2,934.32,
   starting with the 5 claims past 90 days — status-check them with the
   payer, document the follow-up, and escalate before they age into
   timely-filing denials like the $529.73-average ones already seen.
4. **Treat MedShield PPO as a special case.** A 28.9% denial rate and
   51.7% paid share warrant a payer-specific review: pull its denial
   reasons separately, check them against its documentation rules, and
   raise the pattern in the next payer meeting with these numbers in
   hand.
5. **Keep reporting denials both ways.** Count-based (16.6%) and
   dollar-based (20.7%) rates side by side, by reason and by payer,
   monthly — that is the view that made the priority order above
   obvious.
