use customerchurn
go

SELECT
    Churn,
    COUNT(*) AS CustomerCount,
    CAST(
        COUNT(*) * 100.0 / SUM(COUNT(*)) over()
        AS DECIMAL(5,2)
    ) AS ChurnPercentage
FROM dbo.telco_churn_clean
GROUP BY Churn;


-- churn by contract

select contract, * from telco_churn_clean

-- contract and churn association
select contract, count(*) as totalcustomers,
sum(case when Churn = 1 then 1 else 0 end) as churnedcustomers,
cast(sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as decimal(5,2)) as churnrate
from telco_churn_clean
group by contract
order by churnrate desc
-- Findings: month to month contracts cause churn.

-- tenure and churn assocation
select 
case 
when tenure <=12 then '0-12 months'
when tenure <=24 then '13-24 months'
when tenure <=48 then '25-48 months'
else '49+ months'
end as TenureGroup,
count(*) as TotalCustomers,
sum(case when churn =1 then 1 else 0 end) as ChurnedCustomers,
cast(sum(case when churn =1 then 1 else 0 end) * 100.0 / count(*) as decimal(5,2)) as ChurnRate
from dbo.telco_churn_clean
group by
case
    when tenure <=12 then '0-12 months'
    when tenure <=24 then '13-24 months'
    when tenure <=48 then '25-48 months'
    else '49+ months'
end
order by ChurnRate desc
-- Findings: The newer the customer, the higher the churn rate


-- monthly charges and churn

select churn, count(*) as customercount,
cast(avg(monthlycharges) as decimal(10,2)) as avgmonthlycharges,
cast(min(monthlycharges) as decimal(10,2)) as minmonthlycharges,
cast(max(monthlycharges) as decimal(10,2)) as maxmonthlycharges
from telco_churn_clean
group by churn

-- internet service and churn rate
select internetservice, count(*) as totalcustomers, sum(case when churn =1 then 1 else 0 end) as churnedcustomers,
cast(
    sum(case when churn=1 then 1 else 0 end) * 100.0 / count(*) as decimal(5,2)) as churnrate

from telco_churn_clean
group by internetservice
order by churnrate desc

-- Contract × Internet Service
SELECT
    Contract,
    InternetService,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ChurnRate
FROM dbo.telco_churn_clean
GROUP BY
    Contract,
    InternetService
ORDER BY
    Contract,
    ChurnRate DESC;


-- EDA: customer demographics

--senior citizen churn
select seniorcitizen, count(*) as totalcustomers,
sum(case when churn = 1 then 1 else 0 end) as churnedcustomers,
cast(sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as decimal(5,2)) as churnrate
from telco_churn_clean
group by seniorcitizen
order by churnrate desc


--partner and churn rate
SELECT
    Partner,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ChurnRate
FROM dbo.telco_churn_clean
GROUP BY Partner
ORDER BY ChurnRate DESC;

--dependents and churn rate
SELECT
    Dependents,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ChurnRate
FROM dbo.telco_churn_clean
GROUP BY Dependents
ORDER BY ChurnRate DESC;


--payment method and churn rate
SELECT
    PaymentMethod,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ChurnRate
FROM dbo.telco_churn_clean
GROUP BY PaymentMethod
ORDER BY ChurnRate DESC;

--paperless billing and churn rate
SELECT
    PaperlessBilling,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ChurnRate
FROM dbo.telco_churn_clean
GROUP BY PaperlessBilling
ORDER BY ChurnRate DESC;


SELECT
    OnlineSecurity,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ChurnRate
FROM dbo.telco_churn_clean
GROUP BY OnlineSecurity
ORDER BY ChurnRate DESC;




SELECT
    OnlineBackup,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ChurnRate
FROM dbo.telco_churn_clean
GROUP BY OnlineBackup
ORDER BY ChurnRate DESC;



--- device protection
select deviceprotection,count(*) as totalcustomers,
sum(case when churn = 1 then 1 else 0 end) as ChurnedCustomers,
cast(sum(case when churn =1 then 1 else 0 end) * 100.0 / count(*)as decimal(5,2)) as churnrate 
from telco_churn_clean
group by deviceprotection
order by churnrate desc

--- tech support
select techsupport, count(*) as totalcustomers, 
sum(case when churn = 1 then 1 else 0 end) as churnedcustomers,
cast(sum(case when churn =1 then 1 else 0 end) * 100.0 /count(*) as decimal(5,2)) as churnrate
from telco_churn_clean
group by techsupport
order by churnrate desc

--- streamingtv
select streamingtv, count(*) as totalcustomers, 
sum(case when churn = 1 then 1 else 0 end) as churnedcustomers,
cast(sum(case when churn =1 then 1 else 0 end) * 100.0 /count(*) as decimal(5,2)) as churnrate
from telco_churn_clean
group by streamingtv
order by churnrate desc

--- streamingmovies
select streamingmovies, count(*) as totalcustomers, 
sum(case when churn = 1 then 1 else 0 end) as churnedcustomers,
cast(sum(case when churn =1 then 1 else 0 end) * 100.0 /count(*) as decimal(5,2)) as churnrate
from telco_churn_clean
group by streamingmovies
order by churnrate desc

--- phoneservice
select phoneservice, count(*) as totalcustomers, 
sum(case when churn = 1 then 1 else 0 end) as churnedcustomers,
cast(sum(case when churn =1 then 1 else 0 end) * 100.0 /count(*) as decimal(5,2)) as churnrate
from telco_churn_clean
group by phoneservice
order by churnrate desc

--- multiplelines
select multiplelines, count(*) as totalcustomers, 
sum(case when churn = 1 then 1 else 0 end) as churnedcustomers,
cast(sum(case when churn =1 then 1 else 0 end) * 100.0 /count(*) as decimal(5,2)) as churnrate
from telco_churn_clean
group by multiplelines
order by churnrate desc



WITH ContractStats AS
(
    SELECT
        Contract,
        COUNT(*) AS TotalCustomers,
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers
    FROM dbo.telco_churn_clean
    GROUP BY Contract
)
SELECT
    Contract,
    TotalCustomers,
    ChurnedCustomers,
    CAST(
        ChurnedCustomers * 100.0 / TotalCustomers
        AS DECIMAL(5,2)
    ) AS ChurnRate,
    CAST(
        TotalCustomers * 100.0 /
        SUM(TotalCustomers) OVER ()
        AS DECIMAL(5,2)
    ) AS CustomerShare
FROM ContractStats
ORDER BY ChurnRate DESC;



--- ranking customer segments by churn rate
WITH SegmentStats AS
(
    SELECT
        Contract,
        InternetService,
        COUNT(*) AS TotalCustomers,
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers
    FROM dbo.telco_churn_clean
    GROUP BY
        Contract,
        InternetService
),
SegmentRates AS
(
    SELECT
        Contract,
        InternetService,
        TotalCustomers,
        ChurnedCustomers,
        CAST(
            ChurnedCustomers * 100.0 / TotalCustomers
            AS DECIMAL(5,2)
        ) AS ChurnRate
    FROM SegmentStats
)
SELECT
    Contract,
    InternetService,
    TotalCustomers,
    ChurnedCustomers,
    ChurnRate,
    RANK() OVER (
        ORDER BY ChurnRate DESC
    ) AS ChurnRateRank
FROM SegmentRates
ORDER BY ChurnRateRank;




SELECT
    CASE
        WHEN tenure <= 12
             AND Contract = 'Month-to-month'
             AND MonthlyCharges >= 70
            THEN 'High Risk'

        WHEN tenure <= 24
             AND Contract = 'Month-to-month'
            THEN 'Medium Risk'

        ELSE 'Lower Risk'
    END AS RiskSegment,

    COUNT(*) AS TotalCustomers,

    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,

    CAST(
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ChurnRate
FROM dbo.telco_churn_clean
GROUP BY
    CASE
        WHEN tenure <= 12
             AND Contract = 'Month-to-month'
             AND MonthlyCharges >= 70
            THEN 'High Risk'

        WHEN tenure <= 24
             AND Contract = 'Month-to-month'
            THEN 'Medium Risk'

        ELSE 'Lower Risk'
    END
ORDER BY ChurnRate DESC;