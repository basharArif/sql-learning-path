SELECT u.name, lo.order_date, lo.amount
FROM users u,
LATERAL (
    SELECT order_date, amount
    FROM orders o
    WHERE o.user_id = u.id
    ORDER BY o.order_date DESC
    LIMIT 1
) lo;