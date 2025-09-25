# Visualization & BI Integration

**Level:** Intermediate  
**Time Estimate:** 35 minutes  
**Prerequisites:** Aggregations, views.

## TL;DR
Prepare data for BI tools by creating summary views and tables. Use materialized views for performance and schedule refreshes to keep data current.

## Learning Objectives
By the end of this lesson, you'll be able to:
- Create summary tables for dashboards.
- Use materialized views for caching.
- Export data to BI tools.
- Optimize queries for visualization.

## Motivation & Real-World Scenario
Dashboards load slowly with raw data queries. Pre-aggregated views speed up reports, improving user experience and reducing server load.

## Theory: Data Preparation for BI

### Aggregation
- Summarize data for charts (e.g., monthly totals).

### Materialized Views
- Cached results of complex queries.

### Export
- CSV/JSON for external tools.

**Data Flow: Database to BI Dashboard:**
```mermaid
graph TD
    A[Raw Database Tables] --> B[ETL/Transformation]
    B --> C[Summary Tables/Views]
    C --> D[Materialized Views\nCached Results]
    D --> E[Export Layer\nCSV/JSON/API]
    E --> F[BI Tools]
    F --> G[Dashboards & Reports]
    
    H[Data Sources] -.-> A
    I[Real-time] -.-> B
    J[Batch Processing] -.-> B
    K[Scheduled Refresh] -.-> D
    
    L[Tableau] -.-> F
    M[Power BI] -.-> F
    N[Metabase] -.-> F
    O[Looker] -.-> F
```

## Worked Examples

### Summary Table
```sql
CREATE TABLE monthly_sales AS
SELECT date_trunc('month', order_date) AS month, product_id, SUM(quantity) AS total_qty
FROM orders
GROUP BY month, product_id;
```

### Materialized View
```sql
CREATE MATERIALIZED VIEW top_products AS
SELECT product_id, SUM(sales) AS total_sales
FROM sales_data
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 10;

-- Refresh
REFRESH MATERIALIZED VIEW top_products;
```

**Materialized View Refresh Cycle:**
```mermaid
graph TD
    A[Base Tables Updated] --> B[Trigger Refresh\nSchedule/Cron]
    B --> C[REFRESH MATERIALIZED VIEW]
    C --> D[Re-execute Query]
    D --> E[Update Cached Results]
    E --> F[New Data Available]
    
    G[Refresh Strategies] -.-> H[Complete Refresh\nREFRESH MATERIALIZED VIEW]
    G -.-> I[Incremental Refresh\nCustom Logic]
    G -.-> J[Concurrent Refresh\nREFRESH CONCURRENTLY]
    
    K[Performance Impact] -.-> L[Blocking during refresh]
    K -.-> M[Stale data between refreshes]
    K -.-> N[Storage overhead]
    
    O[Best Practices] -.-> P[Schedule off-peak hours]
    O -.-> Q[Monitor refresh duration]
    O -.-> R[Use CONCURRENTLY for high availability]
```

### Export to CSV
```sql
COPY (SELECT * FROM monthly_sales) TO '/output/sales.csv' WITH CSV HEADER;
```

### BI Query Pattern
```sql
-- For Tableau/Metabase
SELECT region, SUM(revenue) AS revenue
FROM sales
WHERE date >= '2023-01-01'
GROUP BY region
ORDER BY revenue DESC;
```

## BI Tool Integration Patterns

### Direct Database Connection
```sql
-- Tableau/Power BI connection string
-- Host: your-server.com
-- Port: 5432
-- Database: analytics_db
-- Schema: public
```

### API-Based Integration
```sql
-- Create API endpoint for BI tools
CREATE OR REPLACE FUNCTION get_dashboard_data(
    start_date DATE,
    end_date DATE
)
RETURNS TABLE (
    category TEXT,
    revenue NUMERIC,
    orders INTEGER
)
LANGUAGE SQL
AS $$
    SELECT 
        category,
        SUM(revenue) AS revenue,
        COUNT(*) AS orders
    FROM sales
    WHERE order_date BETWEEN start_date AND end_date
    GROUP BY category;
$$;
```

**BI Integration Architecture:**
```mermaid
graph TB
    subgraph "Data Sources"
        A[(Operational DB)]
        B[(Data Warehouse)]
        C[(Data Lake)]
    end
    
    subgraph "ETL Layer"
        D[Extract] --> E[Transform]
        E --> F[Load]
    end
    
    subgraph "BI Tools"
        G[Tableau]
        H[Power BI]
        I[Looker]
        J[Metabase]
    end
    
    subgraph "Consumption Layer"
        K[Dashboards]
        L[Reports]
        M[Ad-hoc Analysis]
    end
    
    A --> D
    B --> D
    C --> D
    
    F --> G
    F --> H
    F --> I
    F --> J
    
    G --> K
    H --> K
    I --> K
    J --> K
    
    K --> L
    K --> M
    
    N[Security Layer] -.-> A
    N -.-> B
    N -.-> C
    N -.-> F
    
    O[Caching Layer] -.-> F
    O -.-> G
    O -.-> H
```

## Quick Checklist / Cheatsheet
- Use views for dynamic summaries.
- Refresh materialized views on schedule.
- Index summary tables for fast queries.
- Validate data before export.

## Exercises

1. **Easy:** Create a view for daily sales totals.
2. **Medium:** Materialize a top-10 list and refresh it.
3. **Hard:** Export aggregated data and import into a BI tool.

## Solutions

1. `CREATE VIEW daily_sales AS SELECT date, SUM(amount) FROM sales GROUP BY date;`

2. `CREATE MATERIALIZED VIEW top10 AS SELECT ... LIMIT 10; REFRESH MATERIALIZED VIEW top10;`

3. Use COPY to export, then load in tool like Metabase.

## Notes: Vendor Differences / Performance Tips
- MySQL: Use summary tables instead of materialized views.
- SQL Server: Indexed views for similar effect.
- Schedule refreshes during low-traffic times.

## Next Lessons
- Query Plans & Cost Models (for optimizing BI queries).
- Partitioning & Sharding (for large datasets).

