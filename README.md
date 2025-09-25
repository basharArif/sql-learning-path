# SQL Learning Path

This repository contains a structured, multi-part learning path for mastering SQL, from fundamental concepts to advanced, real-world query skills.

---

**Repository Content Overview:**
```mermaid
graph TB
    subgraph "📚 Learning Materials"
        A[learning-path.md<br/>Master Index & Roadmap]
        B[GLOSSARY.md<br/>Key Terms & Definitions]
    end
    
    subgraph "🏗️ Core Content"
        C[fundamentals/<br/>6 Files<br/>Basic SQL Skills]
        D[theory/<br/>4 Files<br/>Database Concepts]
        E[advanced/<br/>6 Files<br/>Complex Techniques]
    end
    
    subgraph "🔧 Practical Applications"
        F[practical/<br/>5 Files<br/>Real-world Tasks]
        G[ops/<br/>3 Files<br/>Operations & Security]
    end
    
    subgraph "🎯 Practice & Testing"
        H[exercises/<br/>Practice Problems]
        I[devtools/<br/>Testing Framework]
    end
    
    A --> C
    A --> D
    A --> E
    A --> F
    A --> G
    
    C --> H
    D --> H
    E --> H
    F --> H
    G --> H
    
    J[Docker Environment] -.-> I
    K[PostgreSQL] -.-> J
    L[Sample Data] -.-> J
    M[Smoke Tests] -.-> I
```

**Content Distribution by Difficulty:**
```mermaid
pie title Content Distribution (25 Files)
    "Beginner" : 6
    "Intermediate" : 8
    "Advanced" : 6
    "Expert" : 5
```

**Learning Progression Timeline:**
```mermaid
gantt
    title SQL Mastery Learning Path
    dateFormat YYYY-MM-DD
    section Fundamentals
    Introduction & Basics    :done, f1, 2024-01-01, 3d
    JOINs                    :done, f2, after f1, 4d
    Aggregations            :done, f3, after f2, 4d
    Subqueries & Sets       :done, f4, after f3, 4d
    Conditional Logic       :done, f5, after f4, 3d
    Indexing Basics         :done, f6, after f5, 3d
    
    section Theory
    Relational Algebra      :done, t1, after f6, 5d
    Data Types              :done, t2, after t1, 4d
    Query Plans             :done, t3, after t2, 5d
    Transactions            :done, t4, after t3, 5d
    
    section Advanced
    Recursive CTEs          :done, a1, after t4, 6d
    Lateral Joins & JSON    :done, a2, after a1, 5d
    Temporal Tables         :done, a3, after a2, 5d
    Window Functions        :done, a4, after a3, 6d
    Views & Procedures      :done, a5, after a4, 5d
    Vendor Differences      :done, a6, after a5, 4d
    
    section Practical
    Error Handling          :done, p1, after a6, 4d
    Data Migration          :done, p2, after p1, 5d
    ETL Processes           :done, p3, after p2, 4d
    Testing & Automation    :done, p4, after p3, 5d
    BI Integration          :done, p5, after p4, 4d
    
    section Operations
    Security                :done, o1, after p5, 5d
    Partitioning            :done, o2, after o1, 5d
    Monitoring              :done, o3, after o2, 5d
    
    section Practice
    Exercises & Projects    :active, ex1, after o3, 30d
```

**Technology Stack:**
```mermaid
graph TB
    subgraph "🗄️ Databases"
        A[(PostgreSQL<br/>Primary)]
        B[(MySQL<br/>Examples)]
        C[(SQL Server<br/>References)]
        D[(SQLite<br/>Testing)]
    end
    
    subgraph "🛠️ Tools"
        E[Docker<br/>Environment]
        F[pgTAP<br/>Testing]
        G[PostgreSQL<br/>Client]
        H[Mermaid<br/>Diagrams]
    end
    
    subgraph "📊 Content"
        I[Markdown<br/>Documentation]
        J[SQL Examples<br/>All Dialects]
        K[Visual Diagrams<br/>70+ Charts]
        L[Interactive<br/>Exercises]
    end
    
    subgraph "🚀 Deployment"
        M[GitHub<br/>Hosting]
        N[GitHub Actions<br/>CI/CD]
        O[Docker Hub<br/>Images]
    end
    
    A --> E
    B --> F
    C --> G
    
    E --> M
    F --> N
    G --> O
    
    I --> M
    J --> M
    K --> M
    L --> N
```

**Quick Reference Guide:**
```mermaid
graph TD
    A[New to SQL?] --> B[Start: learning-path.md]
    A --> C[Beginner? fundamentals/]
    A --> D[Know basics? theory/]
    
    E[Want to practice?] --> F[exercises/]
    E --> G[Need examples? practical/]
    
    H[Production ready?] --> I[ops/ for security]
    H --> J[advanced/ for complex queries]
    
    K[Contributing?] --> L[CONTRIBUTING.md]
    K --> M[devtools/TODO.md]
    
    N[Quick setup?] --> O[Docker environment]
    N --> P[Local PostgreSQL]
    
    B --> Q[Follow the roadmap]
    C --> Q
    D --> Q
    F --> Q
    G --> Q
    I --> Q
    J --> Q
```

---

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
