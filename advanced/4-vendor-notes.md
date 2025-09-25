# Vendor Notes

**Level:** Advanced  
**Time Estimate:** 45 minutes  
**Prerequisites:** Basic SQL across vendors.

## TL;DR
SQL syntax varies by vendor. Know differences in UPSERT, JSON, window functions, and more to write portable or optimized code.

## Learning Objectives
By the end of this lesson, you'll be able to:
- Compare feature support across PostgreSQL, MySQL, SQL Server, Oracle, SQLite.
- Adapt code for different RDBMS.
- Choose vendors based on project needs.

## Motivation & Real-World Scenario
Migrating from MySQL to Postgres requires rewriting UPSERT syntax. Understanding vendor differences prevents surprises and aids in choosing the right DB.

## Theory: Key Differences

### Data Types
- PostgreSQL: Rich types (UUID, JSONB, arrays).
- MySQL: Limited JSON until 8.0.
- SQL Server: Spatial types, temporal tables.
- Oracle: Advanced partitioning.
- SQLite: Simple, no advanced types.

### Syntax Variations
- Joins: All similar, but Oracle uses `(+)` for outer joins (legacy).
- Limits: `LIMIT` (Postgres/MySQL), `TOP` (SQL Server), `ROWNUM` (Oracle).

## Worked Examples

### Window Functions
Postgres/MySQL/SQL Server:
```sql
SELECT name, RANK() OVER (ORDER BY salary DESC) FROM employees;
```

Oracle:
```sql
SELECT name, RANK() OVER (ORDER BY salary DESC) FROM employees;  -- Same
```

SQLite: Limited, use subqueries.

### Full-Text Search
Postgres:
```sql
SELECT * FROM articles WHERE to_tsvector('english', content) @@ to_tsquery('search term');
```

MySQL:
```sql
SELECT * FROM articles WHERE MATCH(content) AGAINST('search term');
```

SQL Server:
```sql
SELECT * FROM articles WHERE CONTAINS(content, 'search term');
```

### Materialized Views
Postgres:
```sql
CREATE MATERIALIZED VIEW mv AS SELECT ...;
REFRESH MATERIALIZED VIEW mv;
```

MySQL: Use summary tables or triggers.

SQL Server: Indexed views.

## Feature Matrix (Expanded)

| Feature | PostgreSQL | MySQL | SQL Server | Oracle | SQLite |
|---|---|---|---|---|---|
| UPSERT | `ON CONFLICT` | `INSERT ... ON DUPLICATE KEY` | `MERGE` | `MERGE` | `INSERT OR REPLACE` |
| JSON | `jsonb` (fast) | `JSON` (5.7+) | `JSON` (2016+) | `JSON` | Extension |
| CTEs | Yes | 8.0+ | Yes | Yes | Yes |
| Partitioning | Yes | Yes | Yes | Advanced | No |
| Triggers | Yes | Yes | Yes | Yes | Yes |
| Stored Procs | PL/pgSQL | Stored routines | T-SQL | PL/SQL | No |

## Quick Checklist / Cheatsheet
- Test code on target vendor early.
- Use ORM for portability.
- Check version-specific features.

## Exercises

1. **Easy:** Rewrite a Postgres UPSERT for MySQL.
2. **Medium:** Compare JSON querying syntax.
3. **Hard:** Port a window function query to SQLite.

## Solutions

1. `INSERT INTO t (id, val) VALUES (1, 'x') ON DUPLICATE KEY UPDATE val = VALUES(val);`

2. Postgres: `data->'key'`, MySQL: `JSON_EXTRACT(data, '$.key')`

3. Use subqueries or custom functions in SQLite.

## Notes: Vendor Differences / Performance Tips
- Postgres: Best for complex queries, extensions.
- MySQL: Fast reads, web apps.
- SQL Server: Enterprise features, Windows integration.
- Oracle: Scalability, advanced analytics.
- SQLite: Embedded, simple apps.

Choose based on ecosystem, cost, and features.

## Next Lessons
- Schema Design & Normalization (vendor-agnostic).
- Monitoring & Observability (vendor-specific tools).
