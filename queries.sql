-- Healthcare Claims Analysis — PRACTICE DATA ONLY (sample tables)
-- Table:
--   claims (claim_id, patient_ref, payer, service_date, billed_date,
--           billed_amount, paid_amount, status, denial_reason)
-- status is 'paid', 'denied' or 'pending'.
-- denial_reason is filled only when status = 'denied'.

-- ============================================================
-- 1. Overall denial rate — by claim count AND by billed dollars
-- ============================================================
SELECT
    COUNT(*)                                                    AS total_claims,
    SUM(CASE WHEN status = 'denied' THEN 1 ELSE 0 END)          AS denied_claims,
    ROUND(100.0 * SUM(CASE WHEN status = 'denied' THEN 1 ELSE 0 END)
          / COUNT(*), 1)                                        AS denial_pct_of_claims,
    SUM(billed_amount)                                          AS total_billed,
    SUM(CASE WHEN status = 'denied' THEN billed_amount ELSE 0 END)
                                                                AS denied_billed,
    ROUND(100.0 * SUM(CASE WHEN status = 'denied' THEN billed_amount ELSE 0 END)
          / SUM(billed_amount), 1)                              AS denial_pct_of_billed
FROM claims;

-- ============================================================
-- 2. Denials by reason: count, share of all denials, billed $
-- ============================================================
SELECT
    denial_reason,
    COUNT(*)                        AS denied_claims,
    ROUND(100.0 * COUNT(*)
          / SUM(COUNT(*)) OVER (), 1) AS pct_of_all_denials,
    SUM(billed_amount)              AS denied_billed_amount,
    ROUND(AVG(billed_amount), 2)    AS avg_denied_claim
FROM claims
WHERE status = 'denied'
GROUP BY denial_reason
ORDER BY denied_claims DESC;

-- ============================================================
-- 3. Denial rate by payer
-- ============================================================
SELECT
    payer,
    COUNT(*)                                                    AS total_claims,
    SUM(CASE WHEN status = 'denied' THEN 1 ELSE 0 END)          AS denied_claims,
    ROUND(100.0 * SUM(CASE WHEN status = 'denied' THEN 1 ELSE 0 END)
          / COUNT(*), 1)                                        AS denial_pct,
    SUM(billed_amount)                                          AS billed_amount
FROM claims
GROUP BY payer
ORDER BY denial_pct DESC;

-- ============================================================
-- 4. Aging of unpaid (pending) claims: 0-30 / 31-60 / 61-90 / 90+
-- ============================================================
SELECT
    CASE
        WHEN CURRENT_DATE - billed_date <= 30 THEN '0-30 days'
        WHEN CURRENT_DATE - billed_date <= 60 THEN '31-60 days'
        WHEN CURRENT_DATE - billed_date <= 90 THEN '61-90 days'
        ELSE '90+ days'
    END                                     AS aging_bucket,
    COUNT(*)                                AS pending_claims,
    SUM(billed_amount)                      AS billed_amount_pending,
    ROUND(AVG(CURRENT_DATE - billed_date), 0) AS avg_days_waiting
FROM claims
WHERE status = 'pending'
GROUP BY aging_bucket
ORDER BY MIN(CURRENT_DATE - billed_date);

-- ============================================================
-- 5. Paid vs billed: overall and by payer
-- ============================================================
SELECT
    payer,
    COUNT(*)                        AS claims,
    SUM(billed_amount)              AS billed_amount,
    SUM(paid_amount)                AS paid_amount,
    SUM(billed_amount - paid_amount) AS unpaid_difference,
    ROUND(100.0 * SUM(paid_amount) / NULLIF(SUM(billed_amount), 0), 1)
                                    AS paid_pct_of_billed
FROM claims
WHERE status IN ('paid', 'denied')   -- decided claims only
GROUP BY payer

UNION ALL

SELECT
    'ALL PAYERS',
    COUNT(*),
    SUM(billed_amount),
    SUM(paid_amount),
    SUM(billed_amount - paid_amount),
    ROUND(100.0 * SUM(paid_amount) / NULLIF(SUM(billed_amount), 0), 1)
FROM claims
WHERE status IN ('paid', 'denied')
ORDER BY payer;
