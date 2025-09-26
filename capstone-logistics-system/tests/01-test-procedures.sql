-- Phase 3: Automated SQL Testing
-- This script uses the pgTAP extension to test our stored procedures.

-- This entire script should be run as a single transaction to isolate tests.
BEGIN;

-- Make sure pgTAP is available
CREATE EXTENSION IF NOT EXISTS pgtap;

-- Plan the number of tests to run.
SELECT plan(8); -- We have 8 tests in this suite.

-- 1. Setup test data

-- Create a test supplier, product, and warehouse
INSERT INTO suppliers (id, name) VALUES ('10000000-0000-0000-0000-000000000001', 'Test Supplier');
INSERT INTO products (id, sku, name) VALUES ('20000000-0000-0000-0000-000000000001', 'TEST-SKU-01', 'Test Product');
INSERT INTO warehouses (id, name) VALUES ('30000000-0000-0000-0000-000000000001', 'Test Warehouse');

-- Create a purchase order to receive stock
INSERT INTO purchase_orders (id, supplier_id, warehouse_id, status) VALUES ('40000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', 'PENDING');
INSERT INTO purchase_order_items (purchase_order_id, product_id, quantity) VALUES ('40000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 100);

-- Create a customer order to fulfill
INSERT INTO customer_orders (id, status) VALUES ('50000000-0000-0000-0000-000000000001', 'PENDING');
INSERT INTO customer_order_items (customer_order_id, product_id, quantity) VALUES ('50000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 10);


-- 2. Run the tests

-- Test 1: Check initial state (no inventory)
SELECT is(
    (SELECT quantity FROM inventory WHERE product_id = '20000000-0000-0000-0000-000000000001' AND warehouse_id = '30000000-0000-0000-0000-000000000001'),
    NULL::integer,
    'Test 1: Initial inventory should be null (no record)'
);

-- Test 2: Test the receive_shipment function
SELECT lives_ok(
    'SELECT receive_shipment("40000000-0000-0000-0000-000000000001")',
    'Test 2: receive_shipment function should execute without errors'
);

-- Test 3: Verify stock level after receiving shipment
SELECT is(
    (SELECT quantity FROM inventory WHERE product_id = '20000000-0000-0000-0000-000000000001' AND warehouse_id = '30000000-0000-0000-0000-000000000001'),
    100,
    'Test 3: Inventory should be 100 after receiving shipment'
);

-- Test 4: Verify purchase order status is updated
SELECT is(
    (SELECT status FROM purchase_orders WHERE id = '40000000-0000-0000-0000-000000000001'),
    'RECEIVED',
    'Test 4: Purchase order status should be RECEIVED'
);

-- Test 5: Test the fulfill_customer_order function (happy path)
SELECT lives_ok(
    'SELECT fulfill_customer_order("50000000-0000-0000-0000-000000000001", "30000000-0000-0000-0000-000000000001")',
    'Test 5: fulfill_customer_order should execute without errors for sufficient stock'
);

-- Test 6: Verify stock level after fulfilling order
SELECT is(
    (SELECT quantity FROM inventory WHERE product_id = '20000000-0000-0000-0000-000000000001' AND warehouse_id = '30000000-0000-0000-0000-000000000001'),
    90, -- 100 - 10
    'Test 6: Inventory should be 90 after fulfilling the order'
);

-- Test 7: Verify customer order status is updated
SELECT is(
    (SELECT status FROM customer_orders WHERE id = '50000000-0000-0000-0000-000000000001'),
    'FULFILLED',
    'Test 7: Customer order status should be FULFILLED'
);

-- Test 8: Test fulfill_customer_order for insufficient stock
-- We expect this to throw an exception.
SELECT throws_ok(
    'SELECT fulfill_customer_order("50000000-0000-0000-0000-000000000001", "30000000-0000-0000-0000-000000000001")', -- Trying to fulfill the same 10-item order again
    'P0001', -- This is the generic code for a RAISE EXCEPTION
    'Insufficient stock for product 20000000-0000-0000-0000-000000000001 at warehouse 30000000-0000-0000-0000-000000000001',
    'Test 8: Fulfilling an order with insufficient stock should throw an exception'
);


-- Finish the tests
SELECT * FROM finish();

ROLLBACK;
