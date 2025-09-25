# Lateral Joins Exercise

**Level:** Advanced  
**Time Estimate:** 15 minutes  

## Problem
Given tables `users` and `orders`, find each user's most recent order using LATERAL.

## Schema
```sql
CREATE TABLE users (id INT, name TEXT);
CREATE TABLE orders (id INT, user_id INT, order_date DATE, amount DECIMAL);
```

## Task
Use LATERAL to get the latest order per user.

## Hints
- LATERAL allows correlated subqueries in FROM.
- Use LIMIT 1 with ORDER BY.

## Expected Output
User name, order date, amount for their most recent order.