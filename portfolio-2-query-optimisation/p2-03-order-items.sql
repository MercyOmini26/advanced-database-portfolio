USE ikojn_db;
SET SESSION cte_max_recursion_depth = 100000;
SET SQL_SAFE_UPDATES = 0;

-- 1. Two order lines for each of the 20,000 orders
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
WITH RECURSIVE nums AS (
    SELECT 1 AS n UNION ALL SELECT n + 1 FROM nums WHERE n < 40000
),
ord AS (
    SELECT order_id, ROW_NUMBER() OVER (ORDER BY order_id) AS rn FROM orders
),
prod AS (
    SELECT product_id, price, ROW_NUMBER() OVER (ORDER BY product_id) AS rn FROM products
)
SELECT o.order_id, p.product_id, 1 + MOD(n, 3), p.price
FROM nums
JOIN ord  o ON o.rn = 1 + MOD(n - 1, 20000)
JOIN prod p ON p.rn = 1 + MOD(n * 17, 61);

-- 2. Calculate each order's total from its lines
UPDATE orders o
JOIN (
    SELECT order_id, SUM(quantity * unit_price) AS line_total
    FROM order_items
    GROUP BY order_id
) s ON s.order_id = o.order_id
SET o.total_amount = s.line_total;

-- 3. Check the result
SELECT
    (SELECT COUNT(*) FROM order_items)                        AS order_lines,
    (SELECT COUNT(*) FROM orders WHERE total_amount = 0)      AS orders_with_zero_total,
    (SELECT MIN(total_amount) FROM orders)                    AS smallest_order,
    (SELECT MAX(total_amount) FROM orders)                    AS largest_order;