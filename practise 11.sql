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

MID TERM
EX1:
select distinct replacement_cost
from film 
order by replacement_cost ASC --chi phí thấp nhất là giá trị đầu tiên trong bản ghi

EX2:
select 
case
	when replacement_cost between 9.99 and 19.99 then 'low'
	when replacement_cost between 20.00 and 24.99 then 'medium'
	when replacement_cost between 25.00 and 29.99 then 'high'
end stattttt,
count(*) as number
from film
group by case
	when replacement_cost between 9.99 and 19.99 then 'low'
	when replacement_cost between 20.00 and 24.99 then 'medium'
	when replacement_cost between 25.00 and 29.99 then 'high'
end

EX3:
select f.title, c.name, f.length
from film as f
join film_category  on f.film_id = film_category.film_id
join category as c on film_category.category_id=c.category_id
where c.name='Sports' or c.name='Drama'
order by f.length DESC

EX4:
select c.name,
count(*) as so_luong
from film as f
join film_category  on f.film_id = film_category.film_id
join category as c on film_category.category_id=c.category_id
group by c.name
order by count(*) desc

EX5:
select a.first_name, a.last_name,
count(f.film_id)
from actor as a
join film_actor on a.actor_id = film_actor.actor_id
join film as f on  film_actor.film_id = f.film_id
group by a.first_name, a.last_name
order by count(f.film_id) DESC

EX6: 
select a.address, c.customer_id 
from address as a
left join customer as c on a.address_id=c.address_id
where c.customer_id is null


EX7:
select c.city ,
sum(p.amount) as revenue
from city c
join address a on a.city_id=c.city_id
join customer cu on a.address_id=cu.address_id
join payment p on p.customer_id=cu.customer_id
group by c.city 
order by sum(p.amount) desc

EX8:
select co.country, c.city,
sum(p.amount) as revenue
from country as co
join city as c on co.country_id=c.country_id
join address a on a.city_id=c.city_id
join customer cu on a.address_id=cu.address_id
join payment p on p.customer_id=cu.customer_id
group by c.city ,co.country
order by sum(p.amount) ASC


