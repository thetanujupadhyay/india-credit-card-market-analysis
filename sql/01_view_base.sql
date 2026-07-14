--Layer 1 — Base view with derived columns

CREATE OR REPLACE VIEW v_base AS
SELECT
    year,
    month,

    -- Proper date column: first day of each month
    TO_DATE(year::text || '-' || LPAD(month::text, 2, '0') || '-01', 'YYYY-MM-DD') AS period_date,

    -- Fiscal year label (India: April–March)
    -- April 2022 to March 2023 = FY2022-23
    CASE
        WHEN month >= 4 THEN year::text || '-' || RIGHT((year+1)::text, 2)
        ELSE (year-1)::text || '-' || RIGHT(year::text, 2)
    END AS fiscal_year,

    -- Fiscal quarter
    CASE
        WHEN month IN (4,5,6)   THEN 'Q1'
        WHEN month IN (7,8,9)   THEN 'Q2'
        WHEN month IN (10,11,12) THEN 'Q3'
        WHEN month IN (1,2,3)   THEN 'Q4'
    END AS fiscal_quarter,

    bank_name_std,
    bank_category,

    -- Core credit card metrics
    cc_outstanding,
    cc_total_spend_vol,
    cc_total_spend_val,
    cc_pos_vol,
    cc_pos_val,
    cc_online_vol,
    cc_online_val,
    cc_others_vol,
    cc_others_val,
    cc_atm_cash_vol,
    cc_atm_cash_val,

    -- Derived: spend per card (value in Rs'000 per card)
    CASE
        WHEN cc_outstanding > 0
        THEN ROUND(cc_total_spend_val / cc_outstanding, 2)
        ELSE NULL
    END AS spend_per_card,

    -- Derived: average transaction value (Rs'000 per transaction)
    CASE
        WHEN cc_total_spend_vol > 0
        THEN ROUND(cc_total_spend_val / cc_total_spend_vol, 4)
        ELSE NULL
    END AS avg_txn_value,

    -- Derived: online share of total spend (channel mix %)
    CASE
        WHEN cc_total_spend_val > 0
        THEN ROUND(cc_online_val * 100.0 / cc_total_spend_val, 2)
        ELSE NULL
    END AS online_spend_pct,

    -- Derived: ATM cash as % of total credit card value (risk signal)
    CASE
        WHEN (cc_total_spend_val + cc_atm_cash_val) > 0
        THEN ROUND(cc_atm_cash_val * 100.0 / (cc_total_spend_val + cc_atm_cash_val), 2)
        ELSE NULL
    END AS atm_cash_pct,

    -- Debit card metrics (for comparison)
    dc_outstanding,
    dc_pos_val,
    dc_online_val,
    dc_atm_cash_val,

    -- Infrastructure
    atm_onsite,
    atm_offsite,
    pos_terminals

FROM card_data
WHERE bank_name_std IS NOT NULL;   -- excludes the 0 unmatched rows if any remain

SELECT COUNT(*) FROM v_base;







