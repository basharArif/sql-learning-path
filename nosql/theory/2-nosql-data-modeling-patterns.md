# NoSQL Data Modeling Patterns

**Level:** Advanced  
**Time Estimate:** 60 minutes  
**Prerequisites:** Understanding of different NoSQL database types, CAP theorem, distributed systems.

## TL;DR
NoSQL data modeling differs significantly from relational modeling. It focuses on query patterns, data access patterns, and denormalization rather than normalization. Success requires understanding the specific database type and optimizing for read/write patterns.

## Learning Objectives
By the end of this lesson, you'll be able to:
- Apply different data modeling patterns for various NoSQL types
- Design models optimized for specific query patterns
- Understand trade-offs between consistency, availability, and performance
- Model complex relationships in NoSQL systems
- Choose appropriate modeling approaches for different use cases

## Motivation & Real-World Scenario
An e-commerce company needs to handle high-volume product catalog queries, personalized recommendations, user session management, and real-time analytics. Each requirement has different access patterns and performance needs. A single model won't work optimally for all scenarios, requiring specialized models for different database types based on access patterns.

## Theory: NoSQL Modeling Approaches

### 1. Query-First Design Philosophy
Unlike relational databases where you model based on entities and relationships, NoSQL modeling starts with how data will be accessed.

```
Traditional (Relational) Approach:
Entities → Relationships → Tables → Queries

NoSQL Approach:
Queries → Access Patterns → Data Model → Implementation
```

### 2. Denormalization in NoSQL
NoSQL databases optimize for read performance by storing related data together, accepting data duplication where necessary.

**Visual Representation:**
```
Relational (Normalized):
Users table: [user_id, name, email]
Profiles table: [user_id, bio, avatar]
Preferences table: [user_id, theme, lang]

NoSQL (Denormalized):
User document:
{
  user_id: 123,
  name: "John",
  email: "john@example.com",
  bio: "Software engineer",
  avatar: "pic.jpg",
  theme: "dark",
  lang: "en"
}
```

## Worked Examples

### Example 1: E-commerce Product Catalog (Document DB)
**Query Pattern**: Fetch product with all details for display

**Relational Model**:
- Products table
- Categories table  
- Reviews table
- Inventory table
- Specifications table

**Document Model**:
```json
{
  "product_id": "PROD-123",
  "name": "Wireless Headphones",
  "category": "Electronics",
  "price": 99.99,
  "specifications": {
    "brand": "TechBrand",
    "color": "Black", 
    "weight": "250g"
  },
  "inventory": {
    "in_stock": true,
    "quantity": 50
  },
  "reviews": [
    {
      "user_id": "U-456",
      "rating": 5,
      "comment": "Great quality!",
      "date": "2024-01-15"
    }
  ]
}
```

### Example 2: User Session Management (Key-Value Store)
**Query Pattern**: Fast read/write of session data

**Model**:
```
Key: session:{session_id}
Value: {
  user_id: "U-123", 
  permissions: ["read", "write"],
  last_access: "2024-01-15T10:30:00Z",
  ip_address: "192.168.1.100"
}
TTL: 3600 seconds (1 hour)
```

### Example 3: Social Network (Graph DB)
**Query Pattern**: Find friends of friends, recommend connections

**Model**:
```
Nodes:
- User(id, name, location)
- Interest(name, category)

Relationships:  
- FRIEND_OF(since, strength)
- INTERESTED_IN(level)
- WORKS_AT(company, since)
```

### Example 4: Time-Series Analytics (Column-Family DB)
**Query Pattern**: Analyze user activity over time

**Model**:
```
Column Family: user_activity
Row Key: user_id:YYYYMMDD
Columns:
  HHMMSSmmm: activity_type
  (e.g., "103015001": "login", "103245234": "view_product")
```

## Data Modeling Patterns

### 1. Document Aggregation Pattern
**Use Case**: Store related data together to minimize queries
**Implementation**: Embed related entities in the main document

```json
// Blog post with comments embedded
{
  "post_id": "POST-123",
  "title": "NoSQL Introduction",
  "author": "John Doe",
  "content": "...",
  "comments": [
    {
      "user": "Jane", 
      "text": "Great article!",
      "timestamp": "2024-01-15T10:00:00Z"
    }
  ]
}
```

### 2. Reference Pattern
**Use Case**: Share data across documents, avoid duplication
**Implementation**: Store document IDs that reference other documents

```json
// Blog post with user reference
{
  "post_id": "POST-123",
  "title": "NoSQL Introduction", 
  "author_id": "USER-456",  // Reference to user document
  "content": "..."
}
```

### 3. Bucket Pattern
**Use Case**: Distribute large numbers of small items across documents
**Implementation**: Group related items into "buckets"

```json
// Shopping cart bucket for multiple small items
{
  "bucket_id": "cart_2024_01_15_001",
  "items": [
    {"product_id": "PROD-1", "qty": 2},
    {"product_id": "PROD-2", "qty": 1}
  ],
  "user_id": "USER-123"
}
```

### 4. Attribute Pattern
**Use Case**: Store variable attributes efficiently
**Implementation**: Use flexible structures for varying properties

```json
// Product with variable attributes
{
  "product_id": "PROD-123",
  "name": "Laptop",
  "category": "Electronics",
  "attributes": {
    "screen_size": "15.6 inches",
    "cpu": "Intel i7",
    "ram": "16GB",
    "storage": "512GB SSD"
  }
}
```

### 5. Computed Pattern
**Use Case**: Pre-compute expensive calculations
**Implementation**: Store results of aggregations/computations

```json
// User with pre-computed metrics
{
  "user_id": "USER-123",
  "name": "John",
  "stats": {
    "total_orders": 45,
    "total_spent": 2345.67,
    "preferred_category": "Electronics",
    "avg_rating": 4.3
  }
}
```

## Modeling by Database Type

### Document Databases
- **Embedding**: Store related data within documents
- **Referencing**: Use IDs for shared data
- **Schema flexibility**: Design for query patterns
- **Document size**: Consider maximum document size limits

### Key-Value Stores
- **Key design**: Create meaningful, predictable keys
- **Value structure**: Plan for how values will be accessed
- **Namespace strategy**: Group related keys with prefixes
- **TTL management**: Plan for data expiration

### Column-Family Stores
- **Row key design**: Optimize for access patterns
- **Column families**: Group related columns
- **Time-series optimization**: Include time in keys
- **Wide row design**: Plan for very wide rows if needed

### Graph Databases
- **Node granularity**: Balance between too fine vs. too coarse
- **Relationship semantics**: Choose meaningful relationship types
- **Label strategy**: Use labels for categorization
- **Index planning**: Plan for index usage on properties

## Advanced Modeling Concepts

### 1. Polyglot Persistence
Using multiple database types for different aspects of an application:

```
Web Application Data Architecture:
- Relational DB: Financial transactions (ACID required)
- Document DB: User profiles, content management
- Key-Value Store: Session management, caching
- Graph DB: Social connections, recommendations  
- Column-Family DB: Analytics, event logging
```

### 2. Eventual Consistency Handling
- **Read Repair**: Detect and fix inconsistencies on read
- **Hinted Handoff**: Temporarily store data when nodes unavailable
- **Quorum Reads/Writes**: Balance consistency and availability
- **Conflict Resolution**: Handle data conflicts in distributed systems

### 3. Schema Evolution
- **Backward Compatibility**: New code works with old data
- **Forward Compatibility**: Old code works with new data
- **Migration Strategies**: Plan for data transformation
- **Versioning**: Track schema changes

## Anti-Patterns to Avoid

### 1. Relational Thinking in NoSQL
- Trying to model like a relational database
- Using joins where not supported
- Focusing on normalization over query optimization

### 2. Poor Key Design (Key-Value)
- Sequential keys causing hotspots
- Keys that are too long
- Inconsistent naming conventions

### 3. Ignoring Data Size Limits
- Large documents exceeding limits
- Wide rows in column-family stores
- Deeply nested structures

### 4. Lack of Query Planning
- Modeling without considering access patterns
- Not optimizing for the most frequent queries
- Failing to consider future query needs

## Performance Optimization

### 1. Read Optimization
- Denormalize for common read patterns
- Pre-compute expensive operations
- Use appropriate indexing strategies

### 2. Write Optimization  
- Batch write operations
- Optimize for sequential writes where possible
- Consider write amplification

### 3. Storage Optimization
- Compress where possible
- Remove unnecessary data
- Use appropriate data types

## Quick Checklist / Cheatsheet

- **Start with queries**: Model around access patterns
- **Denormalize freely**: Prioritize read performance
- **Plan for growth**: Consider how data will scale
- **Test patterns**: Verify performance with real data
- **Consider consistency**: Choose appropriate consistency model
- **Multiple models**: Different models for different use cases

## Exercises

1. **Easy**: Design a document model for a simple blog system.
2. **Medium**: Create a data model for a social media feed using appropriate NoSQL approach.
3. **Hard**: Design a polyglot persistence architecture for a large e-commerce platform.

## Next Steps

- Explore specific database implementations
- Study performance testing strategies
- Learn distributed system patterns
- Practice with real-world datasets