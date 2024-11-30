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

