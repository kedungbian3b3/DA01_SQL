--Số lượng đơn hàng và số lượng khách hàng mỗi tháng
select 
FORMAT_TIMESTAMP('%Y-%m', created_at) AS month_year,
count(distinct user_id) as total_user,
count(order_id) as total_order
from bigquery-public-data.thelook_ecommerce.orders
where status='Complete' and created_at between '2019-01-01' AND '2022-04-30'
group by month_year
order by month_year
/* in sight:
- Trong khoảng đầu 2019 đến cuối 2020, số lượng người mua tăng nhẹ và ổn định vào các khoảng cuối năm 2019 và 2020
- Trong năm 2021, số lượng người mua tăng trưởng mạnh lên tới 29.67% ở đầu kỳ, tăng đều ở trung kỳ và biến động tại cuối kỳ (từ tháng 9 đổ đi)
- Sau đó lại ổn định ở 2 tháng đầu năm 2022 nhưng lại tăng mạnh đến 13.77% cho đến hết tháng 4.
*/

--Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
select 
FORMAT_TIMESTAMP('%Y-%m', created_at) AS month_year,
AVG(sale_price) as average_order_value,
count(distinct user_id) as distinct_users,
from bigquery-public-data.thelook_ecommerce.order_items 
where status='Complete' and created_at between '2019-01-01' AND '2022-04-30'
group by month_year
order by month_year

/* Insight:
- Trong năm 2019, có đúng tháng 5 chỉ với 30 khách hàng nhưng lại có giá trị đơn hàng trung bình cao nhất trong năm, còn lại ổn định
=> Tháng 5 có sự kiện nào đó tốt hoặc những khách hàng trong tháng đó có mức thu nhập và nhu cầu chi tiêu cao
- Các tháng trong các năm tiếp theo có số AVG ổn định gần như không thay đổi (như 1 đường line ngang) và số lượng khách hàng tăng như bên phần 1 đã đề cập.
*/

--Nhóm khách hàng theo độ tuổi
with min_max as ( select gender,
min(age) as youngest,max(age) as oldest
from bigquery-public-data.thelook_ecommerce.users
WHERE created_at BETWEEN '2019-01-01' AND '2022-04-30'
group by gender ),
all_customer as (
select u.first_name,u.last_name,u.gender,u.age,
case 
  when u.age=m.youngest then 'youngest'
  when u.age=m.oldest then 'oldest'
  else ''
end as tag 
from bigquery-public-data.thelook_ecommerce.users u
join min_max m 
ON u.gender = m.gender
 WHERE u.created_at BETWEEN '2019-01-01' AND '2022-04-30')
 select age, count(*) as so_lg , tag from all_customer
where gender in ('M', 'F')
      and tag in ('youngest', 'oldest')
GROUP BY age, tag
order BY age, tag
/*Trẻ nhất là 12 tuổi 956, lớn nhất là 70 tuổi 953*/

-- Top 5 sản phẩm mỗi tháng.
WITH SALE_TABLE AS (
    SELECT 
        FORMAT_TIMESTAMP('%Y-%m', b.created_at) AS month_year,
        b.product_id, 
        a.name AS product_name, 
        b.sale_price, 
        a.cost, 
        COUNT(b.product_id) AS quantity_sold
    FROM 
        bigquery-public-data.thelook_ecommerce.products a
    JOIN 
        bigquery-public-data.thelook_ecommerce.order_items b
        ON a.id = b.product_id
    WHERE 
        b.status = 'Complete'
        AND b.created_at BETWEEN '2019-01-01' AND '2022-04-30'
    GROUP BY 
        month_year, 
        b.product_id, 
        a.name, 
        b.sale_price, 
        a.cost
), PROFIT_TABLE AS (
    SELECT 
        month_year,
        product_id,
        product_name,
        (sale_price * quantity_sold) AS sales,
        (cost * quantity_sold) AS cost,
        (sale_price - cost) * quantity_sold AS profit
    FROM SALE_TABLE 
)
SELECT * FROM (
  SELECT 
      DENSE_RANK() OVER(PARTITION BY month_year ORDER BY profit DESC) AS rank_per_month,
      *
  FROM PROFIT_TABLE
  ORDER BY month_year 
)
WHERE rank_per_month IN (1,2,3,4,5)

--Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
WITH SALE_DATA AS (
    SELECT 
        FORMAT_TIMESTAMP('%Y-%m-%d', b.created_at) AS dates,
        a.category AS product_categories,
        b.sale_price,
        COUNT(b.product_id) AS slg_order
    FROM bigquery-public-data.thelook_ecommerce.products a
    JOIN bigquery-public-data.thelook_ecommerce.order_items b
        ON a.id = b.product_id
    WHERE 
        b.status = 'Complete'
        AND b.created_at BETWEEN '2022-01-15' AND '2022-04-15'
    GROUP BY 
        dates, 
        product_categories, 
        sale_price
), DAILY_REVENUE AS (
    SELECT 
        dates,
        product_categories,
        SUM(sale_price * slg_order) AS revenue
    FROM SALE_DATA
    GROUP BY 
        dates, 
        product_categories
)
SELECT 
    dates,
    product_categories,
    revenue
FROM DAILY_REVENUE
ORDER BY 
    dates, 
    product_categories;
--III.1
WITH x AS (
SELECT 
        FORMAT_TIMESTAMP('%Y-%m', c.created_at) AS Month,
        FORMAT_TIMESTAMP('%Y', c.created_at) AS Year,
        a.category AS Product_category,
        COUNT(b.product_id) AS TPO -- Tổng số đơn hàng mỗi category ở từng tháng
    FROM 
        bigquery-public-data.thelook_ecommerce.products a
    JOIN 
        bigquery-public-data.thelook_ecommerce.order_items b
        ON a.id = b.product_id
    JOIN 
        bigquery-public-data.thelook_ecommerce.orders c
        ON b.order_id = c.order_id
    WHERE 
        b.status = 'Complete'
    GROUP BY 1, 2, 3
    ORDER BY Month, Year,Product_category 
), xx AS(
SELECT
    Month,
    Year,
    Product_category,
    ROUND(sum(TPO * b.sale_price),2) AS TPV, -- Tổng doanh thu mỗi category ở từng tháng
    TPO,
    ROUND(SUM(TPO * a.cost),2) AS Total_cost -- Tổng chi phí mỗi category ở từng tháng,
FROM x
    JOIN bigquery-public-data.thelook_ecommerce.products a
        ON x.Product_category = a.category
    JOIN 
        bigquery-public-data.thelook_ecommerce.order_items b
        ON a.id = b.product_id
    WHERE 
        b.status = 'Complete'
GROUP BY 1,2,3,5
ORDER BY Month, Year,Product_category 
)
SELECT  
    Month,
    Year,
    Product_category,
    TPV,
    TPO,
    -- Tăng trưởng doanh thu 
    round((TPV - LAG(TPV) OVER (ORDER BY Year, Month, Product_category)) / LAG(TPV) OVER (ORDER BY Year, Month, Product_category) * 100.00,2) || '%' AS Revenue_growth, 
    -- Tăng trưởng số đơn hàng
    round((TPO - LAG(TPO) OVER (ORDER BY Year, Month, Product_category)) / LAG(TPO) OVER (ORDER BY Year, Month, Product_category) * 100.00,2) || '%' AS Order_growth, 
    Total_cost,
    ROUND((TPV - Total_cost),2) AS Total_profit, -- Tổng lợi nhuận mỗi tháng
    ROUND(((TPV - Total_cost) / Total_cost * 100.00),2) AS Profit_to_cost_ratio  -- Tỷ lệ lợi nhuận trên chi phí mỗi tháng
FROM xx
ORDER BY Year, Month, Product_category

--III.2
WITH date_index AS (
  SELECT 
      user_id,
      amount,
      created_at,
      FORMAT_TIMESTAMP('%Y-%m', created_at) AS cohort_date,
      (EXTRACT(YEAR FROM created_at) - EXTRACT(YEAR FROM first_purchase_date)) * 12 + 
      EXTRACT(MONTH FROM created_at) - EXTRACT(MONTH FROM first_purchase_date) + 1 AS index
  FROM (
    SELECT 
        user_id, 
        ROUND(sale_price, 2) AS amount,
        MIN(created_at) OVER (PARTITION BY user_id) AS first_purchase_date,
        created_at
    FROM 
        bigquery-public-data.thelook_ecommerce.order_items 
  )
), condition AS (
    SELECT 
        cohort_date,
        index,
        COUNT(DISTINCT user_id) AS user_count,
        SUM(amount) AS sum_amount
    FROM 
        date_index
    GROUP BY 
        cohort_date,
        index
    ORDER BY 
        cohort_date, 
        index
), customer_cohort AS (
    SELECT  
        cohort_date, 
        SUM(CASE WHEN index = 1 THEN user_count ELSE 0 END) AS m1,
        SUM(CASE WHEN index = 2 THEN user_count ELSE 0 END) AS m2,
        SUM(CASE WHEN index = 3 THEN user_count ELSE 0 END) AS m3,
        SUM(CASE WHEN index = 4 THEN user_count ELSE 0 END) AS m4
    FROM condition
    GROUP BY cohort_date
    ORDER BY cohort_date
), retention_cohort AS (
    SELECT 
        cohort_date,
        ROUND(m1 / m1 * 100.00, 2) || '%' AS m1,
        ROUND(m2 / m1 * 100.00, 2) || '%' AS m2,
        ROUND(m3 / m1 * 100.00, 2) || '%' AS m3,
        ROUND(m4 / m1 * 100.00, 2) || '%' AS m4
    FROM customer_cohort
), churn_cohort AS (
    SELECT 
        cohort_date,
        (100 - ROUND(m1 / m1 * 100.00, 2)) || '%' AS m1,
        (100 - ROUND(m2 / m1 * 100.00, 2)) || '%' AS m2,
        (100 - ROUND(m3 / m1 * 100.00, 2)) || '%' AS m3,
        (100 - ROUND(m4 / m1 * 100.00, 2)) || '%' AS m4
    FROM customer_cohort
)
--select * from customer_cohort
--select * from retention_cohort
--select * from churn_cohort
