# Monitoring & Observability

**Level:** Intermediate  
**Time Estimate:** 35 minutes  
**Prerequisites:** Basic SQL, system admin.

## TL;DR
Monitor database health with metrics like query performance, connections, and locks. Use tools like pg_stat_statements and exporters for alerts.

## Learning Objectives
By the end of this lesson, you'll be able to:
- Query system views for metrics.
- Set up basic monitoring.
- Identify performance bottlenecks.
- Integrate with monitoring stacks.

## Motivation & Real-World Scenario
A database slows down under load. Monitoring reveals high lock waits, allowing quick fixes before outages.

## Theory: Key Metrics

### Performance
- Query latency, throughput.

### Health
- Connections, locks, replication lag.

### Resources
- CPU, memory, disk I/O.

**Database Monitoring Architecture:**
```mermaid
graph TB
    subgraph "Database Layer"
        A[(PostgreSQL/MySQL)]
        B[pg_stat_statements]
        C[pg_stat_activity]
        D[pg_locks]
    end
    
    subgraph "Collection Layer"
        E[postgres_exporter]
        F[custom_queries]
        G[system_metrics]
    end
    
    subgraph "Time Series DB"
        H[(Prometheus)]
        I[(InfluxDB)]
    end
    
    subgraph "Visualization"
        J[Grafana]
        K[DataDog]
        L[Custom Dashboards]
    end
    
    subgraph "Alerting"
        M[AlertManager]
        N[PagerDuty]
        O[Slack]
    end
    
    A --> B
    A --> C
    A --> D
    
    B --> E
    C --> E
    D --> E
    E --> H
    F --> H
    G --> H
    
    H --> J
    H --> K
    H --> L
    
    H --> M
    M --> N
    M --> O
    
    P[Thresholds] -.-> M
    Q[Runbooks] -.-> N
    Q -.-> O
```

**Database Metrics Hierarchy:**
```mermaid
graph TD
    A[Database Health] --> B[Performance Metrics]
    A --> C[Resource Metrics]
    A --> D[Availability Metrics]
    
    B --> E[Query Latency]
    B --> F[Throughput TPS/QPS]
    B --> G[Connection Pool Usage]
    B --> H[Lock Wait Times]
    
    C --> I[CPU Usage %]
    C --> J[Memory Usage %]
    C --> K[Disk I/O]
    C --> L[Network I/O]
    
    D --> M[Uptime %]
    D --> N[Replication Lag]
    D --> O[Backup Status]
    D --> P[Error Rates]
    
    Q[Business Metrics] -.-> R[Active Users]
    Q -.-> S[Transaction Volume]
    Q -.-> T[Revenue Impact]
    
    U[Alert Priority] -.-> V[Critical: System Down]
    U -.-> W[High: Performance Degraded]
    U -.-> X[Medium: Resource Warning]
    U -.-> Y[Low: Trend Monitoring]
```

**Alert Flow & Escalation:**
```mermaid
graph TD
    A[Metric Collection] --> B{Metric > Threshold?}
    B -->|No| A
    B -->|Yes| C[Generate Alert]
    
    C --> D{Alert Severity}
    D -->|Critical| E[Immediate Page On-call Engineer]
    D -->|High| F[Email + Slack 15min timeout]
    D -->|Medium| G[Slack Notification 1hr timeout]
    D -->|Low| H[Dashboard Warning No immediate action]
    
    E --> I[Engineer Acknowledges]
    F --> I
    G --> I
    H --> J[Auto-resolve if metric normalizes]
    
    I --> K{Resolved?}
    K -->|Yes| L[Close Alert]
    K -->|No| M[Escalate to Manager]
    
    M --> N[Manager Review]
    N --> O[Declare Incident]
    O --> P[Incident Response Team]
    P --> Q[Root Cause Analysis]
    Q --> R[Implement Fix]
    R --> S[Post-mortem]
    S --> T[Update Runbooks]
    
    L --> U[Log for Analysis]
    U --> V[Update Thresholds if needed]
```

**Observability Dashboard Layout:**
```mermaid
graph TB
    subgraph "Top Row - System Overview"
        A[Database Status ● Up/Down]
        B[Uptime 99.9%]
        C[Active Connections 45/100]
        D[Replication Lag 2.3s]
    end
    
    subgraph "Middle Row - Performance"
        E[Query Latency Chart over time]
        F[Throughput TPS Chart over time]
        G[Slow Query Count Top 10 list]
        H[Lock Waits Current count]
    end
    
    subgraph "Bottom Row - Resources"
        I[CPU Usage % Chart over time]
        J[Memory Usage % Chart over time]
        K[Disk I/O Read/Write MB/s]
        L[Network I/O Packets/s]
    end
    
    subgraph "Right Panel - Alerts & Logs"
        M[Active Alerts Critical: 0 Warning: 2]
        N[Recent Logs Error log entries]
        O[Top Queries By execution time]
    end
    
    P[Time Range Selector] -.-> E
    P -.-> F
    P -.-> I
    P -.-> J
    P -.-> K
    P -.-> L
    
    Q[Refresh Interval 30s] -.-> A
    Q -.-> B
    Q -.-> C
    Q -.-> D
```

## Worked Examples

### Slow Queries (Postgres)
```sql
SELECT query, calls, total_time / calls AS avg_time
FROM pg_stat_statements
ORDER BY total_time DESC
LIMIT 10;
```

### Active Connections
```sql
SELECT count(*) FROM pg_stat_activity;
```

### Lock Waits
```sql
SELECT * FROM pg_locks WHERE granted = false;
```

### Replication Lag
```sql
SELECT client_addr, pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn) AS lag_bytes
FROM pg_stat_replication;
```

### Prometheus Exporter
Install `postgres_exporter`, configure scrape in Prometheus.

## Quick Checklist / Cheatsheet
- Enable pg_stat_statements.
- Monitor pg_stat_activity regularly.
- Set alerts for high connection counts.
- Use EXPLAIN ANALYZE for query tuning.

## Exercises

1. **Easy:** Find the top 5 slowest queries.
2. **Medium:** Check for blocked queries.
3. **Hard:** Set up a simple alert for replication lag.

## Solutions

1. `SELECT query, total_time FROM pg_stat_statements ORDER BY total_time DESC LIMIT 5;`

2. `SELECT * FROM pg_stat_activity WHERE wait_event_type = 'Lock';`

3. Use a cron job to query lag and email if > threshold.

## Notes: Vendor Differences / Performance Tips
- MySQL: Use `performance_schema`.
- SQL Server: DMVs like `sys.dm_exec_requests`.
- Monitor trends, not just snapshots.

## Next Lessons
- Query Plans & Cost Models (for query analysis).
- Advanced Security (for audit logs).

