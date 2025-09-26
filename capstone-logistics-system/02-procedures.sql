-- Phase 2: Core Business Logic (Procedures)
-- These procedures encapsulate the primary operations of the inventory system.

-- Procedure to handle receiving a shipment from a supplier.
-- It atomically updates the inventory and the purchase order status.
CREATE OR REPLACE FUNCTION receive_shipment(p_purchase_order_id UUID)
RETURNS VOID AS $$
DECLARE
    item RECORD;
    v_warehouse_id UUID;
BEGIN
    -- Get the warehouse for the purchase order
    SELECT warehouse_id INTO v_warehouse_id
    FROM purchase_orders
    WHERE id = p_purchase_order_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Purchase Order % not found', p_purchase_order_id;
    END IF;

    -- Loop through items in the purchase order and update inventory
    FOR item IN
        SELECT product_id, quantity FROM purchase_order_items
        WHERE purchase_order_id = p_purchase_order_id
    LOOP
        -- Use UPSERT to add stock. If the product is new to the warehouse, it creates a record.
        INSERT INTO inventory (product_id, warehouse_id, quantity)
        VALUES (item.product_id, v_warehouse_id, item.quantity)
        ON CONFLICT (product_id, warehouse_id)
        DO UPDATE SET quantity = inventory.quantity + item.quantity;
    END LOOP;

    -- Mark the purchase order as RECEIVED
    UPDATE purchase_orders
    SET status = 'RECEIVED'
    WHERE id = p_purchase_order_id;

END;
$$ LANGUAGE plpgsql;


-- Procedure to fulfill a customer order from a specific warehouse.
-- It atomically checks for and decrements stock.
CREATE OR REPLACE FUNCTION fulfill_customer_order(p_customer_order_id UUID, p_warehouse_id UUID)
RETURNS VOID AS $$
DECLARE
    item RECORD;
    current_stock INT;
BEGIN
    -- Loop through items in the customer order
    FOR item IN
        SELECT product_id, quantity FROM customer_order_items
        WHERE customer_order_id = p_customer_order_id
    LOOP
        -- Lock the inventory row for this product and warehouse to prevent race conditions
        SELECT quantity INTO current_stock
        FROM inventory
        WHERE product_id = item.product_id AND warehouse_id = p_warehouse_id
        FOR UPDATE;

        -- Check for sufficient stock
        IF current_stock IS NULL OR current_stock < item.quantity THEN
            RAISE EXCEPTION 'Insufficient stock for product % at warehouse %', item.product_id, p_warehouse_id;
        END IF;

        -- Decrement the stock
        UPDATE inventory
        SET quantity = quantity - item.quantity
        WHERE product_id = item.product_id AND warehouse_id = p_warehouse_id;

    END LOOP;

    -- Mark the customer order as FULFILLED
    UPDATE customer_orders
    SET status = 'FULFILLED'
    WHERE id = p_customer_order_id;

END;
$$ LANGUAGE plpgsql;
