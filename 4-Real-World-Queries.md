[<- Back to Learning Path](learning-path.md)

---
# Part 4: Real-World Application

**Level:** Intermediate to Advanced  
**Time Estimate:** 50 minutes  
**Prerequisites:** Advanced SQL.

## TL;DR
Real-world SQL applies techniques to analytics, reporting, and pivoting for business insights and project practice.

## Learning Objectives
By the end of this lesson, you'll be able to:
- Write analytical queries for sales/user data.
- Pivot data for reports.
- Plan practice projects.
- Use tools for learning.

## Motivation & Real-World Scenario
Businesses analyze sales trends, user behavior. These queries turn raw data into actionable insights.

## Theory: Analytical Queries

### Aggregations for Metrics
Summarize data for KPIs.

### Pivoting
Transform rows to columns.

### Practice Projects
Build end-to-end apps.

## Worked Examples

### Sales Analytics
```sql
SELECT product_id, SUM(quantity) AS total_sold, SUM(price * quantity) AS revenue
FROM sales
WHERE sale_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY product_id
ORDER BY revenue DESC;
```
**Explanation**: Aggregates sales by product for yearly report.

### User Retention
```sql
SELECT user_id,
       MIN(login_date) AS first_login,
       MAX(login_date) AS last_login,
       COUNT(*) AS total_logins
FROM user_logins
GROUP BY user_id
HAVING COUNT(*) >= 5;
```
**Explanation**: Finds active users with multiple logins.

### Inventory Reorder
```sql
SELECT product_id, name, stock_quantity
FROM products
WHERE stock_quantity < reorder_level;
```
**Explanation**: Identifies low-stock items needing reorder.

### Monthly Revenue Trend
```sql
SELECT DATE_TRUNC('month', sale_date) AS month, SUM(price * quantity) AS revenue
FROM sales
GROUP BY month
ORDER BY month;
```
**Explanation**: Trends revenue over time.

### Pivoting Data
```sql
SELECT 
    product_name,
    SUM(CASE WHEN sale_quarter = 'Q1' THEN sale_amount ELSE 0 END) AS q1_sales,
    SUM(CASE WHEN sale_quarter = 'Q2' THEN sale_amount ELSE 0 END) AS q2_sales,
    SUM(CASE WHEN sale_quarter = 'Q3' THEN sale_amount ELSE 0 END) AS q3_sales,
    SUM(CASE WHEN sale_quarter = 'Q4' THEN sale_amount ELSE 0 END) AS q4_sales
FROM sales
GROUP BY product_name;
```
**Explanation**: CASE creates columns from row values.

## Practice Projects

### HR Management
- Tables: employees, departments, salaries, leave_requests
- Queries: Department summaries, leave tracking.

### E-Commerce Dashboard
- Tables: products, orders, order_items, users
- Build: Sales reports, top customers.

### School Analytics
- Tables: students, classes, enrollments, grades
- Analyze: Performance trends, pass rates.

## Tools to Practice
- pgAdmin/PostgreSQL GUI
- MySQL Workbench
- DBeaver (multi-DB)
- DB Fiddle (online)

## Final Milestone: Pro Skills
- Normalize schemas (1NF-3NF)
- Optimize with indexes/EXPLAIN
- Use CTEs, window functions, materialized views

## Quick Checklist / Cheatsheet
- Analytics: GROUP BY with aggregates.
- Pivoting: CASE for columns.
- Projects: Plan schema first.

## Exercises

1. **Easy:** Query total sales by month.
2. **Medium:** Pivot product sales by category.
3. **Hard:** Design a full e-commerce schema.

## Solutions

1. `SELECT DATE_TRUNC('month', sale_date), SUM(amount) FROM sales GROUP BY 1;`
2. Use CASE to create category columns.
3. Users, Products, Orders, OrderItems with FKs.

## Notes: Vendor Differences / Performance Tips
- DATE_TRUNC: PostgreSQL. Use DATEPART in SQL Server.
- Index date columns for trends.

## Next Lessons
Pro SQL Skills (Optimization).