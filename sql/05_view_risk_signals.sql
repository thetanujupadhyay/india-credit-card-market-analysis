-- Dashboard 4: Risk Signal Monitor


CREATE OR REPLACE VIEW v_risk_signals AS
SELECT
    period_date,
    fiscal_year,
    year,
    month,
    bank_name_std,
    bank_category,
    cc_total_spend_vol,
    cc_total_spend_val,
    cc_atm_cash_vol,
    cc_atm_cash_val,
    atm_cash_pct,

    -- ATM cash % vs prior month
    atm_cash_pct
    - LAG(atm_cash_pct) OVER (PARTITION BY bank_name_std ORDER BY year, month)
    AS atm_cash_pct_mom_change,

    -- Value growth vs volume growth divergence
    -- If value grows much faster than volume = high ticket transactions = potential risk
    ROUND(
        cc_total_spend_val
        / NULLIF(LAG(cc_total_spend_val) OVER (PARTITION BY bank_name_std ORDER BY year, month), 0)
    , 4) AS spend_val_growth_ratio,

    ROUND(
        cc_total_spend_vol
        / NULLIF(LAG(cc_total_spend_vol) OVER (PARTITION BY bank_name_std ORDER BY year, month), 0)
    , 4) AS spend_vol_growth_ratio,

    -- Divergence: value growing faster than volume signals avg ticket rising
    ROUND(
        (cc_total_spend_val / NULLIF(LAG(cc_total_spend_val) OVER (PARTITION BY bank_name_std ORDER BY year, month), 0))
        - (cc_total_spend_vol / NULLIF(LAG(cc_total_spend_vol) OVER (PARTITION BY bank_name_std ORDER BY year, month), 0))
    , 4) AS val_vol_divergence,

    -- KRI Flag: ATM cash % above 5% = elevated risk signal
    CASE WHEN atm_cash_pct > 5  THEN 'HIGH'
         WHEN atm_cash_pct > 2  THEN 'MEDIUM'
         ELSE 'NORMAL'
    END AS atm_risk_flag,

    -- KRI Flag: value-volume divergence > 0.2 = anomaly
    CASE
        WHEN (
            cc_total_spend_val / NULLIF(LAG(cc_total_spend_val) OVER (PARTITION BY bank_name_std ORDER BY year, month), 0)
            - cc_total_spend_vol / NULLIF(LAG(cc_total_spend_vol) OVER (PARTITION BY bank_name_std ORDER BY year, month), 0)
        ) > 0.2 THEN 'FLAGGED'
        ELSE 'NORMAL'
    END AS divergence_flag

FROM v_base
ORDER BY year, month, bank_name_std;

SELECT * FROM v_risk_signals LIMIT 5;







