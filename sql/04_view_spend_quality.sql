-- Dashboard 3: Spend Quality


CREATE OR REPLACE VIEW v_spend_quality AS
SELECT
    period_date,
    fiscal_year,
    year,
    month,
    bank_name_std,
    bank_category,
    cc_total_spend_vol,
    cc_total_spend_val,
    avg_txn_value,
    spend_per_card,
    online_spend_pct,

    -- PoS share
    CASE
        WHEN cc_total_spend_val > 0
        THEN ROUND(cc_pos_val * 100.0 / cc_total_spend_val, 2)
        ELSE NULL
    END AS pos_spend_pct,

    -- Channel mix trend: online pct vs prior month
    online_spend_pct
    - LAG(online_spend_pct) OVER (PARTITION BY bank_name_std ORDER BY year, month)
    AS online_pct_mom_change,

    -- Avg txn value vs prior month
    avg_txn_value
    - LAG(avg_txn_value) OVER (PARTITION BY bank_name_std ORDER BY year, month)
    AS avg_txn_mom_change,

    -- Industry avg txn value that month (for comparison)
    ROUND(AVG(avg_txn_value) OVER (PARTITION BY year, month), 4) AS industry_avg_txn_value,

    -- Is this bank above or below industry avg?
    CASE
        WHEN avg_txn_value > AVG(avg_txn_value) OVER (PARTITION BY year, month)
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS txn_quality_flag

FROM v_base
WHERE cc_total_spend_vol > 0
ORDER BY year, month, bank_name_std;

SELECT * FROM v_spend_quality LIMIT 5;



-- Addition

CREATE OR REPLACE VIEW v_spend_quality AS
SELECT
    period_date,
    fiscal_year,
    year,
    month,
    bank_name_std,
    bank_category,
    cc_total_spend_vol,
    cc_total_spend_val,
    avg_txn_value,
    spend_per_card,
    online_spend_pct,
    CASE
        WHEN cc_total_spend_val > 0
        THEN ROUND(cc_pos_val * 100.0 / cc_total_spend_val, 2)
        ELSE NULL
    END AS pos_spend_pct,
    online_spend_pct - LAG(online_spend_pct) OVER (PARTITION BY bank_name_std ORDER BY year, month) AS online_pct_mom_change,
    avg_txn_value - LAG(avg_txn_value) OVER (PARTITION BY bank_name_std ORDER BY year, month) AS avg_txn_mom_change,
    ROUND(AVG(avg_txn_value) OVER (PARTITION BY year, month), 4) AS industry_avg_txn_value,
    CASE
        WHEN avg_txn_value > AVG(avg_txn_value) OVER (PARTITION BY year, month)
        THEN 'Above Average' ELSE 'Below Average'
    END AS txn_quality_flag,
    cc_outstanding              -- appended at the end, safe
FROM v_base
WHERE cc_total_spend_vol > 0
ORDER BY year, month, bank_name_std;

SELECT * FROM v_spend_quality LIMIT 5;