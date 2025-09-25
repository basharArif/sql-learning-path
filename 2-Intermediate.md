[<- Back to Learning Path](learning-path.md)

---
# Part 2: Intermediate SQL

**Level:** Intermediate  
**Time Estimate:** 60 minutes  
**Prerequisites:** SQL Fundamentals.

## TL;DR
Intermediate SQL covers joins for combining tables, aggregations for summaries, subqueries for complex filters, and set operations for combining results.

## Learning Objectives
By the end of this lesson, you'll be able to:
- Join tables with various types.
- Use GROUP BY and aggregate functions.
- Write subqueries and set operations.
- Apply indexes for performance.

## Motivation & Real-World Scenario
Real apps need data from multiple tables, like user orders or department summaries. These techniques enable complex reports and analytics.

## Theory: Combining and Summarizing Data

### Joins
Combine rows from tables based on related columns.

### Aggregations
Summarize data with functions like COUNT, SUM.

### Subqueries
Queries within queries for advanced filtering.

### Set Operations
Combine query results like unions.

## Worked Examples

### JOINS (Combining Tables)

#### a. INNER JOIN – Match in both tables
```sql
SELECT employees.name, departments.name AS department
FROM employees
INNER JOIN departments ON employees.department_id = departments.id;
```
**Explanation**: Returns only rows with matches in both tables.

#### b. LEFT JOIN – All from left + matches from right
```sql
SELECT employees.name, departments.name AS department
FROM employees
LEFT JOIN departments ON employees.department_id = departments.id;
```
**Explanation**: Includes all left rows, NULL for no match.

#### c. RIGHT JOIN – All from right + matches from left (PostgreSQL/MySQL)
```sql
SELECT employees.name, departments.name AS department
FROM employees
RIGHT JOIN departments ON employees.department_id = departments.id;
```
**Explanation**: Includes all right rows, NULL for no match.

#### d. FULL OUTER JOIN – All records, matched or not (PostgreSQL only)
```sql
SELECT employees.name, departments.name AS department
FROM employees
FULL OUTER JOIN departments ON employees.department_id = departments.id;
```
**Explanation**: All rows from both, NULL where no match.

#### e. SELF JOIN - Join a table to itself
```sql
SELECT e.name AS employee_name, m.name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;
```
**Explanation**: Treat table as two for hierarchies.

### AGGREGATION FUNCTIONS
```sql
SELECT COUNT(*) FROM employees;  -- Total rows

SELECT department_id, COUNT(*) AS total
FROM employees
GROUP BY department_id;  -- Group summaries

SELECT department_id, AVG(age) AS average_age
FROM employees
GROUP BY department_id;
```
**Explanation**: GROUP BY creates groups; aggregates summarize each.

### HAVING vs WHERE
```sql
SELECT department_id, COUNT(*) AS total
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;
```
**Explanation**: WHERE filters rows before grouping; HAVING after.

### Subqueries

#### a. In WHERE clause
```sql
SELECT * FROM employees
WHERE department_id IN (
    SELECT id FROM departments WHERE name = 'HR'
);
```
**Explanation**: Subquery provides values for IN.

#### b. Correlated subquery
```sql
SELECT name
FROM employees e
WHERE age > (
    SELECT AVG(age) FROM employees WHERE department_id = e.department_id
);
```
**Explanation**: Subquery references outer query (correlated).

### Set Operations

#### a. UNION vs UNION ALL
```sql
SELECT name FROM employees
UNION  -- Removes duplicates
SELECT name FROM contractors;

SELECT name FROM employees
UNION ALL  -- Keeps duplicates
SELECT name FROM contractors;
```
**Explanation**: UNION deduplicates; UNION ALL is faster.

#### b. INTERSECT (PostgreSQL only)
```sql
SELECT name FROM employees
INTERSECT
SELECT name FROM departments;
```
**Explanation**: Common rows only.

#### c. EXCEPT (PostgreSQL only)
```sql
SELECT name FROM employees
EXCEPT
SELECT name FROM departments;
```
**Explanation**: In first but not second.

### CASE Statement (Conditional Logic)
```sql
SELECT name, age,
    CASE
        WHEN age >= 60 THEN 'Senior'
        WHEN age >= 30 THEN 'Mid-Level'
        ELSE 'Junior'
    END AS age_category
FROM employees;
```
**Explanation**: If-then-else in queries.

### Indexes and Performance Basics
```sql
CREATE INDEX idx_name ON employees(name);
EXPLAIN SELECT * FROM employees WHERE name = 'Alice';
```
**Explanation**: Indexes speed lookups. EXPLAIN shows plan.

## Quick Checklist / Cheatsheet
- INNER JOIN: Matching rows.
- LEFT/RIGHT: Include unmatched.
- GROUP BY: Summarize groups.
- Subqueries: Nested queries.
- UNION: Combine results.

## Exercises

1. **Easy:** Join employees and departments, show names.
2. **Medium:** Count employees per department with HAVING >1.
3. **Hard:** Use subquery to find above-average salaries.

## Solutions

1. `SELECT e.name, d.name FROM employees e INNER JOIN departments d ON e.department_id = d.id;`
2. `SELECT department_id, COUNT(*) FROM employees GROUP BY department_id HAVING COUNT(*) > 1;`
3. `SELECT name FROM employees WHERE salary > (SELECT AVG(salary) FROM employees);`

## Notes: Vendor Differences / Performance Tips
- FULL OUTER: PostgreSQL. Use LEFT+RIGHT in others.
- INTERSECT/EXCEPT: PostgreSQL/MySQL. Use NOT IN in others.
- Index JOIN columns for speed.

## Next Lessons
Advanced SQL (Views, Transactions).