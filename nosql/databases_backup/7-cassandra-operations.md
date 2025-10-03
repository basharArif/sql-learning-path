# 7. Cassandra Operations

## 🎯 **TL;DR**
Master Cassandra cluster management, maintenance operations, monitoring, and troubleshooting techniques for production deployments.

## 📋 **Learning Objectives**
By the end of this module, you'll be able to:
- Set up and configure Cassandra clusters
- Perform routine maintenance and monitoring
- Handle node failures and cluster scaling
- Optimize performance and troubleshoot issues
- Implement backup and recovery strategies

## 🚀 **Cluster Setup & Configuration**

### **Single Node Setup**
```bash
# Download and extract Cassandra
wget https://downloads.apache.org/cassandra/4.1.0/apache-cassandra-4.1.0-bin.tar.gz
tar -xzf apache-cassandra-4.1.0-bin.tar.gz
cd apache-cassandra-4.1.0

# Configure cassandra.yaml
vim conf/cassandra.yaml

# Key configuration settings
cluster_name: 'Test Cluster'
seeds: "127.0.0.1"
listen_address: 127.0.0.1
rpc_address: 127.0.0.1
data_file_directories:
  - /var/lib/cassandra/data
commitlog_directory: /var/lib/cassandra/commitlog
saved_caches_directory: /var/lib/cassandra/saved_caches

# Start Cassandra
bin/cassandra -f

# Verify startup
bin/cqlsh
```

### **Multi-Node Cluster Setup**
```bash
# Node 1 configuration (seed node)
cluster_name: 'Production Cluster'
seeds: "192.168.1.10"
listen_address: 192.168.1.10
rpc_address: 192.168.1.10

# Node 2 configuration
cluster_name: 'Production Cluster'
seeds: "192.168.1.10"
listen_address: 192.168.1.11
rpc_address: 192.168.1.11

# Node 3 configuration
cluster_name: 'Production Cluster'
seeds: "192.168.1.10"
listen_address: 192.168.1.12
rpc_address: 192.168.1.12

# Start nodes in order
# Start seed node first
ssh node1 "cassandra -f"

# Wait for seed to be ready, then start other nodes
ssh node2 "cassandra -f"
ssh node3 "cassandra -f"
```

### **Docker Compose Setup**
```yaml
version: '3.8'
services:
  cassandra-1:
    image: cassandra:4.1
    container_name: cassandra-1
    environment:
      - CASSANDRA_CLUSTER_NAME=test-cluster
      - CASSANDRA_SEEDS=cassandra-1
      - CASSANDRA_LISTEN_ADDRESS=cassandra-1
      - CASSANDRA_RPC_ADDRESS=0.0.0.0
    ports:
      - "9042:9042"
    volumes:
      - cassandra-data-1:/var/lib/cassandra
    networks:
      - cassandra-net

  cassandra-2:
    image: cassandra:4.1
    container_name: cassandra-2
    depends_on:
      - cassandra-1
    environment:
      - CASSANDRA_CLUSTER_NAME=test-cluster
      - CASSANDRA_SEEDS=cassandra-1
      - CASSANDRA_LISTEN_ADDRESS=cassandra-2
      - CASSANDRA_RPC_ADDRESS=0.0.0.0
    ports:
      - "9043:9042"
    volumes:
      - cassandra-data-2:/var/lib/cassandra
    networks:
      - cassandra-net

volumes:
  cassandra-data-1:
  cassandra-data-2:

networks:
  cassandra-net:
    driver: bridge
```

## 🔧 **Cluster Management**

### **Nodetool Commands**
Nodetool is Cassandra's primary command-line tool for cluster management.

```bash
# Check cluster status
nodetool status

# Detailed node information
nodetool info

# Check ring topology
nodetool ring

# View compaction statistics
nodetool compactionstats

# Check thread pools
nodetool tpstats

# View gossip information
nodetool gossipinfo

# Check streaming operations
nodetool netstats
```

### **Keyspace Operations**
```sql
-- Create keyspace with NetworkTopologyStrategy
CREATE KEYSPACE ecommerce
WITH REPLICATION = {
  'class': 'NetworkTopologyStrategy',
  'datacenter1': 3,
  'datacenter2': 2
};

-- Alter keyspace replication
ALTER KEYSPACE ecommerce
WITH REPLICATION = {
  'class': 'NetworkTopologyStrategy',
  'datacenter1': 3,
  'datacenter2': 3
};

-- Drop keyspace
DROP KEYSPACE ecommerce;

-- List all keyspaces
DESCRIBE KEYSPACES;

-- Describe specific keyspace
DESCRIBE KEYSPACE ecommerce;
```

### **Table Operations**
```sql
-- Create table with options
CREATE TABLE products (
  product_id UUID PRIMARY KEY,
  name TEXT,
  price DECIMAL
) WITH
  bloom_filter_fp_chance = 0.01
  AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
  AND compaction = {'class': 'SizeTieredCompactionStrategy'}
  AND compression = {'sstable_compression': 'LZ4Compressor'};

-- Alter table
ALTER TABLE products ADD description TEXT;
ALTER TABLE products DROP price;

-- Truncate table (removes all data)
TRUNCATE products;

-- Drop table
DROP TABLE products;
```

## 📊 **Monitoring & Metrics**

### **System Metrics**
```bash
# JVM statistics
nodetool gcstats

# Memory usage
nodetool info | grep -E "(Heap|Off)"

# Cache statistics
nodetool caches

# Table statistics
nodetool tablestats ecommerce.products
```

### **Performance Metrics**
```sql
-- Query system tables
SELECT * FROM system.local;
SELECT * FROM system.peers;

-- View slow queries (if enabled)
SELECT * FROM system_traces.sessions LIMIT 10;

-- Check table metrics
SELECT keyspace_name, table_name, read_count, write_count
FROM system_metrics.table_metrics;
```

### **JMX Monitoring**
```bash
# Connect to JMX
jmxterm -l localhost:7199

# Get MBean info
bean org.apache.cassandra.metrics:type=ClientRequest,scope=Read,name=Latency

# Get attribute values
get TotalLatency
get 95thPercentile
```

## 🔄 **Replication & Consistency**

### **Repair Operations**
```bash
# Full repair (expensive, run during maintenance windows)
nodetool repair

# Incremental repair
nodetool repair -inc

# Repair specific keyspace
nodetool repair ecommerce

# Repair specific table
nodetool repair ecommerce products

# Preview repair
nodetool repair --dry-run
```

### **Consistency Level Tuning**
```sql
-- Check current consistency level
CONSISTENCY;

-- Set consistency for session
CONSISTENCY QUORUM;

-- Query with specific consistency
SELECT * FROM products WHERE product_id = ?
USING CONSISTENCY LOCAL_QUORUM;

INSERT INTO products (product_id, name)
VALUES (?, ?)
USING CONSISTENCY LOCAL_QUORUM;
```

### **Read Repair**
```sql
-- Configure read repair chance
ALTER TABLE products
WITH read_repair_chance = 0.1;

-- Force read repair
SELECT * FROM products WHERE product_id = ?
USING CONSISTENCY ALL;
```

## 🚨 **Failure Handling**

### **Node Failure Recovery**
```bash
# Check for dead nodes
nodetool status

# Remove dead node (after 72 hours)
nodetool removenode <dead_node_token>

# Replace dead node
nodetool replace <old_ip> <new_ip>

# Decommission node gracefully
nodetool decommission
```

### **Handling Hinted Handoffs**
```bash
# Check hinted handoffs
nodetool hintedhandoff

# Enable/disable hinted handoffs
nodetool disablehandoff
nodetool enablehandoff

# Clear old hints
nodetool truncatehints
```

### **Network Partition Recovery**
```bash
# Check for schema disagreements
nodetool describecluster

# Force schema agreement
nodetool resetlocalschema

# Check gossip state
nodetool gossipinfo
```

## 📈 **Scaling Operations**

### **Adding Nodes**
```bash
# 1. Configure new node
# Edit cassandra.yaml with correct cluster settings

# 2. Start new node
cassandra -f

# 3. Check if node joined
nodetool status

# 4. Run repair to populate data
nodetool repair
```

### **Removing Nodes**
```bash
# Decommission gracefully (preferred)
nodetool decommission

# Force remove (if node is down)
nodetool removenode <node_token>

# Check removal status
nodetool removenode status
```

### **Datacenter Operations**
```bash
# Add datacenter
ALTER KEYSPACE ecommerce
WITH REPLICATION = {
  'class': 'NetworkTopologyStrategy',
  'dc1': 3,
  'dc2': 3
};

# Rebuild datacenter
nodetool rebuild dc2

# Check datacenter status
nodetool status --resolve-ip
```

## 💾 **Backup & Recovery**

### **Snapshot-Based Backup**
```bash
# Create snapshot
nodetool snapshot ecommerce

# List snapshots
nodetool listsnapshots

# Clear snapshots
nodetool clearsnapshot

# Backup script
#!/bin/bash
KEYSPACE="ecommerce"
SNAPSHOT_NAME="backup_$(date +%Y%m%d_%H%M%S)"
nodetool snapshot -t $SNAPSHOT_NAME $KEYSPACE

# Copy snapshots to backup location
for node in $(nodetool status | awk '/UN/ {print $2}'); do
  rsync -av /var/lib/cassandra/data/$KEYSPACE/ backup-server:/backups/
done
```

### **Incremental Backup**
```bash
# Enable incremental backups
# In cassandra.yaml
incremental_backups: true

# Incremental backup location
# backups_directory: /var/lib/cassandra/backups

# List incremental backups
ls /var/lib/cassandra/backups/
```

### **Restore from Backup**
```bash
# Stop Cassandra
nodetool drain
sudo systemctl stop cassandra

# Clear data directories
sudo rm -rf /var/lib/cassandra/data/*
sudo rm -rf /var/lib/cassandra/commitlog/*
sudo rm -rf /var/lib/cassandra/saved_caches/*

# Restore from snapshot
sudo cp -r /backups/ecommerce/* /var/lib/cassandra/data/ecommerce/

# Start Cassandra
sudo systemctl start cassandra

# Run repair
nodetool repair
```

## 🔧 **Maintenance Tasks**

### **Compaction Management**
```bash
# Check compaction stats
nodetool compactionstats

# Force compaction
nodetool compact ecommerce products

# Stop compaction
nodetool stop COMPACTION

# Configure compaction strategy
ALTER TABLE products
WITH compaction = {
  'class': 'LeveledCompactionStrategy',
  'sstable_size_in_mb': 160
};
```

### **Flush and Cleanup**
```bash
# Flush memtables to disk
nodetool flush

# Clean up deleted data
nodetool cleanup

# Clear system caches
nodetool invalidatekeycache
nodetool invalidaterowcache
nodetool invalidatecountercache
```

### **Log Management**
```bash
# Rotate logs
nodetool drain

# Check log files
tail -f /var/log/cassandra/system.log
tail -f /var/log/cassandra/debug.log

# Enable debug logging
nodetool setlogginglevel org.apache.cassandra DEBUG
```

## 🐛 **Troubleshooting**

### **Common Issues**

#### **1. Unavailable Exception**
```
Exception: Cannot achieve consistency level QUORUM
```
**Solutions:**
```bash
# Check node status
nodetool status

# Check replication factor
DESCRIBE KEYSPACE ecommerce;

# Run repair
nodetool repair ecommerce
```

#### **2. Timeout Exceptions**
```
Exception: Operation timed out
```
**Solutions:**
```sql
-- Lower consistency level
CONSISTENCY ONE;

-- Increase timeouts in cassandra.yaml
read_request_timeout_in_ms: 10000
write_request_timeout_in_ms: 10000
```

#### **3. Out of Memory Errors**
**Solutions:**
```bash
# Increase heap size
# In cassandra-env.sh
JVM_OPTS="$JVM_OPTS -Xms8G -Xmx8G"

# Enable GC logging
JVM_OPTS="$JVM_OPTS -XX:+PrintGCDetails"

# Restart Cassandra
sudo systemctl restart cassandra
```

#### **4. Disk Space Issues**
```bash
# Check disk usage
df -h /var/lib/cassandra

# Check table sizes
nodetool tablestats | grep "Space used"

# Clear snapshots
nodetool clearsnapshot

# Run cleanup
nodetool cleanup
```

## 📊 **Performance Tuning**

### **Memory Tuning**
```bash
# JVM heap settings (cassandra-env.sh)
JVM_OPTS="$JVM_OPTS -Xms16G -Xmx16G"

# New generation size
JVM_OPTS="$JVM_OPTS -Xmn4G"

# GC tuning
JVM_OPTS="$JVM_OPTS -XX:+UseG1GC"
JVM_OPTS="$JVM_OPTS -XX:MaxGCPauseMillis=500"
```

### **Disk Tuning**
```yaml
# cassandra.yaml
concurrent_reads: 32
concurrent_writes: 32
concurrent_counter_writes: 16

# Compaction settings
compaction_throughput_mb_per_sec: 64

# Memtable settings
memtable_heap_space_in_mb: 2048
memtable_offheap_space_in_mb: 2048
```

### **Network Tuning**
```yaml
# cassandra.yaml
inter_dc_tcp_nodelay: true
internode_compression: dc

# Connection settings
native_transport_max_threads: 128
native_transport_max_frame_size_in_mb: 256
```

## 🧪 **Exercises**

### **Medium Level**
1. **Cluster Setup**
   - Set up a 3-node Cassandra cluster using Docker
   - Configure replication across nodes
   - Test failover by stopping nodes

2. **Monitoring Setup**
   - Configure nodetool monitoring
   - Set up basic alerting for key metrics
   - Create a monitoring dashboard

3. **Backup & Recovery**
   - Implement automated backup scripts
   - Test restore procedures
   - Validate backup integrity

### **Hard Level**
4. **Performance Optimization**
   - Tune JVM settings for high throughput
   - Optimize compaction strategies
   - Implement read/write optimizations

5. **Disaster Recovery**
   - Set up multi-datacenter replication
   - Implement cross-DC failover
   - Test disaster recovery procedures

6. **Troubleshooting Scenarios**
   - Diagnose and fix consistency issues
   - Resolve performance bottlenecks
   - Handle disk space emergencies

## 🔍 **Key Takeaways**
- **Nodetool**: Primary tool for cluster management and monitoring
- **Repair**: Essential for maintaining data consistency
- **Monitoring**: Critical for production deployments
- **Scaling**: Plan for growth and failure scenarios
- **Backup**: Regular backups are essential for data safety

## 📚 **Additional Resources**
- [Cassandra Operations](https://cassandra.apache.org/doc/latest/operating/)
- [Nodetool Documentation](https://cassandra.apache.org/doc/latest/tools/nodetool/)
- [Troubleshooting Guide](https://cassandra.apache.org/doc/latest/troubleshooting/)
- [Performance Tuning](https://cassandra.apache.org/doc/latest/operating/optimization.html)

## 🎯 **Next Steps**
Ready for performance optimization? Check out the next module on **Cassandra Performance Tuning** to learn advanced optimization techniques and best practices!