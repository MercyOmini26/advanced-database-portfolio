USE ikojn_db;
SET SESSION cte_max_recursion_depth = 100000;

-- 1. Five product categories (skips any that already exist)
INSERT IGNORE INTO categories (category_name)
VALUES ('Dresses'), ('Tops'), ('Skirts'), ('Trousers'), ('Accessories');

-- 2. Sixty products, linked to those categories by name
INSERT INTO products (product_name, category_id, size, colour, price, stock_quantity)
WITH RECURSIVE nums AS (
    SELECT 1 AS n UNION ALL SELECT n + 1 FROM nums WHERE n < 60
)
SELECT
    CONCAT(ELT(1 + MOD(n, 8), 'Nairobi', 'Mombasa', 'Kisumu', 'Nakuru', 'Eldoret', 'Malindi', 'Lamu', 'Naivasha'),
           ' ', ELT(1 + MOD(n, 5), 'Dress', 'Top', 'Skirt', 'Trousers', 'Scarf')),
    c.category_id,
    ELT(1 + MOD(n, 4), 'S', 'M', 'L', 'XL'),
    ELT(1 + MOD(n, 6), 'Yellow', 'Black', 'Red', 'Blue', 'Green', 'White'),
    ROUND(1500 + MOD(n * 137, 3500), 2),
    10 + MOD(n * 7, 90)
FROM nums
JOIN categories c
  ON c.category_name = ELT(1 + MOD(n, 5), 'Dresses', 'Tops', 'Skirts', 'Trousers', 'Accessories');

-- 3. Two thousand customers
INSERT INTO customers (full_name, phone_number, delivery_address)
WITH RECURSIVE nums AS (
    SELECT 1 AS n UNION ALL SELECT n + 1 FROM nums WHERE n < 2000
)
SELECT
    CONCAT(ELT(1 + MOD(n, 10), 'Amina', 'Wanjiru', 'Achieng', 'Njeri', 'Zawadi', 'Akinyi', 'Mwende', 'Atieno', 'Wambui', 'Halima'),
           ' ',
           ELT(1 + MOD(n * 7, 10), 'Otieno', 'Kamau', 'Mutua', 'Ochieng', 'Wekesa', 'Kiptoo', 'Mwangi', 'Odhiambo', 'Njoroge', 'Barasa')),
    CONCAT('07', LPAD(n, 8, '0')),
    CONCAT('Plot ', n, ', ', ELT(1 + MOD(n, 5), 'Nairobi', 'Mombasa', 'Kisumu', 'Nakuru', 'Eldoret'))
FROM nums;

-- 4. Check the counts
SELECT
    (SELECT COUNT(*) FROM categories) AS categories,
    (SELECT COUNT(*) FROM products)   AS products,
    (SELECT COUNT(*) FROM customers)  AS customers;