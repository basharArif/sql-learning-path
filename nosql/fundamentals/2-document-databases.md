# Document Databases

**Level:** Intermediate  
**Time Estimate:** 45 minutes  
**Prerequisites:** Basic understanding of NoSQL concepts, CAP theorem.

## TL;DR
Document databases store data in flexible, semi-structured documents (often JSON-like). They offer schema flexibility and are ideal for applications with evolving data structures where rigid schemas would be limiting.

## Learning Objectives
By the end of this lesson, you'll be able to:
- Understand the document data model and its characteristics
- Identify use cases appropriate for document databases
- Design document structures for different scenarios
- Compare document databases with other NoSQL types
- Understand query patterns in document databases

## Motivation & Real-World Scenario
A content management system needs to store articles, user profiles, and comments. Each has different attributes that change over time. A relational database would require complex schema changes and multiple tables. Document databases allow flexible schemas where each document can have different fields without requiring schema migrations.

## Theory: Document Data Model

### Core Concepts
Document databases store data in documents, which are self-contained units of information with flexible structure.

**Key Characteristics:**
- **Flexible Schema**: Each document can have different fields
- **Self-Contained**: Related data stored together in one document
- **Hierarchical**: Documents can contain nested objects and arrays
- **JSON-like**: Often use JSON, BSON, or similar formats

**Visual Representation:**
```
Document Database Structure:

Collection (similar to table)
├── Document 1:
│   { 
│     id: "123",
│     name: "John Doe",
│     addresses: [
│       {type: "home", street: "123 Main St"},
│       {type: "work", street: "456 Office Blvd"}
│     ],
│     preferences: {theme: "dark", lang: "en"}
│   }
├── Document 2:
│   {
│     id: "124", 
│     name: "Jane Smith",
│     addresses: [
│       {type: "home", street: "789 Oak Ave"}
│     ]
│     // Different structure from Document 1
│   }
└── ...
```

### Document Structure
Documents contain field-value pairs where values can be:
- Primitive types (strings, numbers, booleans)
- Nested documents
- Arrays of values or documents
- Special types (dates, binary data, object IDs)

### Collections
Collections are containers for documents, similar to tables in relational databases:
- No enforced schema (though some systems allow validation)
- Documents in a collection may have different structures
- Can have indexes for query optimization

## Worked Examples

### Example 1: E-commerce Product Catalog
**Relational approach** would require multiple tables: products, categories, product_attributes, inventory, etc.

**Document approach** keeps related data in one place:

```json
{
  "product_id": "PROD-123",
  "name": "Wireless Headphones",
  "category": "Electronics",
  "brand": "TechBrand",
  "price": 99.99,
  "specifications": {
    "color": "Black",
    "weight": "250g",
    "battery_life": "20 hours",
    "connectivity": "Bluetooth 5.0"
  },
  "inventory": {
    "in_stock": true,
    "quantity": 50,
    "warehouse_locations": ["NY", "CA", "TX"]
  },
  "reviews": [
    {
      "user_id": "USER-456",
      "rating": 5,
      "comment": "Great sound quality!",
      "date": "2024-01-15"
    }
  ]
}
```

### Example 2: User Profile with Preferences
```json
{
  "user_id": "USER-789",
  "personal_info": {
    "name": "Alice Johnson",
    "email": "alice@example.com",
    "phone": "+1-555-0123",
    "birth_date": "1990-05-15"
  },
  "preferences": {
    "theme": "dark",
    "language": "en",
    "notifications": {
      "email": true,
      "sms": false,
      "push": true
    }
  },
  "social_links": [
    {"platform": "linkedin", "url": "linkedin.com/in/alice"},
    {"platform": "twitter", "url": "twitter.com/alice"}
  ],
  "subscription": {
    "type": "premium",
    "start_date": "2024-01-01",
    "renewal_date": "2025-01-01"
  }
}
```

## Query Patterns

### 1. Document-Level Queries
Query entire documents based on specific field values:
```
Find all products in "Electronics" category
Find users with email domain "company.com"
```

### 2. Field-Based Queries
Query based on nested field values:
```
Find products with price < 100
Find users with theme preference = "dark"
```

### 3. Array Queries
Query array fields and elements:
```
Find products available in "NY" warehouse
Find users with Twitter social link
```

### 4. Complex Queries
Combine multiple conditions:
```
Find electronics products under $100 with free shipping
Find premium users with push notifications enabled
```

## Design Principles

### 1. Embedding vs Referencing
**Embedding**: Store related data within the same document
- Use when: Data is always accessed together, updates are atomic
- Example: User profile with addresses

**Referencing**: Store related data in separate documents
- Use when: Data is large or accessed independently
- Example: User with list of large order histories

### 2. Schema Design Considerations
- **Query-Driven Design**: Structure based on how data is accessed
- **Write Patterns**: Consider update frequency and atomicity needs
- **Read Patterns**: Optimize for common query patterns
- **Growth Patterns**: Plan for data growth and query evolution

## Advantages

1. **Schema Flexibility**: No fixed schema requirements
2. **Development Speed**: Faster iteration and feature releases
3. **Natural Mapping**: Maps well to object-oriented programming
4. **Aggregation**: Rich querying and document transformation capabilities
5. **Scalability**: Horizontal scaling with sharding support

## Disadvantages

1. **Data Duplication**: May require denormalization
2. **Complex Joins**: Limited support for complex relationships
3. **ACID Limitations**: Weaker transactional guarantees across documents
4. **Storage Overhead**: May use more storage due to duplication
5. **Query Complexity**: Complex queries can be performance intensive

## Use Cases

**Good for:**
- Content management systems
- User profiles and preferences
- Catalogs and inventories
- Real-time analytics
- IoT data storage
- Event logging and time-series data

**Not ideal for:**
- Complex relational data with many joins
- Systems requiring complex transactions across multiple entities
- Data warehousing and reporting
- Applications requiring strict ACID guarantees across entities

## Key Considerations

- **Data Access Patterns**: Design document structure around query patterns
- **Document Size Limits**: Most systems have document size caps
- **Indexing Strategy**: Plan indexes for efficient queries
- **Consistency Requirements**: Understand consistency models
- **Scaling Strategy**: Plan for horizontal or vertical scaling

## Quick Checklist / Cheatsheet

- **Use when**: Flexible schema and self-contained related data
- **Avoid when**: Complex multi-document transactions required
- **Design for**: How you'll query the data
- **Consider**: Document size limits and growth
- **Plan**: Indexes for common query patterns

## Exercises

1. **Easy**: Design a document structure for a blog post with metadata and comments.
2. **Medium**: Model an e-commerce order with line items, shipping, and payment info.
3. **Hard**: Design a flexible document schema for a multi-tenant SaaS application.

## Next Steps

- Learn about document database indexing strategies
- Study query optimization techniques
- Explore document database clustering and sharding
- Practice with different document database systems