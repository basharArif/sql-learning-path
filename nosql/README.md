# Non-Relational Databases Learning Path

This section covers NoSQL and non-relational database systems, complementing the relational SQL learning path.

## 🎯 **Learning Focus**
**Concepts & Query Models Only** - This section teaches data models, query patterns, indexing, and trade-offs. We focus on **learning** not operations, administration, or deployment.

## 📚 Module Overview

### Foundational Concepts
- **[NoSQL vs SQL Comparison](fundamentals/0-nosql-vs-sql-comparison.md)**: When to choose each approach
- **[CAP Theorem and Trade-offs](fundamentals/1-cap-theorem-and-tradeoffs.md)**: Distributed systems fundamentals
- **[ACID vs BASE Consistency](theory/1.5-acid-vs-base-consistency.md)**: Consistency models explained
- **[NoSQL Data Modeling](theory/1.7-nosql-data-modeling.md)**: Schema design patterns

### Document Databases
- **[MongoDB: Document Database](databases/2-mongodb-document-database.md)**: JSON-like documents, flexible schemas

### Key-Value Stores
- **[Redis Fundamentals](databases/3-redis-key-value-store.md)**: In-memory data structures
- **[Redis Advanced](databases/4-redis-advanced-concepts.md)**: Pub/Sub, clustering concepts
- **[Redis Applications](databases/5-redis-practical-applications.md)**: Real-world patterns

### Column-Family Stores
- **[Cassandra: Column-Family](databases/6-cassandra-column-family.md)**: Wide-column store concepts

### Graph Databases
- **[Neo4j: Graph Database](databases/9-neo4j-graph-database.md)**: Property graph model

### Time Series Databases
- **InfluxDB**: Time series data storage
- **TimescaleDB**: PostgreSQL extension for time series
- **Prometheus**: Monitoring and time series

### Search Engines
- **Elasticsearch**: Distributed search and analytics
- **Solr**: Enterprise search platform

## 🎯 Learning Objectives

- Understand CAP theorem and database trade-offs
- Learn different data models (document, key-value, graph, etc.)
- Master query languages for each database type
- Design schemas for non-relational systems
- Implement data migration strategies
- Optimize performance and scaling

## 🚀 Getting Started

1. Start with [NoSQL vs SQL Comparison](fundamentals/0-nosql-vs-sql-comparison.md) to understand when to choose each approach
2. Review [CAP theorem concepts](fundamentals/1-cap-theorem-and-tradeoffs.md) for distributed systems fundamentals
3. Learn about [consistency models](theory/1.5-acid-vs-base-consistency.md) (ACID vs BASE)
4. Study [data modeling patterns](theory/1.7-nosql-data-modeling.md) for NoSQL schema design
5. Choose your first database based on use case
6. Set up local development environment
7. Practice basic CRUD operations
8. Learn indexing and query optimization

## 📖 Prerequisites

- Basic programming concepts
- Understanding of data structures
- Familiarity with JSON
- Basic command line usage

## 🔄 Integration with SQL Learning

This NoSQL section complements the relational database learning path. Many applications use both SQL and NoSQL databases together (polyglot persistence).

- SQL for: Complex queries, transactions, structured data
- NoSQL for: Flexible schemas, high scalability, specific data patterns