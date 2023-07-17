--Which sales reps are handling which accounts? 

select sales_rep_id,sales_rep."name" ,sales_rep.region_id , accounts."name",
row_number() over(partition by sales_rep."name") as acc_num from accounts 
join sales_rep 
on accounts.sales_rep_id = sales_rep .id
order by sales_rep.region_id


--One of the aspects that the business wants to explore is what has been the share of each sales representative's
-- year on year sales out of the total yearly sales.


SELECT
    EXTRACT(YEAR FROM o.occurred_at) AS year,
    sr."name"  AS sales_rep_name,
    SUM(o.total_amt_usd) / SUM(SUM(o.total_amt_usd)) 
    OVER (PARTITION BY EXTRACT(YEAR FROM o.occurred_at)) AS sales_share,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM o.occurred_at) ORDER BY SUM(o.total_amt_usd) DESC) AS sales_rank
FROM
    orders o
JOIN
    accounts a ON o.account_id = a.id
JOIN
    sales_rep sr ON a.sales_rep_id = sr.id
GROUP BY
   	year,
    sr."name" 
ORDER BY
    year,
    sales_rank;
   
   
-- Repeat the analysis given above but this time for region. 
--Generate the percentage contribution of each region to total yearly revenue over years.
   
SELECT
    EXTRACT(YEAR FROM o.occurred_at) AS year,
    r."name"  AS region_name,
    SUM(o.total_amt_usd) / SUM(SUM(o.total_amt_usd)) OVER (PARTITION BY EXTRACT(YEAR FROM o.occurred_at)) AS region_share,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM o.occurred_at) ORDER BY SUM(o.total_amt_usd) DESC) AS region_rank
FROM
    orders o
JOIN
    accounts a ON o.account_id = a.id
JOIN
    sales_rep sr ON a.sales_rep_id = sr.id
JOIN
    region r ON sr.region_id = r.id
GROUP BY
    year,
    r."name" 
ORDER BY
    year,
    region_rank;

 

