-- In order to analyse customer loyalty
-- rank customers based on the average days between their orders.

SELECT
customer_id,
round(avg(daysUntilNextOrder),0) as avgDays,
rank() over(order by coalesce(avg(daysUntilNextOrder), 99999)) as RankCustomer
from(SELECT 
	order_id,
	customer_id,
	order_date as currentDate,
	lead(order_date) over(partition by customer_id order by order_date) as NextOrder,
	datediff(lead(order_date) over(partition by customer_id order by order_date), order_date)  as daysUntilNextOrder
	FROM
	orders
)t
group by customer_id;

