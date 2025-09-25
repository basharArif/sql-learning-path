# SQL Learning Path

This repository contains a structured, multi-part learning path for mastering SQL, from fundamental concepts to advanced, real-world query skills.

## Structure

The learning path is broken down into several documents, designed to be read sequentially:

- **[learning-path.md](learning-path.md)**: The main table of contents for the entire course.
- **[1-Fundamentals.md](1-Fundamentals.md)**: Covers the absolute basics of databases and SQL.
- **[2-Intermediate.md](2-Intermediate.md)**: Dives into `JOIN`s, aggregations, and other core concepts.
- **[3-Advanced.md](3-Advanced.md)**: Explores advanced topics like window functions, triggers, and transactions.
- **[4-Real-World-Queries.md](4-Real-World-Queries.md)**: Provides practical examples and use cases.
- **[5-Pro-SQL-Skills.md](5-Pro-SQL-Skills.md)**: Focuses on professional skills like schema design and optimization.
- **[6-Expert-Topics.md](6-Expert-Topics.md)**: Covers advanced topics like specialized indexes, JSON querying, and data warehousing concepts.
- **[GLOSSARY.md](GLOSSARY.md)**: A glossary of key SQL terms.

## How to Use

1.  Start with the `learning-path.md` file to get an overview.
2.  Proceed through the numbered files in order.
3.  Refer to the `GLOSSARY.md` for definitions of key terms.

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
