-- Phase 1: Foundational Schema
-- This schema defines the core tables for the logistics and inventory system.

-- Best practice: Use UUIDs for primary keys to avoid conflicts in a distributed system.
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Table for storing product information
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sku VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    weight_kg NUMERIC(8, 2) CHECK (weight_kg > 0)
);

-- Table for storing supplier information
CREATE TABLE suppliers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    contact_info TEXT
);

-- Table for warehouse locations
CREATE TABLE warehouses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    location TEXT
);

-- The core inventory table: tracks stock levels of products at each warehouse.
CREATE TABLE inventory (
    product_id UUID NOT NULL REFERENCES products(id),
    warehouse_id UUID NOT NULL REFERENCES warehouses(id),
    quantity INT NOT NULL CHECK (quantity >= 0),
    PRIMARY KEY (product_id, warehouse_id)
);

-- Table for purchase orders sent to suppliers to replenish stock
CREATE TABLE purchase_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supplier_id UUID NOT NULL REFERENCES suppliers(id),
    warehouse_id UUID NOT NULL REFERENCES warehouses(id),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'SHIPPED', 'RECEIVED')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Line items for each purchase order
CREATE TABLE purchase_order_items (
    purchase_order_id UUID NOT NULL REFERENCES purchase_orders(id),
    product_id UUID NOT NULL REFERENCES products(id),
    quantity INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (purchase_order_id, product_id)
);

-- Table for customer orders
CREATE TABLE customer_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_info TEXT, -- Simplified for this example
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'FULFILLED', 'CANCELED')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Line items for each customer order
CREATE TABLE customer_order_items (
    customer_order_id UUID NOT NULL REFERENCES customer_orders(id),
    product_id UUID NOT NULL REFERENCES products(id),
    quantity INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (customer_order_id, product_id)
);

-- Add indexes for frequently queried foreign keys
CREATE INDEX ON inventory (warehouse_id);
CREATE INDEX ON purchase_orders (supplier_id);
CREATE INDEX ON purchase_orders (warehouse_id);
CREATE INDEX ON customer_orders (created_at DESC);
