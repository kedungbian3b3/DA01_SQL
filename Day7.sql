
EX1:
select name
from students
where marks>75
order by right(name,3), id asc;

EX2:
select Upper(left(name,1))||lower(substring(name,2))
from users

EX3:
select manufacturer,
round(sum(total_sales)/1000000)||' '||'million'
from pharmacy_sales 
group by manufacturer
order by sum(total_sales) DESC;

EX4:
select extract(month from submit_date) as mth,
user_id,
round(AVG(stars),2) as avg_stars
from reviews 
group by extract(month from submit_date), user_id
order by extract(month from submit_date), user_id

EX5:
select sender_id,
count(sender_id) as message_count
from messages 
group by sender_id	
order by count(sender_id) DESC
limit(2)

EX6:
select tweet_id 
from Tweets 
where position(right(1))>15

EX7:
select activity_date,
count(user_id)
from Activity 
where extract(day from '27-07-2019') - extract(day from activity_date)<=30
group by activity_date
having count(activity_type )>=1

EX8:
select count(id)
from employees
where extract(month from joining_date)<=7

EX9:
select position('a' in first_name) as a_position
from worker
where first_name='Amitah'

EX10:
select id, 
title,
winery,
substring(title from length(winery)+2 for 4) as year
from winemag_p2 
where country = 'Macedonia'
