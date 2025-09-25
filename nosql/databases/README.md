# NoSQL Databases

This folder contains hands-on tutorials for specific NoSQL database implementations. Each module teaches you how to work with a particular database, including installation, basic operations, and advanced features.

## 📚 Available Databases

### Document Databases
#### [2-mongodb-document-database.md](2-mongodb-document-database.md)
**Type:** Document Database | **Level:** Beginner to Intermediate | **Time:** 45 minutes

Comprehensive guide to MongoDB, the most popular document database. Covers:
- Document model and BSON format
- CRUD operations with MongoDB shell
- Query operators and logical expressions
- Aggregation framework for data processing
- Indexing strategies for performance
- Schema design patterns (embedding vs referencing)

**Best For:** Applications with flexible schemas, complex objects, and aggregation needs

### Key-Value Stores
#### [3-redis-key-value-store.md](3-redis-key-value-store.md)
**Type:** Key-Value Store | **Level:** Beginner to Intermediate | **Time:** 45 minutes

Complete introduction to Redis, the in-memory data structure store. Covers:
- Five core data types: strings, lists, sets, hashes, sorted sets
- Basic CRUD operations with redis-cli
- Memory management and persistence options
- Configuration for different use cases
- Common patterns: caching, counters, sessions

**Best For:** High-performance caching, real-time applications, and data structure operations

#### [4-redis-advanced-concepts.md](4-redis-advanced-concepts.md)
**Type:** Key-Value Store | **Level:** Intermediate to Advanced | **Time:** 40 minutes

Master Redis advanced features for production deployments. Covers:
- Publish/Subscribe messaging patterns
- Redis Cluster for high availability and sharding
- Persistence strategies (RDB vs AOF)
- Performance optimization and monitoring
- Security, authentication, and access control

**Best For:** Production Redis deployments, high-availability systems, and performance-critical applications

#### [5-redis-practical-applications.md](5-redis-practical-applications.md)
**Type:** Key-Value Store | **Level:** Intermediate | **Time:** 30 minutes

Real-world Redis implementations and integration patterns. Covers:
- User session management and authentication
- API rate limiting and abuse protection
- Job queues for background processing
- Real-time analytics and dashboards
- E-commerce integration and caching strategies

**Best For:** Building complete applications with Redis as a key component

### Planned Databases

#### Key-Value Stores
- **Riak**: Distributed key-value database
- **etcd**: Configuration and service discovery

#### Column-Family Stores
#### [6-cassandra-column-family.md](6-cassandra-column-family.md)
**Type:** Column-Family Database | **Level:** Intermediate | **Time:** 50 minutes

Complete guide to Apache Cassandra, the distributed column-family database. Covers:
- Distributed architecture with nodes, clusters, and datacenters
- Column-family data model and CQL (Cassandra Query Language)
- Primary key design and data distribution
- Replication strategies and consistency levels
- Data modeling patterns for different use cases

**Best For:** Large-scale distributed systems, time series data, and high-write workloads

#### [7-cassandra-operations.md](7-cassandra-operations.md)
**Type:** Column-Family Database | **Level:** Intermediate to Advanced | **Time:** 40 minutes

Master Cassandra cluster management and operations for production deployments. Covers:
- Cluster setup, configuration, and multi-node deployments
- Nodetool commands for monitoring and maintenance
- Replication, consistency, and repair operations
- Failure handling, scaling, and node management
- Backup, recovery, and troubleshooting techniques

**Best For:** Production Cassandra administration, cluster operations, and maintenance

#### [8-cassandra-performance-tuning.md](8-cassandra-performance-tuning.md)
**Type:** Column-Family Database | **Level:** Advanced | **Time:** 35 minutes

Advanced Cassandra performance optimization for high-throughput production systems. Covers:
- JVM and garbage collection tuning for different workloads
- Compaction strategy selection (STCS, LCS, TWCS) and configuration
- Caching strategies (key cache, row cache, counter cache)
- Query optimization and data model performance tuning
- Storage, disk, and network optimization techniques

**Best For:** Production performance optimization, capacity planning, and bottleneck resolution

#### Graph Databases
#### [9-neo4j-graph-database.md](9-neo4j-graph-database.md)
**Type:** Graph Database | **Level:** Intermediate | **Time:** 45 minutes

Complete introduction to Neo4j, the leading graph database using the property graph model. Covers:
- Property graph model with nodes, relationships, properties, and labels
- Cypher query language for pattern matching and graph traversals
- Data modeling patterns for social networks, e-commerce, and knowledge graphs
- Indexes, constraints, and basic graph algorithms
- When to choose graph databases over relational or other NoSQL databases

**Best For:** Connected data, relationship-heavy applications, and complex traversals

#### [10-neo4j-algorithms.md](10-neo4j-algorithms.md)
**Type:** Graph Database | **Level:** Intermediate to Advanced | **Time:** 40 minutes

Master graph algorithms in Neo4j for analyzing connected data and extracting insights. Covers:
- Path finding algorithms (Dijkstra, A*, k-shortest paths)
- Centrality measures (PageRank, betweenness, closeness, eigenvector)
- Community detection (Louvain, label propagation, connected components)
- Link prediction and similarity algorithms
- Real-world applications in social networks, recommendations, and fraud detection

**Best For:** Graph analytics, network analysis, and relationship-based insights

#### Time Series Databases
- **InfluxDB**: Time series data storage
- **TimescaleDB**: PostgreSQL time series extension
- **Prometheus**: Monitoring and metrics

#### Search Engines
- **Elasticsearch**: Distributed search and analytics
- **Solr**: Enterprise search platform

## 🎯 Learning Approach

### For Each Database, Learn:
1. **Installation & Setup**: Local development environment
2. **Basic Operations**: CRUD operations in the database's native language
3. **Query Patterns**: How to retrieve and manipulate data
4. **Indexing**: Performance optimization techniques
5. **Advanced Features**: Unique capabilities of each database
6. **Best Practices**: Production-ready patterns and anti-patterns

### Recommended Learning Order:
1. **Start with MongoDB** (document databases - most approachable)
2. **Redis** (key-value stores - simple but powerful)
3. **Cassandra** (column-family - distributed systems concepts)
4. **Neo4j** (graph databases - different data model)
5. **Specialized databases** based on your needs

## 📖 Prerequisites

- Completion of [fundamentals](../fundamentals/) and [theory](../theory/) modules
- Basic programming skills
- Understanding of data structures and algorithms

## 🛠️ Development Setup

Most NoSQL databases can be run locally using:
- **Docker**: Containerized installations
- **Package Managers**: apt, brew, chocolatey
- **Cloud Services**: AWS, GCP, Azure managed services
- **Local Installers**: Official distribution packages

## 🔗 Integration with Theory

Each database implementation demonstrates:
- **CAP Theorem**: How the database handles C/A/P trade-offs
- **Consistency Models**: ACID vs BASE in practice
- **Data Modeling**: Applying theoretical patterns to real databases
- **Performance**: Scaling characteristics and optimization

## 💡 Choosing Your First Database

### Start with MongoDB if you need:
- Flexible schemas that evolve over time
- Complex queries and aggregations
- JSON-like data structures
- Full-text search capabilities

### Start with Redis if you need:
- High-performance caching
- Simple key-value operations
- Pub/Sub messaging
- Data structure server

### Start with Cassandra if you need:
- Massive horizontal scaling
- High write throughput
- Multi-datacenter deployment
- Time series or IoT data

## 🚀 Hands-On Practice

Each database module includes:
- **Code Examples**: Working queries and operations
- **Exercises**: Easy/Medium/Hard practice problems
- **Best Practices**: Production-ready patterns
- **Common Pitfalls**: What to avoid

## 🔗 Next Steps

After learning specific databases:
- Explore [advanced topics](../advanced/) for scaling and performance
- Study [practical applications](../practical/) for real-world use cases
- Consider [hybrid architectures](../practical/) combining multiple databases