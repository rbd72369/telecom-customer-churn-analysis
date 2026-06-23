-- ============================================================
-- SILVER LAYER
-- Cleaned and transformed data from raw source
-- Replaces raw boolean/integer fields with readable values
-- Adds bucketing and sort order columns
-- ============================================================

CREATE OR REPLACE TABLE `churn_data.churn_silver` AS
SELECT
  CustomerID,
  gender,

  -- Senior Citizen: replace raw 0/1 with readable label
  CASE
    WHEN SeniorCitizen = 1 THEN 'Senior'
    ELSE 'Non-Senior'
  END AS SeniorCitizen,

  -- Partner: replace raw boolean with readable label
  CASE
    WHEN Partner = True THEN 'Yes'
    ELSE 'No'
  END AS Partner,

  -- Dependents: replace raw boolean with readable label
  CASE
    WHEN Dependents = True THEN 'Yes'
    ELSE 'No'
  END AS Dependents,

  tenure,
  CASE
    WHEN tenure <= 12 THEN '0-12 months'
    WHEN tenure <= 24 THEN '13-24 months'
    WHEN tenure <= 48 THEN '25-48 months'
    ELSE '49+ months'
  END AS tenure_bucket,
  CASE
    WHEN tenure <= 12 THEN 1
    WHEN tenure <= 24 THEN 2
    WHEN tenure <= 48 THEN 3
    ELSE 4
  END AS tenure_bucket_sort,

  PhoneService,
  MultipleLines,
  InternetService,
  OnlineSecurity,
  OnlineBackup,
  DeviceProtection,
  TechSupport,
  StreamingTV,
  StreamingMovies,
  Contract,
  PaperlessBilling,
  PaymentMethod,

  MonthlyCharges,
  CASE
    WHEN MonthlyCharges < 35 THEN 'Under $35'
    WHEN MonthlyCharges < 70 THEN '$35-$70'
    WHEN MonthlyCharges < 90 THEN '$70-$90'
    ELSE 'Over $90'
  END AS monthly_charges_bucket,
  CASE
    WHEN MonthlyCharges < 35 THEN 1
    WHEN MonthlyCharges < 70 THEN 2
    WHEN MonthlyCharges < 90 THEN 3
    ELSE 4
  END AS monthly_charges_bucket_sort,

  SAFE_CAST(TotalCharges AS FLOAT64) AS TotalCharges,

  Churn,
  CASE
    WHEN Churn = TRUE THEN 1
    ELSE 0
  END AS Churn_Flag

FROM `churn_data.raw_churn`;
