# NoSQL Operations and Best Practices

**Level:** Advanced  
**Time Estimate:** 50 minutes  
**Prerequisites:** Understanding of NoSQL database types, performance concepts, distributed systems.

## TL;DR
NoSQL operations encompass the operational aspects of running NoSQL databases in production, including deployment, monitoring, backup/recovery, scaling, and maintenance. Best practices ensure reliability, performance, and maintainability in distributed environments.

## Learning Objectives
By the end of this lesson, you'll be able to:
- Implement proper deployment and configuration strategies
- Set up monitoring and alerting for NoSQL systems
- Plan and execute backup and recovery procedures
- Perform scaling operations with minimal downtime
- Apply operational best practices for production environments

## Motivation & Real-World Scenario
An online retail company operates multiple NoSQL databases across 3 data centers. During Black Friday, traffic increases 10x, requiring seamless scaling and monitoring to maintain service. A database node fails during peak hours, but the system continues operating thanks to proper backup strategies, monitoring alerts, and automated failover procedures designed during quieter periods.

## Theory: Operational Considerations

### 1. Production Readiness
NoSQL databases in production require:
- **High Availability**: Multi-node clusters with failover
- **Disaster Recovery**: Backup and recovery procedures
- **Monitoring**: Real-time performance and health metrics
- **Maintenance Windows**: Scheduled maintenance procedures
- **Capacity Planning**: Proactive resource scaling

### 2. Distributed System Operations
Core operational challenges:
- **Node Management**: Adding/removing nodes
- **Data Distribution**: Ensuring even data spread
- **Consistency Checks**: Maintaining data integrity
- **Network Partitions**: Handling network failures
- **Clock Synchronization**: Managing time across nodes

### 3. SLA and Performance Requirements
- **Availability**: Target uptime percentages
- **Latency**: Response time requirements
- **Throughput**: Operations per second targets
- **Durability**: Data loss tolerance

## Worked Examples

### Example 1: Node Addition/Removal (Cassandra-style)
**Scenario**: Adding capacity to a Cassandra cluster

**Preparation Phase**:
```bash
# 1. Check cluster status
nodetool status

# 2. Check current capacity
nodetool info

# 3. Ensure adequate free space on new node
df -h
```

**Execution Phase**:
```bash
# 4. Start new node with auto-bootstrap
# (cassandra.yaml: auto_bootstrap: true)
sudo systemctl start cassandra

# 5. Monitor streaming progress
nodetool netstats

# 6. Verify data distribution after completion
nodetool ring
```

**Validation Phase**:
```bash
# 7. Run consistency checks
nodetool repair

# 8. Verify cluster health
nodetool status
```

### Example 2: Backup and Recovery (MongoDB-style)
**Scenario**: Setting up automated backups

**Backup Script**:
```bash
#!/bin/bash
# daily-backup.sh

# Configuration
BACKUP_DIR="/backups/mongodb/$(date +%Y%m%d)"
DB_HOST="localhost"
DB_PORT="27017"

# Create backup directory
mkdir -p $BACKUP_DIR

# Perform backup
mongodump --host $DB_HOST:$DB_PORT --out $BACKUP_DIR

# Compress backup
tar -czf $BACKUP_DIR.tar.gz -C $(dirname $BACKUP_DIR) $(basename $BACKUP_DIR)

# Remove uncompressed directory
rm -rf $BACKUP_DIR

# Remove backups older than 30 days
find /backups/mongodb -name "*.tar.gz" -mtime +30 -delete

# Send success notification
echo "Backup completed: $(date)" >> /var/log/backup.log
```

**Recovery Process**:
```bash
# 1. Stop application writes
# 2. Restore from backup
tar -xzf mongodb-20240115.tar.gz -C /tmp/
mongorestore --host localhost:27017 /tmp/20240115/

# 3. Verify data integrity
mongo --eval "db.stats()"
```

### Example 3: Monitoring Setup (Generic approach)
**Scenario**: Setting up monitoring for a Redis cluster

**Monitoring Script**:
```bash
#!/bin/bash
# redis-monitor.sh

REDIS_HOST="localhost"
REDIS_PORT="6379"
ALERT_THRESHOLD=80  # 80% memory usage threshold

# Check Redis connectivity
if ! redis-cli -h $REDIS_HOST -p $REDIS_PORT ping > /dev/null 2>&1; then
    echo "CRITICAL: Redis server not responding" | mail -s "Redis Down" ops@company.com
    exit 1
fi

# Check memory usage
MEMORY_USAGE=$(redis-cli -h $REDIS_HOST -p $REDIS_PORT info memory | grep used_memory_human | cut -d':' -f2)
MEMORY_RSS=$(redis-cli -h $REDIS_HOST -p $REDIS_PORT info memory | grep used_memory_rss_human | cut -d':' -f2)
MAX_MEMORY=$(redis-cli -h $REDIS_HOST -p $REDIS_PORT config get maxmemory | tail -1)
MAX_MEMORY_HUMAN=$(redis-cli -h $REDIS_HOST -p $REDIS_PORT config get maxmemory-human | tail -1)

# Calculate percentage
PERCENT_USED=$(echo "$MEMORY_RSS * 100 / $MAX_MEMORY" | bc)

if [ $PERCENT_USED -gt $ALERT_THRESHOLD ]; then
    echo "WARNING: Redis memory usage at $PERCENT_USED%" | mail -s "Redis Memory Alert" ops@company.com
fi

# Log metrics to monitoring system
echo "$(date): Redis memory used: $MEMORY_RSS, max: $MAX_MEMORY_HUMAN, usage: $PERCENT_USED%" >> /var/log/redis-monitor.log
```

### Example 4: Capacity Planning
**Scenario**: Planning for traffic growth

**Current Metrics**:
- Current data size: 500GB
- Growth rate: 10% monthly
- Current queries per second: 10,000 read, 1,000 write
- Projected traffic increase: 3x during peak

**Capacity Calculation**:
```
Data Growth: 500GB * (1.1^12) = ~1.6TB in 12 months
Storage Required: 1.6TB * 3 (replication) = 4.8TB
QPS Peak: (10,000 + 1,000) * 3 = 33,000 QPS
Memory for Cache: At least 20% of data set = ~320GB
```

## Database-Type Specific Operations

### Document Database Operations

#### 1. Schema Management
- **Versioning**: Track schema changes
- **Migration Scripts**: Plan for zero-downtime migrations
- **Backward Compatibility**: Ensure old code works with new schemas
- **Validation**: Implement schema validation when needed

#### 2. Index Management
- **Index Creation**: Plan creation during low-traffic periods
- **Index Usage Monitoring**: Track index efficiency
- **Index Cleanup**: Remove unused indexes periodically
- **Background Operations**: Use non-blocking index operations

#### 3. Sharding Strategies
- **Shard Key Selection**: Choose keys for even distribution
- **Shard Balancing**: Monitor and maintain balance
- **Cross-shard Queries**: Minimize distributed operations
- **Migration Planning**: Plan for shard splits

### Key-Value Store Operations

#### 1. Memory Management
- **Eviction Policies**: Configure appropriate policies (LRU, TTL, etc.)
- **Memory Monitoring**: Track memory usage and fragmentation
- **Persistence Strategy**: Balance durability vs. performance
- **Memory Scaling**: Plan for memory increases

#### 2. High Availability
- **Replication Setup**: Configure master-slave or cluster mode
- **Failover Procedures**: Plan for automatic/manual failover
- **Consistency Verification**: Check data consistency across replicas
- **Connection Management**: Handle client reconnection patterns

#### 3. Performance Tuning
- **Maxmemory Settings**: Configure appropriate limits
- **Network Optimization**: Optimize for low-latency access
- **Persistence Tuning**: Balance AOF/RDB settings
- **Threading Configuration**: Optimize for available cores

### Column-Family Store Operations

#### 1. Compaction Management
- **Compaction Strategy**: Choose size-tiered, leveled, or time-window
- **I/O Impact**: Schedule during low-traffic periods
- **Space Requirements**: Plan for temporary space during compaction
- **Performance Monitoring**: Monitor during compaction

#### 2. Repair Operations
- **Consistency Checks**: Regular nodetool repair execution
- **Incremental Repairs**: Minimize resource impact
- **Tombstone Management**: Clean up deleted data
- **Schedule Planning**: Balance consistency vs. performance

#### 3. Data Center Operations
- **Multi-DC Configuration**: Configure for cross-DC replication
- **Consistency Policies**: Choose appropriate consistency levels
- **Network Bandwidth**: Plan for cross-DC traffic
- **Failover Procedures**: Handle DC outages

### Graph Database Operations

#### 1. Graph Maintenance
- **Index Optimization**: Maintain property indexes
- **Traversal Performance**: Monitor and optimize paths
- **Memory Management**: Graphs can be memory-intensive
- **Query Planning**: Understand query execution paths

#### 2. Backup Strategies
- **Graph Consistency**: Ensure graph structure consistency
- **Incremental Backups**: Consider for large graphs
- **Recovery Testing**: Regular recovery validation
- **Export Formats**: Choose appropriate for your system

## Monitoring Best Practices

### 1. Key Metrics by Database Type

**Document Databases**:
- Query response times
- Index usage and efficiency
- Connection pool metrics
- Document size distribution

**Key-Value Stores**:
- Cache hit/miss ratios
- Memory usage and fragmentation
- Network latency
- Eviction rates

**Column-Family Stores**:
- Read/write latencies
- Compaction performance
- Repair status
- Node synchronization

**Graph Databases**:
- Traversal performance
- Path query times
- Node/relationship growth
- Index hit ratios

### 2. Alerting Strategies
- **Response Time Thresholds**: Alert on performance degradation
- **Resource Utilization**: CPU, memory, disk, network alerts
- **Error Rates**: Alert on unusual error patterns
- **Availability**: Monitor node connectivity
- **Data Consistency**: Alert on cross-node inconsistencies

### 3. Dashboards and Visualization
- **Real-time Metrics**: Live system status
- **Historical Trends**: Performance over time
- **Capacity Planning**: Resource utilization trends
- **Business Metrics**: Application-specific metrics

## Security Operations

### 1. Access Control
- **Authentication**: Strong user authentication
- **Authorization**: Role-based access control
- **Network Security**: Firewall and encryption
- **Audit Logging**: Track access and operations

### 2. Data Protection
- **Encryption at Rest**: Protect stored data
- **Encryption in Transit**: Secure network communication
- **Backup Security**: Secure backup data
- **Key Management**: Secure encryption keys

## Disaster Recovery

### 1. Backup Strategies
- **Regular Backups**: Scheduled automated backups
- **Point-in-Time Recovery**: Log-based recovery capability
- **Geographic Distribution**: Offsite backup storage
- **Recovery Testing**: Regular restore testing

### 2. Failover Procedures
- **Automatic Failover**: Configure where supported
- **Manual Procedures**: Document manual failover steps
- **Rollback Plans**: Plan for recovery from failed operations
- **Communication Plans**: Notify stakeholders during outages

## Operational Best Practices

### 1. Deployment
- **Configuration Management**: Version control for configs
- **Environment Parity**: Similar configs across environments
- **Zero-Downtime Deployments**: Blue-green or rolling updates
- **Rollback Procedures**: Quick rollback capability

### 2. Maintenance
- **Regular Patching**: Keep systems up to date
- **Health Checks**: Automated health monitoring
- **Cleanup Tasks**: Regular maintenance operations
- **Performance Reviews**: Regular performance assessments

### 3. Documentation
- **Runbooks**: Step-by-step operational procedures
- **Incident Response**: Document incident handling
- **Configuration Guides**: Setup and configuration documentation
- **Change Management**: Track system changes

## Quick Checklist / Cheatsheet

- **Backup First**: Always backup before major changes
- **Test Changes**: Test in staging before production
- **Monitor Impact**: Track metrics after changes
- **Document Procedures**: Keep runbooks updated
- **Plan for Failure**: Design for failure scenarios
- **Capacity Planning**: Plan ahead for growth
- **Security First**: Implement security measures
- **Monitor Continuously**: Set up comprehensive monitoring

## Exercises

1. **Easy**: Create a monitoring dashboard for a NoSQL database.
2. **Medium**: Design a disaster recovery plan for a distributed NoSQL system.
3. **Hard**: Plan a zero-downtime migration from one NoSQL type to another.

## Next Steps

- Learn specific database operational tools
- Practice with containerized deployment
- Study cloud provider NoSQL services
- Explore infrastructure as code for NoSQL deployment