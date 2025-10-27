-- Group Customers into three segments based on spending behaviour,
-- VIP with at least 12 months of  history and spending more than 5K
-- Regular at least 12 months history and spending 5K or less
-- New lifespan less than 12 months
-- Total number of customers by each group

WITH CTE AS(

SELECT 
customer_key,
DATEDIFF(month,MIN(order_date), MAX(order_date)) diff_year,
sum(sales_amount) total_spending,
CASE WHEN sum(sales_amount) > 5000 AND DATEDIFF(month,MIN(order_date), MAX(order_date)) >= 12 THEN 'VIP'
	WHEN sum(sales_amount) <= 5000 AND DATEDIFF(month,MIN(order_date), MAX(order_date)) >= 12 THEN 'Regular'
	ELSE 'New'
	END category
FROM gold.fact_sales
GROUP BY customer_key
)
SELECT 
category,
count(customer_key) as total_customers
FROM CTE
GROUP BY Category
ORDER BY total_customers DESC

