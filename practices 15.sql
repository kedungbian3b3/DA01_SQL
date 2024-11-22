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
