EX1:
select distinct city from station
where ID%2=0;
EX2:
select count(city)-count(distinct city) from station
EX3:
select ceil(abs(avg(salary) - cast(replace(cast(avg(salary) as varchar),'0','') as decimal))) from EMPLOYEES
EX4:
select item_count,
sum(order_occurrences) as count_orders,
(item_count*order_occurrences) as count_items
from items_per_order 
group by item_count, count_items
order by item_count;

select sum(count_items)/sum(count_orders) as mean;

EX5:
select candidate_id,
count(skill)
from candidates 
where skill in ('Python','Tableau','PostgreSQL')
group by candidate_id
having count(skill)=3

EX6:
select user_id,
date_part('day',max(post_date)-min(post_date)) as day_between 
from posts
group by user_id
having count(user_id)>=2

EX7:
Select card_name,
Max(issued_amount) - Min(issued_amount) as difference
from monthly_cards_issued 
group by card_name

EX8:
/*Xuất tên nhà sản xuất, 
số lượng thuốc liên quan đến tổn thất
và tổng số tổn thất theo giá trị tuyệt đối. 
Hiển thị kết quả được sắp xếp theo thứ tự giảm dần
với mức tổn thất cao nhất được hiển thị ở trên cùng.*/

select manufacturer, 
round(total_sales/units_sold,2) as drug_cost,  --giá tiền từng loại thuốc 
cogs-total_sales as price_lost, -- số tiền tổn thất từng loại
floor((cogs-total_sales)/(total_sales/units_sold)) AS count_of_drug_causing_loss, --số lượng thuốc bị tổn thất
abs(cogs-total_sales) AS total_lost --tổng tổn thất
from pharmacy_sales 
where cogs-total_sales>0 -- nhãn hàng tổn thất
group by manufacturer, total_sales, units_sold, cogs
order by  manufacturer DESC;

EX9:
select movie 
from Cinema
where ID%2=1 and description != '%boring%'


EX10:

/*Viết một giải pháp để tính toán số lượng các môn học duy nhất mà mỗi giáo viên giảng dạy trong trường đại học.

Trả về bảng kết quả theo bất kỳ thứ tự nào.*/

Select teacher_id,
count(distinct subject_id) as subject
from Teacher 
group by teacher_id

EX11:
/*Viết một giải pháp sẽ trả về số lượng người theo dõi cho mỗi người dùng.

Trả về bảng kết quả được sắp xếp theo user_id theo thứ tự tăng dần.*/

select user_id,
count(follower_id ) as count_follower
from Followers 
group by user_id
order by user_id ASC


EX12:
select class,
from Courses 
group by class
having count(student)>=5

