EX1:
select ci.name, co.cotinent, avg(ci.population)
from city as ci
INNER JOIN country as co on ci.CountryCode=co.Code
group by ci.name, co.cotinent

EX2:
select t.text_id, e.email_id, t.signup_action
from texts as t
inner join emails as e on t.email_id=e.email_id

EX3:
select 
ag.age_bucket,
round((sum(case 
  when ac.activity_type = 'open' then ac.time_spent
end)*100)/sum(time_spent),2) as open_perc  ,
round((sum(case 
  when ac.activity_type = 'send' then ac.time_spent
end)*100)/sum(time_spent),2) as send_perc 
from activities as ac 
inner join age_breakdown as ag 
on ac.user_id=ag.user_id
where ac.activity_type='open' or  ac.activity_type='send'
group by ag.age_bucket 

EX4:
select c.customer_id
from products as p 
inner join customer_contracts as c 
on p.product_id=c.product_id
group by c.customer_id
having COUNT(product_category)=3
ORDER BY c.customer_id

EX5:
select a.employee_id,a.name,
count(b.employee_id ) as re_count,
round(avg(b.age) ) as avg_age 
from employees as a
join employees as b on a.employee_id = b.reports_to  
group by a.employee_id,a.name 
order by a.employee_id DESC

EX6:
select p.product_name,        
sum(unit) as unit 
from Products as p
inner join Orders as o 
on p.product_id  =o.product_id  
where extract(month from o.order_date )=2 and extract(year from o.order_date )=2020  
group by p.product_name  
having sum(unit)>=100

EX7:
SELECT p.page_id
from pages p
left join page_likes l on p.page_id = l.page_id
where l.page_id is null 
