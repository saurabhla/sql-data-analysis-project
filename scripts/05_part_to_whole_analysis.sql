-- Which categories contribute to overall sales
WITH CTE AS(
SELECT
  category,
  SUM(sales_amount) as total_sales
FROM 
  gold.fact_sales f
LEFT JOIN 
  gold.dim_products p
ON 
  f.product_key = p.product_key
GROUP BY 
  category
)
SELECT 
  category,
  total_sales,
  SUM(total_sales) OVER () as total_sum,
  CONCAT(ROUND((CAST(total_sales as FLOAT)/SUM(total_sales) OVER ()) * 100,2), '%') AS percentage_of_total
FROM 
  CTE
ORDER BY percentage_of_total DESC;
