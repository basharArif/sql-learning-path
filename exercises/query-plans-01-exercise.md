# Query Plans Practice

1. Given an `EXPLAIN ANALYZE` output where `Seq Scan` is used and actual rows = 1000 but estimated rows = 10, what are three likely causes and what steps would you take?
2. A query shows a `Nested Loop` with `loops=500` — what does this imply and how would you address it?
3. You observe `Index Only Scan` is not used though an index exists — list reasons this may happen.
4. Given a query with `Hash Join` taking long, what planner settings or system resources might you check?
5. Describe when `Bitmap Index Scan` + `Bitmap Heap Scan` is preferred over repeated `Index Scan`.
