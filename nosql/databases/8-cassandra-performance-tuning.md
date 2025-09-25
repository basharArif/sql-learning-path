# 8. Cassandra Performance Tuning

## 🎯 **TL;DR**
Master advanced Cassandra performance optimization techniques, including JVM tuning, compaction strategies, caching, and query optimization for high-throughput production systems.

## 📋 **Learning Objectives**
By the end of this module, you'll be able to:
- Optimize JVM settings for Cassandra workloads
- Choose and configure appropriate compaction strategies
- Implement effective caching strategies
- Tune queries and data models for performance
- Monitor and troubleshoot performance issues

## ⚙️ **JVM & Memory Tuning**

### **Heap Size Configuration**
```bash
# cassandra-env.sh - Heap settings
JVM_OPTS="$JVM_OPTS -Xms16G"
JVM_OPTS="$JVM_OPTS -Xmx16G"

# New generation size (1/3 to 1/4 of heap)
JVM_OPTS="$JVM_OPTS -Xmn4G"

# Survivor ratio
JVM_OPTS="$JVM_OPTS -XX:SurvivorRatio=4"

# Maximum tenuring threshold
JVM_OPTS="$JVM_OPTS -XX:MaxTenuringThreshold=1"
```

### **Garbage Collection Tuning**
```bash
# G1GC for large heaps (recommended for Cassandra 3.0+)
JVM_OPTS="$JVM_OPTS -XX:+UseG1GC"
JVM_OPTS="$JVM_OPTS -XX:MaxGCPauseMillis=500"
JVM_OPTS="$JVM_OPTS -XX:G1RSetUpdatingPauseTimePercent=5"
JVM_OPTS="$JVM_OPTS -XX:InitiatingHeapOccupancyPercent=25"

# GC logging
JVM_OPTS="$JVM_OPTS -XX:+PrintGCDetails"
JVM_OPTS="$JVM_OPTS -XX:+PrintGCDateStamps"
JVM_OPTS="$JVM_OPTS -XX:+PrintHeapAtGC"
JVM_OPTS="$JVM_OPTS -XX:+PrintTenuringDistribution"
JVM_OPTS="$JVM_OPTS -XX:+PrintGCApplicationStoppedTime"
JVM_OPTS="$JVM_OPTS -Xloggc:/var/log/cassandra/gc.log"
JVM_OPTS="$JVM_OPTS -XX:+UseGCLogFileRotation"
JVM_OPTS="$JVM_OPTS -XX:NumberOfGCLogFiles=10"
JVM_OPTS="$JVM_OPTS -XX:GCLogFileSize=10M"
```

### **Off-Heap Memory**
```yaml
# cassandra.yaml - Off-heap settings
memtable_offheap_space_in_mb: 2048
index_summary_capacity_in_mb: 256
counter_cache_size_in_mb: 256
```

## 🗜️ **Compaction Strategies**

### **SizeTieredCompactionStrategy (STCS)**
Best for write-heavy workloads with low read latency requirements.

```sql
-- Default for most tables
ALTER TABLE sensor_data
WITH compaction = {
  'class': 'SizeTieredCompactionStrategy',
  'min_threshold': 4,
  'max_threshold': 32,
  'bucket_high': 1.5,
  'bucket_low': 0.5
};
```

**Use Cases:**
- High write throughput
- Variable data sizes
- General-purpose workloads

### **LeveledCompactionStrategy (LCS)**
Best for read-heavy workloads requiring predictable performance.

```sql
-- For read-optimized tables
ALTER TABLE products
WITH compaction = {
  'class': 'LeveledCompactionStrategy',
  'sstable_size_in_mb': 160
};
```

**Use Cases:**
- Read-heavy workloads
- Predictable read latency
- Large datasets with frequent updates

### **TimeWindowCompactionStrategy (TWCS)**
Best for time series data with TTL-based expiration.

```sql
-- For time series data
ALTER TABLE metrics
WITH compaction = {
  'class': 'TimeWindowCompactionStrategy',
  'compaction_window_unit': 'DAYS',
  'compaction_window_size': 1
};
```

**Use Cases:**
- Time series data
- Data with TTL expiration
- Log data with time-based queries

### **DateTieredCompactionStrategy (DTCS)**
Deprecated - use TWCS instead for time-based compaction.

## 📊 **Caching Configuration**

### **Key Cache**
Caches partition keys and row indices in memory.

```sql
-- Enable key caching
ALTER TABLE products
WITH caching = {
  'keys': 'ALL',
  'rows_per_partition': 'NONE'
};

-- Cache only frequently accessed keys
ALTER TABLE products
WITH caching = {
  'keys': '1000',
  'rows_per_partition': 'NONE'
};
```

### **Row Cache**
Caches entire rows in memory (use with caution).

```sql
-- Enable row caching for small, frequently accessed tables
ALTER TABLE user_sessions
WITH caching = {
  'keys': 'ALL',
  'rows_per_partition': 'ALL'
};
```

### **Counter Cache**
Caches counter values to reduce lock contention.

```yaml
# cassandra.yaml
counter_cache_size_in_mb: 256
counter_cache_save_period: 7200
counter_cache_keys_to_save: 100
```

### **Chunk Cache**
Caches compressed data chunks.

```yaml
# cassandra.yaml
file_cache_size_in_mb: 512
```

## 🔧 **Query & Data Model Optimization**

### **Primary Key Design**
```sql
-- Good: Partition by user, cluster by time
CREATE TABLE user_posts (
  user_id UUID,
  post_id TIMEUUID,
  content TEXT,
  created_at TIMESTAMP,
  PRIMARY KEY (user_id, post_id)
) WITH CLUSTERING ORDER BY (post_id DESC);

-- Query pattern: Get user's recent posts
SELECT * FROM user_posts
WHERE user_id = ?
LIMIT 10;
```

### **Secondary Indexes**
```sql
-- Create secondary index
CREATE INDEX ON products (category);

-- Composite index (limited support)
CREATE INDEX ON products ((category, price));

-- SASI (SSTable Attached Secondary Index) for text search
CREATE CUSTOM INDEX ON products (name)
USING 'org.apache.cassandra.index.sasi.SASIIndex'
WITH OPTIONS = {
  'mode': 'CONTAINS',
  'analyzer_class': 'org.apache.cassandra.index.sasi.analyzer.StandardAnalyzer'
};
```

### **Materialized Views**
```sql
-- Create materialized view for different query patterns
CREATE MATERIALIZED VIEW products_by_category AS
SELECT * FROM products
WHERE category IS NOT NULL AND product_id IS NOT NULL
PRIMARY KEY (category, product_id);

-- Query the view
SELECT * FROM products_by_category
WHERE category = 'electronics'
LIMIT 20;
```

### **Denormalization Strategies**
```sql
-- Store user data with posts for fast access
CREATE TABLE posts_with_user (
  post_id UUID PRIMARY KEY,
  user_id UUID,
  username TEXT,
  user_avatar TEXT,
  content TEXT,
  created_at TIMESTAMP
);

-- Update denormalized data in batches
BEGIN BATCH
  INSERT INTO posts (post_id, user_id, content, created_at) VALUES (?, ?, ?, ?);
  INSERT INTO posts_with_user (post_id, user_id, username, user_avatar, content, created_at)
    VALUES (?, ?, ?, ?, ?, ?);
APPLY BATCH;
```

## 📈 **Read & Write Optimization**

### **Read Optimization**
```sql
-- Use appropriate consistency levels
SELECT * FROM products WHERE product_id = ?
USING CONSISTENCY ONE;  -- For fast reads

-- Limit result sets
SELECT * FROM user_posts
WHERE user_id = ?
LIMIT 50;

-- Use paging for large result sets
SELECT * FROM user_posts
WHERE user_id = ?
LIMIT 50;

-- Then get next page
SELECT * FROM user_posts
WHERE user_id = ?
  AND post_id < ?
LIMIT 50;
```

### **Write Optimization**
```sql
-- Batch related writes
BEGIN BATCH
  INSERT INTO orders (order_id, user_id, total) VALUES (?, ?, ?);
  UPDATE inventory SET quantity = quantity - ? WHERE product_id = ?;
  INSERT INTO order_history (order_id, action, timestamp) VALUES (?, 'created', ?);
APPLY BATCH;

-- Use UNLOGGED batch for performance (non-atomic)
BEGIN UNLOGGED BATCH
  INSERT INTO metrics (sensor_id, timestamp, value) VALUES (?, ?, ?);
  INSERT INTO metrics (sensor_id, timestamp, value) VALUES (?, ?, ?);
APPLY BATCH;
```

### **Batch Size Optimization**
```yaml
# cassandra.yaml
batch_size_warn_threshold_in_kb: 64
batch_size_fail_threshold_in_kb: 1024

# Unlogged batch settings
unlogged_batch_across_partitions_warn_threshold: 10
```

## 💾 **Storage & Disk Optimization**

### **Commitlog Configuration**
```yaml
# cassandra.yaml
commitlog_sync: periodic
commitlog_sync_period_in_ms: 10000
commitlog_segment_size_in_mb: 32

# Commitlog directory (separate disk recommended)
commitlog_directory: /cassandra/commitlog
```

### **SSTable Configuration**
```yaml
# cassandra.yaml
concurrent_compactors: 4
compaction_throughput_mb_per_sec: 64
stream_throughput_outbound_megabits_per_sec: 200

# SSTable preemptive opening
preheat_kernel_page_cache: true
```

### **Disk Layout**
```bash
# Recommended disk layout
/cassandra/data        # Data files (fast SSDs)
/cassandra/commitlog   # Commit logs (fast SSDs)
/cassandra/saved_caches # Caches (fast SSDs)
/backups               # Backup storage (HDD/Cloud)
```

## 🌐 **Network & Connection Tuning**

### **Native Transport Settings**
```yaml
# cassandra.yaml
native_transport_max_threads: 128
native_transport_max_frame_size_in_mb: 256
native_transport_max_concurrent_connections: -1
native_transport_max_concurrent_connections_per_ip: -1
```

### **Internode Communication**
```yaml
# cassandra.yaml
inter_dc_tcp_nodelay: true
internode_compression: dc
internode_recv_buff_size_in_bytes: 4194304
internode_send_buff_size_in_bytes: 4194304
```

### **Client Connection Pooling Configuration**
```yaml
# cassandra.yaml - Connection pooling settings
native_transport_max_threads: 128
native_transport_max_frame_size_in_mb: 256
native_transport_max_concurrent_connections: -1
native_transport_max_concurrent_connections_per_ip: -1

# Connection timeout settings
read_request_timeout_in_ms: 5000
write_request_timeout_in_ms: 2000
request_timeout_in_ms: 10000

# Pooling options (for drivers)
pooling:
  core_connections_per_host_local: 2
  max_connections_per_host_local: 8
  core_connections_per_host_remote: 1
  max_connections_per_host_remote: 2
  max_requests_per_connection: 1024
```

## 📊 **Monitoring Performance**

### **Key Metrics to Monitor**
```bash
# Read/write latency percentiles
nodetool tablehistograms ecommerce.products

# Cache hit rates
nodetool info | grep "Key cache hit rate"
nodetool info | grep "Row cache hit rate"

# Compaction statistics
nodetool compactionstats

# Thread pool statistics
nodetool tpstats
```

### **Performance Troubleshooting**
```bash
# Identify slow queries
nodetool setlogginglevel org.apache.cassandra TRACE

# Check for dropped messages
nodetool tpstats | grep -E "(Dropped|Pending)"

# Monitor SSTable count
nodetool tablestats | grep "SSTable count"

# Check for large partitions
nodetool tablehistograms | grep "Partition size"
```

## 🧪 **Performance Testing**

### **Cassandra Stress Tool**
```bash
# Basic write test
cassandra-stress write n=1000000 -rate threads=50

# Mixed read/write test
cassandra-stress mixed ratio\\(write=1,read=3\\) n=1000000 -rate threads=50

# Custom schema test
cassandra-stress user profile=/path/to/profile.yaml n=1000000
```

### **Profile Configuration**
```yaml
# stress-profile.yaml
keyspace: test_keyspace

keyspace_definition: |
  CREATE KEYSPACE test_keyspace WITH REPLICATION = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
  };

table: test_table
table_definition: |
  CREATE TABLE test_table (
    id int PRIMARY KEY,
    data text
  );

columnspec:
  - name: id
    size: uniform(1..1000000)
  - name: data
    size: fixed(100)

insert:
  partitions: uniform(1..1000000)
  batchtype: UNLOGGED

queries:
  simple:
    cql: SELECT * FROM test_table WHERE id = ?
    fields: samerow
```

### **JMeter Testing**
```xml
<!-- JMX configuration for Cassandra testing -->
<ThreadGroup>
  <CassandraSampler>
    <contactPoints>localhost</contactPoints>
    <keyspace>test_keyspace</keyspace>
    <query>SELECT * FROM test_table WHERE id = ?</query>
    <consistencyLevel>ONE</consistencyLevel>
  </CassandraSampler>
</ThreadGroup>
```

## 🧪 **Exercises**

### **Medium Level**
1. **JVM Tuning**
   - Configure optimal heap settings for different workloads
   - Set up GC logging and monitoring
   - Tune JVM parameters for latency vs throughput

2. **Compaction Strategy Selection**
   - Choose appropriate compaction strategies for different data patterns
   - Monitor compaction performance and adjust settings
   - Compare performance between STCS, LCS, and TWCS

3. **Caching Optimization**
   - Configure key and row caching for optimal performance
   - Monitor cache hit rates and adjust sizes
   - Implement cache warming strategies

### **Hard Level**
4. **Query Optimization**
   - Optimize data models for specific query patterns
   - Implement materialized views for complex queries
   - Use secondary indexes effectively

5. **Storage Tuning**
   - Configure disk layout for optimal I/O performance
   - Tune commitlog and SSTable settings
   - Implement backup strategies without performance impact

6. **Production Performance Audit**
   - Analyze a running Cassandra cluster for bottlenecks
   - Implement comprehensive monitoring and alerting
   - Create performance baseline and optimization plan

## 🔍 **Key Takeaways**
- **JVM Tuning**: Critical for garbage collection and memory management
- **Compaction**: Choose strategy based on read/write patterns and data lifecycle
- **Caching**: Balance memory usage with performance benefits
- **Data Modeling**: Design for query patterns, not normalization
- **Monitoring**: Essential for identifying and resolving performance issues

## 📚 **Additional Resources**
- [Cassandra Performance Tuning](https://cassandra.apache.org/doc/latest/operating/optimization.html)
- [JVM Tuning Guide](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/)
- [Compaction Strategies](https://cassandra.apache.org/doc/latest/cql/ddl.html#compaction-options)
- [Monitoring Best Practices](https://cassandra.apache.org/doc/latest/operating/monitoring.html)

## 🎯 **Next Steps**
Cassandra module complete! Ready to explore graph databases? Check out **Neo4j Graph Database** to learn about property graphs, Cypher queries, and graph algorithms!