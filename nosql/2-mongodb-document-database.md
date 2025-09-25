# MongoDB: Document Database Fundamentals

## Introduction to MongoDB

MongoDB is a popular document database that stores data in flexible, JSON-like documents. Unlike relational databases, MongoDB doesn't require a fixed schema, making it ideal for applications with evolving data structures.

## Key Concepts

### Documents
- Basic unit of data in MongoDB
- Similar to JSON objects
- Can contain nested objects and arrays
- No fixed schema required

```javascript
// Example document
{
  "_id": ObjectId("507f1f77bcf86cd799439011"),
  "name": "John Doe",
  "email": "john@example.com",
  "address": {
    "street": "123 Main St",
    "city": "New York",
    "zip": "10001"
  },
  "tags": ["developer", "mongodb"],
  "created_at": ISODate("2023-01-01T00:00:00Z")
}
```

### Collections
- Groups of documents (similar to tables)
- Documents in same collection can have different structures
- No foreign key constraints

### Databases
- Container for collections
- Similar to relational database concept

## Basic Operations

### Create (Insert)
```javascript
// Insert one document
db.users.insertOne({
  name: "Jane Smith",
  email: "jane@example.com",
  age: 28
})

// Insert multiple documents
db.users.insertMany([
  { name: "Bob", age: 25 },
  { name: "Alice", age: 30 }
])
```

### Read (Find)
```javascript
// Find all documents
db.users.find()

// Find with conditions
db.users.find({ age: { $gte: 25 } })

// Find one document
db.users.findOne({ name: "Jane Smith" })

// Projection (select specific fields)
db.users.find({}, { name: 1, email: 1, _id: 0 })
```

### Update
```javascript
// Update one document
db.users.updateOne(
  { name: "Jane Smith" },
  { $set: { age: 29 } }
)

// Update multiple documents
db.users.updateMany(
  { age: { $lt: 30 } },
  { $set: { status: "young" } }
)

// Replace entire document
db.users.replaceOne(
  { name: "Jane Smith" },
  { name: "Jane Doe", email: "jane.doe@example.com" }
)
```

### Delete
```javascript
// Delete one document
db.users.deleteOne({ name: "Bob" })

// Delete multiple documents
db.users.deleteMany({ age: { $lt: 20 } })

// Delete all documents
db.users.deleteMany({})
```

## Query Operators

### Comparison Operators
- `$eq`: Equal to
- `$ne`: Not equal to
- `$gt`: Greater than
- `$gte`: Greater than or equal
- `$lt`: Less than
- `$lte`: Less than or equal
- `$in`: In array
- `$nin`: Not in array

### Logical Operators
- `$and`: Logical AND
- `$or`: Logical OR
- `$not`: Logical NOT
- `$nor`: Logical NOR

### Element Operators
- `$exists`: Check if field exists
- `$type`: Check field type

### Array Operators
- `$all`: Match all elements in array
- `$elemMatch`: Match elements in array
- `$size`: Match array size

## Indexing

### Create Index
```javascript
// Single field index
db.users.createIndex({ email: 1 })

// Compound index
db.users.createIndex({ name: 1, age: -1 })

// Text index
db.users.createIndex({ description: "text" })

// Unique index
db.users.createIndex({ email: 1 }, { unique: true })
```

### Index Types
- **Single Field**: Index on one field
- **Compound**: Index on multiple fields
- **Multikey**: Index on array fields
- **Text**: Full-text search
- **Geospatial**: Location-based queries
- **Hashed**: Hash-based sharding

## Aggregation Framework

MongoDB's aggregation pipeline processes data through multiple stages:

```javascript
db.orders.aggregate([
  // Stage 1: Filter documents
  { $match: { status: "completed" } },

  // Stage 2: Group by customer
  {
    $group: {
      _id: "$customer_id",
      total_amount: { $sum: "$amount" },
      order_count: { $sum: 1 }
    }
  },

  // Stage 3: Sort results
  { $sort: { total_amount: -1 } },

  // Stage 4: Limit results
  { $limit: 10 }
])
```

## Schema Design Patterns

### Embedded Documents
- Store related data together
- Good for one-to-one or one-to-few relationships
- Avoids joins but can lead to data duplication

### References
- Store related data in separate collections
- Use ObjectId references
- Similar to foreign keys in relational databases

### Bucket Pattern
- Group related data into "buckets"
- Useful for time-series or sequential data

## Best Practices

1. **Design for Query Patterns**: Structure data based on how you'll query it
2. **Use Appropriate Indexes**: Index fields used in queries and sorts
3. **Consider Document Size**: Keep documents under 16MB limit
4. **Plan for Growth**: Design for horizontal scaling
5. **Monitor Performance**: Use explain() to analyze queries

## Getting Started

1. Install MongoDB locally or use MongoDB Atlas
2. Connect using MongoDB Compass (GUI) or mongosh (CLI)
3. Create your first database and collection
4. Practice CRUD operations
5. Experiment with aggregation pipelines