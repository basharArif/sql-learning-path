# Glossary of SQL Terms

---

### A

*   **ACID**: An acronym for Atomicity, Consistency, Isolation, and Durability. These are the four properties of a database transaction that guarantee data validity even in the event of errors, power failures, etc.
*   **Aggregate Function**: A function that performs a calculation on a set of values and returns a single value (e.g., COUNT, SUM, AVG, MIN, MAX).

### C

*   **Column**: A vertical entity in a table that contains all information associated with a specific field in a table.
*   **CTE (Common Table Expression)**: A temporary, named result set that you can reference within a `SELECT`, `INSERT`, `UPDATE`, or `DELETE` statement. Created using the `WITH` clause.
*   **Cartesian Product**: The result of a JOIN operation without a WHERE clause, producing every possible combination of rows from the joined tables.

### D

*   **Database Design**: The process of structuring a database in an organized and efficient way to reduce redundancy and improve data integrity.
*   **Data Modeling**: The process of creating a visual representation of a database's entities, attributes, and relationships.

### E

*   **ERD (Entity-Relationship Diagram)**: A visual representation of entities and their relationships in a database.

### F

*   **Foreign Key**: A key used to link two tables together. It is a field (or collection of fields) in one table that refers to the `PRIMARY KEY` in another table.

### I

*   **Index**: A special lookup table that the database search engine can use to speed up data retrieval. An index is a pointer to data in a table.
*   **Isolation Level**: A setting that determines how transaction integrity is visible to other users and systems, controlling the extent to which one transaction must be isolated from effects of other concurrent transactions.

### J

*   **JOIN**: An SQL clause used to combine rows from two or more tables based on a related column between them.

### N

*   **Normalization**: The process of organizing data in a database to reduce redundancy and improve data integrity. 
    *   **1NF (First Normal Form)**: Each table cell contains only atomic (indivisible) values, and each record is unique.
    *   **2NF (Second Normal Form)**: Must be in 1NF and all non-key attributes are fully functional dependent on the primary key.
    *   **3NF (Third Normal Form)**: Must be in 2NF and all attributes are functionally dependent only on the primary key (no transitive dependencies).

### P

*   **Primary Key**: A constraint that uniquely identifies each record in a table. Primary keys must contain unique values and cannot contain NULL values.
*   **Performance Tuning**: The process of optimizing the performance of database queries and operations.

### R

*   **RDBMS (Relational Database Management System)**: A program that allows you to create, update, and administer a relational database. SQL is the language used to communicate with an RDBMS.
*   **Row**: A single, implicitly structured data item in a table. Also known as a record.

### S

*   **SQL (Structured Query Language)**: A domain-specific language used in programming and designed for managing data held in a relational database management system (RDBMS).
*   **Subquery**: A query nested inside another query (SELECT, INSERT, UPDATE, or DELETE statement).
*   **Schema**: The structure of a database that defines the tables, columns, data types, and relationships.

### T

*   **Table**: A set of data elements (values) using a model of vertical columns (identifiable by name) and horizontal rows, the cell being the unit where a row and column intersect.
*   **Transaction**: A sequence of operations performed as a single logical unit of work.

### U

*   **UPSERT (Update or Insert)**: An operation that either updates a row if it exists or inserts a new row if it does not exist.

### W

*   **Window Function**: A function which uses values from one or multiple rows to return a value for each row. Unlike aggregate functions, window functions do not group rows into a single output row.
