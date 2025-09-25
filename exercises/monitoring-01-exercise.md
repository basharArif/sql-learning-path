# Monitoring Exercise

**Level:** Intermediate  
**Time Estimate:** 10 minutes  

## Problem
Check for long-running queries in PostgreSQL.

## Task
Query pg_stat_activity for queries running longer than 1 minute.

## Hints
- Use now() - query_start.
- Filter by state = 'active'.

## Expected Output
PID, duration, query text.