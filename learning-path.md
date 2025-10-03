# SQL Learning Path - Master Index

This document provides a structured path through the SQL learning content. The course is organized into several parts, from core fundamentals to expert-level operations.

---

**SQL Learning Roadmap:**
```mermaid
graph TD
    subgraph "🎯 START HERE"
        A["Introduction & Basics\nCREATE, INSERT, SELECT\nUPDATE, DELETE"]
    end
    
    subgraph "📊 Fundamentals"
        B["JOINS\\nINNER, LEFT, RIGHT, FULL"]
        C["Aggregations\nGROUP BY, COUNT, SUM\nHAVING, DISTINCT"]
        D["Subqueries & Sets\nUNION, INTERSECT\nEXISTS, IN"]
        E["Conditional Logic\nCASE WHEN, COALESCE"]
        F["Indexing Basics\nB-Tree, Performance"]
        G["Normalization\n1NF, 2NF, 3NF"]
        H["Database Design\nSchema & Modeling"]
    end
    
    subgraph "🧠 Theory"
        I["Relational Algebra\nSelection, Projection\nJoin, Union"]
        J["Data Types\nNumeric, Text, Date\nJSON, Arrays"]
        K["Query Plans\nEXPLAIN, Cost Models\nOptimization"]
        L["Transactions\nACID, Isolation Levels\nConcurrency Control"]
        M["Data Modeling\nERD, Schema Design"]
        N["Performance Tuning\nIndexes, Query Optimization"]
    end
    
    subgraph "⚡ Advanced"
        O["Recursive CTEs\nHierarchies, Trees\nGraphs"]
        P["Lateral Joins\nJSON Functions\nAdvanced Queries"]
        Q["Temporal Tables\nChange Data Capture\nAudit Trails"]
        R["Window Functions\nRANK, LAG, LEAD\nRunning Totals"]
        S["Views, Procedures, & Triggers\nFunctions, Stored Code"]
        T["Vendor Notes & Differences\nPostgreSQL vs MySQL\nSQL Server vs Oracle"]
    end
    
    subgraph "🔧 Practical"
        U["Error Handling\nExceptions, Rollback\nRecovery Patterns"]
        V["Data Migration\nBackup/Restore\nPITR, WAL"]
        W["ETL Processes\nData Import\nTransformation"]
        X["Testing & Automation\nUnit Tests, CI/CD\npgTAP, SQLTest"]
        Y["BI Integration\nMaterialized Views\nDashboards"]
    end
    
    subgraph "🏗️ Operations"
        Z["Security\nRBAC, Encryption\nAudit Logging"]
        AA["Partitioning\nSharding, Scaling\nPerformance"]
        BB["Monitoring\nMetrics, Alerts\nObservability"]
    end
    
    subgraph "🎓 Mastery"
        CC["Exercises\nPractice Problems\nReal Scenarios"]
        DD["Solutions\nCode Reviews\nBest Practices"]
    end
    
    A --> B
    B --> C
    C --> D
    D --> E
    E --> F
    F --> G
    G --> H
    
    H --> I
    H --> J
    I --> K
    J --> K
    K --> L
    L --> M
    M --> N

    N --> O
    N --> P
    O --> Q
    P --> Q
    Q --> R
    R --> S
    S --> T
    
    T --> U
    T --> V
    T --> W
    T --> X
    T --> Y
    
    Y --> Z
    Y --> AA
    Y --> BB
    
    BB --> CC
    CC --> DD
    
    EE["Prerequisites\nNone"] -.-> A
    FF["Time: 3-4 weeks\nPractice Required"] -.-> H
    GG["Time: 2-3 weeks\nDeep Understanding"] -.-> L
    HH["Time: 1-2 weeks\nAdvanced Concepts"] -.-> N
    II["Time: 2-4 weeks\nComplex Problems"] -.-> T
    JJ["Time: 1-2 weeks\nReal Projects"] -.-> Y
    KK["Time: 1 week\nProduction Ready"] -.-> BB
    LL["Time: Ongoing\nMastery"] -.-> DD
```

**Skill Development Matrix:**
```mermaid
graph LR
    subgraph "Beginner Skills"
        A1["Basic CRUD\nOperations"]
        A2["Simple Queries\nWHERE, ORDER BY"]
        A3["Table Design\nCREATE TABLE"]
        A4["Data Types\nBasic Types"]
    end
    
    subgraph "Intermediate Skills"
        B1["Complex JOINs\nMultiple Tables"]
        B2["Aggregations\nGROUP BY, HAVING"]
        B3["Subqueries\nNested Queries"]
        B4["Performance\nBasic Indexing"]
        B5["Transactions\nACID Properties"]
        B6["Normalization\n1NF, 2NF, 3NF"]
        B7["Database Design\nSchema Principles"]
    end
    
    subgraph "Advanced Skills"
        C1["Recursive Queries\nHierarchical Data"]
        C2["Window Functions\nAnalytical Queries"]
        C3["JSON Handling\nSemi-structured Data"]
        C4["Stored Procedures\nBusiness Logic"]
        C5["Query Optimization\nEXPLAIN Plans"]
        C6["Data Modeling\nERD, Relationships"]
        C7["Performance Tuning\nAdvanced Optimization"]
    end
    
    subgraph "Expert Skills"
        D1["Database Design\nNormalization"]
        D2["High Availability\nReplication, Clustering"]
        D3["Security\nRBAC, Encryption"]
        D4["Monitoring\nMetrics, Alerting"]
        D5["ETL Pipelines\nData Integration"]
        D6["Performance Tuning\nAdvanced Optimization"]
    end
    
    A1 --> B1
    A2 --> B2
    A3 --> B3
    A4 --> B4
    
    B1 --> C1
    B2 --> C2
    B3 --> C3
    B4 --> C4
    B5 --> C5
    B6 --> C6
    B7 --> C7
    
    C1 --> D1
    C2 --> D2
    C3 --> D3
    C4 --> D4
    C5 --> D5
    C5 --> D6
    
    E[Career Applications] -.-> F[Data Analyst]
    E -.-> G[Database Developer]
    E -.-> H[Data Engineer]
    E -.-> I[DBA/Architect]
    
    D1 -.-> F
    D1 -.-> G
    D2 -.-> H
    D3 -.-> I
    D4 -.-> I
    D5 -.-> H
    D6 -.-> G
    D6 -.-> I
```

---

## Part 1: Fundamentals
*The essential building blocks of SQL. Start here if you are new to databases.*

1.  **[Introduction and Basics](fundamentals/1-introduction-and-basics.md)**: What is a database? Basic `CREATE`, `INSERT`, `SELECT`, `UPDATE`, `DELETE`.
2.  **[JOINs](fundamentals/2-joins.md)**: Combining data from multiple tables.
3.  **[Aggregations and Grouping](fundamentals/3-aggregations-and-grouping.md)**: Summarizing data with `GROUP BY`, `COUNT`, `SUM`, etc.
4.  **[Subqueries and Set Operations](fundamentals/4-subqueries-and-sets.md)**: Nested queries and combining results with `UNION`.
5.  **[Conditional Logic](fundamentals/5-conditional-logic.md)**: Using the `CASE` statement.
6.  **[Indexing Basics](fundamentals/6-indexing-basics.md)**: A brief introduction to performance.
7.  **[Database Normalization](fundamentals/7-normalization.md)**: Reducing redundancy with 1NF, 2NF, and 3NF.
8.  **[Database Design Principles](fundamentals/8-database-design.md)**: Schema design and modeling best practices.

---

## Part 2: Core Theory
*A deeper dive into the concepts that power a relational database.*

1.  **[Relational Algebra](theory/1-relational-algebra.md)**: The mathematical foundation of SQL.
2.  **[Data Types](theory/2-data-types.md)**: A detailed look at data types.
3.  **[Query Plans & Cost Models](theory/3-query-plans-and-cost-models.md)**: How the database executes your queries.
4.  **[Transactions, Isolation & Concurrency](theory/4-transactions-isolation-and-concurrency.md)**: The principles of ACID and safe data handling.
5.  **[Data Modeling Techniques](theory/5-data-modeling.md)**: Creating effective ERDs and schemas.
6.  **[Performance Tuning](theory/6-performance-tuning.md)**: Optimizing queries and database configurations.

---

## Part 3: Advanced Techniques
*Powerful SQL features for complex problems.*

1.  **[Recursive CTEs & Hierarchies](advanced/1-recursive-ctes-and-hierarchies.md)**: Querying tree-like structures.
2.  **[Lateral Joins & JSON Functions](advanced/2-lateral-joins-and-json-functions.md)**: Advanced joins and handling `JSON` data.
3.  **[Temporal Tables & Change Data Capture](advanced/3-temporal-tables-and-change-data-capture.md)**: Tracking data history.
4.  **[Vendor Notes & Differences](advanced/4-vendor-notes.md)**: How syntax differs between PostgreSQL, MySQL, etc.
5.  **[Window Functions](advanced/5-window-functions.md)**: Powerful analytical functions like `RANK()` and `LAG()`.
6.  **[Views, Procedures, & Triggers](advanced/6-views-procedures-triggers.md)**: Reusing code and automating tasks.

---

## Part 4: Practical Guides & Operations
*Hands-on guides for common, real-world database tasks.*

- **Error Handling**: [Error Handling & Exceptions](practical/1-error-handling-and-exceptions.md)
- **Data Management**: [Data Migration, Backup & Restore](practical/2-data-migration-backup-restore.md)
- **ETL**: [Data Import & ETL](practical/3-data-import-and-etl.md)
- **Testing**: [SQL Testing & Automation](practical/4-sql-testing-and-automation.md)
- **BI**: [Visualization & BI Integration](practical/5-visualization-and-BI-integration.md)
- **Security**: [Advanced Security](ops/1-advanced-security.md)
- **Scaling**: [Partitioning & Sharding](ops/2-partitioning-and-sharding.md)
- **Monitoring**: [Monitoring & Observability](ops/3-monitoring-and-observability.md)

---

## Part 5: Exercises
*Practice your skills.*

- **[Exercises README](exercises/README.md)**: Introduction to the exercises.
- **[Solutions](exercises/solutions/)**: Solutions to the exercises.

---

## Part 6: Non-Relational Databases (NoSQL)
*Alternative database models for specific use cases.*

### Fundamentals
1.  **[NoSQL vs SQL Comparison](nosql/fundamentals/0-nosql-vs-sql-comparison.md)**: When to choose each approach
2.  **[CAP Theorem and Trade-offs](nosql/fundamentals/1-cap-theorem-and-tradeoffs.md)**: Distributed systems fundamentals
3.  **[Document Databases](nosql/fundamentals/2-document-databases.md)**: Flexible schema, JSON-like documents
4.  **[Key-Value Stores](nosql/fundamentals/3-key-value-stores.md)**: Fast key-based access, caching
5.  **[Column-Family Stores](nosql/fundamentals/4-column-family-stores.md)**: Wide-column storage, analytics
6.  **[Graph Databases](nosql/fundamentals/5-graph-databases.md)**: Relationship-focused data models

### Theory
1.  **[ACID vs BASE Consistency](nosql/theory/1.5-acid-vs-base-consistency.md)**: Consistency models explained
2.  **[NoSQL Data Modeling](nosql/theory/1.7-nosql-data-modeling.md)**: Schema design patterns
3.  **[NoSQL Data Modeling Patterns](nosql/theory/2-nosql-data-modeling-patterns.md)**: Advanced modeling approaches

### Practical Applications
- **Performance**: [NoSQL Performance and Optimization](nosql/practical/1-nosql-performance-optimization.md)
- **Operations**: [NoSQL Operations Best Practices](nosql/practical/2-nosql-operations-best-practices.md)

### Operations
- **Security**: Data security in NoSQL systems
- **Monitoring**: Monitoring and observability for NoSQL
- **Backup/Recovery**: Data protection strategies