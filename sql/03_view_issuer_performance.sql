-- Dashboard 2: Issuer Performance

CREATE OR REPLACE VIEW v_issuer_performance AS
SELECT
    period_date,
    fiscal_year,
    year,
    month,
    bank_name_std,
    bank_category,
    cc_outstanding,
    cc_total_spend_val,
    spend_per_card,

    -- Market share % by outstanding cards
    ROUND(
        cc_outstanding * 100.0
        / NULLIF(SUM(cc_outstanding) OVER (PARTITION BY year, month), 0),
    2) AS market_share_pct,

    -- Rank by outstanding cards each month
    RANK() OVER (PARTITION BY year, month ORDER BY cc_outstanding DESC) AS rank_by_outstanding,

    -- Rank by spend value each month
    RANK() OVER (PARTITION BY year, month ORDER BY cc_total_spend_val DESC) AS rank_by_spend,

    -- MoM card additions per bank
    cc_outstanding
    - LAG(cc_outstanding) OVER (PARTITION BY bank_name_std ORDER BY year, month)
    AS mom_card_additions

FROM v_base
ORDER BY year, month, rank_by_outstanding;

SELECT * FROM v_issuer_performance LIMIT 5;



