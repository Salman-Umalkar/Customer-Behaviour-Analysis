create database customer_behaviour;
use customer_behaviour;
select *from customer_behaviour_analysis; 

-- Business Insights Question
-- 1.Which Category Generates Highest Revenue?

select category,round(sum(purchase_amount),2) as `Highest Revenue` 
from customer_behaviour_analysis
group by category
order by `Highest Revenue` desc;

-- Bussiness Problem:- Comapany Does Not Know Which Category Contributes Most to Revenue
-- Impact:-
			-- Helps Prioritizes high-performing Categories
			-- Optimizes Inventory Planning
            -- Improves Marketing ROI

-- 2.Are Discount Actually Increasing Purchased Value?alter
select  discount_applied,
round(sum(purchase_amount),2) as `Total Revenue` ,
round(avg(purchase_amount),2) as `avg Revenue` 
from
customer_behaviour_analysis
group by discount_applied
order by `Total Revenue` desc; 

-- Bussiness problem :- Discounts may reduce profit without increasing sales
-- impact
-- Identify Effective ness of discount
-- Reduce Unnecessary discount cost
-- Improve profit margin

-- 3.what is the total nrevene geenrated by male and female Customer

select gender,round(sum(purchase_amount),2) as `Total Revenue` 
from customer_behaviour_analysis
group by gender
order by `Total Revenue`  desc;

-- Business Problem 
-- Lack of understanding of revenue contribution among gender segments
-- impact
-- Helps design Targeted marketing Companies
-- Improves Customer Segmetation Strategy
-- Enhance Personalization Efforts

-- 4.which customer used a discount but stilll spent more than avg purchase amount

select customer_id,
round(purchase_amount,2) as 'purchase_amount',
discount_applied
from customer_behaviour_analysis
where discount_applied='yes' and 
 purchase_amount>(select avg(purchase_amount) from customer_behaviour_analysis)
 order by purchase_amount desc
 limit 10; 
-- top 10 customer who spent more than avg purchased amount after applying discounts
-- BP;- Company Cannot Identify high-spending customers who are also discount users

-- impact:- identefies premium discoutn-sensitive customers
-- Enables Targeted Discoutn Campains
-- Improves Customer Retention And Revenue

-- 5.Which Are the Top/Bottom 5 Products With The Highest Average Review Rating

select item_purchased,
round(avg(review_rating),2) as avg_rating
from customer_behaviour_analysis
group by item_purchased
order by avg_rating desc
limit 5;

select item_purchased,
round(avg(review_rating),2) as avg_rating
from customer_behaviour_analysis
group by item_purchased
order by avg_rating 
limit 5;

-- BP:- No visiblity into products performance  based on customer Satisfaction
-- Impact Promotes high-performance Products
-- Improves low-rated Products
-- Enhances Customer Experience

-- 6.Avg Purchase:Standard vs Express Shipping

select *from 
 customer_behaviour_analysis;
 
 select shipping_type,
 count(distinct customer_id) as order_placed,
 round(avg(purchase_amount),2) as Avg_purchase
 from customer_behaviour_analysis
 where shipping_type IN('Express','Standard')
 group by shipping_type;

-- BP :- Unclear If faster Shipping leads to higher Spending
-- Impact
-- Helps optimizes shipping pricing stratergy
-- Encourage Premium Shipping Adoption
-- Increase Average Order Value

-- 7.do subscribed customers spend more ? Comapare average speed and total revenue between subscribers and non-subscribers
select subscription_status,
count(distinct customer_id) as users,
round(avg(purchase_Amount),2) as Avg_revenue,
round(sum(purchase_Amount),2) as Total_revenue
from customer_behaviour_analysis
group by subscription_status
order by Total_revenue desc;
-- BP :- The Effective Of Subscription Programs is Unknown

-- Impact
-- Validates Subscriptiom Model Performance
-- improves customer loyalty Programs
-- Increase Customer Lifetime Value

-- 8.Top 5 products With Highest Discount Usage %

select *from customer_behaviour_analysis;

select item_purchased,
count(item_purchased) as Total_number_of_item_sold,
count(CASE when discount_applied='Yes' then 1 END) as Total_no_of_items_sold_when_discount_applied,
concat(round(count(CASE when discount_applied='Yes' then 1 END)*100/count(*),2),'%') as Discount_Percentage
from customer_behaviour_analysis
group by item_purchased
order by Discount_Percentage DESC
limit 5;
-- BP Some Products May be Overly Dependent On Discounts
-- Impact :-
	-- Identifies Discount-driven Products
    -- Helps Optimizes Pricing Strategy
    -- Reduces Profit Margin Loss
    
    
-- 10.Segment customer into new,returning and loyal based on their total number of previous purchased
-- and show the count of each segment 

select 
CASE WHEN previous_purchases='0' THEN 'New Customer'
 WHEN previous_purchases BETWEEN 1 and 15 THEN 'Returning Customer'
ELSE 'Loyal Customer'
END as Customer_Segment,
count(*) as Total_Customer
from customer_behaviour_analysis
group by Customer_Segment
order by Total_Customer DESC;

-- BP Lack Of Customer Segmentation To generic Strategies
-- IMpact 
-- Enables Personalized Marketing
-- Improves Retention Strategies
-- Increase Conversion Rates

-- 10. What are the Top 3 Most Purchased Products Within Each Department
with cte as (select category,
item_purchased,
count(item_purchased) as Most_purchased,
RANK() over(PARTITION by Category ORDER BY count(item_purchased) DESC) as RNK
from customer_behaviour_analysis
group by category,item_purchased)
select *from CTE where RNK<=3;

-- BP:- The company doesn't Know top-performing products within categories.
-- Impact 
-- improves product placement & recommendation
-- helps inventory Optimization
-- increases sales through best-sellers


--  11.Are customers who are repeat buyers (more than 5 previos purchases) also likely to subscribe ?

select 
	case 
		when previous_purchases > 5 then 'Repeat Buyers'
        ELSE 'Normal Buyers'
	END as Customer_type,
    subscription_status,
        
        count(*) as customer_count,
        concat(round(count(*)*100/sum(count(*)) over(partition by case 
		when previous_purchases > 5 then 'Repeat Buyers'
        ELSE 'Normal Buyers'
	END ),2),'%') as percent
    
from customer_behaviour_analysis
group by case 
		when previous_purchases > 5 then 'Repeat Buyers'
        ELSE 'Normal Buyers'
	END,subscription_status ;
    
    -- BP:- Unclear RelationShip Between Loyalty and subscription
    -- IMpact
    -- Improves Subscription targeting
    -- Increase Conersion to paid Programs
    -- Increase Customer Retention stratergy
    
-- 12.what is the revenue contribution of each group ?

select 
	case 
		 when age between 18 and 25 then '18-25'
		 when age between 26 and 35 then '26-35'
		 when age between 36 and 50 then '36-50'
         ELSE '51+'
         END as age_group,
         concat(round(sum(purchase_amount)/100000,2),'L') as Total_Revenue
         from customer_behaviour_analysis
         group by  
         CASE
		 when age between 18 and 25 then '18-25'
		 when age between 26 and 35 then '26-35'
		 when age between 36 and 50 then '36-50'
         ELSE '51+'
         END
         order by Total_Revenue DESC;
         
  -- BP:- No visibilty into which age age group contributes most to revenue.
  -- Impact
  -- Enables Age-Based Targetting
  -- Enhanced Marketing Efficiency
	
    