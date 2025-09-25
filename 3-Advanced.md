[<- Back to Learning Path](learning-path.md)

---
# Part 3: Advanced SQL

**Level:** Advanced  
**Time Estimate:** 75 minutes  
**Prerequisites:** Intermediate SQL.

## TL;DR
Advanced SQL includes views for reusable queries, transactions for consistency, window functions for analytics, and triggers for automation.

## Learning Objectives
By the end of this lesson, you'll be able to:
- Create and use views, procedures, functions.
- Manage transactions with ACID.
- Apply window functions for rankings.
- Implement triggers and security best practices.

## Motivation & Real-World Scenario
E-commerce needs secure, consistent data handling—transactions prevent errors, views simplify reports, triggers automate audits.

## Theory: Advanced Database Features

### Views
Virtual tables from queries.

### Stored Procedures/Functions
Reusable code in database.

### Transactions
Ensure data integrity.

### Window Functions
Advanced aggregations over windows.

### Triggers
Auto-execute on events.

## Worked Examples

### Views, Stored Procedures & Functions

#### a. Views (virtual tables)
```sql
CREATE VIEW active_employees AS
SELECT name, age FROM employees WHERE age >= 18;
SELECT * FROM active_employees;
```
**Explanation**: Views are saved queries, act like tables.

#### b. Stored Procedures (Reusable logic, MySQL-style)
```sql
DELIMITER //
CREATE PROCEDURE GetEmployeeCount()
BEGIN
    SELECT COUNT(*) FROM employees;
END //
DELIMITER ;
CALL GetEmployeeCount();
```
**Explanation**: Procedures execute logic, no return value.

#### c. Functions
```sql
CREATE FUNCTION GetTotalEmployees() RETURNS INT
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM employees;
    RETURN total;
END;
```
**Explanation**: Functions return values.

#### d. Database Triggers
```sql
CREATE TABLE employee_audits (
    id SERIAL PRIMARY KEY,
    employee_id INT,
    old_salary NUMERIC,
    new_salary NUMERIC,
    changed_on TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_salary_change() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.salary <> OLD.salary THEN
        INSERT INTO employee_audits(employee_id, old_salary, new_salary, changed_on)
        VALUES(OLD.id, OLD.salary, NEW.salary, now());
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER salary_change_trigger
AFTER UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION log_salary_change();
```
**Explanation**: Triggers fire on INSERT/UPDATE/DELETE, enforce rules or log changes.

### Transactions & ACID
```sql
BEGIN;
UPDATE accounts SET balance = balance - 500 WHERE id = 1;
UPDATE accounts SET balance = balance + 500 WHERE id = 2;
COMMIT;  -- Or ROLLBACK on error
```
**Explanation**: ACID ensures reliable changes.

### Window Functions
```sql
SELECT name, age, RANK() OVER (ORDER BY age DESC) AS age_rank
FROM employees;
```
**Explanation**: Operate on result sets, like rankings.

### Security & Best Practices
- Use parameterized queries to prevent SQL injection.
- Grant minimal privileges: `GRANT SELECT ON employees TO analyst;`
- Avoid `SELECT *` in production.
- Partition large tables for performance.

## Quick Checklist / Cheatsheet
- Views: Reusable SELECTs.
- Transactions: BEGIN/COMMIT/ROLLBACK.
- Window functions: OVER clauses.
- Triggers: Auto on events.

## Exercises

1. **Easy:** Create a view for employees over 30.
2. **Medium:** Write a function to calculate average salary.
3. **Hard:** Implement a trigger to prevent negative balances.

## Solutions

1. `CREATE VIEW senior_employees AS SELECT * FROM employees WHERE age > 30;`
2. `CREATE FUNCTION avg_salary() RETURNS DECIMAL AS 'SELECT AVG(salary) FROM employees;' LANGUAGE SQL;`
3. `CREATE TRIGGER check_balance BEFORE UPDATE ON accounts FOR EACH ROW WHEN (NEW.balance < 0) EXECUTE FUNCTION raise_error();`

## Notes: Vendor Differences / Performance Tips
- Triggers: PostgreSQL uses plpgsql, MySQL uses SQL.
- Window functions: Supported in modern RDBMS.
- Index triggers for performance.

## Next Lessons
Real-World Queries (Applications).