Create table zepto
(
sku_id INT iDENTITY(1,1) primary key,
Category Varchar (120),
Name varchar (150) not null,
Mrp numeric (8,2),
Discount_percent Numeric (5,2),
Available_Quantity Integer,
Discounted_selling_price Numeric (8,2),
WeightInGms Integer,
OutOf_stock BIT,
Quantity Integer
)

--> READING THE DATA
SELECT * FROM [dbo].[zepto_v2]

-->CHECKING THE TOTAL ROWS
SELECT COUNT(*) FROM [dbo].[zepto_v2]

-->DATA CLEANING

-- CHECKING THE NULL VALUES
SELECT * FROM[dbo].[zepto_v2]
WHERE CATEGORY IS NULL
OR NAME IS NULL
OR MRP IS NULL
OR DISCOUNTPERCENT IS NULL
OR AVAILABLEQUANTITY IS NULL
OR DISCOUNTEDSELLINGPRICE IS NULL
OR WEIGHTINGMS IS NULL
OR OUTOFSTOCK IS NULL
OR QUANTITY IS NULL

-- CHECKING DUPLICATE PRODUCTS
SELECT NAME, COUNT(*) FROM [dbo].[zepto_v2]
GROUP BY NAME 
HAVING COUNT(*) >1

--> BUSINESS QUESTIONS

-- Total Number of Products
select name as products from [dbo].[zepto_v2]

-- Number of Categories
select Count(category) from [dbo].[zepto_v2]

-- Products Available in Each Category
select category,name as product_name from [dbo].[zepto_v2]
group by name, category

-- Which Products Have the Highest Discount
select name,category, discountpercent from [dbo].[zepto_v2]
where discountpercent  = ( select max(discountpercent) from [dbo].[zepto_v2])

-- Which Products Are Out Of Stock
select name, category, outofstock from [dbo].[zepto_v2]
where outofstock =1

-- Total Inventory Available In Each Category
select category, sum(availablequantity) as total_Inventory from [dbo].[zepto_v2]
group by category
order by total_Inventory desc

-- Most Expensive Products
select name, category, mrp from [dbo].[zepto_v2]
where mrp = (select max(mrp)as most_exp_pro from [dbo].[zepto_v2])

-- Cheapest Products
select name,category, mrp from [dbo].[zepto_v2] 
where mrp = (select min(mrp) as Least_exp_product from [dbo].[zepto_v2])

-- Average Discount By Categroy
select category, avg(discountpercent) as avg_discount from [dbo].[zepto_v2]
group by category
order by avg_discount desc

-- Revenue Opportunity
select category, sum(availablequantity * discountedsellingprice) as revenue_opportunity from [dbo].[zepto_v2]
group by category
order by revenue_opportunity desc

-- Business Problems
--The management wants to classify products based on discounts for marketing campaigns.
--High Discount (>=50%)
--Medium Discount (20-49%)
--Low Discount (<20%)

select name,discountpercent,
case
when discountpercent >= 50 then 'High Discount'
when discountpercent >= 20 then 'Medium Discount'
when discountpercent <= 20 then 'Low Discount'
End as Discountcategory
from [dbo].[zepto_v2]

--Top 3 Expencive Products in each category
with cte as
(
select *,
row_number() over(partition by category order by mrp desc) rnk
from [dbo].[zepto_v2]
)
select * from cte where rnk <= 3

--Which Category Contributes the Highest Inventory
select category, sum([availableQuantity]) as total_inventory from [dbo].[zepto_v2]
group by category
order by total_inventory desc

--Find the products that cost more than the average mrp.
select name,mrp from [dbo].[zepto_v2]
where mrp>
(
select avg(mrp) from [dbo].[zepto_v2]
)

--Find categories having more than 20 products
select category, count(*) products from [dbo].[zepto_v2]
group by category
having count (*)>20

--Extract the first 5 characters
select left(name,5) from [dbo].[zepto_v2]

--length of product names
select name, len(name) namelength from [dbo].[zepto_v2]

--Estimate the maximum revenue if all available stock is sold at the discounted price
select sum(discountedsellingprice * availablequantity) as estimaterevenue from [dbo].[zepto_v2]

--Profit and Loss
--How much discount is the company giving on each product
select name, mrp, discountedsellingprice,(mrp- discountedsellingprice) as discountamt
from [dbo].[zepto_v2]

