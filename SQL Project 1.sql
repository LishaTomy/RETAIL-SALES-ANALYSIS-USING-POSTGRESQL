-- SQL Retail Sales Analysis - P1

create database sql_project_p1;

-------------------------------------------------create table-------------------------------------------

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			 (
			 transactions_id INT PRIMARY KEY,	
			 sale_date	DATE,
			 sale_time	TIME,
			 customer_id	INT,
			 gender	VARCHAR(15),
			 age INT,	
			 category	VARCHAR(15),
			 quantiy INT,	
			 price_per_unit	FLOAT,
			 cogs	FLOAT,
			 total_sale FLOAT
			 );

------------------------------------------------------------------IMPORTING DATA------------------------------------------- 
 SELECT * FROM retail_sales
 LIMIT 10;

--------------------------------------------------------RETRIEVING THE COUNT OF DATA----------------------------------------------
 SELECT COUNT(*) FROM retail_sales 

--------------------------------------------------------CHECKING FOR NULL VALUE--------------------------------------------

SELECT * FROM retail_sales
WHERE 
 transactions_id IS NULL
 OR
 sale_date IS NULL
 OR
 sale_time IS NULL
 OR
 customer_id IS NULL
 OR
 gender IS NULL
 OR
 age IS NULL
 OR
 category IS NULL
 OR
 quantiy IS NULL
 OR
 price_per_unit IS NULL
 OR
 cogs IS NULL
 OR
 total_sale IS NULL
;

--------------------------------------------------- DATA CLEANING --------------------------------------------

DELETE FROM retail_sales
WHERE 
 transactions_id IS NULL
 OR
 sale_date IS NULL
 OR
 sale_time IS NULL
 OR
 customer_id IS NULL
 OR
 gender IS NULL
 OR
 age IS NULL
 OR
 category IS NULL
 OR
 quantiy IS NULL
 OR
 price_per_unit IS NULL
 OR
 cogs IS NULL
 OR
 total_sale IS NULL
;

-----------------------------------------------------DATA EXPLORATION--------------------------------------

-- Total Sales RECORDS?

SELECT COUNT(*) AS total_sales FROM retail_sales;

-- How many unique customers do we have?

SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- How many categories in the sales

SELECT DISTINCT category FROM retail_sales;

----Data Analysis & Business Key Problems & Insights

-----My Analysis & Findings-----


 -- Query to retrieve all columns for sales made on '2022-11-05'

SELECT * FROM retail_sales
where sale_date = '2022-11-05';

--Query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT  * from retail_sales
where 
category = 'Clothing' 
and
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND 
quantiy >= 4
 ;

--Query to calculate the total sales (total_sale) for each category.

select category,
sum(total_sale) as net_sales,
count(*) as total_orders
from retail_sales
group by 1
order by total_orders desc;

-- Query to find the average age of customers who purchased items from the 'Beauty' category.

select category,
round(avg(age),2) as avg_age
from retail_sales
where category='Beauty'
group by 1;

-- Query to find all transactions where the total_sale is greater than 1000.

SELECT  * from retail_sales
where
total_sale > 1000;

-- Query to find the total number of transactions (transaction_id) made by each gender in each category.

select
category, gender,
count (transactions_id) as trnx_id
from retail_sales
group by category,gender
order by category;

-- Query to calculate the average sale for each month. Find out best selling month in each year

select 
year,
month,
avg_sale
from
(
	select
	extract(YEAR from sale_date) as year,
	extract(MONTH from sale_date) as month,
	avg(total_sale) as avg_sale,
	rank() over(partition by extract(YEAR from sale_date) order by avg(total_sale)  desc) as rank
	from retail_sales
	group by 1,2
)as t1
where rank = 1
order by 1,3 desc;



-- Query to find the top 5 customers based on the highest total sales 


select customer_id,
sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

-- Query to find the number of unique customers who purchased items from each category.

select 
category,
count(distinct customer_id)
from retail_sales
group by category
order by 2 desc;

-- Query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

with hourly_sales
as
(
select *,
case
 when extract(hour from sale_time)< 12 then 'Morning'
 when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
 else 'Evening'
 end as shift
from retail_sales
)
select 
shift,
count(*) as total_orders
from hourly_sales
group by 1
order by 2 desc;