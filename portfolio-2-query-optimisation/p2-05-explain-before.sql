USE ikojn_db;

EXPLAIN ANALYZE
SELECT COUNT(*) AS orders, SUM(total_amount) AS order_value
FROM orders
WHERE order_status = 'Delivered'
  AND order_date >= NOW() - INTERVAL 30 DAY;