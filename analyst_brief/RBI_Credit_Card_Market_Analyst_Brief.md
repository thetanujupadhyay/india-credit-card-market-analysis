# 🏦 India Credit Card Market Analysis
### Issuer Performance · Spend Trends · Risk Signals | FY2022–23 to FY2025–26

> **End-to-end data analytics pipeline** — Raw RBI filings → Python ETL → PostgreSQL → Power BI  
> Built to mirror real-world analyst workflows at financial institutions, using publicly available regulatory data.

---

## 📌 Project Overview

This project analyzes **49 monthly filings** from the Reserve Bank of India (RBI Bank-wise ATM/POS/Card Statistics) covering **66 credit card issuers** across the Indian banking ecosystem. The objective was not just to visualize data, but to **build the complete analyst pipeline from scratch** — from messy, multi-format government files to a validated, decision-ready executive brief.

The final output is a **4-page interactive Power BI dashboard** backed by a clean PostgreSQL data model, supported by a validated one-page analyst brief that mirrors the kind of reporting produced by credit risk and product analytics teams at financial institutions like American Express, JPMorgan, and Goldman Sachs.

---

## ❓ Business Problem

The Indian credit card market is growing — but **how** is it growing, **who** is winning, and **where are the risks?** Regulators publish raw data monthly, but no analysis was readily available that:

- Tracked issuer-level competitive dynamics over a multi-year period
- Distinguished regulatory-driven anomalies from genuine market trends
- Separated structural risk signals from statistical noise in thin-base datasets
- Delivered business-impact conclusions rather than just charts

This project answers those questions using real data, rigorous validation, and decisions a credit or product strategy team could act on.

---

## 🛠️ Pipeline Architecture

```
RBI Raw Excel Files (49 months)
          │
          ▼
  ┌───────────────┐
  │  Excel Audit  │  Manual structure mapping, schema definition,
  │               │  dual-format detection (pre/post March 2022)
  └───────┬───────┘
          │
          ▼
  ┌───────────────┐
  │  Python ETL   │  pandas · openpyxl
  │               │  File parsing, name standardization,
  │               │  bank_name_master lookup, derived columns,
  │               │  49-file merge → master_data.csv
  └───────┬───────┘
          │
          ▼
  ┌───────────────┐
  │  PostgreSQL   │  5 analytical views built on top of
  │               │  card_data table using window functions
  │               │  (LAG, RANK, PARTITION BY, NULLIF)
  └───────┬───────┘
          │
          ▼
  ┌───────────────┐
  │   Power BI    │  4 dashboard pages + 1 drillthrough
  │               │  DAX measures, cross-page slicer sync,
  │               │  conditional formatting, KRI flags
  └───────┬───────┘
          │
          ▼
  Analyst Brief (validated, business-ready)
```

---

## 📊 Dashboard Pages

### Page 1 — Industry Pulse
**Business question:** How is India's credit card market evolving at a macro level?

| KPI | FY23 | FY24 | FY25 | FY26 |
|---|---|---|---|---|
| Cards Outstanding | 85.30M | 101.8M | 109.88M | 118.63M |
| YoY Growth | 15.86% | **19.34%** | 7.94% | 7.6% |
| Total Annual Spend | Rs 14.32L cr | Rs 18.31L cr | Rs 21.09L cr | Rs 23.62L cr |

**Key finding:** Growth peaked in FY23-24, then stabilized at ~7.6–8% YoY — a mature-market pace. The August–September 2022 MoM dip (-2.82%) was traced to RBI's mandatory dormant-card closure mandate (effective July 1, 2022) — a regulatory event, not a demand signal. External headline figures (RBI/industry sources) were cross-checked against dashboard output and matched within 1%.

> 📷 *[<img width="2880" height="1800" alt="dashboard_industry_pulse png" src="https://github.com/user-attachments/assets/6b922bc8-e9e5-4325-b35f-17606b762c4c" />]*

---

### Page 2 — Issuer Performance
**Business question:** Who is gaining or losing market share, and why?

**Key findings:**
- **HDFC** held the #1 position across all 4 years (20.56% → 22.18%), but its story is a *recovery* to its original 22.4% (Apr 2022 pre-dip) level, not new growth — an important distinction for competitive framing
- **Axis Bank's 2.3M card spike (FY22-23)** was the Citi India consumer banking migration (effective March 1, 2023), confirmed against external sources — not organic acquisition; corroborated by that year's unusually low spend-per-card of Rs 13.6k
- **Kotak Mahindra** declined from 5.9% to 3.9% share following RBI's digital onboarding restriction (April 24, 2024 – February 12, 2025), during which its card base shrank ~17% in absolute terms
- **IDFC First Bank** grew from 1.8% to 3.83% through consistent organic acquisition, now within 0.07 percentage points of overtaking Kotak
- **American Express** spend-per-card: Rs 29.4k → Rs 50.2k (+71% over 4 years), the only unbroken multi-year premium climb in the dataset

> 📷 *[<img width="2880" height="1800" alt="dashboard_issuer_performance png" src="https://github.com/user-attachments/assets/ab52e015-9e49-4449-92c3-0f3f8fc676ee" />]*

---

### Page 3 — Spend Quality
**Business question:** Which issuers have premium customers, and how is digital adoption evolving?

**Key findings:**
- Industry average transaction size **fell every year** (Rs 5,200 → Rs 3,970) — confirmed through two independent calculation methods across two separate dashboard views; credit cards are becoming a **daily-utility instrument**, not a big-ticket one
- **HDFC is the only major issuer growing both card base (+50%) and spend-per-card simultaneously** (Rs 21.46k → Rs 24.83k) — all other large issuers trade off scale against monetization
- **IndusInd Bank's premium decline is confirmed across three independent metrics:** falling spend-per-card, shift from above- to below-industry-average transaction value, and persistent negative value/volume divergence — one of the strongest multi-angle findings in the analysis
- **IDFC First and Yes Bank** ran >55% PoS-dominant channel mixes by FY25-26 — an outlier versus the broader online-first shift of all other major issuers
- Equitas SFB and Bank of America figures were **excluded** from headline conclusions after verification revealed card bases of 324 cards and 4 monthly transactions nationwide, respectively — statistical artifacts, not market signals

> 📷 *[<img width="2880" height="1800" alt="dashboard_spend_quality png" src="https://github.com/user-attachments/assets/bd3dc71f-6b63-4d27-9576-408880bcbc9c" />]*

---

### Page 4 — Risk Signals
**Business question:** Which issuers show elevated or anomalous risk patterns?

| KPI | FY23 | FY24 | FY25 | FY26 |
|---|---|---|---|---|
| Industry ATM Cash Share % | 29.16% | 27.03% | 20.31% | **18.54%** |
| High-Risk Issuers Flagged | 2 | 3 | 1 | 1 |
| Divergence Flags | 1 | 0 | 2 | 1 |

**Key findings:**
- **Industry-wide ATM-cash usage nearly halved** over 4 years — credit cards are functioning as payment instruments, not cash-access tools, at the aggregate level
- **Canara Bank is the single persistent outlier** — #1 highest-risk issuer in every year, every year improving (~1 pp/year), yet never relinquishing the top position; this is a structural demographic pattern, not a transient risk
- **Public Sector banks show consistently higher ATM cash usage than Private/Foreign** — a clear, confirmable category-level signal (the Small Finance category is dominated by AU SFB alone and was not used for category-level claims)
- **Bandhan Bank's 15.3% spike (FY23-24) is a launch artifact** — its entire credit card book launched in March 2024 with ~Rs 1.23 lakh in total spend; excluded from headline risk conclusions
- **KRI dashboard** flags issuers by ATM Cash % thresholds (HIGH >5%, MEDIUM >2%) and value/volume divergence (>0.2), with DCB Bank and ESAF SFB divergence flags similarly excluded after verification revealed thin transaction bases (480 and 4,414 monthly transactions, respectively)

> 📷 *[<img width="2880" height="1800" alt="dashboard_risk_signals png" src="https://github.com/user-attachments/assets/ce736c13-5c4b-4e26-ab71-3e850e51db6a" />]*

---

## 🔍 Key Analytical Decisions (Methodology)

| Decision | Rationale |
|---|---|
| Dataset starts March 2022, not January 2020 | RBI changed reporting methodology in March 2022 — earlier data captures different transaction categories; cross-period comparability was prioritized over dataset length |
| Fiscal year (April–March), not calendar year | Consistent with RBI, IBA, and Indian banking sector reporting convention |
| Values standardized to Rs'000 | Source unit for spend value columns; all aggregations and derived metrics reflect this consistently |
| Bank name standardization via master lookup table | 91 raw name variants mapped to 66 standardized names; handles mergers (Citi → Axis migration), rebrands (Ratnakar → RBL), and abbreviation inconsistencies |
| 4 thin-base exclusions | Equitas SFB (324 cards), Bank of America (4 transactions), Bandhan FY24 (market entry), DCB/ESAF (sub-1,000 monthly transactions) — all excluded from headline claims with explicit documentation |
| NaN preserved, not zero-filled | Missing ATM data (Oct 2022, confirmed absent in raw RBI file) retained as NaN — not imputed — to distinguish absence from zero-activity |

---

## ✅ External Validation

| Metric | External Source | Dashboard | Match |
|---|---|---|---|
| Cards outstanding, Mar 2024 | RBI/Industry: ~101M | 101.8M | ✓ (<1% variance) |
| Annual spend FY24 | Industry: Rs 18.26L cr | Rs 18.31L cr | ✓ (<0.3% variance) |
| Axis-Citi migration date | March 1, 2023 (confirmed) | FY22-23 spike (Mar 2023) | ✓ Exact month |
| Kotak RBI restriction | April 24, 2024 – Feb 12, 2025 | Share decline begins FY24-25 (Apr 2024) | ✓ Exact FY |

---

## 🗂️ Repository Structure

```
rbi_credit_card_project/
│
├── notebooks/
│   └── 01_clean_and_merge.ipynb       # Full Python ETL pipeline
│
├── sql/
│   ├── 01_view_base.sql               # v_base with all derived columns
│   ├── 02_view_industry_pulse.sql     # Dashboard 1 view
│   ├── 03_view_issuer_performance.sql # Dashboard 2 view
│   ├── 04_view_spend_quality.sql      # Dashboard 3 view
│   └── 05_view_risk_signals.sql       # Dashboard 4 view
│
├── reference/
│   └── bank_name_master.xlsx          # 91-row name standardization lookup
│
├── processed/
│   └── master_data.csv                # Clean merged dataset (3,118 rows × 30 cols)
│
├── analyst_brief/
│   └── RBI_Credit_Card_Market_Analyst_Brief.md
│
├── dashboard/
│   └── RBI_Credit_Card_Analysis.pbix  # Power BI file
│
└── README.md
```

---

## 🧰 Tools & Technologies

| Layer | Tool | Purpose |
|---|---|---|
| Data Source | RBI ATMView Portal | 49 raw monthly Excel files |
| Auditing | Microsoft Excel | Manual structure mapping, schema validation |
| ETL | Python (pandas, openpyxl) | Cleaning, standardization, merging |
| Data Store | PostgreSQL (pgAdmin) | Analytical views, window functions |
| BI Layer | Power BI Desktop | 4-page dashboard, DAX measures |
| Connector | Npgsql (psycopg2) | Python → PostgreSQL, Power BI → PostgreSQL |

---

## 📁 Data Source

**RBI Bank-wise ATM/POS/Card Statistics**  
🔗 [https://www.rbi.org.in/Scripts/ATMView.aspx](https://www.rbi.org.in/Scripts/ATMView.aspx)

Raw files are publicly available from the Reserve Bank of India. The dataset covers March 2022 to April 2026 (49 months). Raw files are not included in this repository due to size; the cleaned master dataset (`master_data.csv`) and the ETL notebook to reproduce it from scratch are both included.

---

## 📈 Business Impact

This project produced **four directly actionable findings:**

1. **The Indian credit card market has transitioned from expansion to maturity** — issuance growth decelerated from a peak of 19.3% YoY (FY24) to ~7.6% (FY26), requiring a strategy shift from acquisition volume to portfolio monetization.

2. **Two regulatory events reshaped individual issuer trajectories** more than any competitive dynamic — the 2022 dormant-card mandate and the 2024 Kotak restriction. Risk and compliance investment has a quantifiable market-share cost.

3. **Industry ATM-cash usage on credit cards declined 36% over 4 years** — credit cards are functioning as payment instruments. The remaining risk is structurally concentrated in PSU banks and one persistent outlier (Canara Bank), not spread system-wide.

4. **Premiumization is narrow, not broad** — AmEx's spend-per-card rose 71% over 4 years, while the industry-wide average transaction value fell 24%. Premium growth is an issuer-specific achievement, not a market tailwind.

---

## 👤 About

**Tanuj** — B.Tech (Hons.) CSE (Data Science), NIET Greater Noida (2026)  
Targeting Data Analyst and Product Analyst roles in fintech and financial services.

📧 [tanujupadhyayofficial@gmail.com] · 💼 [https://www.linkedin.com/in/thetanujupadhyay/] · 🐙 [https://github.com/thetanujupadhyay]

---

*All data sourced from publicly available RBI publications. This analysis is independent, not affiliated with or endorsed by the Reserve Bank of India or any issuer mentioned.*
