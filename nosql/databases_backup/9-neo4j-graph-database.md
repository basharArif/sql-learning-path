# 9. Neo4j - Graph Database Fundamentals

## 🎯 **TL;DR**
Neo4j is a native graph database that uses property graph model to represent and store data relationships. It excels at handling connected data and complex traversals with the Cypher query language.

## 📋 **Learning Objectives**
By the end of this module, you'll be able to:
- Understand the property graph model and its components
- Create and query graph data using Cypher
- Design graph schemas for different use cases
- Implement basic graph traversals and pattern matching
- Choose when to use graph databases over relational databases

## 🕸️ **Property Graph Model**

Neo4j uses the property graph model, which consists of nodes, relationships, properties, and labels.

```mermaid
graph TD
    subgraph "Property Graph Model"
        A[Node<br/>Person<br/>name: "Alice"<br/>age: 30] --> B[Relationship<br/>KNOWS<br/>since: 2015]
        B --> C[Node<br/>Person<br/>name: "Bob"<br/>age: 28]
        A --> D[Relationship<br/>WORKS_AT<br/>role: "Engineer"]
        D --> E[Node<br/>Company<br/>name: "TechCorp"<br/>industry: "Software"]
    end

    style A fill:#e1f5fe
    style C fill:#e1f5fe
    style E fill:#fff3e0
```

### **Core Components**

#### **1. Nodes**
Nodes are the primary elements in a graph, representing entities or objects.

```cypher
// Create nodes with labels and properties
CREATE (p:Person {name: "Alice", age: 30, city: "New York"})
CREATE (c:Company {name: "TechCorp", industry: "Software", founded: 2010})

// Create nodes without properties
CREATE (p:Person)
```

#### **2. Relationships**
Relationships connect nodes and can have direction, type, and properties.

```cypher
// Create relationships between existing nodes
MATCH (p:Person {name: "Alice"}), (c:Company {name: "TechCorp"})
CREATE (p)-[:WORKS_AT {role: "Senior Engineer", since: 2020}]->(c)

// Create relationship with properties
CREATE (p1:Person {name: "Alice"})-[:FRIENDS_WITH {since: 2018, closeness: "best"}]->(p2:Person {name: "Bob"})
```

#### **3. Properties**
Key-value pairs that store data on nodes and relationships.

```cypher
// Properties on nodes
CREATE (p:Person {
  name: "Charlie",
  age: 35,
  skills: ["Java", "Python", "GraphQL"],
  address: {
    street: "123 Main St",
    city: "San Francisco",
    zip: "94102"
  }
})

// Properties on relationships
CREATE (p:Person {name: "Alice"})-[:RATED {stars: 5, review: "Excellent product!", date: date("2024-01-15")}]->(prod:Product {name: "Laptop"})
```

#### **4. Labels**
Labels categorize nodes and enable indexing and querying.

```cypher
// Multiple labels on a node
CREATE (u:User:Admin {name: "Admin User", permissions: ["read", "write", "delete"]})

// Query by label
MATCH (u:User) RETURN u.name
MATCH (a:Admin) RETURN a.name
```

## 🔍 **Cypher Query Language**

Cypher is Neo4j's declarative query language for graphs, inspired by SQL but designed for graph patterns.

### **Basic Queries**

#### **CREATE - Creating Data**
```cypher
// Create single node
CREATE (p:Person {name: "David", age: 25})

// Create relationship between existing nodes
MATCH (p:Person {name: "Alice"}), (c:Company {name: "TechCorp"})
CREATE (p)-[:WORKS_AT {role: "Manager"}]->(c)

// Create path (nodes and relationships together)
CREATE (p:Person {name: "Eve"})-[:FOLLOWS]->(p2:Person {name: "Frank"})
```

#### **MATCH - Finding Data**
```cypher
// Find all nodes with a label
MATCH (p:Person) RETURN p

// Find specific node by property
MATCH (p:Person {name: "Alice"}) RETURN p

// Find relationships
MATCH (p:Person)-[r:WORKS_AT]->(c:Company)
RETURN p.name, r.role, c.name

// Find paths of specific length
MATCH (p:Person)-[:FRIENDS_WITH*2]->(friend:Person)
RETURN p.name, friend.name
```

#### **RETURN - Specifying Results**
```cypher
// Return properties
MATCH (p:Person) RETURN p.name, p.age

// Return entire nodes/relationships
MATCH (p:Person)-[r:WORKS_AT]->(c:Company)
RETURN p, r, c

// Return distinct values
MATCH (p:Person) RETURN DISTINCT p.city

// Limit results
MATCH (p:Person) RETURN p.name LIMIT 10
```

#### **WHERE - Filtering**
```cypher
// Property filters
MATCH (p:Person) WHERE p.age > 25 RETURN p.name, p.age

// Relationship type filters
MATCH (p:Person)-[r]->(c:Company)
WHERE type(r) = "WORKS_AT" AND r.since > 2020
RETURN p.name, r.role

// Pattern filters
MATCH (p:Person)-[:FRIENDS_WITH]->(friend:Person)
WHERE p.city = friend.city
RETURN p.name, friend.name

// Complex conditions
MATCH (p:Person)
WHERE p.age >= 20 AND p.age <= 35 AND p.city IN ["New York", "San Francisco"]
RETURN p
```

### **Advanced Patterns**

#### **Variable Length Paths**
```cypher
// Find friends of friends (2nd degree connections)
MATCH (p:Person)-[:FRIENDS_WITH*2]->(friend:Person)
WHERE p.name = "Alice"
RETURN friend.name

// Find paths of length 1 to 3
MATCH (p:Person)-[:FRIENDS_WITH*1..3]->(friend:Person)
WHERE p.name = "Alice"
RETURN friend.name, length(path) as distance

// Shortest path
MATCH path = shortestPath((p1:Person)-[*]-(p2:Person))
WHERE p1.name = "Alice" AND p2.name = "Charlie"
RETURN path
```

#### **OPTIONAL MATCH**
```cypher
// Find people and their companies (if they work)
MATCH (p:Person)
OPTIONAL MATCH (p)-[r:WORKS_AT]->(c:Company)
RETURN p.name, c.name, r.role

// Compare with required relationship
MATCH (p:Person)-[r:WORKS_AT]->(c:Company)
RETURN p.name, c.name, r.role
```

#### **UNION**
```cypher
// Combine results from different patterns
MATCH (p:Person)-[:WORKS_AT]->(c:Company)
RETURN p.name as name, "Employee" as type
UNION
MATCH (c:Company)<-[:OWNS]-(p:Person)
RETURN p.name as name, "Owner" as type
```

## 📊 **Graph Traversal & Algorithms**

### **Basic Traversals**
```cypher
// Depth-first traversal (following relationships)
MATCH (start:Person {name: "Alice"})-[:FRIENDS_WITH*]->(friend:Person)
RETURN friend.name

// Breadth-first with level information
MATCH path = (start:Person {name: "Alice"})-[:FRIENDS_WITH*1..3]->(friend:Person)
RETURN friend.name, length(path) as distance
ORDER BY distance

// Find mutual friends
MATCH (p1:Person {name: "Alice"})-[:FRIENDS_WITH]->(mutual:Person)<-[:FRIENDS_WITH]-(p2:Person {name: "Bob"})
WHERE p1 <> p2
RETURN mutual.name
```

### **Graph Algorithms**

#### **Centrality Measures**
```cypher
// Degree centrality (number of connections)
MATCH (p:Person)-[r:FRIENDS_WITH]-()
RETURN p.name, count(r) as degree
ORDER BY degree DESC

// Betweenness centrality (using APOC)
CALL algo.betweenness.stream('Person', 'FRIENDS_WITH')
YIELD nodeId, centrality
RETURN algo.getNodeById(nodeId).name as name, centrality
ORDER BY centrality DESC
```

#### **Community Detection**
```cypher
// Connected components
CALL algo.unionFind.stream('Person', 'FRIENDS_WITH')
YIELD nodeId, setId
RETURN setId, collect(algo.getNodeById(nodeId).name) as community
ORDER BY size(community) DESC

// Triangle counting
CALL algo.triangleCount.stream('Person', 'FRIENDS_WITH')
YIELD nodeId, triangles
RETURN algo.getNodeById(nodeId).name as name, triangles
ORDER BY triangles DESC
```

## 🏗️ **Data Modeling Patterns**

### **Social Network Model**
```cypher
// Create users
CREATE (u1:User {id: 1, name: "Alice", email: "alice@example.com"})
CREATE (u2:User {id: 2, name: "Bob", email: "bob@example.com"})
CREATE (u3:User {id: 3, name: "Charlie", email: "charlie@example.com"})

// Create friendships
CREATE (u1)-[:FRIENDS_WITH {since: 2018}]->(u2)
CREATE (u2)-[:FRIENDS_WITH {since: 2019}]->(u3)
CREATE (u1)-[:FRIENDS_WITH {since: 2020}]->(u3)

// Create posts
CREATE (p1:Post {id: 1, content: "Hello world!", created: datetime()})
CREATE (p2:Post {id: 2, content: "Graph databases are awesome!", created: datetime()})

// Connect users to posts
CREATE (u1)-[:POSTED]->(p1)
CREATE (u2)-[:POSTED]->(p2)

// Add likes
CREATE (u1)-[:LIKES {timestamp: datetime()}]->(p2)
CREATE (u3)-[:LIKES {timestamp: datetime()}]->(p1)
```

### **E-commerce Model**
```cypher
// Create products and categories
CREATE (laptop:Product {id: 1, name: "Gaming Laptop", price: 1299.99})
CREATE (mouse:Product {id: 2, name: "Gaming Mouse", price: 79.99})
CREATE (keyboard:Product {id: 3, name: "Mechanical Keyboard", price: 149.99})

CREATE (electronics:Category {name: "Electronics"})
CREATE (gaming:Category {name: "Gaming"})

// Create category relationships
CREATE (laptop)-[:BELONGS_TO]->(electronics)
CREATE (laptop)-[:BELONGS_TO]->(gaming)
CREATE (mouse)-[:BELONGS_TO]->(electronics)
CREATE (mouse)-[:BELONGS_TO]->(gaming)
CREATE (keyboard)-[:BELONGS_TO]->(electronics)
CREATE (keyboard)-[:BELONGS_TO]->(gaming)

// Create customer and orders
CREATE (customer:Customer {id: 1, name: "John Doe", email: "john@example.com"})
CREATE (order:Order {id: 1, total: 1429.98, date: date("2024-01-15")})

// Connect order to customer
CREATE (customer)-[:PLACED]->(order)

// Add order items
CREATE (order)-[:CONTAINS {quantity: 1, price: 1299.99}]->(laptop)
CREATE (order)-[:CONTAINS {quantity: 1, price: 79.99}]->(mouse)
CREATE (order)-[:CONTAINS {quantity: 1, price: 49.99}]->(keyboard)
```

### **Knowledge Graph Model**
```cypher
// Create entities
CREATE (ai:Concept {name: "Artificial Intelligence", category: "Technology"})
CREATE (ml:Concept {name: "Machine Learning", category: "Technology"})
CREATE (dl:Concept {name: "Deep Learning", category: "Technology"})
CREATE (neural:Concept {name: "Neural Networks", category: "Technology"})

// Create relationships
CREATE (ai)-[:INCLUdes]->(ml)
CREATE (ml)-[:INCLUdes]->(dl)
CREATE (dl)-[:USES]->(neural)

// Add properties to relationships
CREATE (ai)-[:RELATED_TO {strength: 0.9, type: "parent"}]->(ml)
CREATE (ml)-[:RELATED_TO {strength: 0.8, type: "subset"}]->(dl)

// Create people and their expertise
CREATE (expert:Person {name: "Dr. Smith", field: "AI"})
CREATE (expert)-[:EXPERT_IN {level: "expert", years: 15}]->(ai)
CREATE (expert)-[:CONTRIBUTED_TO {papers: 50}]->(ml)
```

## 🔧 **Indexes & Constraints**

### **Indexes**
```cypher
// Create index on property
CREATE INDEX FOR (p:Person) ON (p.name)

// Create composite index
CREATE INDEX FOR (p:Person) ON (p.city, p.age)

// Create full-text index
CREATE FULLTEXT INDEX personSearch FOR (p:Person) ON EACH [p.name, p.bio]

// Use indexes in queries
MATCH (p:Person) WHERE p.name = "Alice" RETURN p  // Uses index
```

### **Constraints**
```cypher
// Unique constraint
CREATE CONSTRAINT unique_person_email FOR (p:Person) REQUIRE p.email IS UNIQUE

// Node property existence constraint
CREATE CONSTRAINT person_name_exists FOR (p:Person) REQUIRE p.name IS NOT NULL

// Relationship property existence constraint
CREATE CONSTRAINT friendship_since_exists FOR ()-[f:FRIENDS_WITH]-() REQUIRE f.since IS NOT NULL

// Node key constraint (composite uniqueness)
CREATE CONSTRAINT unique_person_name_city FOR (p:Person) REQUIRE (p.name, p.city) IS NODE KEY
```

## 🧪 **Exercises**

### **Easy Level**
1. **Basic Node and Relationship Creation**
   - Create nodes for people with properties (name, age, city)
   - Create FRIENDS_WITH relationships between people
   - Query to find all friends of a specific person

2. **Property Graph Queries**
   - Add properties to relationships (since date, closeness level)
   - Query relationships with property filters
   - Update node and relationship properties

3. **Label Usage**
   - Create nodes with multiple labels (Person, Employee)
   - Query nodes by different label combinations
   - Add and remove labels from existing nodes

### **Medium Level**
4. **Social Network Analysis**
   - Build a small social network with 10+ people
   - Find mutual friends between two people
   - Calculate degree centrality for all users

5. **E-commerce Graph**
   - Model products, categories, customers, and orders
   - Find product recommendations based on purchase history
   - Calculate customer spending patterns

6. **Path Finding**
   - Find shortest paths between nodes
   - Discover paths of specific lengths
   - Implement different traversal strategies

### **Hard Level**
7. **Knowledge Graph Construction**
   - Build a knowledge graph of related concepts
   - Implement concept similarity algorithms
   - Create inference rules for new relationships

8. **Graph Algorithm Implementation**
   - Implement PageRank algorithm
   - Calculate betweenness centrality
   - Detect communities in the graph

9. **Complex Query Patterns**
   - Multi-hop traversals with complex conditions
   - Aggregations on graph patterns
   - Time-based graph analysis

## 🔍 **Key Takeaways**
- **Property Graph**: Nodes, relationships, properties, and labels form the foundation
- **Cypher**: Pattern-matching query language designed for graphs
- **Relationships**: First-class citizens that can have properties and direction
- **Traversal**: Follow relationships to discover connections and patterns
- **Modeling**: Design for query patterns, not just data storage

## 📚 **Additional Resources**
- [Neo4j Cypher Manual](https://neo4j.com/docs/cypher-manual/current/)
- [Graph Database Concepts](https://neo4j.com/docs/getting-started/current/graph-database/)
- [Neo4j Browser Guide](https://neo4j.com/docs/browser-manual/current/)
- [Property Graph Model](https://neo4j.com/docs/getting-started/current/graph-database/#property-graph)

## 🎯 **Next Steps**
Ready to dive deeper into graph algorithms and advanced patterns? Check out the next module on **Neo4j Graph Algorithms** to learn about path finding, centrality measures, and community detection!