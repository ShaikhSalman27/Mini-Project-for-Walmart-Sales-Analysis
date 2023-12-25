### Walmart Sales Analysis Dataset

use walmartsalesanalysis;

SELECT * FROM walmartsalesanalysis.`walmartsalesdata.csv`;

-- --------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------   Feature Engineering   ------------------------------------------------------ 

# Add column time_of_day
select 
	time,
    (case
		when `time` between "00:00:00" and "12:00:00" then "Morning" 
        when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
	end
    ) as time_of_date
 from `walmartsalesdata.csv`;

alter table `walmartsalesdata.csv` add column time_of_day varchar(20);

update `walmartsalesdata.csv`
set time_of_day = (
case
		when `time` between "00:00:00" and "12:00:00" then "Morning" 
        when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
	end
);

# Add column day_name

select 
	date,
    dayname(date) as day_name
from `walmartsalesdata.csv`;

alter table `walmartsalesdata.csv` add column day_name varchar(20);

update `walmartsalesdata.csv`
set day_name = dayname(date);

# Add column month name

select 
	date,
		monthname(date)
from `walmartsalesdata.csv`;

alter table `walmartsalesdata.csv` add column month_name varchar(20);

update `walmartsalesdata.csv`
set month_name = monthname(date);


-- -------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------  Exploratory Data Analysis (EDA)  -----------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------     Generic    ------------------------------------------------------------------------

# How many unique cities does data have?

select distinct(City) from `walmartsalesdata.csv`;

# In wich city is each branch?

select distinct(City), Branch from `walmartsalesdata.csv`;


-- -------------------------------------------------------   Product   ----------------------------------------------------------------------

# How many unique product lines does the data have?

select distinct(`Product line`) from `walmartsalesdata.csv`;
select count(distinct(`Product line`)) as total_product from `walmartsalesdata.csv`;

# What is the most common payment method?

select payment, count(payment) total_payment from `walmartsalesdata.csv` group by payment order by total_payment desc; 
select max(Payment) from `walmartsalesdata.csv`;

# What is the most selling product line?

select `product line`, count(`product line`) as cnt from `walmartsalesdata.csv` group by `Product line` order by `product line` desc;

# What is the total revenue by month?

select month_name, round(sum(total), 2) as total_revenue from `walmartsalesdata.csv` group by month_name order by total_revenue desc;

# What month had the largest COGS?

select month_name, round(sum(COGS), 2) as cogs from `walmartsalesdata.csv` group by month_name order by cogs desc;

# What product line had the largest revenue?

select `product line`, round(sum(total), 2) as total_revenue from `walmartsalesdata.csv` group by `product line` order by total_revenue desc;

# What is the city with the largest revenue?

select city, round(sum(total), 2) as total_revenue from `walmartsalesdata.csv` group by city order by total_revenue desc;

# What product line had the largest VAT?

select `product line`, avg(`tax 5%`) as VAT from `walmartsalesdata.csv` group by `product line` order by VAT desc;

# Which branch sold more products than average product sold?

select branch, sum(quantity) as quantity from `walmartsalesdata.csv` 
group by branch 
having sum(quantity) > (select avg(quantity) from `walmartsalesdata.csv`);

select branch, sum(quantity) as quantity from `walmartsalesdata.csv` 
group by branch 
order by quantity desc;

-- what is the most common product line by gender ?

select Gender, `Product line`, count(Gender) as qnt from `walmartsalesdata.csv` group by Gender, `Product line` order by qnt desc;
select Gender, `Product line`, sum(Quantity) as qnt from `walmartsalesdata.csv` group by Gender, `Product line` order by qnt desc;
select Gender, `Product line`, count(Quantity) as qnt from `walmartsalesdata.csv` group by Gender, `Product line` order by qnt desc;

-- What is the average rating of each product line ?

select `Product line`, round(avg(Rating), 2) as Rating from `walmartsalesdata.csv` group by `Product line` order by Rating desc;


-- --------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------  Sales  --------------------------------------------------------------------------

-- Numer of sales made in each time of the day per weekday ?

select Quantity, weekday(count(day_name)) from  `walmartsalesdata.csv` group by Quantity;

-- which of the customer types brings the most revenue ?

select `Customer type`, round(sum(Total), 2) as total from `walmartsalesdata.csv` group by `Customer type` order by total desc limit 1;

-- which city has largest tax prcentage/VAT (Value Added Tax) ?

select City, sum(`Tax 5%`)as tax from `walmartsalesdata.csv` group by City order by tax desc;
select City, max(`Tax 5%`)as tax from `walmartsalesdata.csv` group by City order by tax desc;

-- which customer type pays the most in VAT ?

select `Customer type`, avg(`Tax 5%`)as tax from `walmartsalesdata.csv` group by `Customer type` order by tax desc;


-- ----------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------   Customer   ----------------------------------------------------------------

-- How many unique customer types does the data have ?

select distinct(`Customer type`) from `walmartsalesdata.csv`;

-- How many unique payment methods does the data have ?

select distinct(Payment) from `walmartsalesdata.csv`;

-- What is the most common customer type ?

select max(`Customer type`) from `walmartsalesdata.csv`;

-- Which customer type buys the most ?

select `Customer type`, sum(Total) as total from `walmartsalesdata.csv` group by `Customer type` order by total desc limit 1;

-- What is the gendr of the most customer  ?

select Gender, `Product line`, round(sum(Total), 2) as total from `walmartsalesdata.csv` group by Gender, `Product line` order by total desc;

-- What is the gender distribution per branch ?

select Gender,Branch, count(Branch) from `walmartsalesdata.csv` group by Gender, Branch;

-- Which time of the day do customers give most ratings ?

select time_of_day, day_name, max(Rating) as rating from `walmartsalesdata.csv` group by time_of_day, day_name order by rating desc;

-- which time of the day do customer give most rating by per brach ?

select time_of_day, day_name, Branch, max(Rating) as rating, count(Branch) 
from `walmartsalesdata.csv` 
group by time_of_day, day_name, Branch 
order by rating desc;

-- which day of the week has the best avg rating ?

select day_name, max(Rating) as rating from `walmartsalesdata.csv` group by day_name order by rating desc;

-- which day of the week has the best average rating per branch ?

select day_name, Branch, max(Rating) as rating from `walmartsalesdata.csv` group by Branch, day_name order by rating desc;