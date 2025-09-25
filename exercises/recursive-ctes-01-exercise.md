# Recursive CTEs Exercise

**Level:** Advanced  
**Time Estimate:** 20 minutes  

## Problem
Given a table `employees` with columns `id`, `name`, `manager_id`, find the hierarchy for employee ID 1.

## Schema
```sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name TEXT,
    manager_id INT REFERENCES employees(id)
);
```

## Task
Write a recursive CTE to show the full hierarchy under employee 1, including levels.

## Hints
- Use UNION ALL in the recursive part.
- Add a level column.

## Expected Output
A list of employees with their level in the hierarchy.