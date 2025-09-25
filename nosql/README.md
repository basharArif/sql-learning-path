# Non-Relational Databases Learning Path

This section covers NoSQL and non-relational database systems, complementing the relational SQL learning path.

## 📚 Module Overview

### Foundational Concepts
- **[NoSQL vs SQL Comparison](0-nosql-vs-sql-comparison.md)**: When to choose each approach
- **[CAP Theorem and Trade-offs](1-cap-theorem-and-tradeoffs.md)**: Distributed systems fundamentals
- **[ACID vs BASE Consistency](1.5-acid-vs-base-consistency.md)**: Consistency models explained
- **[NoSQL Data Modeling](1.7-nosql-data-modeling.md)**: Schema design patterns

### Document Databases
- **[MongoDB: Document Database](2-mongodb-document-database.md)**: JSON-like documents, flexible schemas
- **CouchDB**: RESTful document storage
- **DynamoDB**: AWS managed NoSQL database

### Key-Value Stores
- **Redis**: In-memory data structure store
- **Riak**: Distributed key-value store
- **etcd**: Distributed key-value store for configuration

### Column-Family Stores
- **Cassandra**: Wide-column store for big data
- **HBase**: Hadoop ecosystem column store
- **ScyllaDB**: High-performance Cassandra-compatible

### Graph Databases
- **Neo4j**: Property graph database
- **ArangoDB**: Multi-model database
- **Amazon Neptune**: Managed graph database

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

1. Start with [NoSQL vs SQL Comparison](0-nosql-vs-sql-comparison.md) to understand when to choose each approach
2. Review [CAP theorem concepts](1-cap-theorem-and-tradeoffs.md) for distributed systems fundamentals
3. Learn about [consistency models](1.5-acid-vs-base-consistency.md) (ACID vs BASE)
4. Study [data modeling patterns](1.7-nosql-data-modeling.md) for NoSQL schema design
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