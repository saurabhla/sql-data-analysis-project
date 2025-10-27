-- Calculate total sales per month
-- and running total of sales over time

SELECT 
  order_date,
  total_sales,
  SUM(total_sales) OVER (PARTITION BY YEAR(order_date) ORDER BY order_date ) as running_total_sales
FROM
(
SELECT 
  DATETRUNC(month,order_date) as order_date,
  SUM(sales_amount) as total_sales
FROM 
  gold.fact_sales
  WHERE order_date IS NOT NULL
  GROUP BY DATETRUNC(month,order_date)
)t
