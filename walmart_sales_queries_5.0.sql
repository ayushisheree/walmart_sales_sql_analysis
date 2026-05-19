-- Q1 -- Store wise total revenue.

select store,
round(sum(weekly_sales),2) as total_sales 
from walmart_sales 
group by 1;


-- Q2 -- top 5 store according highest sales.

select store,
round(sum(weekly_sales),2) as total_sales 
from walmart_sales 
group by 1
order by 2 desc 
limit 5;


-- Q3 -- Holiday weeks/ Non holiday weeks count.

select holiday_flag,
count(distinct(date)) as count_weeks
from walmart_sales
group by 1;


-- Q4 -- Holiday weeks/ Non holiday weeks average sales.

select holiday_flag,
round(avg(weekly_sales),2) as avg_sales
from walmart_sales 
group by 1;


-- Q5 -- On which date weekly sales were highest.

select date,
weekly_sales
from walmart_sales 
order by 2 desc
limit 1;


-- Q6 -- Average fuel price.

select round(avg(fuel_price),2) as avg_fuel_price 
from walmart_sales;


-- Q7 -- On which date temperature was highest.

select date,
temperature 
from walmart_sales
order by 2 desc 
limit 1;


-- Q8 -- Every year's total sales.

select date_format(date,'%Y') as years,
round(sum(weekly_sales),2) as total_sales 
from walmart_sales 
group by 1;


-- Q9 -- Every month's average sales.

select date_format(date,'%Y-%m') as  months,
round(avg(weekly_sales),2) as avg_sales 
from walmart_sales 
group by 1;


-- Q10 -- Top 3 highest selling stores every year.

with cte as (select date_format(date,'%Y') as years,
store,
round(sum(weekly_sales),2) as total_sales
from walmart_sales 
group by 1,2),
ctee as (select *,
rank() over (partition by years order by total_sales desc) as rnk
from cte)
select years,store,total_sales,rnk
from ctee 
where rnk <= 3;


-- Q11 -- On holiday weeks which store's sales were highest.

select store,
weekly_sales,
holiday_flag 
from walmart_sales 
where holiday_flag = 1
order by 2 desc
limit 1;


-- Q12 -- Impact on sales by increasing price in fuel.

select 
case 
when fuel_price between 2 and 3 then '2-3'
when fuel_price between 3 and 4 then '3-4'
when fuel_price between 4 and 5 then '4-5'
end as fuel_category,
round(avg(weekly_sales),2) as avg_sales 
from walmart_sales
group by 1
order by 1;


-- Q13 -- Temperature impact on sales.

select 
case 
when temperature  between 1 and 24 then 'Cold'
when temperature between 25 and 50 then 'Moderate'
when temperature > 50 then 'Hot'
else 'Unknown'
end as temp_category,
round(sum(weekly_sales),2) as total_sales 
from walmart_sales 
group by 1
order by 2 desc;


-- Q14 -- Every quarter total sales.

select 
date_format(date,'%Y') as years,
concat('Q-',quarter(date)) as quarterr,
round(sum(weekly_sales),2) as total_sales 
from walmart_sales 
group by 1,2;


-- Q15 -- Every store month over month growth in percentage.

with cte as (select store,
date_format(date,'%m') as months,
round(sum(weekly_sales),2) as total_sales
from walmart_sales 
group by 1,2)
select *,
lag(total_sales) over (partition by store order by months) as prev_sales,
round((total_sales-lag(total_sales) over (partition by store order by months)) * 100/
(lag(total_sales) over (partition by store order by months)),2) as percent
from cte;


-- Q16 -- Top performer store of every month.

with cte as (select date_format(date,'%Y-%m') as months,
store,
round(sum(weekly_sales),2) as total_sales
from walmart_sales 
group by 1,2),
ctee as (select *,
rank() over (partition by months order by total_sales desc) as rnk 
from cte)
select months,
store,
total_sales from ctee 
where rnk = 1;


-- Q17 -- 3 weeks moving average.

with cte as (select date,
round(sum(weekly_sales),2) as total_sales 
from walmart_sales
group by 1
order by date)
select *,
round(avg(total_sales) over (rows between 2 preceding and current row),2) as running_avg
from cte;


-- Q18 -- Top stores by yearly sales.

with cte as (select date_format(date,'%Y') as years,
store,
round(sum(weekly_sales),2) as total_sales 
from walmart_sales 
group by 1,2),
ctee as (select *,
rank() over (partition by years order by total_sales desc) as rnk 
from cte)
select years,store,total_sales
from ctee 
where rnk = 1;


-- Q19 -- Holiday vs Non holiday sales.

select holiday_flag,
round(sum(weekly_sales),2) as total_sales 
from walmart_sales 
group by 1;


-- Q 20 -- Month over Month growth in percentage.

with cte as (select date_format(date,'%Y-%m') as months,
round(sum(weekly_sales),2) as total_sales
from walmart_sales
group by 1)
select *,
concat(round((total_sales-lag(total_sales) over (order by months)) * 100 /
(lag(total_sales) over (order by months)),2),'%') as growth_in_per
from cte;

-- Q21 -- Top 3 sales of walmart by months. 

with cte as (select date_format(date,'%Y-%m') as months,
round(sum(weekly_sales),2) as total_sales
from walmart_sales 
group by 1),
ctee as (select *,
rank() over (order by total_sales desc) as rnk 
from cte)
select months,total_sales,rnk
from ctee 
where rnk <= 3;


-- Q -- store's highest total sales in quarter.

with cte as (select store,
concat('Q-',quarter(date)) as quarters,
round(sum(weekly_sales),2) as total_sales
from walmart_sales 
group by 1,2),
ctee as (
select *,
rank() over (partition by store order by total_sales desc) as rnk 
from cte)
select store,quarters,total_sales
from ctee
where rnk = 1;





