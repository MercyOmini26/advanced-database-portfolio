USE ikojn_db;

CREATE INDEX idx_orders_status_date ON orders (order_status, order_date);

EXPLAIN ANALYZE
SELECT COUNT(*) AS orders, SUM(total_amount) AS order_value
FROM orders
WHERE order_status = 'Delivered'
  AND order_date >= NOW() - INTERVAL 30 DAY;