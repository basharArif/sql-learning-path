# Views, Procedures, Functions & Triggers

**Level:** Advanced  
**Time Estimate:** 40 minutes  
**Prerequisites:** Intermediate SQL.

## TL;DR
Views, stored procedures, functions, and triggers allow you to store and execute SQL logic directly within the database. They promote reusability, simplify complex operations, and can automate tasks.

## Motivation & Real-World Scenario
Instead of having every application re-write a complex query to get a user's profile data, you can create a `VIEW` that simplifies it. Instead of having an application calculate sales totals, you can create a `FUNCTION`. To automatically log all changes to a sensitive table, you can use a `TRIGGER`.

## Theory & Worked Examples

### a. Views (Virtual Tables)
A view is a stored `SELECT` query that acts like a virtual table. It's a great way to simplify complex queries or restrict access to certain columns.

```sql
-- Create a view to show only active employees
CREATE VIEW active_employees AS
SELECT name, age, department
FROM employees 
WHERE status = 'active';

-- Query the view just like a table
SELECT * FROM active_employees WHERE department = 'Engineering';
```
**Explanation**: The view doesn't store data itself; it runs the underlying query every time it's accessed.

### b. Stored Procedures
A stored procedure is a set of SQL statements that can be saved and reused. They can take parameters but do not have to return a value. They are ideal for encapsulating business logic.

**Example (PostgreSQL/plpgsql):**
```sql
CREATE OR REPLACE PROCEDURE archive_old_records(archive_date DATE)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Move old records to an archive table
    INSERT INTO orders_archive (id, order_data)
    SELECT id, row_to_json(orders) FROM orders WHERE order_date < archive_date;

    -- Delete the archived records
    DELETE FROM orders WHERE order_date < archive_date;
END;
$$;

-- Execute the procedure
CALL archive_old_records('2023-01-01');
```

### c. Functions
A function is similar to a procedure but is designed to always return a value (either a single scalar value or a set of rows). Functions can be used directly within a `SELECT` statement.

**Example (PostgreSQL/plpgsql):**
```sql
CREATE OR REPLACE FUNCTION get_total_sales_for_month(month INT, year INT)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    total_sales NUMERIC;
BEGIN
    SELECT SUM(amount) INTO total_sales
    FROM sales
    WHERE EXTRACT(MONTH FROM sale_date) = month AND EXTRACT(YEAR FROM sale_date) = year;
    
    RETURN total_sales;
END;
$$;

-- Use the function in a query
SELECT get_total_sales_for_month(5, 2024);
```

### d. Database Triggers
A trigger is a special type of stored procedure that automatically executes when a DML event (`INSERT`, `UPDATE`, `DELETE`) occurs on a table.

**Example (PostgreSQL/plpgsql): Log salary changes**
```sql
-- Create a function that the trigger will call
CREATE OR REPLACE FUNCTION log_salary_change()
RETURNS TRIGGER AS $$
BEGIN
    -- OLD and NEW are special variables containing the row before and after the update
    IF NEW.salary <> OLD.salary THEN
        INSERT INTO salary_audits(employee_id, old_salary, new_salary, changed_on)
        VALUES(OLD.id, OLD.salary, NEW.salary, now());
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger to fire AFTER every UPDATE on the employees table
CREATE TRIGGER salary_change_trigger
AFTER UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION log_salary_change();
```

## Quick Checklist / Cheatsheet
- **View**: Use for simplifying `SELECT` queries.
- **Procedure**: Use for multi-step operations and business logic that doesn't need to return a value.
- **Function**: Use when you need to compute and return a value.
- **Trigger**: Use for automation and auditing in response to data changes.

## Notes: Vendor Differences
- **PostgreSQL**: Uses `plpgsql` or other procedural languages. Differentiates between `PROCEDURE` and `FUNCTION`.
- **MySQL**: Uses its own stored routine syntax. `PROCEDURE` is common.
- **SQL Server**: Uses `T-SQL`. `STORED PROCEDURE` is the standard.
