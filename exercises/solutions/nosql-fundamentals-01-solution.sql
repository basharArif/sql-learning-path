-- NoSQL Fundamentals Exercise 1 - Solution

-- Note: This exercise focuses on database selection and CAP theorem concepts,
-- which are architectural decisions rather than SQL queries.
-- However, here are example queries for different database types
-- that might be used in the scenarios described:

-- 1. Product Catalog (AP - Availability & Partition Tolerance)
-- Example using MongoDB for high availability catalog:

-- Create product catalog collection with sharding for global access
-- db.createCollection("products", {
--   validator: {
--     $jsonSchema: {
--       bsonType: "object",
--       required: ["name", "category", "price"],
--       properties: {
--         name: { bsonType: "string" },
--         category: { bsonType: "string" },
--         price: { bsonType: "number" }
--       }
--     }
--   }
-- })

-- Index for global read performance
-- db.products.createIndex({ "category": 1 })
-- db.products.createIndex({ "name": "text" })

-- Query for global product search
-- db.products.find({ "category": "Electronics" }).limit(20)

-- 2. Shopping Cart (AP - Availability & Partition Tolerance)
-- Example using Redis for session-based shopping cart:

-- SET user:cart:session_id "product_id|quantity|product_id2|quantity2"
-- HMSET cart:session_id product_id 2 product_id2 1
-- HGETALL cart:session_id

-- 3. Order Processing (CP - Consistency & Partition Tolerance)
-- Example using PostgreSQL for ACID-compliant orders:

-- CREATE TABLE orders (
--   order_id SERIAL PRIMARY KEY,
--   user_id INT NOT NULL,
--   status VARCHAR(20) DEFAULT 'pending',
--   total DECIMAL(10,2),
--   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--   CONSTRAINT chk_status CHECK (status IN ('pending', 'confirmed', 'shipped', 'delivered', 'cancelled'))
-- );

-- CREATE TABLE order_items (
--   item_id SERIAL PRIMARY KEY,
--   order_id INT REFERENCES orders(order_id),
--   product_id INT,
--   quantity INT NOT NULL,
--   price DECIMAL(10,2) NOT NULL
-- );

-- Transaction to create an order with consistency guarantees:
-- BEGIN;
-- INSERT INTO orders (user_id, status, total) VALUES (123, 'pending', 99.99);
-- INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (CURRVAL('orders_order_id_seq'), 456, 2, 49.99);
-- UPDATE inventory SET stock = stock - 2 WHERE product_id = 456;
-- COMMIT;

-- 4. Real-time Inventory (AP - Availability & Partition Tolerance)
-- Example using Cassandra for distributed inventory:

-- CREATE KEYSPACE inventory_keyspace
-- WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenter1': 3};

-- CREATE TABLE inventory_keyspace.products (
--   product_id UUID,
--   name TEXT,
--   available_count COUNTER,
--   last_updated TIMESTAMP,
--   PRIMARY KEY (product_id)
-- );

-- Increment inventory counter (highly available)
-- UPDATE inventory_keyspace.products SET available_count = available_count + 1 WHERE product_id = 123e4567-e89b-12d3-a456-426614174000;

-- Advanced Challenge - Data synchronization example:
-- Using Apache Kafka for event streaming between systems:

-- 1. Order service publishes "order_created" event
-- 2. Inventory service consumes event and updates stock
-- 3. Catalog service consumes event and updates product availability
</content>