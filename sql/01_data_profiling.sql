-- 1. Check table structure
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'telco_churn_raw'
-- Findings: total number of columns: 21

-- 2. Finding total number of rows in the table
SELECT COUNT(*) AS TotalCustomers
FROM dbo.telco_churn_raw;
-- Findings: Total 7043 rows

SELECT TOP 20 *
FROM dbo.telco_churn_raw;

-- Check for duplicate customers
select customerID, count(*) as NumberOfRecords from telco_churn_raw
group by customerID
having count(*) > 1;
--Findings: No duplicate customerID

-- Check for missing values
SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN customerID IS NULL THEN 1 ELSE 0 END) AS Missing_customerID,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS Missing_gender,
    SUM(CASE WHEN SeniorCitizen IS NULL THEN 1 ELSE 0 END) AS Missing_SeniorCitizen,
    SUM(CASE WHEN Partner IS NULL THEN 1 ELSE 0 END) AS Missing_Partner,
    SUM(CASE WHEN Dependents IS NULL THEN 1 ELSE 0 END) AS Missing_Dependents,
    SUM(CASE WHEN tenure IS NULL THEN 1 ELSE 0 END) AS Missing_tenure,
    SUM(CASE WHEN PhoneService IS NULL THEN 1 ELSE 0 END) AS Missing_PhoneService,
    SUM(CASE WHEN MultipleLines IS NULL THEN 1 ELSE 0 END) AS Missing_MultipleLines,
    SUM(CASE WHEN InternetService IS NULL THEN 1 ELSE 0 END) AS Missing_InternetService,
    SUM(CASE WHEN OnlineSecurity IS NULL THEN 1 ELSE 0 END) AS Missing_OnlineSecurity,
    SUM(CASE WHEN OnlineBackup IS NULL THEN 1 ELSE 0 END) AS Missing_OnlineBackup,
    SUM(CASE WHEN DeviceProtection IS NULL THEN 1 ELSE 0 END) AS Missing_DeviceProtection,
    SUM(CASE WHEN TechSupport IS NULL THEN 1 ELSE 0 END) AS Missing_TechSupport,
    SUM(CASE WHEN StreamingTV IS NULL THEN 1 ELSE 0 END) AS Missing_StreamingTV,
    SUM(CASE WHEN StreamingMovies IS NULL THEN 1 ELSE 0 END) AS Missing_StreamingMovies,
    SUM(CASE WHEN StreamingMovies IS NULL THEN 1 ELSE 0 END) AS Missing_StreamingMovies,
    SUM(CASE WHEN Contract IS NULL THEN 1 ELSE 0 END) AS Missing_Contract,
    SUM(CASE WHEN PaperlessBilling IS NULL THEN 1 ELSE 0 END) AS Missing_PaperlessBilling,
    SUM(CASE WHEN PaymentMethod IS NULL THEN 1 ELSE 0 END) AS Missing_PaymentMethod,
    SUM(CASE WHEN TotalCharges IS NULL THEN 1 ELSE 0 END) AS Missing_TotalCharges,
    SUM(CASE WHEN Churn IS NULL THEN 1 ELSE 0 END) AS Missing_Churn
FROM dbo.telco_churn_raw;
--Findings: 11 missing TotalCharges

-- Checking why TotalCharges have 11 missing values
SELECT
    customerID,
    tenure,
    MonthlyCharges,
    TotalCharges,
    Churn
FROM dbo.telco_churn_raw
WHERE TotalCharges IS NULL;
-- Findings: New customers(tenure = 0) will not have TotalCharges

-- Checking if categorical columns contain unexpected values
SELECT DISTINCT gender
FROM dbo.telco_churn_raw;

SELECT DISTINCT InternetService
FROM dbo.telco_churn_raw;

SELECT DISTINCT Contract
FROM dbo.telco_churn_raw;

SELECT DISTINCT PaymentMethod
FROM dbo.telco_churn_raw;

SELECT DISTINCT MultipleLines
FROM dbo.telco_churn_raw;

SELECT DISTINCT OnlineSecurity
FROM dbo.telco_churn_raw;
-- Findings: No strange values


SELECT
    MIN(tenure) AS MinTenure,
    MAX(tenure) AS MaxTenure,
    MIN(MonthlyCharges) AS MinMonthlyCharges,
    MAX(MonthlyCharges) AS MaxMonthlyCharges,
    MIN(TotalCharges) AS MinTotalCharges,
    MAX(TotalCharges) AS MaxTotalCharges
FROM dbo.telco_churn_raw;

SELECT
    COUNT(*) AS InvalidRows
FROM dbo.telco_churn_raw
WHERE tenure < 0
   OR MonthlyCharges < 0
   OR TotalCharges < 0;

-- check for binary columns
   SELECT
    Churn,
    COUNT(*) AS CustomerCount
FROM dbo.telco_churn_raw
GROUP BY Churn;


SELECT
    Partner,
    COUNT(*) AS CustomerCount
FROM dbo.telco_churn_raw
GROUP BY Partner;

SELECT
    PhoneService,
    COUNT(*) AS CustomerCount
FROM dbo.telco_churn_raw
GROUP BY PhoneService;