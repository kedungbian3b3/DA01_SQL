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
SELECT 
    TO_CHAR(trans_date, 'YYYY-MM') AS month,
    country,
    COUNT(*) AS trans_count,
    SUM(amount) AS trans_total_amount,
    COUNT(CASE WHEN state = 'approved' THEN 1 END) AS approved_count,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM 
    Transactions
GROUP BY 
    TO_CHAR(trans_date, 'YYYY-MM'), country;
EX7:
select a.product_id ,
a.year as first_year,
a.quantity,
a.price 
from Sales as a
join (
    select product_id,
    Min(year) as min_year
    from Sales
    Group by product_id 
) as b 
on a.product_id=b.product_id
and a.year=b.min_year
EX8:
select customer_id 
from Customer 
where customer_id  in (select customer_id
from Customer 
group by customer_id
having count(product_key )=2) 
group by customer_id

EX9:

select employee_id 
from Employees 
where manager_id not in (select employee_id from Employees)
and salary < 30000

EX10:
with Duplicate_Job_Listings as(
select 
company_id,
title,
description,
count(job_id) as job_count 
from job_listings
group by company_id,title,description).
select count(*) from Duplicate_Job_Listings
where job_count>=2
EX11:
WITH UserMovieCounts AS (
    SELECT u.name, COUNT(DISTINCT mr.movie_id) AS movie_count
    FROM Users u
    JOIN MovieRating mr ON u.user_id = mr.user_id
    GROUP BY u.user_id, u.name),
TopUser AS (
…TopMovie AS (
    SELECT title
    FROM MovieAverageRatings
    ORDER BY avg_rating DESC, title
    LIMIT 1)
SELECT name AS results
FROM TopUser
UNION ALL
SELECT title AS results
FROM TopMovie;
EX12:
with numn_RequestAccepted as(
SELECT requester_id AS id FROM RequestAccepted
UNION ALL
SELECT accepter_id AS id FROM RequestAccepted )
select id,
count(*) as num
from numn_RequestAccepted
group by id
order by num DESC
limit 1

