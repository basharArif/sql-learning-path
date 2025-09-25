[<- Back to Learning Path](learning-path.md)

---
# Part 5: Pro SQL Skills

**Level:** Advanced  
**Time Estimate:** 60 minutes  
**Prerequisites:** Real-World Queries.

## TL;DR
Pro skills focus on schema design, optimization, CTEs, window functions, and materialized views for scalable databases.

## Learning Objectives
By the end of this lesson, you'll be able to:
- Design normalized schemas.
- Optimize queries with indexes/EXPLAIN.
- Use advanced features like CTEs and materialized views.

## Motivation & Real-World Scenario
Pro developers build efficient, maintainable databases—normalization prevents anomalies, optimization handles scale.

## Theory: Pro-Level Techniques

### Schema Design
Normalization reduces redundancy.

### Optimization
Indexes, EXPLAIN for performance.

### Advanced Queries
CTEs, window functions, materialized views.

## Worked Examples

### Schema Design with Normalization
```plaintext
Users(id, name, email)
Products(id, name, price, category_id)
Categories(id, name)
Orders(id, user_id, order_date)
OrderItems(id, order_id, product_id, quantity, unit_price)
```
- 1NF: No repeating groups.
- 2NF: No partial dependencies.
- 3NF: No transitive dependencies.

### Optimized Queries
```sql
SELECT p.name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.id
JOIN orders o ON o.id = oi.order_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY p.name
ORDER BY total_sold DESC
LIMIT 5;
```
**Explanation**: Joins with filters, indexes on JOIN columns.

### CTEs (Common Table Expressions)
```sql
WITH sales_per_product AS (
    SELECT product_id, SUM(quantity) AS total_sold
    FROM order_items
    GROUP BY product_id
)
SELECT p.name, s.total_sold
FROM sales_per_product s
JOIN products p ON p.id = s.product_id;
```
**Explanation**: Readable subqueries.

### Window Functions Mastery
```sql
SELECT name, department_id,
       RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS dept_rank
FROM employees;
```
**Explanation**: Rankings within groups.

### Materialized Views (PostgreSQL)
```sql
CREATE MATERIALIZED VIEW product_sales_summary AS
SELECT product_id, SUM(quantity) AS total_sold
FROM order_items
GROUP BY product_id;
REFRESH MATERIALIZED VIEW product_sales_summary;
```
**Explanation**: Precomputed for fast reads.

### Query Plan Analysis
```sql
EXPLAIN ANALYZE
SELECT * FROM products WHERE name ILIKE '%book%';
```
**Explanation**: Check Seq Scan vs Index Scan, costs.

## Final Pro-Level Checklist
- [ ] Master joins, filters, aggregations
- [ ] Write multi-table queries
- [ ] Use CTEs and window functions
- [ ] Design normalized schemas
- [ ] Optimize with indexes/EXPLAIN
- [ ] Implement security/integrity

## Quick Checklist / Cheatsheet
- Normalization: 1NF-3NF rules.
- EXPLAIN: Analyze plans.
- CTEs: WITH for readability.

## Exercises

1. **Easy:** Normalize a denormalized table.
2. **Medium:** Optimize a slow query with EXPLAIN.
3. **Hard:** Create a materialized view for reports.

## Solutions

1. Split into related tables.
2. Add indexes on WHERE/JOIN columns.
3. `CREATE MATERIALIZED VIEW ... AS SELECT ...;`

## Notes: Vendor Differences / Performance Tips
- Materialized views: PostgreSQL. Views in others.
- EXPLAIN: Similar, but syntax varies.

## Next Lessons
Expert Topics (Indexing, JSON).