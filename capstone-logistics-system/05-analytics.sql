-- Phase 5: Advanced Analytics and Reporting

-- Part 1: Materialized View for Dashboarding
-- BI dashboards often need to query large amounts of data, which can be slow.
-- A materialized view pre-calculates and stores the results of a query,
-- allowing for near-instantaneous dashboard loads.

CREATE MATERIALIZED VIEW daily_inventory_summary AS
SELECT
    w.id AS warehouse_id,
    w.name AS warehouse_name,
    p.id AS product_id,
    p.name AS product_name,
    i.quantity,
    (i.quantity * COALESCE(p.weight_kg, 0)) AS total_weight_kg, -- Example of a calculated metric
    CURRENT_DATE AS summary_date
FROM inventory i
JOIN products p ON i.product_id = p.id
JOIN warehouses w ON i.warehouse_id = w.id
WITH DATA;

-- This view would be refreshed on a schedule (e.g., nightly) to keep it up-to-date.
-- REFRESH MATERIALIZED VIEW daily_inventory_summary;

-- Add an index for fast filtering by date and warehouse
CREATE UNIQUE INDEX ON daily_inventory_summary (summary_date, warehouse_id, product_id);


-- Part 2: Advanced Reporting with Window Functions
-- This view creates a supplier performance report. It calculates the time it takes
-- for a purchase order to be received and compares it to the supplier's average.

CREATE OR REPLACE VIEW supplier_performance_report AS
SELECT
    s.name AS supplier_name,
    po.id AS purchase_order_id,
    po.created_at AS order_placed_at,
    log.changed_at AS order_received_at,
    (log.changed_at - po.created_at) AS processing_time,
    -- Use a window function to calculate the average processing time for each supplier
    AVG(log.changed_at - po.created_at) OVER (PARTITION BY s.id) AS avg_supplier_processing_time
FROM purchase_orders po
JOIN suppliers s ON po.supplier_id = s.id
-- We need to find when the PO was marked as 'RECEIVED'. We can get this from our audit log.
-- This demonstrates the power of having a good audit trail!
LEFT JOIN (
    SELECT DISTINCT ON (purchase_order_id) purchase_order_id, changed_at
    FROM purchase_order_items -- A proxy to find when items were received
    -- In a real system, you might have a dedicated 'received_at' timestamp.
    -- For this example, we'll join with the inventory log to find when the stock was added.
    -- A simpler way would be to log the PO status change.
    -- Let's assume for this report we find the last time an item from the PO was logged.
    INNER JOIN inventory_log il ON purchase_order_items.product_id = il.product_id
    ORDER BY purchase_order_id, changed_at DESC
) AS log ON po.id = log.purchase_order_id
WHERE po.status = 'RECEIVED';


-- Example query on the view:
-- Find all orders from 'Test Supplier' that were processed slower than their average.
-- SELECT * FROM supplier_performance_report
-- WHERE supplier_name = 'Test Supplier' AND processing_time > avg_supplier_processing_time;
