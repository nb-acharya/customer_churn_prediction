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





