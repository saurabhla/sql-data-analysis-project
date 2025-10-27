-- Analyze the yearly performance of products by comparing their sales
-- to both the average sales performance of the product and the previous year's sales

SELECT
product_key,
order_date,
total_sales,
AVG(total_sales) OVER( PARTITION BY product_key) as average_sales,
total_sales- AVG(total_sales) OVER( PARTITION BY product_key) as total_diff,
CASE WHEN total_sales- AVG(total_sales) OVER( PARTITION BY product_key) > 0 THEN 'Above Avg'
		WHEN total_sales- AVG(total_sales) OVER( PARTITION BY product_key) < 0 THEN 'Below Avg'
		ELSE 'Avg'
		END avg_change,
LAG(total_sales,1,0)  OVER(PARTITION BY product_key ORDER BY DATETRUNC(year, order_date)) as previos_sales,
total_sales- LAG(total_sales,1,0) OVER(PARTITION BY product_key ORDER BY DATETRUNC(year, order_date)) yearly_difference,
CASE WHEN total_sales- LAG(total_sales,1,0) OVER(PARTITION BY product_key ORDER BY DATETRUNC(year, order_date)) > 0 THEN 'Above'
		WHEN total_sales- LAG(total_sales,1,0) OVER(PARTITION BY product_key ORDER BY DATETRUNC(year, order_date)) < 0 THEN 'Below'
		ELSE 'Same'
		END yearly_change
FROM
(
SELECT
DATETRUNC(year, order_date) as order_date,
product_key,
SUM(sales_amount) as total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY product_key, DATETRUNC(year, order_date)
) t
