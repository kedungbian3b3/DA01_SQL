EX1:
SELECT 
  EXTRACT( year from transaction_date) as year,
  product_id,
  spend as curr_year_spend,
  lag(spend) over (PARTITION BY product_id ORDER BY EXTRACT( year from transaction_date)) as prev_year_spend,
  ROUND(((spend - lag(spend) over (PARTITION BY product_id ORDER BY EXTRACT( year from transaction_date))) 
  / lag(spend) over (PARTITION BY product_id ORDER BY EXTRACT( year from transaction_date))) * 100,2) as yoy_rate
FROM user_transactions

EX2:
with min_time as(
SELECT
  issue_month,
  issue_year,
  MIN(concat(issue_year, ' / ', issue_month)) OVER(PARTITION BY card_name) as launch_month,
  card_name, 
  issued_amount
  FROM monthly_cards_issued
)
SELECT
    card_name, 
    issued_amount
FROM min_time
WHERE concat(issue_year, ' / ', issue_month) = launch_month
ORDER BY issued_amount DESC
EX3:
with trans3 as(
SELECT 
  row_number() over (PARTITION BY user_id ORDER BY transaction_date) as stt,
  user_id,
  spend,
  transaction_date
FROM transactions)
SELECT  
  user_id,
  spend,
  transaction_date
from trans3 
WHERE stt = 3
EX4:
WITH last_trans as(
SELECT 
  rank() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) stt,
  user_id,
  product_id,
  transaction_date
FROM user_transactions)
SELECT 
  transaction_date,
  user_id,
  COUNT(product_id) purchase_count
FROM last_trans
WHERE stt = 1
GROUP BY   
  user_id,
  transaction_date
ORDER BY transaction_date

EX5:
SELECT 
    t1.user_id,
    t1.tweet_date,
    ROUND(AVG(t2.tweet_count), 2) AS rolling_avg_3d
FROM tweets t1
JOIN tweets t2 
ON t1.user_id = t2.user_id 
    AND t2.tweet_date BETWEEN t1.tweet_date - INTERVAL '2 DAY' AND t1.tweet_date
GROUP BY t1.user_id, 
    t1.tweet_date
ORDER BY t1.user_id, 
    t1.tweet_date;
EX6:
WITH previous as(
SELECT 
    merchant_id, 
    credit_card_id, 
    amount, 
    transaction_timestamp as current,
    ROUND(EXTRACT(EPOCH FROM transaction_timestamp - 
          LAG(transaction_timestamp) OVER(
          PARTITION BY merchant_id, credit_card_id, amount 
          ORDER BY transaction_timestamp)
            )/60, 2) AS minute_difference 
FROM transactions
)
SELECT 
  COUNT(merchant_id) AS payment_count
FROM previous
WHERE minute_difference <=10
EX7:
WITH total as(
SELECT 
  category,
  product,
  SUM(spend) AS total_spend,
  RANK() OVER (PARTITION BY category 
      ORDER BY SUM(spend) DESC) AS ranking 
FROM product_spend 
WHERE to_char(transaction_date, 'yyyy') = '2022'
GROUP BY category,
        product
)
SELECT 
  category,
  product,
  total_spend
FROM total 
WHERE ranking in (1,2) 
EX8:
WITH top10 AS (
    SELECT 
        a.artist_name, 
        COUNT(c.song_id) AS count_app,
        DENSE_RANK() OVER(ORDER BY COUNT(c.song_id) DESC) AS artist_rank
    FROM artists a
    JOIN songs b
        ON a.artist_id = b.artist_id
    JOIN global_song_rank c
        ON b.song_id = c.song_id 
    WHERE c.rank <= 10
    GROUP BY a.artist_name
)
SELECT 
    artist_name, 
    artist_rank
FROM top10
WHERE artist_rank <= 5
