-- Layer 2 — Dashboard views
-- Dashboard 1: Industry Pulse
CREATE OR REPLACE VIEW v_industry_pulse AS
SELECT
    period_date,
    fiscal_year,
    fiscal_quarter,
    year,
    month,

    -- Market totals
    SUM(cc_outstanding)      AS total_cc_outstanding,
    SUM(cc_total_spend_vol)  AS total_spend_vol,
    SUM(cc_total_spend_val)  AS total_spend_val,
    SUM(cc_atm_cash_val)     AS total_atm_cash_val,

    -- MoM growth in outstanding cards
    LAG(SUM(cc_outstanding)) OVER (ORDER BY year, month) AS prev_month_outstanding,
    ROUND(
        (SUM(cc_outstanding) - LAG(SUM(cc_outstanding)) OVER (ORDER BY year, month))
        * 100.0
        / NULLIF(LAG(SUM(cc_outstanding)) OVER (ORDER BY year, month), 0),
    2) AS cc_outstanding_mom_pct,

    -- YoY growth in outstanding cards
    LAG(SUM(cc_outstanding), 12) OVER (ORDER BY year, month) AS same_month_last_year,
    ROUND(
        (SUM(cc_outstanding) - LAG(SUM(cc_outstanding), 12) OVER (ORDER BY year, month))
        * 100.0
        / NULLIF(LAG(SUM(cc_outstanding), 12) OVER (ORDER BY year, month), 0),
    2) AS cc_outstanding_yoy_pct,

    -- MoM growth in spend value
    ROUND(
        (SUM(cc_total_spend_val) - LAG(SUM(cc_total_spend_val)) OVER (ORDER BY year, month))
        * 100.0
        / NULLIF(LAG(SUM(cc_total_spend_val)) OVER (ORDER BY year, month), 0),
    2) AS spend_val_mom_pct

FROM v_base
GROUP BY period_date, fiscal_year, fiscal_quarter, year, month
ORDER BY year, month;

SELECT * FROM v_industry_pulse LIMIT 5;

