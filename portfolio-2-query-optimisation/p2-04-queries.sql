USE ikojn_db;

-- Query 1: Top 10 customers by total spending (JOIN + GROUP BY)
SELECT c.full_name, c.phone_number,
       COUNT(o.order_id)  AS orders_placed,
       SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name, c.phone_number
ORDER BY total_spent DESC
LIMIT 10;

-- Query 2: Sales per category (three tables joined)
SELECT cat.category_name,
       SUM(oi.quantity)                  AS units_sold,
       SUM(oi.quantity * oi.unit_price)  AS revenue
FROM order_items oi
JOIN products   p   ON p.product_id   = oi.product_id
JOIN categories cat ON cat.category_id = p.category_id
GROUP BY cat.category_name
ORDER BY revenue DESC;

-- Query 3: Low-stock products
SELECT product_name, size, colour, stock_quantity
FROM products
WHERE stock_quantity < 20
ORDER BY stock_quantity;