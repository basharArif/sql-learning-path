-- MongoDB Document Database Exercise - Solution
-- Note: This is a MongoDB exercise, so solutions use MongoDB query syntax

-- 1. Document Design - Creating the collection with validation
db.createCollection("products", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["name", "category", "price", "inventory"],
      properties: {
        name: { bsonType: "string", description: "Product name is required" },
        category: { bsonType: "string", description: "Product category is required" },
        price: { bsonType: "number", minimum: 0, description: "Price must be a positive number" },
        inventory: {
          bsonType: "object",
          required: ["quantity"],
          properties: {
            quantity: { bsonType: "int", minimum: 0 }
          }
        }
      }
    }
  }
})

-- 2. Sample data insertion
db.products.insertMany([
  {
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
        user_id: ObjectId("507f1f77bcf86cd799439011"),
        rating: 5,
        comment: "Great laptop!",
        date: new Date("2024-01-15")
      }
    ],
    inventory: {
      in_stock: true,
      quantity: 25,
      warehouse: "NYC"
    },
    tags: ["gaming", "laptop", "high-performance"]
  },
  {
    name: "Cotton T-Shirt",
    category: "Clothing",
    subcategory: "Shirts",
    price: 19.99,
    specifications: {
      material: "100% Cotton",
      size: "M",
      color: "Blue"
    },
    images: ["tshirt1.jpg"],
    reviews: [
      {
        user_id: ObjectId("507f1f77bcf86cd799439012"),
        rating: 4,
        comment: "Good quality",
        date: new Date("2024-01-16")
      }
    ],
    inventory: {
      in_stock: true,
      quantity: 100,
      warehouse: "LA"
    },
    tags: ["cotton", "casual", "tshirt"]
  }
])

-- 3. Query Implementation
-- Find all electronics products under $100
db.products.find({
  category: "Electronics",
  price: { $lt: 100 }
})

-- Get products with average rating > 4.0
db.products.aggregate([
  {
    $addFields: {
      avgRating: {
        $avg: "$reviews.rating"
      }
    }
  },
  {
    $match: {
      avgRating: { $gt: 4.0 }
    }
  }
])

-- Find products by category with pagination
db.products.find({ category: "Electronics" })
  .skip(10)
  .limit(20)

-- Get product recommendations based on similar products
db.products.aggregate([
  {
    $match: { _id: ObjectId("...") } // specific product ID
  },
  {
    $lookup: {
      from: "products",
      localField: "tags",
      foreignField: "tags",
      as: "similar_products"
    }
  },
  {
    $unwind: "$similar_products"
  },
  {
    $match: {
      "similar_products._id": { $ne: "$_id" }
    }
  }
])

-- 4. Indexing Strategy
-- Single field indexes
db.products.createIndex({ category: 1 })
db.products.createIndex({ price: 1 })
db.products.createIndex({ "inventory.quantity": 1 })

-- Compound indexes
db.products.createIndex({ category: 1, price: 1 })

-- Text search index
db.products.createIndex({ name: "text", tags: "text" })

-- 5. Aggregation Pipeline
-- Calculate average rating per category
db.products.aggregate([
  {
    $addFields: {
      avgRating: {
        $avg: "$reviews.rating"
      }
    }
  },
  {
    $group: {
      _id: "$category",
      avgRating: { $avg: "$avgRating" },
      productCount: { $sum: 1 }
    }
  }
])

-- Find top-selling products by month (requires sales data)
db.products.aggregate([
  {
    $lookup: {
      from: "sales",
      localField: "_id",
      foreignField: "product_id",
      as: "sales_data"
    }
  },
  {
    $unwind: "$sales_data"
  },
  {
    $addFields: {
      saleMonth: { $month: "$sales_data.date" },
      saleYear: { $year: "$sales_data.date" }
    }
  },
  {
    $group: {
      _id: {
        product_id: "$_id",
        month: "$saleMonth",
        year: "$saleYear"
      },
      totalSold: { $sum: "$sales_data.quantity" },
      productName: { $first: "$name" }
    }
  },
  {
    $sort: { totalSold: -1 }
  }
])

-- Generate product statistics report
db.products.aggregate([
  {
    $group: {
      _id: "$category",
      avgPrice: { $avg: "$price" },
      minPrice: { $min: "$price" },
      maxPrice: { $max: "$price" },
      totalProducts: { $sum: 1 },
      avgQuantity: { $avg: "$inventory.quantity" }
    }
  }
])
</content>