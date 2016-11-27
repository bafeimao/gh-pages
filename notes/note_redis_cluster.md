default slots: 16384, (avg:5461)

** 重新分片 **
$ ./redis-trib.rb reshard 127.0.0.1:7000

重新分片后执行健康检查






TODO:
- [] 手动执行故障恢复
- [] 执行故障恢复


### 集群健康检查

$ ./redis-trib.rb check 127.0.0.1:7000

```
>>> Performing Cluster Check (using node 127.0.0.1:7000)
M: 10ac24757328c02a4a271edec5466f189c4db4c1 127.0.0.1:7000
   slots:500-5460 (4961 slots) master
   1 additional replica(s)
S: 4ca3ac0b0ce1c1dffec0a85457d729522607f996 127.0.0.1:7003
   slots: (0 slots) slave
   replicates 10ac24757328c02a4a271edec5466f189c4db4c1
M: e7c5039677cdce24486a54c2f47cc90319240730 127.0.0.1:7001
   slots:0-499,5461-11422 (6462 slots) master
   1 additional replica(s)
S: edfbcf234110669ba74cd222da26985712470913 127.0.0.1:7005
   slots: (0 slots) slave
   replicates 9bfa5f4cb76442048aff5accd6b1cc58040d078e
S: 17a3eb9e0e987fbd3235ce93d72ce2c3dd0fd7b3 127.0.0.1:7004
   slots: (0 slots) slave
   replicates e7c5039677cdce24486a54c2f47cc90319240730
M: 9bfa5f4cb76442048aff5accd6b1cc58040d078e 127.0.0.1:7002
   slots:11423-16383 (4961 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```

恭喜一线，一线机会远大于二线三线，财富增值幅度远大于二三线
二三线城市，接入成本低，蒸蒸日上
会赚钱，会投资，最后购买不动产，沉淀财富
勤劳是不能致富的，一定要重视资本的力量
教课书上的很多东西未必是真实有效的
西方经济学，正统经济学理论，不能生搬硬套，因为正统原理是基于理性经纪人
所有的经济都是为政治服务的
资源是稀缺的，永远都不能平均分配的，注定掌握在少部分人手里
真相往往是残忍的，真理永远只掌握在少数人手里
工人庞大，注定不会伟大
政府，调控，用嘴打压，用心救市，这么做的对的，话是说给所有人听的，但真话只有少数人才能听到，不然就乱套了
站到少数人队伍中
大量砖家生搬硬套经济学原理，所以经常会错。
-------------------------------------------------------
不要买远大大
十年以后的今天，对于大部分的老百姓来说多多少少都已经有房子了
中国现在不缺房子了，而是缺好房子
今年开始（2016）已经进入一个分化的过程
大量的人希望卖旧换新
存量会越来越多，每在一线城市买套房子，就会在三四线城市留下3套存量房
向上买房子，去选择你能承受的最小面积最大单价，强者很强
社会资源属性的兑现，北三环学区房以前3w，现在10w





也可以通过指定参数的形式不需要询问并手动输入参数

$ ./redis-trib.rb reshard --from <node-id> --to <node-id> --slots <number of slots> --yes <host>:<port>


测试故障转移，将7002设置为故障后，运行consistency-test的终端输出大量的错误警告信息：
235988 R (0 err) | 235988 W (0 err) | 
238276 R (0 err) | 238276 W (0 err) | 
240534 R (0 err) | 240534 W (0 err) | 


=== REDIS BUG REPORT START: Cut & paste starting from here ===
13738:M 07 Sep 11:25:38.135 # Redis 3.2.3 crashed by signal: 11
13738:M 07 Sep 11:25:38.135 # Crashed running the instuction at: 0x45d080
13738:M 07 Sep 11:25:38.135 # Accessing address: 0xffffffffffffffff
13738:M 07 Sep 11:25:38.135 # Failed assertion: <no assertion failed> (<no file>:0)

------ STACK TRACE ------
EIP:
./redis-server *:7002 [cluster](debugCommand+0x230)[0x45d080]

Backtrace:
./redis-server *:7002 [cluster](logStackTrace+0x3c)[0x45bd5c]
./redis-server *:7002 [cluster](sigsegvHandler+0xa1)[0x45cc41]
/lib64/libpthread.so.0(+0xf710)[0x7fc161b93710]
./redis-server *:7002 [cluster](debugCommand+0x230)[0x45d080]
./redis-server *:7002 [cluster](call+0x72)[0x424192]
./redis-server *:7002 [cluster](processCommand+0x365)[0x428d75]
./redis-server *:7002 [cluster](processInputBuffer+0x109)[0x435089]
./redis-server *:7002 [cluster](aeProcessEvents+0x13d)[0x41f86d]
./redis-server *:7002 [cluster](aeMain+0x2b)[0x41fb6b]
./redis-server *:7002 [cluster](main+0x370)[0x427220]
/lib64/libc.so.6(__libc_start_main+0xfd)[0x7fc16180ed1d]
./redis-server *:7002 [cluster][0x41d039]

------ INFO OUTPUT ------
# Server
redis_version:3.2.3
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:ff6807a0d69d29c6
redis_mode:cluster
os:Linux 2.6.32-042stab090.3 x86_64
arch_bits:64
multiplexing_api:epoll
gcc_version:4.4.7
process_id:13738
run_id:01db8d6930d0d4dd740c6672a3138c430e5e6ef0
tcp_port:7002
uptime_in_seconds:55047
uptime_in_days:0
hz:10
lru_clock:13600946
executable:/data/redis-cluster/7002/./redis-server
config_file:/data/redis-cluster/7002/./redis.conf

# Clients
connected_clients:2
client_longest_output_list:0
client_biggest_input_buf:0
blocked_clients:0

# Memory
used_memory:3538520
used_memory_human:3.37M
used_memory_rss:5378048
used_memory_rss_human:5.13M
used_memory_peak:3538520
used_memory_peak_human:3.37M
total_system_memory:33521328128
total_system_memory_human:31.22G
used_memory_lua:37888
used_memory_lua_human:37.00K
maxmemory:0
maxmemory_human:0B
maxmemory_policy:noeviction
mem_fragmentation_ratio:1.52
mem_allocator:jemalloc-4.0.3

# Persistence
loading:0
rdb_changes_since_last_save:92909
rdb_bgsave_in_progress:0
rdb_last_save_time:1473164081
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:0
rdb_current_bgsave_time_sec:-1
aof_enabled:1
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok
aof_current_size:5239771
aof_base_size:0
aof_pending_rewrite:0
aof_buffer_length:0
aof_rewrite_buffer_length:0
aof_pending_bio_fsync:0
aof_delayed_fsync:0

# Stats
total_connections_received:10
total_commands_processed:242257
instantaneous_ops_per_sec:1375
total_net_input_bytes:12684268
total_net_output_bytes:12376531
instantaneous_input_kbps:75.08
instantaneous_output_kbps:47.23
rejected_connections:0
sync_full:1
sync_partial_ok:0
sync_partial_err:0
expired_keys:0
evicted_keys:0
keyspace_hits:86931
keyspace_misses:5978
pubsub_channels:0
pubsub_patterns:0
latest_fork_usec:203
migrate_cached_sockets:0

# Replication
role:master
connected_slaves:1
slave0:ip=127.0.0.1,port=7005,state=online,offset=5288790,lag=1
master_repl_offset:5315960
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:4267385
repl_backlog_histlen:1048576

# CPU
used_cpu_sys:42.00
used_cpu_user:32.28
used_cpu_sys_children:0.00
used_cpu_user_children:0.00

# Commandstats
cmdstat_get:calls=92909,usec=238568,usec_per_call=2.57
cmdstat_set:calls=1,usec=23,usec_per_call=23.00
cmdstat_incr:calls=92908,usec=252654,usec_per_call=2.72
cmdstat_ping:calls=5,usec=7,usec_per_call=1.40
cmdstat_psync:calls=1,usec=358,usec_per_call=358.00
cmdstat_replconf:calls=54410,usec=99037,usec_per_call=1.82
cmdstat_info:calls=2,usec=100,usec_per_call=50.00
cmdstat_cluster:calls=2020,usec=16461,usec_per_call=8.15
cmdstat_command:calls=1,usec=663,usec_per_call=663.00

# Cluster
cluster_enabled:1

# Keyspace
db0:keys=5979,expires=0,avg_ttl=0
hash_init_value: 1472613083

------ CLIENT LIST OUTPUT ------
id=3 addr=127.0.0.1:3470 fd=10 name= age=54657 idle=0 flags=S db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=0 obl=0 oll=0 omem=0 events=r cmd=replconf
id=10 addr=127.0.0.1:42600 fd=21 name= age=107 idle=0 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=32768 obl=0 oll=0 omem=0 events=r cmd=incr
id=11 addr=127.0.0.1:42815 fd=22 name= age=0 idle=0 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=32768 obl=0 oll=0 omem=0 events=r cmd=debug

------ CURRENT CLIENT INFO ------
id=11 addr=127.0.0.1:42815 fd=22 name= age=0 idle=0 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=32768 obl=0 oll=0 omem=0 events=r cmd=debug
argv[0]: 'debug'
argv[1]: 'segfault'

------ REGISTERS ------
13738:M 07 Sep 11:25:38.159 # 
RAX:0000000000000000 RBX:00007fc159bb2d80
RCX:0000000000000000 RDX:00007fc161933080
RDI:00007fc159b6a2d3 RSI:00000000004e76cf
RBP:00007fc159b454b0 RSP:00007fffa9dd1ba0
R8 :0000000000000000 R9 :0000000000000001
R10:00007fc16191cec0 R11:0000000000000000
R12:00007fc159b6a2d3 R13:0000000000000002
R14:00007fc159b454b0 R15:00053be277902331
RIP:000000000045d080 EFL:0000000000010246
CSGSFS:0000000000000033
13738:M 07 Sep 11:25:38.159 # (00007fffa9dd1baf) -> 0000000000000000
13738:M 07 Sep 11:25:38.159 # (00007fffa9dd1bae) -> 0000000000000000
13738:M 07 Sep 11:25:38.159 # (00007fffa9dd1bad) -> 0000000000000000
13738:M 07 Sep 11:25:38.159 # (00007fffa9dd1bac) -> 0000000000000000
13738:M 07 Sep 11:25:38.159 # (00007fffa9dd1bab) -> 0000000000000000
13738:M 07 Sep 11:25:38.159 # (00007fffa9dd1baa) -> 0000000000000000
13738:M 07 Sep 11:25:38.159 # (00007fffa9dd1ba9) -> 0000000000000000
13738:M 07 Sep 11:25:38.159 # (00007fffa9dd1ba8) -> 3163346264346339
13738:M 07 Sep 11:25:38.159 # (00007fffa9dd1ba7) -> 3831663636343563
13738:M 07 Sep 11:25:38.159 # (00007fffa9dd1ba6) -> 6564653137326134
13738:M 07 Sep 11:25:38.159 # (00007fffa9dd1ba5) -> 6132306338323337
13738:M 07 Sep 11:25:38.159 # (00007fffa9dd1ba4) -> 3537343263613031
13738:M 07 Sep 11:25:38.159 # (00007fffa9dd1ba3) -> 1579520000000000
13738:M 07 Sep 11:25:38.159 # (00007fffa9dd1ba2) -> 0100000000000000
13738:M 07 Sep 11:25:38.159 # (00007fffa9dd1ba1) -> 0700000000000000
13738:M 07 Sep 11:25:38.159 # (00007fffa9dd1ba0) -> 0300010000000000

------ FAST MEMORY TEST ------
13738:M 07 Sep 11:25:38.160 # Bio thread for job type #0 terminated
13738:M 07 Sep 11:25:38.160 # Bio thread for job type #1 terminated
*** Preparing to test memory region 721000 (94208 bytes)
*** Preparing to test memory region 2419000 (135168 bytes)
*** Preparing to test memory region 7fc159a00000 (2097152 bytes)
*** Preparing to test memory region 7fc159dff000 (10485760 bytes)
*** Preparing to test memory region 7fc15a800000 (12582912 bytes)
*** Preparing to test memory region 7fc161400000 (2097152 bytes)
*** Preparing to test memory region 7fc161b7f000 (20480 bytes)
*** Preparing to test memory region 7fc161d9d000 (16384 bytes)
*** Preparing to test memory region 7fc16243b000 (16384 bytes)
*** Preparing to test memory region 7fc162445000 (12288 bytes)
*** Preparing to test memory region 7fc16244a000 (4096 bytes)
.O.O.O.O.O.O.O.O.O.O.O
Fast memory test PASSED, however your memory can still be broken. Please run a memory test for several hours if possible.
=== REDIS BUG REPORT END. Make sure to include from START to END. ===

       Please report the crash by opening an issue on github:

           http://github.com/antirez/redis/issues

  Suspect RAM error? Use redis-server --test-memory to verify it.

Reading: Connection lost (ECONNRESET)
13747:S 07 Sep 11:25:38.271 # Connection with master lost.
13747:S 07 Sep 11:25:38.271 * Caching the disconnected master state.
13747:S 07 Sep 11:25:38.425 * Connecting to MASTER 127.0.0.1:7002
13747:S 07 Sep 11:25:38.425 * MASTER <-> SLAVE sync started
13747:S 07 Sep 11:25:38.425 # Error condition on socket for SYNC: Connection refused
Writing: Too many Cluster redirections? (last error: MOVED 13063 127.0.0.1:7002)
Reading: Too many Cluster redirections? (last error: MOVED 11493 127.0.0.1:7002)
13747:S 07 Sep 11:25:39.436 * Connecting to MASTER 127.0.0.1:7002
13747:S 07 Sep 11:25:39.436 * MASTER <-> SLAVE sync started
13747:S 07 Sep 11:25:39.436 # Error condition on socket for SYNC: Connection refused
Writing: Too many Cluster redirections? (last error: MOVED 11493 127.0.0.1:7002)
240828 R (2 err) | 240828 W (2 err) | 
13747:S 07 Sep 11:25:40.445 * Connecting to MASTER 127.0.0.1:7002
13747:S 07 Sep 11:25:40.446 * MASTER <-> SLAVE sync started
13747:S 07 Sep 11:25:40.446 # Error condition on socket for SYNC: Connection refused
Reading: Too many Cluster redirections? (last error: MOVED 16080 127.0.0.1:7002)
Writing: Too many Cluster redirections? (last error: MOVED 16080 127.0.0.1:7002)
240833 R (3 err) | 240833 W (3 err) | 
13747:S 07 Sep 11:25:41.452 * Connecting to MASTER 127.0.0.1:7002
13747:S 07 Sep 11:25:41.452 * MASTER <-> SLAVE sync started
13747:S 07 Sep 11:25:41.452 # Error condition on socket for SYNC: Connection refused
Reading: Too many Cluster redirections? (last error: MOVED 14831 127.0.0.1:7002)
13747:S 07 Sep 11:25:42.459 * Connecting to MASTER 127.0.0.1:7002
13747:S 07 Sep 11:25:42.459 * MASTER <-> SLAVE sync started
13747:S 07 Sep 11:25:42.459 # Error condition on socket for SYNC: Connection refused
Writing: Too many Cluster redirections? (last error: MOVED 14831 127.0.0.1:7002)
240833 R (4 err) | 240833 W (4 err) | 
Reading: Too many Cluster redirections? (last error: MOVED 15150 127.0.0.1:7002)
13747:S 07 Sep 11:25:43.469 * Connecting to MASTER 127.0.0.1:7002
13747:S 07 Sep 11:25:43.469 * MASTER <-> SLAVE sync started
13747:S 07 Sep 11:25:43.469 # Error condition on socket for SYNC: Connection refused
Writing: Too many Cluster redirections? (last error: MOVED 15150 127.0.0.1:7002)
240837 R (5 err) | 240837 W (5 err) | 
Reading: Too many Cluster redirections? (last error: MOVED 14947 127.0.0.1:7002)
13719:M 07 Sep 11:25:44.404 * Marking node 9bfa5f4cb76442048aff5accd6b1cc58040d078e as failing (quorum reached).
13719:M 07 Sep 11:25:44.404 # Cluster state changed: fail
13741:S 07 Sep 11:25:44.404 * FAIL message received from 10ac24757328c02a4a271edec5466f189c4db4c1 about 9bfa5f4cb76442048aff5accd6b1cc58040d078e
13741:S 07 Sep 11:25:44.404 # Cluster state changed: fail
13747:S 07 Sep 11:25:44.404 * FAIL message received from 10ac24757328c02a4a271edec5466f189c4db4c1 about 9bfa5f4cb76442048aff5accd6b1cc58040d078e
13747:S 07 Sep 11:25:44.404 # Cluster state changed: fail
13727:M 07 Sep 11:25:44.405 * FAIL message received from 10ac24757328c02a4a271edec5466f189c4db4c1 about 9bfa5f4cb76442048aff5accd6b1cc58040d078e
13727:M 07 Sep 11:25:44.405 # Cluster state changed: fail
13744:S 07 Sep 11:25:44.405 * FAIL message received from 10ac24757328c02a4a271edec5466f189c4db4c1 about 9bfa5f4cb76442048aff5accd6b1cc58040d078e
13744:S 07 Sep 11:25:44.405 # Cluster state changed: fail
13747:S 07 Sep 11:25:44.477 * Connecting to MASTER 127.0.0.1:7002
13747:S 07 Sep 11:25:44.477 * MASTER <-> SLAVE sync started
13747:S 07 Sep 11:25:44.477 # Start of election delayed for 821 milliseconds (rank #0, offset 5315960).
13747:S 07 Sep 11:25:44.477 # Error condition on socket for SYNC: Connection refused
Writing: CLUSTERDOWN The cluster is down
240839 R (6 err) | 240839 W (6 err) | 
Reading: CLUSTERDOWN The cluster is down
Reading: CLUSTERDOWN The cluster is down
Writing: CLUSTERDOWN The cluster is down
240839 R (414 err) | 240839 W (414 err) | 
13747:S 07 Sep 11:25:45.384 # Starting a failover election for epoch 8.
13727:M 07 Sep 11:25:45.386 # Failover auth granted to edfbcf234110669ba74cd222da26985712470913 for epoch 8
13719:M 07 Sep 11:25:45.386 # Failover auth granted to edfbcf234110669ba74cd222da26985712470913 for epoch 8
13747:S 07 Sep 11:25:45.386 # Failover election won: I'm the new master.
13747:S 07 Sep 11:25:45.386 # configEpoch set to 8 after successful failover
13747:M 07 Sep 11:25:45.386 * Discarding previously cached master state.
13747:M 07 Sep 11:25:45.386 # Cluster state changed: ok
13744:S 07 Sep 11:25:45.388 # Cluster state changed: ok
13719:M 07 Sep 11:25:45.427 # Cluster state changed: ok
13727:M 07 Sep 11:25:45.428 # Cluster state changed: ok
13741:S 07 Sep 11:25:45.428 # Cluster state changed: ok
241780 R (810 err) | 241780 W (810 err) | 
244170 R (810 err) | 244170 W (810 err) | 

