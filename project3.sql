/* Ở Project này chúng ta sử dụng dataset đã được xử lý ở PROJECT 1.

Sau khi dữ liệu được làm sạch hãy tiến hành phân tích theo các gợi ý sau:

1) Doanh thu theo từng ProductLine, Year  và DealSize?

Output: PRODUCTLINE, YEAR_ID, DEALSIZE, REVENUE

2) Đâu là tháng có bán tốt nhất mỗi năm?

Output: MONTH_ID, REVENUE, ORDER_NUMBER

3) Product line nào được bán nhiều ở tháng 11?

Output: MONTH_ID, REVENUE, ORDER_NUMBER

4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 

Xếp hạng các các doanh thu đó theo từng năm.

Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK

5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM 

(sử dụng lại bảng customer_segment ở buổi học 23) */


select * from public.sales_dataset_rfm_prj_clean

/*1) Doanh thu theo từng ProductLine, Year  và DealSize?
Output: PRODUCTLINE, YEAR_ID, DEALSIZE, REVENUE*/
select 
productline,
year_id,
DealSize,
sum(sales) as revenue 
from public.sales_dataset_rfm_prj_clean
group by productline,
year_id,
DealSize
order by productline,
year_id,
DealSize DESC

/*2) Đâu là tháng có bán tốt nhất mỗi năm?
Output: MONTH_ID, REVENUE, ORDER_NUMBER*/
with rank_table as (
select 	month_id,year_id,sum(sales) as revenue
from public.sales_dataset_rfm_prj_clean
group by month_id,year_id
order by month_id,year_id,sum(sales) )
, ranking as( select *,
rank() over(partition by year_id order by revenue desc)
from rank_table)
select month_id, year_id, revenue
from ranking
where rank=1

/*3) Product line nào được bán nhiều ở tháng 11?*/
with ranktable as(
select month_id, year_id,productline,
sum(sales) as revenue
from public.sales_dataset_rfm_prj_clean
group by month_id, year_id,productline
having month_id=11
order by year_id)
,rank11 as (
select *,
rank() over(partition by year_id order by revenue) ranking
from ranktable)
select month_id, year_id, productline,  revenue from rank11
where ranking=1

/*4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
Xếp hạng các các doanh thu đó theo từng năm.
Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK*/
with relan as (
select productline, country, year_id , sum(sales) as revenue
from public.sales_dataset_rfm_prj_clean
where country='UK'
group by productline, country, year_id)
select YEAR_ID, PRODUCTLINE,REVENUE,
rank() over(partition by year_id order by revenue DESC) 
from relan
-- sản phẩm có doanh thu tốt nhất mỗi nhăm ở UK
select YEAR_ID, PRODUCTLINE,REVENUE
from ((select productline, country, year_id , sum(sales) as revenue,
rank() over(partition by year_id order by sum(sales) DESC) ranking
from public.sales_dataset_rfm_prj_clean
where country='UK'
group by productline, country, year_id)) 
where ranking=1

/*5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM */
with RFM as(
select customername ,
current_date - MAX(orderdate) as R,
count(ordernumber) as F,
sum(sales) as M
from public.sales_dataset_rfm_prj_clean
group by customername)
, rfmscore as(
select customername,
cast(ntile(5) over(order by R DESC) as varchar) ||
cast(ntile(5) over(order by F DESC) as varchar) ||
cast(ntile(5) over(order by M DESC) as varchar) as RFM
from RFM)
select customername
from rfmscore as q join public.segment_score as w on q.rfm=w.scores 
where w.segment = 'Champions'

/*Khách hàng tốt nhất:
"Royale Belge"
"Australian Gift Network, Co"
"Boards & Toys Co."
"Mini Auto Werke"
"Mini Caravy"
"Quebec Home Shopping Network"*/
