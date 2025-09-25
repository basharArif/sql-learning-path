# Query Plans and Cost Models

Understanding how the database planner chooses an execution plan is one of the fastest ways to improve query performance. This lesson explains the planner's cost model, common plan nodes, how to read `EXPLAIN` and `EXPLAIN ANALYZE`, and gives a practical optimization checklist.

## Planner overview

When you submit SQL, the planner:

1. Parses and rewrites the query.
2. Estimates the cost of alternative plans using statistics and heuristics.
3. Chooses a plan with a (theoretically) lowest cost.

Key input to the planner: table/column statistics (ANALYZE), available indexes, and configuration (work_mem, enable_* flags).

## Common plan nodes

- Seq Scan: full table scan; cheap for small tables, expensive for large ones.
- Index Scan / Index Only Scan: uses an index to retrieve rows; Index Only avoids heap fetch when the index contains all needed columns.
- Bitmap Index Scan + Bitmap Heap Scan: good for combining multiple index conditions.
- Hash Join: builds a hash table on the smaller input and probes it with the larger input — good for equality joins.
- Merge Join: merges two pre-sorted inputs — efficient for range joins if inputs are sorted or indexed.
- Nested Loop: for each row in the outer input, execute inner input; fast when outer is small and inner is indexed.

## EXPLAIN vs EXPLAIN ANALYZE

- `EXPLAIN` shows the planner's estimated plan and costs without executing the query.
- `EXPLAIN ANALYZE` executes the query and shows actual timing and row counts (more accurate for real performance analysis).

Always compare estimated vs actual rows — big discrepancies point to outdated statistics or bad estimates.

## Annotated example (simulated)

Below is a typical `EXPLAIN ANALYZE` output (annotated). This is an illustrative example that highlights what to look for.

```
Nested Loop  (cost=0.00..1234.00 rows=10 width=200) (actual time=0.12..5.23 rows=100 loops=1)
	->  Index Scan using idx_users_id on users  (cost=0.00..8.50 rows=5 width=100) (actual time=0.01..0.02 rows=5 loops=1)
	->  Index Scan using idx_orders_user_id on orders  (cost=0.00..245.00 rows=2 width=120) (actual time=0.02..0.05 rows=20 loops=5)
```

- `cost=0.00..1234.00`: planner's startup and total cost estimate.
- `rows=10`: planner's estimated number of rows for this node.
- `actual time=0.12..5.23 rows=100`: real timings and number of rows returned by this node.

Interpretation:

- The planner estimated 10 rows but actual rows are 100 — underestimation by statistics.
- Nested Loop may be acceptable for small outer inputs, but here inner index scan is executed many times (loops=5) leading to more runtime.

## Common causes of bad plans

- Outdated or missing statistics (run `ANALYZE` on large tables).
- Missing indexes on filter or join columns.
- Parameter sniffing / prepared statements leading to generic plans (consider `EXPLAIN (ANALYZE, BUFFERS, VERBOSE)`).
- Incorrect data types or implicit casts preventing index use.

## Optimization checklist (practical)

1. Run `ANALYZE table_name;` to refresh statistics.
2. `EXPLAIN ANALYZE` the slow query and compare estimated vs actual rows.
3. If Seq Scan on large table: consider adding an index on filtering columns.
4. For joins, ensure join columns are indexed. Consider hash vs merge join by checking `EXPLAIN` and the sizes of inputs.
5. Use `EXPLAIN (ANALYZE, BUFFERS, VERBOSE)` to see buffer hits/misses and IO behavior.
6. Check `work_mem` for hash joins and sorts; increase temporarily for analysis if needed.
7. Rewrite query if necessary: replace correlated subqueries with joins/CTEs, avoid `SELECT *`, and limit early when possible.

## Practical examples and tips

- Index-only scan requires the index to cover all selected columns. Use `INCLUDE(...)` in Postgres for covering indexes.
- For OR conditions, sometimes rewriting as `UNION ALL` of two selective queries performs better.
- For analytical workloads, consider materialized views or summary tables.

## Exercises

1. Describe what you would do if `EXPLAIN ANALYZE` shows `Seq Scan` on a 50M-row table for a selective WHERE clause.
2. Given an output where `actual rows >> estimated rows`, list three possible reasons and remedies.
3. Write a query against `orders(order_date, customer_id, amount)` to find top customers last month. Run `EXPLAIN` and explain which index would help.

## Solutions (guidance)

1. If `Seq Scan` on large table for a selective predicate: check statistics, add an index on the predicate column(s) (or a partial index for common predicates), consider whether table partitioning can help.
2. `actual >> estimated` reasons: outdated statistics (run ANALYZE), data skew or correlation unaccounted for, incorrect assumptions due to type casts. Remedies: collect extended stats, run `ANALYZE`, add histograms/extended statistics, rewrite query.
3. Query example:

```sql
SELECT customer_id, SUM(amount) AS total
FROM orders
WHERE order_date >= date_trunc('month', current_date - interval '1 month')
	AND order_date < date_trunc('month', current_date)
GROUP BY customer_id
ORDER BY total DESC
LIMIT 10;
```

Helpful index: `CREATE INDEX idx_orders_date_customer_amount ON orders (order_date, customer_id);` — improves filtering by date and grouping by customer.

Advanced note: for heavy analytics, a partial index or materialized view that pre-aggregates recent data is often faster.

## Worked example (products table)

Schema (sample):

```sql
CREATE TABLE products (
	id SERIAL PRIMARY KEY,
	name TEXT,
	category_id INT,
	price NUMERIC(10,2),
	created_at TIMESTAMPTZ
);
```

Query 1 (slow):

```sql
SELECT * FROM products WHERE price < 20 AND category_id = 5;
```

Planner `EXPLAIN` (before index) — simulated:

```
Seq Scan on products  (cost=0.00..2000.00 rows=1000 width=50)
	Filter: (price < 20 AND category_id = 5)
```

Interpretation: planner expects many rows and chooses a sequential scan. If the table has millions of rows and the predicate is selective (few rows match), an index can drastically reduce IO.

Action: Add a composite index for the predicate:

```sql
CREATE INDEX idx_products_cat_price ON products (category_id, price);
ANALYZE products;
```

Planner `EXPLAIN` (after index) — simulated:

```
Index Scan using idx_products_cat_price on products (cost=0.42..12.50 rows=5 width=50)
	Index Cond: (category_id = 5 AND price < 20)
```

Result: The planner now expects a small number of rows and uses the index. Real `EXPLAIN ANALYZE` will show actual times and rows; compare estimated vs actual.

Note: If the predicate is not selective (e.g., price < very large), the planner may still choose a Seq Scan.


