EX1:
with Duplicate_Job_Listings as(
select 
company_id,
title,
description,
count(job_id) as job_count 
from job_listings
group by company_id,title,description)
select count(*) from Duplicate_Job_Listings
where job_count>=2 

EX2:
WITH t1 AS (
    SELECT 
        category,
        product,
        SUM(spend) AS total_spend
    FROM product_spend
    WHERE EXTRACT(YEAR FROM transaction_date) = 2022
      AND category = 'appliance'
    GROUP BY category, product
    ORDER BY total_spend DESC
    LIMIT 2
),
t2 AS (
    SELECT 
        category,
        product,
        SUM(spend) AS total_spend
    FROM product_spend
    WHERE EXTRACT(YEAR FROM transaction_date) = 2022
      AND category = 'electronics'
    GROUP BY category, product
    ORDER BY total_spend DESC
    LIMIT 2
)

SELECT * FROM t1
UNION ALL
SELECT * FROM t2

EX3:
with t1 as(
select policy_holder_id, count(policy_holder_id)
from callers 
group by policy_holder_id
having count(policy_holder_id)>=3 )
select count(*)
from t1 

EX4:
select page_id
from pages 
where page_id not in (select 
page_id
from page_likes 
)

EX5:
with t1 as(
select user_id,
extract(month from event_date) as cdate
from user_actions
where extract(month from event_date) = 7 
),
t2 as (
select user_id,
count(user_id)
from user_actions
where extract(month from event_date)+1 = 7
group by user_id, extract(month from event_date)
),
t3 as (
select t2.user_id,
count(*)
from t2
join t1 on t1.user_id=t2.user_id
group by t2.user_id)
select count(*) as monthly_active_users
from t3 

EX6:
