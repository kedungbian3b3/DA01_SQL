EX1:
select NAME from CITY
where POPULATION > 120000 and COUNTRYCODE = 'USA';
EX2:
Select * from city
where countrycode = 'JPN';
EX3:
Select city, state from station;
EX4:
SELECT DISTINCT CITY
FROM STATION
WHERE CITY LIKE '%A' 
   OR CITY LIKE '%E' 
   OR CITY LIKE '%I' 
   OR CITY LIKE '%O' 
   OR CITY LIKE '%U';
EX5:
SELECT DISTINCT CITY
FROM STATION
WHERE CITY LIKE 'a%' 
   OR CITY LIKE 'e%' 
   OR CITY LIKE 'i%' 
   OR CITY LIKE 'o%' 
   OR CITY LIKE 'u%';
EX6:
SELECT DISTINCT CITY
FROM STATION
WHERE CITY not like 'A%'
AND CITY not like 'E%'
AND CITY not like'I%'
AND CITY not like'O%'
AND CITY not like'U%';
EX7:
SELECT name from Employee
order by name ASC;
EX8:
select name from employee
where salary >2000 and months<10;
EX9:
select product_id from products
where low_fats = 'Y' and recyclable='Y';
EX10:
select name from customer
where referee_id <> 2;
EX11:
select name, population, area from world
where area >= 3000000
and population >=25000000;
EX12:
select author_id id from Views
where viewer_id=author_id
order by id ASC;
EX13:
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date is null;
EX14:
select * from lyft_drivers
where yearly_salary <=30000 or yearly_salary>=70000;
EX15:
select advertising_channel from uber_advertising
where money_spent >= 100000 and year=2019;
