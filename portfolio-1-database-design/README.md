# Portfolio 1: Database Design and Modelling

**Case study:** Ikojn, an online store for 100% Made-in-Kenya women's wear.
**Database:** MySQL 8.0 (`ikojn_db`)

## Files in this folder
- `er-diagram.png,png`: entity-relationship diagram
- `schema.sql`: SQL script that creates the tables

## ER diagram
![ER diagram](er-diagram.png.png)

## Design notes: normalisation

The Ikojn design is normalised so that every fact is stored once, which avoids repeated data and contradictions. It follows first normal form because each cell holds one value: if an order has two products, each product is a separate row in order_items. It follows second and third normal form because data is grouped by what it describes: everything about a customer is in customers, everything about a category is in categories, and everything about a product is in products, so a phone number or price only needs to be changed in one place. Each order has its own ID, and its products are linked through order_items. Two deliberate choices are unit_price in order_items, which keeps the price paid even if the product price changes later, and total_amount in orders, which could be calculated from the order lines but is stored to make reports faster.
