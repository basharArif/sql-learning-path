# NoSQL Fundamentals

This folder contains the foundational concepts you need to understand before diving into specific NoSQL databases. These modules establish the theoretical foundation and decision-making frameworks for NoSQL database selection and usage.

## 📚 Modules

### [0-nosql-vs-sql-comparison.md](0-nosql-vs-sql-comparison.md)
**Level:** Intermediate | **Time:** 25 minutes

Learn when to choose SQL vs NoSQL databases. Covers:
- Core differences between relational and non-relational databases
- Decision frameworks for database selection
- Real-world case studies (Netflix, Twitter, Airbnb)
- Hybrid architecture patterns (polyglot persistence)
- Migration strategies and trade-off analysis

### [1-cap-theorem-and-tradeoffs.md](1-cap-theorem-and-tradeoffs.md)
**Level:** Intermediate | **Time:** 30 minutes

Master the fundamental theorem of distributed systems. Covers:
- CAP theorem properties (Consistency, Availability, Partition Tolerance)
- Database categorization (CA, AP, CP systems)
- Practical implications for system design
- Real-world examples and decision criteria
- Trade-offs between different CAP choices

## 🎯 Learning Path

1. **Start Here**: Read the comparison module to understand when NoSQL makes sense
2. **Build Foundation**: Study CAP theorem to grasp distributed system trade-offs
3. **Make Decisions**: Use the frameworks to choose appropriate databases for your projects

## 📖 Prerequisites

- Basic understanding of databases and SQL concepts
- Familiarity with distributed systems concepts (helpful but not required)

## 🔗 Next Steps

After completing these fundamentals:
- Move to [theory concepts](../theory/) for deeper understanding of consistency models
- Explore [specific databases](../databases/) to learn implementation details
- Study [advanced topics](../advanced/) for scaling and performance optimization

## 💡 Key Takeaways

- **NoSQL ≠ No SQL**: NoSQL means "Not Only SQL" - many applications benefit from both
- **CAP Theorem**: You can only guarantee 2 out of 3 properties in distributed systems
- **Right Tool**: Choose databases based on your specific access patterns and requirements
- **Hybrid Approach**: Modern applications often combine multiple database types