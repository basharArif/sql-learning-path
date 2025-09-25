[<- Back to Learning Path](learning-path.md)

---
# Part 6: Expert Topics

**Level:** Expert  
**Time Estimate:** 70 minutes  
**Prerequisites:** Pro SQL Skills.

## TL;DR
Expert topics cover advanced indexing, JSON handling, and data warehousing for high-performance, semi-structured data.

## Learning Objectives
By the end of this lesson, you'll be able to:
- Use covering/GIN indexes.
- Query JSON data efficiently.
- Understand OLTP vs OLAP.

## Motivation & Real-World Scenario
Modern apps handle JSON APIs and massive analytics—expert techniques ensure speed and flexibility.

## Theory: Expert-Level Features

### Advanced Indexing
Specialized indexes for performance.

### JSON Handling
Query semi-structured data.

### Data Warehousing
OLAP for analytics.

## Worked Examples

### Advanced Performance & Indexing

#### Covering Indexes
```sql
CREATE INDEX idx_prod_cat_price ON products (category_id) INCLUDE (product_id, price);
```
**Explanation**: Includes all needed columns, avoids table lookup.

#### Other Index Types (PostgreSQL)
- Hash: Equality only.
- GIN: Arrays/JSON.
- GiST: Geometric/full-text.

### Working with Semi-Structured Data (JSON)

#### Querying JSONB
```sql
SELECT * FROM events
WHERE data ->> 'type' = 'login';

SELECT * FROM events
WHERE data @> '{"user_id": 123}';
```
**Explanation**: -> accesses fields, @> checks containment.

#### Indexing JSONB
```sql
CREATE INDEX idx_events_data_gin ON events USING GIN (data);
```
**Explanation**: Speeds JSON queries.

### Data Warehousing Concepts

#### OLTP vs. OLAP
- OLTP: Transactions (e.g., e-commerce).
- OLAP: Analytics (fast SELECTs on history).

#### Star Schema
Fact table + dimension tables for fast joins.

## Quick Checklist / Cheatsheet
- Covering indexes: INCLUDE extra columns.
- JSON: -> for access, GIN for indexing.
- Warehousing: Denormalize for OLAP.

## Exercises

1. **Easy:** Create a covering index.
2. **Medium:** Query JSONB with GIN index.
3. **Hard:** Design a star schema.

## Solutions

1. `CREATE INDEX ... INCLUDE (...);`
2. `CREATE INDEX USING GIN; SELECT with @>;`
3. Fact: Sales; Dimensions: Date, Product, Customer.

## Notes: Vendor Differences / Performance Tips
- GIN: PostgreSQL. Full-text in others.
- Star schema: Common in warehouses.

## End of Tutorial
