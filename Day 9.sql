EX1:
select 
sum(case 
  when device_type='laptop' then 1 else 0
end) laptop_reviews,
sum(case 
  when device_type<>'laptop' then 1 else 0
end) mobile_views
from viewership 

EX2:
select
x,y,z,
case
    when power(x)+power(y)=power(z) then 'YES'
    when power(z)+power(y)=power(x) then 'YES'
    when power(x)+power(z)=power(y) then 'YES'
    else 'NO'
end triangle 
from Triangle

EX3:
select 
ROUND(
  (count(case 
    when call_category='n/a' or call_category is null then 1
  end) *100) / count(*)
,1)
from callers 

EX4:
select 
case
    when referee_id <> 2 then name
end name 
from customer

EX5:
select 
case
    when survived =1 then 'survived' 
    else 'die'
end as status,
sum(
case
    when pclass = 1 then 1 else 0
end) first_class,
sum(
case
    when pclass = 2 then 1 else 0
end) second_class,
sum(
case
    when pclass = 3 then 1 else 0
end) third_class
from titanic
group by status
