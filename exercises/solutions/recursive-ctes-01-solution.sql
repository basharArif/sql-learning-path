WITH RECURSIVE hierarchy AS (
    SELECT id, name, manager_id, 0 AS level
    FROM employees
    WHERE id = 1

    UNION ALL

    SELECT e.id, e.name, e.manager_id, h.level + 1
    FROM employees e
    JOIN hierarchy h ON e.manager_id = h.id
)
SELECT * FROM hierarchy ORDER BY level, id;