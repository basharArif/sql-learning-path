-- Phase 4: Scaling and Security Operations

-- Part 1: Partitioning the inventory_log table
-- As the inventory_log table will grow very large over time, we partition it by date
-- to make queries faster and maintenance (like dropping old logs) easier.

-- First, we need to rename the old table and create a new partitioned table.
ALTER TABLE inventory_log RENAME TO inventory_log_old;

CREATE TABLE inventory_log (
    id BIGSERIAL,
    product_id UUID NOT NULL,
    warehouse_id UUID NOT NULL,
    old_quantity INT,
    new_quantity INT,
    change_type VARCHAR(50),
    changed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    changed_by NAME DEFAULT current_user,
    PRIMARY KEY (id, changed_at) -- Partition key must be part of the primary key
) PARTITION BY RANGE (changed_at);

-- Now, create partitions for specific time ranges. This would typically be automated.
-- For this example, we'll create a partition for October 2025 and November 2025.
CREATE TABLE inventory_log_2025_10 PARTITION OF inventory_log
    FOR VALUES FROM ('2025-10-01') TO ('2025-11-01');

CREATE TABLE inventory_log_2025_11 PARTITION OF inventory_log
    FOR VALUES FROM ('2025-11-01') TO ('2025-12-01');

-- Copy the data from the old table into the new partitioned table.
INSERT INTO inventory_log SELECT * FROM inventory_log_old;

-- Drop the old table.
DROP TABLE inventory_log_old;

-- The trigger function needs to be updated to work with the partitioned table.
-- The trigger itself does not need to be changed.
-- (In this case, the existing trigger function works without modification, but it's a good practice to review)


-- Part 2: Row-Level Security (RLS)
-- We will create a role for a warehouse manager who should only see data
-- related to their own warehouse.

-- Create the role
CREATE ROLE warehouse_manager;

-- Grant basic permissions to the role. They can see and manage inventory and orders.
GRANT SELECT, INSERT, UPDATE, DELETE ON inventory, customer_orders, customer_order_items, purchase_orders, purchase_order_items TO warehouse_manager;
GRANT USAGE ON SCHEMA public TO warehouse_manager;

-- Create a mapping table to associate users with warehouses.
CREATE TABLE user_warehouse_mappings (
    user_name NAME PRIMARY KEY,
    warehouse_id UUID NOT NULL REFERENCES warehouses(id)
);

-- Create a test user and assign them to the role and a warehouse.
CREATE USER manager_jane WITH PASSWORD 'securepassword';
GRANT warehouse_manager TO manager_jane;
INSERT INTO user_warehouse_mappings (user_name, warehouse_id) VALUES ('manager_jane', '30000000-0000-0000-0000-000000000001');


-- Enable Row-Level Security on the relevant tables.
ALTER TABLE inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE warehouses ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchase_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_orders ENABLE ROW LEVEL SECURITY;

-- Define the security policies.

-- Policy: A warehouse manager can only see their own warehouse.
CREATE POLICY warehouse_manager_policy ON warehouses
    FOR SELECT
    USING (id = (SELECT warehouse_id FROM user_warehouse_mappings WHERE user_name = current_user));

-- Policy: A warehouse manager can only interact with inventory for their own warehouse.
CREATE POLICY inventory_manager_policy ON inventory
    FOR ALL
    USING (warehouse_id = (SELECT warehouse_id FROM user_warehouse_mappings WHERE user_name = current_user));

-- Policy: A warehouse manager can only see purchase orders for their own warehouse.
CREATE POLICY po_manager_policy ON purchase_orders
    FOR ALL
    USING (warehouse_id = (SELECT warehouse_id FROM user_warehouse_mappings WHERE user_name = current_user));

-- Policy: A warehouse manager can only see customer orders being fulfilled from their warehouse.
-- NOTE: Our current schema doesn't link customer_orders to a warehouse until fulfillment.
-- A more robust schema might assign them earlier. For now, we can't apply a simple RLS policy to customer_orders for managers.
-- This is a good example of how security requirements influence schema design.


-- To test this, you would connect as `manager_jane` and run:
-- SELECT * FROM inventory;
-- You would only see rows where warehouse_id = '30000000-0000-0000-0000-000000000001'.
