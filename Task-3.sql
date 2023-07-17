--The business wants to understand which accounts contribute to the bulk of the revenue and 
--the business also wants to see year on year trend on the revenue contribution of each account.

--The final table should show revenue share of each account for each year's total revenue. 

SELECT
    EXTRACT(YEAR FROM o.occurred_at) AS year,
    a.name AS account_name,
    sum(o.total_amt_usd) as revenue,
    SUM(o.total_amt_usd) / SUM(SUM(o.total_amt_usd)) 
    OVER (PARTITION BY EXTRACT(YEAR FROM o.occurred_at)) AS revenue_share,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM o.occurred_at)ORDER BY SUM(o.total_amt_usd) DESC) AS revenue_rank
FROM
    orders o
JOIN
    accounts a ON o.account_id = a.id
GROUP BY
    year,
    account_name  
ORDER BY
    year,
    revenue_rank;