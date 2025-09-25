# Query Plans Practice — Solutions (guidance)

1. Causes when actual >> estimated: outdated statistics (`ANALYZE` needed), data skew or correlations not captured by simple stats, or parameterized queries causing bad estimates. Steps: run `ANALYZE`, consider extended statistics on correlated columns, rewrite query or add constraints/indexes.

2. `Nested Loop` with `loops=500` means the inner side was executed 500 times — likely the outer side returned many rows. Address by ensuring the inner side has an index, rewrite to use a hash/merge join if more appropriate, or reduce outer rows via pre-filtering.

3. Reasons `Index Only Scan` isn't used: the index does not cover all requested columns (requires index to include the selected columns), visibility map not up-to-date (VACUUM), or planner decided it's cheaper to do a heap fetch.

4. For slow `Hash Join`, check `work_mem` (may be too small causing disk-based spills), check actual sizes of inputs (one side may be larger than expected), and check system IO/CPU. Increasing `work_mem` or rewriting the query may help.

5. `Bitmap Index Scan` + `Bitmap Heap Scan` is preferred when multiple indexes contribute selective predicates that together filter rows; the bitmap approach avoids repeated random IO by consolidating index hits before fetching heap rows.
