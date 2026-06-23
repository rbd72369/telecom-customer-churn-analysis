-- ============================================================
-- GOLD LAYER
-- Business-ready consumption layer for Power BI
-- Renames columns to business-friendly display names
-- Drops raw columns already replaced in silver
-- ============================================================

CREATE OR REPLACE TABLE `churn_data.churn_gold` AS
SELECT
  CustomerID                                    AS `Customer ID`,
  gender                                        AS `Gender`,
  SeniorCitizen                                 AS `Senior Citizen`,
  Partner                                       AS `Partner Status`,
  Dependents                                    AS `Dependents`,
  tenure                                        AS `Tenure`,
  tenure_bucket                                 AS `Tenure Group`,
  tenure_bucket_sort                            AS `Tenure Group Sort`,
  PhoneService                                  AS `Phone Service`,
  MultipleLines                                 AS `Multiple Lines`,
  InternetService                               AS `Internet Service`,
  OnlineSecurity                                AS `Online Security`,
  OnlineBackup                                  AS `Online Backup`,
  DeviceProtection                              AS `Device Protection`,
  TechSupport                                   AS `Tech Support`,
  StreamingTV                                   AS `Streaming TV`,
  StreamingMovies                               AS `Streaming Movies`,
  Contract                                      AS `Contract`,
  PaperlessBilling                              AS `Paperless Billing`,
  PaymentMethod                                 AS `Payment Method`,
  MonthlyCharges                                AS `Monthly Charges`,
  monthly_charges_bucket                        AS `Monthly Charge Tier`,
  monthly_charges_bucket_sort                   AS `Monthly Charge Tier Sort`,
  TotalCharges                                  AS `Total Charges`,
  Churn                                         AS `Churn`,
  Churn_Flag                                    AS `Churn Flag`

FROM `churn_data.churn_silver`;
