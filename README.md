# telecom-customer-churn-analysis
End-to-end customer churn analysis for a fictional telecom provider. BigQuery medallion architecture (bronze/silver/gold), SQL transformations, and Power BI dashboard identifying and illustrating key churn drivers across 7,000+ customers.

# Customer Churn Analysis
### Telecom Dataset | BigQuery · SQL · Power BI

---

## Overview

This project analyzes customer churn for a fictional telecom provider using a publicly available dataset of ~7,000 customers. The goal was to identify which customer segments are most at risk of churning and quantify the revenue impact — producing insights that could inform retention strategy.

The end-to-end workflow follows a medallion architecture (bronze → silver → gold) in BigQuery, with SQL-based transformation at each layer and an interactive two-page Power BI dashboard built on top of the gold layer.

---

## Key Findings

- **Overall churn rate: 26.54%** across 7,043 customers, representing **$139K in lost monthly revenue**
- **Month-to-month contracts** have the highest churn at 42.71%, compared to 11.27% for one-year and 2.83% for two-year contracts
- **Fiber optic customers** churn at 41.89%, more than double the DSL rate of 18.96%
- **Early tenure customers (0–12 months)** churn at 47.44%, the highest of any tenure group
- **Senior citizens** churn at 41.68% vs 23.61% for non-seniors
- **Customers without partners or dependents** churn at higher rates than those with partners (32.96% vs 19.66%) and dependents (31.28% vs 15.45%)

---

## Tech Stack

| Layer | Tool |
|---|---|
| Data storage & querying | Google BigQuery |
| Transformation | SQL (medallion architecture) |
| Visualization | Power BI Desktop |
| DAX measures | Churn rate, revenue lost, customer counts |
| Data modeling | Gold layer table as single source of truth for Power BI |

---

## Data Architecture

This project implements a three-layer medallion architecture entirely within BigQuery:

**Bronze** — raw source data loaded directly from the IBM Telco dataset with no modifications. Preserves original schema and values as-is.

**Silver** (`churn_silver`) — cleaned and transformed view built on top of bronze. Key transformations include:
- `SAFE_CAST` on TotalCharges to handle malformed numeric values
- Boolean and integer fields replaced with readable labels (`SeniorCitizen` 0/1 → "Senior"/"Non-Senior", `Partner` True/False → "Yes"/"No")
- Tenure and monthly charge bucketing with sort order columns for correct BI tool ordering
- Churn flag added as integer for DAX measure compatibility

**Gold** (`churn_gold`) — materialized table built on top of silver, structured for BI consumption. Renames all columns to business-friendly display names, drops raw intermediate columns no longer needed for reporting, and serves as the single source of truth for Power BI.

```
raw_churn (Bronze)
    └── churn_silver (View)
            └── churn_gold (Table) ← Power BI connects here
```

---

## Dashboard Structure

**Page 1 — Churn Overview**
High-level KPIs alongside churn rate and revenue lost broken down by contract type, internet service, monthly charge tier, and customer tenure. Includes four synchronized slicers (Contract, Internet Service, Senior Citizen, Tenure Group) enabling cross-dimensional filtering across all visuals.

**Page 2 — Customer Demographics**
Churn segmentation by partner status, senior citizen status, and dependent status — pairing churn rate with revenue lost to show both frequency and dollar impact by demographic group. Slicers remain consistent with page 1 and are synced across both pages to maintain filter context during navigation.

---

## Methodology

Raw data was loaded into BigQuery and passed through the silver transformation layer before being materialized into the gold table. Power BI connects exclusively to the gold layer — all column naming, bucketing, and business logic is handled in SQL rather than in the Power BI data model, keeping the BI layer clean and focused on visualization.

DAX measures were written to calculate metrics dynamically based on slicer selections:

```
Churn Rate = 
DIVIDE(
    SUM([Churn Flag]),
    COUNT([Customer ID]),
    0
)
```

```
Revenue Lost to Churn = 
SUMX(
    FILTER(churn_gold, [Churn Flag] = 1),
    churn_gold[Monthly Charges]
)
```

---

## Files

| File | Description |
|---|---|
| `churn_silver.sql` | BigQuery SQL — silver transformation view |
| `churn_gold.sql` | BigQuery SQL — gold materialized table for Power BI |
| `churn_analysis.pbix` | Power BI dashboard file |
| `telco_churn.csv` | Source dataset |

---

## Limitations

- **Churn cause is unknown** — the dataset records whether a customer churned but not why. Voluntary churn (dissatisfaction, competitor offers) and involuntary churn (death, relocation, financial hardship) are indistinguishable. This is particularly relevant for the senior citizen finding — elevated churn in that segment may reflect a mix of voluntary and involuntary attrition.

- **Static snapshot** — the dataset represents a single point in time with no time series component. Trends over time, seasonality, and the impact of specific business events cannot be analyzed.

- **Fictional dataset** — this is a synthetic IBM dataset designed for educational purposes. Findings are analytically valid but should not be treated as reflective of any real telecom company's performance.

- **No cost-to-acquire data** — revenue lost to churn is calculated from monthly charges only. Without customer acquisition cost, the full financial impact of churn cannot be quantified.

---

## Further Investigation

The following questions are raised by the findings but require additional data not present in this dataset:

- Are there early behavioral signals in the first 90 days that predict which month-to-month customers will churn?
- What percentage of month-to-month customers convert to longer contracts over time, and does conversion correlate with lower churn?
- Is there a specific month within the 0–12 tenure range where churn peaks — month 1, month 3, month 6?
- Do customers who adopt additional services early in their tenure churn at lower rates?
- What portion of senior citizen churn is involuntary — driven by death, illness, or other non-retention factors?

---

## Dataset

IBM Telco Customer Churn dataset via Kaggle. Contains demographic, account, and service information for 7,043 telecom customers with a binary churn label.
