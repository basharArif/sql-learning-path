# MongoDB: Document Database Fundamentals

**Level:** Beginner to Intermediate  
**Time Estimate:** 45 minutes  
**Prerequisites:** Basic programming concepts, JSON familiarity.

## TL;DR
MongoDB is a popular document database that stores data in flexible, JSON-like documents. Unlike relational databases, MongoDB doesn't require fixed schemas, making it ideal for applications with evolving data structures.

## Learning Objectives
By the end of this lesson, you'll be able to:
- Understand MongoDB's document model and key concepts
- Perform basic CRUD operations using MongoDB shell
- Use query operators and aggregation framework
- Design indexes for query optimization
- Apply schema design patterns for document databases

## Motivation & Real-World Scenario
Building a content management system where articles have varying structures (some with images, others with videos, different metadata fields). MongoDB's flexible schema allows you to store all article types in one collection without complex table alterations.

## Theory: MongoDB Document Model

### Documents
**Basic unit of data in MongoDB - similar to JSON objects**

```javascript
// Example user document
{
  "_id": ObjectId("507f1f77bcf86cd799439011"),
  "name": "John Doe",
  "email": "john@example.com",
  "age": 30,
  "address": {
    "street": "123 Main St",
    "city": "New York",
    "zip": "10001"
  },
  "tags": ["developer", "mongodb"],
  "created_at": ISODate("2023-01-01T00:00:00Z"),
  "is_active": true
}
```

**Document Structure Visualization:**
```mermaid
graph TD
    A[MongoDB Document] --> B[Document ID<br/>_id: ObjectId]
    A --> C[Scalar Fields<br/>name, email, age]
    A --> D[Nested Object<br/>address: {...}]
    A --> E[Array Field<br/>tags: [...]]
    A --> F[Date Field<br/>created_at: ISODate]
    A --> G[Boolean Field<br/>is_active: true]
    
    D --> D1[street: String]
    D --> D2[city: String]
    D --> D3[zip: String]
    
    E --> E1[developer]
    E --> E2[mongodb]
    
    style A fill:#e1f5fe
    style B fill:#c8e6c9
    style D fill:#fff3e0
    style E fill:#f3e5f5
```

**Key Characteristics:**
- **Flexible Schema**: Fields can vary between documents
- **Nested Objects**: Store complex data hierarchies
- **Arrays**: Support for lists and embedded documents
- **Rich Data Types**: Strings, numbers, dates, booleans, binary data

### Collections
**Groups of documents (similar to tables in relational databases)**

```javascript
// Users collection with varied document structures
db.users.insertMany([
  {
    name: "Alice",
    email: "alice@example.com",
    profile: { bio: "Software engineer", skills: ["JavaScript", "Python"] }
  },
  {
    name: "Bob",
    email: "bob@example.com",
    company: "Tech Corp",
    projects: [
      { name: "Project A", status: "completed" },
      { name: "Project B", status: "in-progress" }
    ]
  }
])
```

**Collection Structure Visualization:**
```mermaid
graph TD
    A[MongoDB Collection: users] --> B[Document 1<br/>Standard User]
    A --> C[Document 2<br/>User with Company]
    A --> D[Document 3<br/>User with Projects]
    
    B --> B1[name: Alice<br/>email: alice@email.com<br/>profile: {...}]
    C --> C1[name: Bob<br/>email: bob@email.com<br/>company: TechCorp<br/>projects: [...]]
    D --> D1[name: Charlie<br/>email: charlie@email.com<br/>projects: [...]<br/>skills: [...]]
    
    style A fill:#e1f5fe
    style B fill:#c8e6c9
    style C fill:#fff3e0
    style D fill:#f3e5f5
```

**Characteristics:**
- Documents in same collection can have different structures
- No foreign key constraints (relationships via embedding or references)
- Automatic creation when first document is inserted

### Databases
**Container for collections - similar to relational database concept**

```javascript
// Switch to or create database
use myapp

// Show current database
db

// List all databases
show dbs
```

## CRUD Operations

### Create (Insert)

**Insert Single Document:**
```javascript
db.users.insertOne({
  name: "Jane Smith",
  email: "jane@example.com",
  age: 28,
  department: "Engineering"
})
```

**Insert Multiple Documents:**
```javascript
db.users.insertMany([
  { name: "Alice", age: 25, department: "HR" },
  { name: "Bob", age: 30, department: "Engineering" },
  { name: "Charlie", age: 35, department: "Sales" }
])
```

### Read (Find)

**Find All Documents:**
```javascript
db.users.find()
```

**Find with Conditions:**
```javascript
// Exact match
db.users.find({ department: "Engineering" })

// Age greater than 25
db.users.find({ age: { $gt: 25 } })

// Multiple conditions (AND)
db.users.find({ department: "Engineering", age: { $gte: 30 } })
```

**Projection (Select Specific Fields):**
```javascript
// Include only name and email
db.users.find({}, { name: 1, email: 1 })

// Exclude age field
db.users.find({}, { age: 0 })

// Include name, exclude _id
db.users.find({}, { name: 1, _id: 0 })
```

### Update Operations

**Update Single Document:**
```javascript
// Update specific field
db.users.updateOne(
  { name: "Jane Smith" },
  { $set: { age: 29, title: "Senior Engineer" } }
)

// Replace entire document
db.users.replaceOne(
  { name: "Jane Smith" },
  {
    name: "Jane Doe",
    email: "jane.doe@example.com",
    age: 29,
    department: "Engineering"
  }
)
```

**Update Multiple Documents:**
```javascript
// Increment age for all Engineering department
db.users.updateMany(
  { department: "Engineering" },
  { $inc: { age: 1 } }
)

// Add new field to all documents
db.users.updateMany(
  {},
  { $set: { last_updated: new Date() } }
)
```

### Delete Operations

**Delete Single Document:**
```javascript
db.users.deleteOne({ name: "Bob" })
```

**Delete Multiple Documents:**
```javascript
// Delete all users in Sales department
db.users.deleteMany({ department: "Sales" })

// Delete all documents
db.users.deleteMany({})
```

## Query Operators

### Comparison Operators
```javascript
// Greater than
db.users.find({ age: { $gt: 25 } })

// Less than or equal
db.users.find({ age: { $lte: 30 } })

// In array
db.users.find({ department: { $in: ["Engineering", "HR"] } })

// Not equal
db.users.find({ department: { $ne: "Sales" } })
```

### Logical Operators
```javascript
// AND (implicit)
db.users.find({ department: "Engineering", age: { $gte: 25 } })

// OR
db.users.find({
  $or: [
    { department: "Engineering" },
    { age: { $gte: 35 } }
  ]
})

// NOR (neither condition)
db.users.find({
  $nor: [
    { department: "Engineering" },
    { age: { $lt: 25 } }
  ]
})
```

### Element Operators
```javascript
// Check if field exists
db.users.find({ title: { $exists: true } })

// Check field type
db.users.find({ age: { $type: "number" } })
```

### Array Operators
```javascript
// Documents with specific array element
db.users.find({ tags: "developer" })

// All elements match
db.users.find({ tags: { $all: ["javascript", "mongodb"] } })

// Array size
db.users.find({ tags: { $size: 3 } })
```

## Aggregation Framework

**MongoDB's powerful data processing pipeline**

```javascript
db.orders.aggregate([
  // Stage 1: Filter documents
  {
    $match: {
      status: "completed",
      total: { $gte: 100 }
    }
  },

  // Stage 2: Group by customer
  {
    $group: {
      _id: "$customer_id",
      total_orders: { $sum: 1 },
      total_revenue: { $sum: "$total" },
      avg_order: { $avg: "$total" }
    }
  },

  // Stage 3: Sort by revenue
  {
    $sort: { total_revenue: -1 }
  },

  // Stage 4: Limit results
  {
    $limit: 10
  },

  // Stage 5: Format output
  {
    $project: {
      customer_id: "$_id",
      total_orders: 1,
      total_revenue: 1,
      avg_order: 1,
      _id: 0
    }
  }
])
```

**Common Aggregation Stages:**
- `$match`: Filter documents
- `$group`: Group documents by key
- `$sort`: Sort documents
- `$limit`: Limit number of documents
- `$project`: Reshape documents
- `$unwind`: Deconstruct arrays

## Indexing for Performance

### Create Indexes
```javascript
// Single field index
db.users.createIndex({ email: 1 })

// Compound index
db.users.createIndex({ department: 1, age: -1 })

// Text index for full-text search
db.users.createIndex({ bio: "text" })

// Unique index
db.users.createIndex({ email: 1 }, { unique: true })

// Geospatial index
db.places.createIndex({ location: "2dsphere" })
```

### Index Types
- **Single Field**: Index on one field
- **Compound**: Multiple fields for complex queries
- **Multikey**: Arrays and embedded documents
- **Text**: Full-text search capabilities
- **Geospatial**: Location-based queries
- **Hashed**: Sharding support

### Index Best Practices
```javascript
// Check index usage
db.users.find({ department: "Engineering" }).explain("executionStats")

// View existing indexes
db.users.getIndexes()

// Drop unused index
db.users.dropIndex({ age: 1 })
```

## Schema Design Patterns

### Embedded Documents (One-to-One/Few)
**Store related data together - good for atomic operations**

```javascript
// User with embedded profile
{
  name: "John Doe",
  email: "john@example.com",
  profile: {
    bio: "Software engineer",
    avatar: "john.jpg",
    social_links: {
      twitter: "@johndoe",
      github: "johndoe"
    }
  }
}
```

**Advantages:**
- Atomic updates
- Single document retrieval
- No joins needed

### References (One-to-Many/Many-to-Many)
**Store relationships via ObjectIds**

```javascript
// User document
{
  _id: ObjectId("..."),
  name: "John Doe",
  posts: [
    ObjectId("post1"),
    ObjectId("post2")
  ]
}

// Post document
{
  _id: ObjectId("post1"),
  title: "MongoDB Guide",
  content: "...",
  author_id: ObjectId("...")
}
```

**Advantages:**
- Flexible relationships
- Avoids data duplication
- Smaller document sizes

### Bucket Pattern (Time-Series Data)
**Group related sequential data**

```javascript
// Sensor readings bucketed by hour
{
  sensor_id: "sensor001",
  timestamp_hour: ISODate("2023-01-01T10:00:00Z"),
  readings: [
    { timestamp: ISODate("2023-01-01T10:15:00Z"), value: 23.5 },
    { timestamp: ISODate("2023-01-01T10:30:00Z"), value: 24.1 },
    { timestamp: ISODate("2023-01-01T10:45:00Z"), value: 23.8 }
  ]
}
```

## Quick Checklist / Cheatsheet

**Basic Operations:**
- `db.collection.insertOne()` - Insert single document
- `db.collection.find()` - Query documents
- `db.collection.updateOne()` - Update single document
- `db.collection.deleteOne()` - Delete single document

**Query Operators:**
- `$gt`, `$lt`, `$gte`, `$lte` - Comparison
- `$in`, `$nin` - Array membership
- `$and`, `$or`, `$nor` - Logical
- `$exists`, `$type` - Element checks

**Aggregation Stages:**
- `$match` - Filter
- `$group` - Group by key
- `$sort` - Sort results
- `$project` - Reshape

**Indexing:**
- Single field: `{ field: 1 }`
- Compound: `{ field1: 1, field2: -1 }`
- Unique: `{ field: 1 }, { unique: true }`

## Exercises

1. **Easy**: Insert a document into a `products` collection with fields for name, price, and category. Then query for all products in the "Electronics" category.

2. **Medium**: Create an aggregation pipeline that groups users by department and calculates the average age for each department. Sort the results by average age descending.

3. **Hard**: Design a schema for a blog application with users, posts, and comments. Decide whether to embed or reference relationships, and explain your reasoning. Include appropriate indexes for common queries.