# Key-Value Stores

**Level:** Intermediate  
**Time Estimate:** 40 minutes  
**Prerequisites:** Basic understanding of NoSQL concepts, CAP theorem.

## TL;DR
Key-value stores are simple NoSQL databases that store data as key-value pairs. They provide extremely fast access to data based on keys and are ideal for caching, session storage, and simple data retrieval scenarios.

## Learning Objectives
By the end of this lesson, you'll be able to:
- Understand the key-value data model and its characteristics
- Identify appropriate use cases for key-value stores
- Design efficient key structures for different scenarios
- Compare key-value stores with other NoSQL types
- Understand performance implications and trade-offs

## Motivation & Real-World Scenario
A web application experiences slow response times due to frequent database queries for user sessions, shopping cart data, and frequently accessed content. A key-value store provides sub-millisecond access times for this data, dramatically improving performance while keeping the primary database free for complex operations.

## Theory: Key-Value Data Model

### Core Concepts
Key-value stores are the simplest form of NoSQL databases, storing data as pairs of keys and values.

**Key Characteristics:**
- **Simple Structure**: Data organized as key → value mappings
- **Fast Access**: O(1) average access time using hash tables
- **Flexible Values**: Values can be any data type or structure
- **No Relationships**: No concept of foreign keys or joins
- **Schema-Free**: No predefined structure requirements

**Visual Representation:**
```
Key-Value Store Structure:

┌─────────────┬─────────────────────────┐
│ Key         │ Value                   │
├─────────────┼─────────────────────────┤
│ user:123    │ {"name": "John", ...}   │
│ session:abc │ "user_id:123,exp:2024"  │
│ cart:456    │ ["item1", "item2", ...] │
│ config:app  │ {"theme": "dark", ...}  │
└─────────────┴─────────────────────────┘
```

### Key Design Considerations
Keys should be:
- **Unique**: Each key maps to one value
- **Descriptive**: Allow for logical grouping and retrieval
- **Consistent**: Follow predictable patterns
- **Efficient**: Not too long to impact performance

## Worked Examples

### Example 1: Session Storage
```bash
# Store user session with expiration
SET session:abc123 "{\"user_id\":1001,\"role\":\"admin\",\"permissions\":[\"read\",\"write\"]}" EX 3600

# Retrieve session data
GET session:abc123

# Delete session after logout
DEL session:abc123
```

### Example 2: Shopping Cart
```bash
# Add items to cart using hash structure
HSET cart:user:1001 item:prod123 2  # 2 of product 123
HSET cart:user:1001 item:prod456 1  # 1 of product 456

# Get entire cart
HGETALL cart:user:1001
```

### Example 3: Cache Implementation
```bash
# Cache expensive query result
SET cache:user_profile:1001 "{\"name\":\"John\",\"email\":\"john@example.com\",\"settings\":{...}}" EX 900

# Check cache first before DB query
# if EXISTS cache:user_profile:1001
#   GET cache:user_profile:1001
# else
#   query DB and SET cache
```

## Data Structure Patterns

### 1. Simple Values
- **Use Case**: Caching, configuration settings
- **Example**: `user:last_login:123` → "2024-01-15T10:30:00Z"

### 2. Complex Values
- **Use Case**: User profiles, session data
- **Example**: `user:profile:123` → `{"name":"John","preferences":{"lang":"en"}}`

### 3. Expiring Values
- **Use Case**: Session data, temporary caches
- **Example**: `verification_token:xyz` → `{"user_id":123,"expiry":1234567890}`

### 4. Counters
- **Use Case**: Page views, hit counts
- **Example**: `page:views:homepage` → `123456` (using INCR/DECR operations)

## Design Patterns

### 1. Namespace Pattern
Use prefixes to group related keys:
```
session:user:123
session:user:456
user:profile:123
user:settings:123
```

### 2. Hash Pattern
For related data that should be retrieved together:
```
user:12345 → {
  name: "John",
  email: "john@example.com",
  preferences: {theme: "dark", lang: "en"}
}
```

### 3. Set Pattern
For collections that need fast membership operations:
```
user:123:friends → SET of user IDs
user:123:blocked → SET of user IDs
```

### 4. List Pattern
For ordered collections like queues or timelines:
```
user:123:notifications → LIST of notification IDs
queue:email_processing → LIST of emails to send
```

## Performance Characteristics

### Speed Advantages
- **O(1) Access**: Hash table lookup for key-based retrieval
- **Memory Optimization**: Often kept in memory for speed
- **Simple Operations**: Minimal processing overhead

### Scalability Considerations
- **Horizontal Scaling**: Partitioning based on key distribution
- **Consistency Models**: Trade consistency for availability/performance
- **Memory Usage**: Consider value size and total dataset size

## Advantages

1. **Speed**: Extremely fast read/write operations
2. **Scalability**: Easy horizontal scaling
3. **Simplicity**: Simple mental model and implementation
4. **Flexibility**: Store any data structure as value
5. **Caching**: Excellent for caching layers
6. **Distributed**: Designed for distributed environments

## Disadvantages

1. **No Relationships**: Cannot query relationships between data
2. **Limited Queries**: No complex query capabilities (no JOINs, no complex WHERE clauses)
3. **No Schema**: No data validation or structure enforcement
4. **Memory Dependent**: Performance relies heavily on memory availability
5. **No ACID**: Limited transactional capabilities

## Use Cases

**Good for:**
- Application caching
- Session storage
- Shopping carts
- User preferences
- Feature flag configuration
- Real-time analytics
- Counters and metrics
- Queue systems

**Not ideal for:**
- Complex queries requiring relationships
- Data with complex interdependencies
- Systems requiring complex transactions
- Reporting and analytics requiring joins
- When data relationships are crucial

## Key Considerations

- **Data Size**: Consider memory and network limitations for large values
- **Eviction Policies**: Plan for memory management and data expiration
- **Consistency**: Understand the consistency model of your key-value store
- **Partitioning**: Design keys for even distribution across nodes
- **Backup/Recovery**: Plan for data persistence if needed

## Quick Checklist / Cheatsheet

- **Use when**: Fast, simple key-based access is needed
- **Avoid when**: Complex queries or relationships are required
- **Plan for**: Memory capacity and data expiration
- **Design keys**: For logical grouping and retrieval
- **Consider**: Persistence requirements

## Exercises

1. **Easy**: Design key patterns for user session management.
2. **Medium**: Create a key-value schema for a URL shortening service.
3. **Hard**: Design a distributed caching layer for a database.

## Next Steps

- Learn about distributed key-value store architectures
- Study consistency and availability trade-offs
- Explore advanced data structures (sets, lists, sorted sets)
- Practice with different key-value store implementations