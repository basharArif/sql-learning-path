# Intermediate SQL: Indexing Basics

**Level:** Intermediate  
**Time Estimate:** 15 minutes  
**Prerequisites:** SQL Fundamentals.

## TL;DR
An index is a special lookup table that the database search engine can use to speed up data retrieval. Creating indexes on frequently queried columns is one of the most effective ways to improve query performance.

## Learning Objectives
By the end of this lesson, you'll be able to:
- Understand what a database index is.
- Create a basic index.
- Use `EXPLAIN` to see if an index is being used.

## Motivation & Real-World Scenario
You have a `users` table with millions of records. A query like `SELECT * FROM users WHERE email = '...'` is very slow because the database has to scan the entire table to find the matching row. By creating an index on the `email` column, the database can find the user almost instantly.

## Theory & Worked Examples

### a. What is an Index?
An index works like the index in the back of a book. Instead of scanning every page (every row), the database looks up the value in the index, which provides a direct pointer to the location of the data on disk. This dramatically reduces the amount of data the database needs to read.

### b. Creating an Index
You use the `CREATE INDEX` command.

```sql
-- Creates an index on the 'name' column of the 'employees' table
CREATE INDEX idx_employees_name ON employees(name);
```
**Explanation**: This creates a B-Tree index (the most common type) on the `name` column. The database will now use this index to speed up queries that filter by `name`.

### c. Checking Index Usage with `EXPLAIN`
The `EXPLAIN` command shows you the execution plan that the database will use for a query. It's the primary tool for checking if your indexes are being used.

**Example: Check if the index on `name` is used.**
```sql
EXPLAIN SELECT * FROM employees WHERE name = 'Alice';
```

**Execution Plan Output (simplified):**

*   **Without an index**, you will see a `Seq Scan` (Sequential Scan), meaning the database is reading the whole table.
    ```
    Seq Scan on employees (cost=0.00..123.45 rows=1 width=50)
    ```
*   **With an index**, you should see an `Index Scan`, meaning the database is using the index.
    ```
    Index Scan using idx_employees_name on employees (cost=0.42..8.44 rows=1 width=50)
    ```

## Quick Checklist / Cheatsheet
- Add indexes to columns frequently used in `WHERE` clauses and `JOIN` conditions.
- Use `EXPLAIN` to verify that your indexes are being used.
- Don't add too many indexes. While they speed up reads, they slow down writes (`INSERT`, `UPDATE`, `DELETE`).

---

## Next Steps

This was a brief introduction. For a much more detailed guide on how the query planner works, different types of indexes, and advanced optimization techniques, please see the full guide:

**[Deep Dive: Query Plans, Indexes, and Cost Models](../theory/3-query-plans-and-cost-models.md)**
