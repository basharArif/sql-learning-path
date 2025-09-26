# NoSQL Fundamentals Exercise 1

**Level:** Intermediate  
**Time Estimate:** 20 minutes  
**Prerequisites:** CAP theorem, ACID vs BASE concepts.

## Exercise: Database Selection Based on CAP Requirements

### Scenario
You're designing a distributed system for a global e-commerce platform. The system needs to handle:
- Product catalog updates
- Shopping cart management  
- Order processing
- Real-time inventory tracking

### Questions

1. **Product Catalog (Read-heavy, global access)**
   - Requirements: High availability, eventual consistency acceptable
   - Which CAP combination would you choose?
   - Recommend 2 specific databases and explain why.

2. **Shopping Cart (User-specific, session-based)**
   - Requirements: High availability, partition tolerance
   - Which CAP combination would you choose?
   - What trade-offs are you making?

3. **Order Processing (Financial transactions)**
   - Requirements: Strong consistency, data integrity critical
   - Which CAP combination would you choose?
   - Explain the trade-offs with partition tolerance.

4. **Real-time Inventory (High concurrency, global)**
   - Requirements: High availability, partition tolerance, eventual consistency OK
   - Which CAP combination would you choose?
   - How would you handle consistency conflicts?

### Advanced Challenge
Design a hybrid architecture that uses different databases for different components. Explain how you would handle data synchronization between systems.

## Learning Objectives
- Apply CAP theorem to real-world scenarios
- Understand trade-offs in database selection
- Design distributed system architectures
- Evaluate consistency vs availability requirements
