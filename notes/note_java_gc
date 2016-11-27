note_java_gc

young（Eden+Survivor(From+To)), old, permanent


Permanent:
Class & Meta, ClassLoader -> PermGen space
GC在主程序运行期不会对PermGen进行清理

4． Minor GC后，Eden是空的吗？
是的，Minor GC会把Eden中的所有活的对象都移到Survivor区域中，如果Survivor区中放不下，那么剩下的活的对象就被移到Old generation 中。

-XX:NewSize=n :设置年轻代大小 

-XX:NewRatio=n: 
设置年轻代和年老代的比值。如:为3，表示年轻代与年老代比值为1：3，年轻代占整个年轻代年老代和的1/4 

-XX:SurvivorRatio=n :
年轻代中Eden区与两个Survivor区的比值。注意Survivor区有两个。如：3，表示Eden：Survivor=3：2，一个Survivor区占整个年轻代的1/5 

-XX:MaxPermSize=n :设置持久代大小 

收集器设置 
-XX:+UseSerialGC :设置串行收集器 
-XX:+UseParallelGC :设置并行收集器 
-XX:+UseParalledlOldGC :设置并行年老代收集器 
-XX:+UseConcMarkSweepGC :设置并发收集器 

垃圾回收统计信息 
-XX:+PrintGC 
-XX:+PrintGCDetails 
-XX:+PrintGCTimeStamps 
-Xloggc:filename 

并行收集器设置 
-XX:ParallelGCThreads=n :设置并行收集器收集时使用的CPU数。并行收集线程数。 
-XX:MaxGCPauseMillis=n :设置并行收集最大暂停时间 
-XX:GCTimeRatio=n :设置垃圾回收时间占程序运行时间的百分比。公式为1/(1+n) 

并发收集器设置 
-XX:+CMSIncrementalMode :设置为增量模式。适用于单CPU情况。 
-XX:ParallelGCThreads=n :设置并发收集器年轻代收集方式为并行收集时，使用的CPU数。并行收集线程数。

默认空余堆内存小于40%时，JVM就会增大堆直到-Xmx的最大限制，可以由-XX:MinHeapFreeRatio=指定
默认空余堆内存大于70%时，JVM会减少堆直到-Xms的最小限制，可以由-XX:MaxHeapFreeRatio=指定。

服务器一般设置-Xms、-Xmx相等以避免在每次GC 后调整堆的大小。  

Young(Nursery)，年轻代。研究表明大部分对象都是朝生暮死，随生随灭的。因此所有收集器都为年轻代选择了复制算法。

Young（年轻代）
年 轻代分三个区。一个Eden区，两个Survivor区。大部分对象在Eden区中生成。当Eden区满时，还存活的对象将被复制到Survivor区 （两个中的一个），当这个Survivor区满时，此区的存活对象将被复制到另外一个Survivor区，当这个Survivor去也满了的时候，从第一 个Survivor区复制过来的并且此时还存活的对象，将被复制“年老区(Tenured)”。需要注意，Survivor的两个区是对称的，没先后关 系，所以同一个区中可能同时存在从Eden复制过来 对象，和从前一个Survivor复制过来的对象，而复制到年老区的只有从第一个Survivor去过来的对象。而且，Survivor区总有一个是空 的。
Tenured（年老代）
年老代存放从年轻代存活的对象。一般来说年老代存放的都是生命期较长的对象。

Perm（持久代）
用 于存放静态文件，如今Java类、方法等。持久代对垃圾回收没有显著影响，但是有些应用可能动态生成或者调用一些class，例如Hibernate等， 在这种时候需要设置一个比较大的持久代空间来存放这些运行过程中新增的类。持久代大小通过-XX:MaxPermSize=<N>进行设置。

gc分为full gc 跟 minor gc，当每一块区满的时候都会引发gc。

Scavenge GC 
一般情况下，当新对象生成，并且在Eden申请空间失败时，就触发了Scavenge GC，堆Eden区域进行GC，清除非存活对象，并且把尚且存活的对象移动到Survivor区。然后整理Survivor的两个区。

对整个堆进行整理，包括Young、Tenured和Perm。Full GC比Scavenge GC要慢，因此应该尽可能减少Full GC。有如下原因可能导致Full GC：
Tenured被写满
Perm域被写满
System.gc()被显示调用
上一次GC之后Heap的各域分配策略动态变化

1：垃圾收集器介绍。
# 串行收集器  
    使用单线程处理所有垃圾回收工作，因为无需多线程交互，所以效率比较高。但是，也无法使用多处理器的优势，所以此收集器适合单处理器机器。当然，此收集器也可以用在小数据量（100M左右）情况下的多处理器机器上。可以使用-XX:+UseSerialGC打开。

# 并行收集器 
   1. 对年轻代进行并行垃圾回收，因此可以减少垃圾回收时间。一般在多线程多处理器机器上使用。使用-XX:+UseParallelGC.打开。并行收集器在J2SE5.0第六6更新上引入，在Java SE6.0中进行了增强--可以堆年老代进行并行收集。如果年老代不使用并发收集的话，是使用单线程进行垃圾回收，因此会制约扩展能力。使用-XX:+UseParallelOldGC打开。

   2. 使用-XX:ParallelGCThreads=<N>设置并行垃圾回收的线程数。此值可以设置与机器处理器数量相等。

   3. 此收集器可以进行如下配置：
          * 最大垃圾回收暂停:指定垃圾回收时的最长暂停时间，通过-XX:MaxGCPauseMillis=<N>指定。<N>为毫秒.如果指定了此值的话，堆大小和垃圾回收相关参数会进行调整以达到指定值。设定此值可能会减少应用的吞吐量。
          * 吞吐量:吞吐量为垃圾回收时间与非垃圾回收时间的比值，通过-XX:GCTimeRatio=<N>来设定，公式为1/（1+N）。例如，-XX:GCTimeRatio=19时，表示5%的时间用于垃圾回收。默认情况为99，即1%的时间用于垃圾回收。

# 并发收集器 
可以保证大部分工作都并发进行（应用不停止），垃圾回收只暂停很少的时间，此收集器适合对响应时间要求比较高的中、大规模应用。使用-XX:+UseConcMarkSweepGC打开。

# 小结

    * 串行处理器：
       --适用情况：数据量比较小（100M左右）；单处理器下并且对响应时间无要求的应用。
       --缺点：只能用于小型应用
    * 并行处理器：
       --适用情况：“对吞吐量有高要求”，多CPU、对应用响应时间无要求的中、大型应用。举例：后台处理、科学计算。
       --缺点：应用响应时间可能较长
    * 并发处理器：传说中的CMS
       --适用情况：“对响应时间有高要求”，多CPU、对应用响应时间有较高要求的中、大型应用。举例：Web服务器/应用服务器、电信交换、集成开发环境。


2.基本收集算法 

   1. 复制：将堆内分成两个相同空间，从根(ThreadLocal的对象，静态对象）开始访问每一个关联的活跃对象，将空间A的活跃对象全部复制到空间B，然后一次性回收整个空间A。
      因为只访问活跃对象，将所有活动对象复制走之后就清空整个空间，不用去访问死对象，所以遍历空间的成本较小，但需要巨大的复制成本和较多的内存。
   2. 标记清除(mark-sweep)：收集器先从根开始访问所有活跃对象，标记为活跃对象。然后再遍历一次整个内存区域，把所有没有标记活跃的对象进行回收处理。该算法遍历整个空间的成本较大暂停时间随空间大小线性增大，而且整理后堆里的碎片很多。
   3. 标记整理(mark-sweep-compact)：综合了上述两者的做法和优点，先标记活跃对象，然后将其合并成较大的内存块。
    可见，没有免费的午餐，无论采用复制还是标记清除算法，自动的东西都要付出很大的性能代价。  


















什么时候从young->old, 什么时候从old->permanent


