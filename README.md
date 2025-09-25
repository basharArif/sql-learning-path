# SQL Learning Path

A comprehensive, visual SQL learning platform with interactive diagrams and practical examples.

## 📚 Learning Modules

### Fundamentals (6 modules)
- [Introduction and Basics](fundamentals/1-introduction-and-basics.md)
- [JOINs](fundamentals/2-joins.md)
- [Aggregations & Grouping](fundamentals/3-aggregations-and-grouping.md)
- [Subqueries and Sets](fundamentals/4-subqueries-and-sets.md)
- [Conditional Logic](fundamentals/5-conditional-logic.md)
- [Indexing Basics](fundamentals/6-indexing-basics.md)

### Theory (4 modules)
- [Relational Algebra](theory/1-relational-algebra.md)
- [Data Types](theory/2-data-types.md)
- [Query Plans and Cost Models](theory/3-query-plans-and-cost-models.md)
- [Transactions, Isolation and Concurrency](theory/4-transactions-isolation-and-concurrency.md)

### Advanced Topics (6 modules)
- [Recursive CTEs and Hierarchies](advanced/1-recursive-ctes-and-hierarchies.md)
- [LATERAL Joins and JSON Functions](advanced/2-lateral-joins-and-json-functions.md)
- [Temporal Tables and Change Data Capture](advanced/3-temporal-tables-and-change-data-capture.md)
- [Advanced Window Functions](advanced/4-advanced-window-functions.md)
- [Window Functions](advanced/5-window-functions.md)
- [Advanced Query Optimization](advanced/6-advanced-query-optimization.md)

### Practical Applications (5 modules)
- [Error Handling and Exceptions](practical/1-error-handling-and-exceptions.md)
- [Data Migration, Backup and Restore](practical/2-data-migration-backup-restore.md)
- [Data Import and ETL](practical/3-data-import-and-etl.md)
- [SQL Testing and Automation](practical/4-sql-testing-and-automation.md)
- [Visualization and BI Integration](practical/5-visualization-and-BI-integration.md)

### Operations (3 modules)
- [Advanced Security](ops/1-advanced-security.md)
- [Partitioning and Sharding](ops/2-partitioning-and-sharding.md)
- [Monitoring and Observability](ops/3-monitoring-and-observability.md)

## 🎯 Features

- **Visual Learning**: 25+ interactive Mermaid diagrams
- **Progressive Difficulty**: From basics to expert-level topics
- **Practical Focus**: Real-world scenarios and examples
- **Comprehensive Coverage**: Fundamentals through advanced operations
- **GitHub Native**: All diagrams render directly on GitHub

## 🚀 Getting Started

1. Start with [Introduction and Basics](fundamentals/1-introduction-and-basics.md)
2. Follow the learning path in [learning-path.md](learning-path.md)
3. Practice with the exercises in each module
4. Use the [GLOSSARY.md](GLOSSARY.md) for reference

## 📖 Learning Path

See [learning-path.md](learning-path.md) for a structured progression through all modules.

## 🛠️ Development Setup

### Quickstart (local)
1. Install Docker and Docker Compose.
2. From repo root run:

```bash
cd /home/arif/projects/sql-learning
docker-compose -f devtools/docker/docker-compose.yml up --build -d
# wait a few seconds for DB to initialize
./devtools/tests/sql-smoke/run_tests.sh
```

This brings up a local PostgreSQL with seeded sample data and runs a small smoke test.

### Alternative Setup
If you don't have Docker/compose available locally:

1. Install `psql` (Postgres client).
2. Create a local Postgres and run the seed SQL in `devtools/docker/seed/seed.sql` manually.
3. Run `./devtools/tests/sql-smoke/run_tests.sh` to execute smoke queries.

## 🤝 Contributing

This is an open-source learning resource. Contributions are welcome!

See `CONTRIBUTING.md` and `devtools/TODO.md` for next steps and how to contribute new content.

## 📄 License

This project is licensed under the MIT License.

The content is organized into topic-based folders. The recommended starting point is the **Master Index**.

- **[learning-path.md](learning-path.md)**: The master index for the entire learning path. It provides a structured route through all the content.
- **`fundamentals/`**: The starting point for beginners. Covers all core SQL concepts.
- **`theory/`**: Contains documents on the fundamental concepts of SQL and databases.
- **`practical/`**: Holds hands-on guides for common, practical database tasks.
- **`advanced/`**: Covers powerful, advanced SQL features for complex problems.
- **`ops/`**: Includes topics related to database operations, security, and maintenance.
- **`exercises/`**: Contains practice problems and solutions.
- **`GLOSSARY.md`**: A glossary of key SQL terms.

## How to Use

1.  Start with the **[learning-path.md](learning-path.md)** file. It provides a structured path through all the topics.
2.  If you are a beginner, start with the **`fundamentals/`** section.
3.  Use the learning path to navigate to the different sections in the `theory`, `practical`, `advanced`, and `ops` folders.
4.  Refer to the `GLOSSARY.md` for definitions of key terms.

Quickstart (local)
1. Install Docker and Docker Compose.
2. From repo root run:

```bash
cd /home/arif/projects/sql-learning
docker-compose -f devtools/docker/docker-compose.yml up --build -d
# wait a few seconds for DB to initialize
./devtools/tests/sql-smoke/run_tests.sh
```

This brings up a local PostgreSQL with seeded sample data and runs a small smoke test.

Contributing & roadmap
- See `CONTRIBUTING.md` and `devtools/TODO.md` for next steps and how to contribute new content.

If you don't have Docker/compose available locally

1. Install `psql` (Postgres client).
2. Create a local Postgres and run the seed SQL in `devtools/docker/seed/seed.sql` manually.
3. Run `./devtools/tests/sql-smoke/run_tests.sh` to execute smoke queries.
