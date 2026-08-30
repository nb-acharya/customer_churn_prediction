USE CustomerChurn;
GO

-- Create a working copy of raw data
select * into dbo.telco_churn_clean
from dbo.telco_churn_raw
go

-- To witness Missing values
SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN customerID IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS MissingGender,
    SUM(CASE WHEN SeniorCitizen IS NULL THEN 1 ELSE 0 END) AS MissingSeniorCitizen,
    SUM(CASE WHEN Partner IS NULL THEN 1 ELSE 0 END) AS MissingPartner,
    SUM(CASE WHEN Dependents IS NULL THEN 1 ELSE 0 END) AS MissingDependents,
    SUM(CASE WHEN tenure IS NULL THEN 1 ELSE 0 END) AS MissingTenure,
    SUM(CASE WHEN MonthlyCharges IS NULL THEN 1 ELSE 0 END) AS MissingMonthlyCharges,
    SUM(CASE WHEN TotalCharges IS NULL THEN 1 ELSE 0 END) AS MissingTotalCharges,
    SUM(CASE WHEN Churn IS NULL THEN 1 ELSE 0 END) AS MissingChurn
FROM dbo.telco_churn_clean;

SELECT
    customerID,
    tenure,
    MonthlyCharges,
    TotalCharges
FROM dbo.telco_churn_clean
WHERE TotalCharges IS NULL;

-- Updating TotalCharges to 0
UPDATE dbo.telco_churn_clean
SET TotalCharges = 0
WHERE TotalCharges IS NULL
  AND tenure = 0;

SELECT COUNT(*) AS RemainingMissingTotalCharges
FROM dbo.telco_churn_clean
WHERE TotalCharges IS NULL;

-- Cleaning Decision:
/*
    11 customers has NULL TotalCharges
    All 11 had tenure = 0, indicating new customers
    For analysis, NULL TotalCharges was converted to 0
*/

-- Checking for any typo appears
SELECT 'gender' AS ColumnName, gender AS Value, COUNT(*) AS Count
FROM dbo.telco_churn_clean
GROUP BY gender

UNION ALL

SELECT 'InternetService', InternetService, COUNT(*)
FROM dbo.telco_churn_clean
GROUP BY InternetService

UNION ALL

SELECT 'Contract', Contract, COUNT(*)
FROM dbo.telco_churn_clean
GROUP BY Contract

UNION ALL

SELECT 'PaymentMethod', PaymentMethod, COUNT(*)
FROM dbo.telco_churn_clean
GROUP BY PaymentMethod;

-- service column
SELECT 'MultipleLines' AS ColumnName, MultipleLines AS Value, COUNT(*) AS Count
FROM dbo.telco_churn_clean
GROUP BY MultipleLines

UNION ALL

SELECT 'OnlineSecurity', OnlineSecurity, COUNT(*)
FROM dbo.telco_churn_clean
GROUP BY OnlineSecurity

UNION ALL

SELECT 'OnlineBackup', OnlineBackup, COUNT(*)
FROM dbo.telco_churn_clean
GROUP BY OnlineBackup

UNION ALL

SELECT 'DeviceProtection', DeviceProtection, COUNT(*)
FROM dbo.telco_churn_clean
GROUP BY DeviceProtection

UNION ALL

SELECT 'TechSupport', TechSupport, COUNT(*)
FROM dbo.telco_churn_clean
GROUP BY TechSupport;

-- Final validation
SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT customerID) AS UniqueCustomers,
    SUM(CASE WHEN TotalCharges IS NULL THEN 1 ELSE 0 END) AS MissingTotalCharges,
    SUM(CASE WHEN MonthlyCharges < 0 THEN 1 ELSE 0 END) AS InvalidMonthlyCharges,
    SUM(CASE WHEN TotalCharges < 0 THEN 1 ELSE 0 END) AS InvalidTotalCharges,
    SUM(CASE WHEN tenure < 0 THEN 1 ELSE 0 END) AS InvalidTenure
FROM dbo.telco_churn_clean;