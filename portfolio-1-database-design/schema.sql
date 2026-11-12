-- Ikojn online store: schema for MIT 8103 Portfolio 1
-- Database: MySQL 8.0
CREATE DATABASE IF NOT EXISTS ikojn_db;
USE ikojn_db;

-- Product groups, e.g. Dresses, Tops
CREATE TABLE categories (
    category_id   INT NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (category_id),
    UNIQUE KEY category_name (category_name)
);

-- People who buy from Ikojn
CREATE TABLE customers (
    customer_id      INT NOT NULL AUTO_INCREMENT,
    full_name        VARCHAR(150) NOT NULL,
    phone_number     VARCHAR(20) NOT NULL,
    delivery_address TEXT NOT NULL,
    PRIMARY KEY (customer_id),
    UNIQUE KEY phone_number (phone_number)
);

-- Items for sale
CREATE TABLE products (
    product_id     INT NOT NULL AUTO_INCREMENT,
    product_name   VARCHAR(150) NOT NULL,
    category_id    INT NOT NULL,
    size           VARCHAR(20) NOT NULL,
    colour         VARCHAR(30) NOT NULL,
    price          DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    PRIMARY KEY (product_id),
    CONSTRAINT products_ibfk_1 FOREIGN KEY (category_id) REFERENCES categories (category_id),
    CONSTRAINT chk_products_price CHECK (price > 0),
    CONSTRAINT chk_products_stock CHECK (stock_quantity >= 0)
);

-- One row per order placed by a customer
CREATE TABLE orders (
    order_id     INT NOT NULL AUTO_INCREMENT,
    customer_id  INT NOT NULL,
    order_date   TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    order_status VARCHAR(20) NOT NULL DEFAULT 'Processing',
    PRIMARY KEY (order_id),
    CONSTRAINT orders_ibfk_1 FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    CONSTRAINT chk_orders_total CHECK (total_amount >= 0)
);

-- The products inside each order (one order has many items)
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id      INT NOT NULL,
    product_id    INT NOT NULL,
    quantity      INT NOT NULL CHECK (quantity > 0),
    unit_price    DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Payments made for orders
CREATE TABLE payments (
    payment_id     INT AUTO_INCREMENT PRIMARY KEY,
    order_id       INT NOT NULL,
    amount_paid    DECIMAL(10,2) NOT NULL CHECK (amount_paid > 0),
    payment_method VARCHAR(30) NOT NULL,
    payment_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
