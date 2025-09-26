# MongoDB Document Database Exercise

**Level:** Beginner to Intermediate  
**Time Estimate:** 25 minutes  
**Prerequisites:** MongoDB fundamentals, JSON, document modeling.

## Exercise: E-commerce Product Catalog Design

### Scenario
Design a MongoDB schema for an e-commerce platform with the following requirements:
- Products have varying attributes (electronics vs clothing)
- Products belong to categories and subcategories
- Products have reviews and ratings
- Products have inventory tracking
- Products have multiple images and specifications

### Tasks

1. **Document Design**
   - Design a product document schema
   - Include embedded vs referenced relationships
   - Handle variable product attributes
   - Consider query patterns

2. **Query Implementation**
   - Find all electronics products under $100
   - Get products with average rating > 4.0
   - Find products by category with pagination
   - Get product recommendations based on similar products

3. **Indexing Strategy**
   - Design indexes for common queries
   - Consider compound indexes
   - Plan for text search capabilities

4. **Aggregation Pipeline**
   - Calculate average rating per category
   - Find top-selling products by month
   - Generate product statistics report

### Sample Data Structure
```javascript
// Product document example
{
  _id: ObjectId("..."),
  name: "Gaming Laptop",
  category: "Electronics",
  subcategory: "Computers",
  price: 1299.99,
  specifications: {
    cpu: "Intel i7",
    ram: "16GB",
    storage: "512GB SSD"
  },
  images: ["laptop1.jpg", "laptop2.jpg"],
  reviews: [
    {
      user_id: ObjectId("..."),
      rating: 5,
      comment: "Great laptop!",
      date: ISODate("2024-01-15")
    }
  ],
  inventory: {
    in_stock: true,
    quantity: 25,
    warehouse: "NYC"
  },
  tags: ["gaming", "laptop", "high-performance"]
}
```

## Learning Objectives
- Design flexible document schemas
- Choose between embedding and referencing
- Create efficient queries and indexes
- Build aggregation pipelines
- Handle variable product attributes
