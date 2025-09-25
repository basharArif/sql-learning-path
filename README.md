# SQL Learning Path

This repository contains a structured, multi-part learning path for mastering SQL, from fundamental concepts to advanced, real-world query skills.

## Structure

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
