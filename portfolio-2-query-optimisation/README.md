# Portfolio 2: Query Processing and Optimisation

**Case study:** Ikojn, an online store for 100% Made-in-Kenya women's wear.
**Database:** MySQL 8.0 (`ikojn_db`)

## Test data
Invented sample data generated with SQL scripts: 6 categories, 61 products, 2,000 customers, 20,000 orders and 40,000 order lines. Because the data is synthetic, customer spending is evenly spread, so results such as the top-10 spenders are very similar.

## Files in this folder
- `p2-01-sample-data.sql`: generates categories, products and customers
- `p2-02-orders.sql`: generates 20,000 orders
- `p2-03-order-items.sql`: generates order lines and calculates order totals
- `p2-04-queries.sql`: three reporting queries
- `p2-05-explain-before.sql`: execution plan before indexing
- `p2-06-index-after.sql`: index creation and execution plan after

## Queries
1. Top 10 customers by total spending (join and group by)
2. Sales per category (three tables joined)
3. Low-stock products (filter and sort)

## Optimisation: before and after an index
Query: count and total value of Delivered orders in the last 30 days.

| Measure | Before (no index) | After (index) |
|---|---|---|
| Access method | Table scan | Index range scan |
| Rows read | 20,000 | 548 |
| Execution time | 20.9 ms | 2.37 ms |
| Estimated cost | 1930 | 302 |

Index created: `CREATE INDEX idx_orders_status_date ON orders (order_status, order_date);`

### Execution plan before
```
-> Aggregate: count(0), sum(orders.total_amount)  (cost=1930 rows=1) (actual time=20.9..20.9 rows=1 loops=1)
    -> Filter: ((orders.order_status = 'Delivered') and (orders.order_date >= <cache>((now() - interval 30 day))))  (cost=1864 rows=657) (actual time=1.93..20.6 rows=548 loops=1)
        -> Table scan on orders  (cost=1864 rows=19715) (actual time=1.86..13.7 rows=20000 loops=1)
```

### Execution plan after
```
-> Aggregate: count(0), sum(orders.total_amount)  (cost=302 rows=1) (actual time=2.37..2.37 rows=1 loops=1)
    -> Index range scan on orders using idx_orders_status_date over (order_status = 'Delivered' AND '2026-10-14 05:21:15' <= order_date)  (cost=247 rows=548) (actual time=0.472..2.2 rows=548 loops=1)
```

## Performance analysis
(to be completed)
