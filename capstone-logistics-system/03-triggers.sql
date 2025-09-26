-- Phase 2: Core Business Logic (Audit Triggers)
-- This file sets up an audit trail for all inventory changes.

-- Table to log every change in inventory
CREATE TABLE inventory_log (
    id BIGSERIAL PRIMARY KEY,
    product_id UUID NOT NULL,
    warehouse_id UUID NOT NULL,
    old_quantity INT,
    new_quantity INT,
    change_type VARCHAR(50), -- e.g., 'RECEIVE_SHIPMENT', 'FULFILL_ORDER', 'MANUAL_ADJUSTMENT'
    changed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    changed_by NAME DEFAULT current_user
);

-- A function that will be called by our trigger
CREATE OR REPLACE FUNCTION log_inventory_change()
RETURNS TRIGGER AS $$
DECLARE
    v_change_type VARCHAR(50);
BEGIN
    -- Determine the type of change based on the operation
    IF (TG_OP = 'UPDATE') THEN
        v_change_type := 'UPDATE';
        INSERT INTO inventory_log (product_id, warehouse_id, old_quantity, new_quantity, change_type)
        VALUES (NEW.product_id, NEW.warehouse_id, OLD.quantity, NEW.quantity, v_change_type);
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        v_change_type := 'INSERT';
        INSERT INTO inventory_log (product_id, warehouse_id, old_quantity, new_quantity, change_type)
        VALUES (NEW.product_id, NEW.warehouse_id, 0, NEW.quantity, v_change_type);
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        v_change_type := 'DELETE';
        INSERT INTO inventory_log (product_id, warehouse_id, old_quantity, new_quantity, change_type)
        VALUES (OLD.product_id, OLD.warehouse_id, OLD.quantity, 0, v_change_type);
        RETURN OLD;
    END IF;
    RETURN NULL; -- result is ignored since this is an AFTER trigger
END;
$$ LANGUAGE plpgsql;

-- The trigger that fires after any change to the inventory table
CREATE TRIGGER inventory_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON inventory
FOR EACH ROW EXECUTE FUNCTION log_inventory_change();
