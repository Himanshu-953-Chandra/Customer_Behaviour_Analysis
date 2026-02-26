select * from customer limit 10;

--What is the total revenue generate by male vs female customers/
select gender, sum(purchase_amount) as revenue
from customer group by gender;

--Which customer used a discount but still spent more than the average purchase amount/
select customer_id, purchase_amount  
from customer
where discount_applied='Yes' and purchase_amount>= (select avg(purchase_amount) from customer)

--Which are the top 5  products with the highest average review ratings?
select item_purchased, round(avg(review_rating::numeric),2) as "Average Rating"
from customer
group by item_purchased
order by avg(review_rating) desc limit 5

--Compare the average purchase amount between Standard and Express shipping.
select shipping_type, round(avg(purchase_amount),2)
from customer
where shipping_type in ('Standard','Express')
group by shipping_type

--Do subscribed customer spend more? Compare average spend and total revenue between 
--subscriber and non-subscriber 
select subscription_status, count(customer_id) as total_customers,
round(avg(purchase_amount),2) as avg_spend, 
round(sum(purchase_amount),2) as total_revnue
from customer
group by subscription_status
order by avg_spend, total_revnue desc

--Which 5 product have the highest purchase percentage with discount applied?
SELECT item_purchased,
ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),2) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

--Segments customer into New,Returninng and Loyalbased on their total number of previous purchases,
--and show  the count of each segment.
with customer_type as
( select customer_id, previous_purchases,
case when previous_purchases= 1  then 'New'
	 when previous_purchases between 2 and 10 then 'Returning'
	 else 'Loyal'
	 end as customer_segment
from customer)
select customer_segment,count(*) as "Number of customers"
from customer_type
group by customer_segment

--What are the top 3 most purchased product within each category?
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status

--What is the revenue contribution by each age group?
select age_group, sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc
