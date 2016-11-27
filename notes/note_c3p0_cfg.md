
**initialPoolSize, minPoolSize, maxPoolSize **
用来定义有多少个连接在池中，要确保minPoolSize <= maxPoolSize，不合理的initialPoolSize值将会被忽略,并且用minPoolSize来代替

acquireIncrement：
默认：3
当池中资源耗尽时，一次性获取的连接个数，

acquireRetryAttempts：
默认：30
在放弃获取连接之前尝试的次数，如果该值设为0或负数，表示尝试无穷多次

acquireRetryDelay：
默认：1000（毫秒）
两次尝试获取资源的时间间隔

autoCommitOnClose：
Default: false


automaticTestTable
Default: null

breakAfterAcquireFailure
Default: false


##### 管理连接池大小及连接年龄（Age)
默认情况下，池不会让连接过期,如果你想保持连接新鲜，可以设置maxConnectionAge或maxIdleTime这两个参数。






连接超时时间，默认2000ms

poolConfig = {JedisPoolConfig@4494}
	JedisPoolConfig对一些参数的默认设置如下：
	testWhileIdle=true
	minEvictableIdleTimeMills=60000
	timeBetweenEvictionRunsMillis=30000
	numTestsPerEvictionRun=-1

 // pool能分配的最大的对象个数，负数意味着无穷大
 maxTotal = 10000,  default：8

 // 最大空闲对象个数
 maxIdle = 10 （8）

 // 最小空闲对象个数
 minIdle = 0 （0）

 // 是否采用后进先出策略(last in, first out)
 lifo = true (true)
 
 // 当从池中获取资源或者将资源还回池中时 是否使用公平锁机制 
 fairness = false (false)
 
 // 当调用borrowObject方法时，如果池中没有对象返回，等待的最大时间（毫秒）
 maxWaitMillis = 10000 (-1)
 
 // 可被清理的最小空闲时间，也就是说对象空闲至少这么多时间才能被Evictor选中
 minEvictableIdleTimeMillis = 60000 ( 60000)

 // 可被清理的最小空闲时间，外加额外条件：池中必须保留minIdle个对象，
 // 如果设置了minEvictableIdleTimeMillis值，那么softMinEvictableIdleTimeMillis将会被覆盖
 softMinEvictableIdleTimeMillis = 1800000 (-1)

 numTestsPerEvictionRun = -1 (-1)

 // 驱逐策略类全限定名
 evictionPolicyClassName = {String@4509} "org.apache.commons.pool2.impl.DefaultEvictionPolicy" (org.apache.commons.pool2.impl.DefaultEvictionPolicy)
 
 // borrowObject方法返回之前，验证为pool创建的对象的有效性
 testOnCreate = false (false) 
 
 // borrowObject方法返回之前，验证返回对象的有效性
 testOnBorrow = true (false)
 
 // 对象返回到pool中验证有效性
 testOnReturn = true (false)
 
 // 是否对池中闲置对象进行有效性验证（
 // 验证工作是由idle object evictor做的，检查周期由timeBetweenEvictionRunsMillis决定
 // 如果验证不通过，该对象要被移除出pool并销毁
 testWhileIdle = true (false)
 
 // 过期对象驱逐者定时器（idle object evictor）执行的时间间隔（毫秒）,如果为负数，则evictor不运行
 timeBetweenEvictionRunsMillis = 30000 (30000)
 
 // 当调用borrowObject方法时，如果池中没有对象时，是否阻塞还是立即抛出异常
 blockWhenExhausted = true (true)
 
 jmxEnabled = true (true)
 jmxNamePrefix = {String@4510} "pool" (pool)
 jmxNameBase = {String@4510} "pool"

