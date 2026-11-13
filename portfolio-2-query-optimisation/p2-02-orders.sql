USE ikojn_db;
SET SESSION cte_max_recursion_depth = 100000;

INSERT INTO orders (customer_id, order_date, total_amount, order_status)
WITH RECURSIVE nums AS (
    SELECT 1 AS n UNION ALL SELECT n + 1 FROM nums WHERE n < 20000
),
cust AS (
    SELECT customer_id, ROW_NUMBER() OVER (ORDER BY customer_id) AS rn
    FROM customers
)
SELECT
    c.customer_id,
    NOW() - INTERVAL MOD(n * 13, 365) DAY - INTERVAL MOD(n * 7, 1440) MINUTE,
    0,
    ELT(1 + MOD(n, 3), 'Processing', 'Dispatched', 'Delivered')
FROM nums
JOIN cust c ON c.rn = 1 + MOD(n * 37, 2000);

SELECT COUNT(*) AS total_orders,
       MIN(order_date) AS oldest_order,
       MAX(order_date) AS newest_order
FROM orders;