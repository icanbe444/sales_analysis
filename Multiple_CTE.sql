-- find the total sales per customer
-- find the last order date for each customers

WITH CTE_total_sales AS (
Select 
	customer_id,
	SUM(sales) as Total_Sales
FROM
	orders
GROUP BY customer_id

), 
CTE_last_order_date AS(
	SELECT
    customer_id,
    MAX(order_date) as last_order
    FROM orders
    GROUP BY customer_id
)
SELECT
	C.customer_id,
    C.first_name,
    C.last_name,
    T.Total_Sales,
    L.last_order
FROM Sales.customers C
LEFT JOIN CTE_total_sales AS T
ON C.customer_id =  T.customer_id
LEFT JOIN CTE_last_order_date AS L
ON C.customer_id = L.customer_id
