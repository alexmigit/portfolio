-- Create a materialized view for order summaries
CREATE MATERIALIZED VIEW order_summary_mv AS
SELECT
	customer_id,
	COUNT(order_id) AS total_orders,
	SUM(total_amount) AS total_spent,
	MAX(order_date) AS last_order_date
FROM orders
GROUP BY customer_id;

