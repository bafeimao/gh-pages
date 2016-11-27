自JDK7u4开始支持G1，用于服务器程序，目标是多处理器以及大内存机器，

G1具备如下特点：
并行与并发：G1能充分利用多CPU、多核环境下的硬件优势，使用多个CPU（CPU或者CPU核心）来缩短Stop-The-World停顿的时间，部分其他收集器原本需要停顿Java线程执行的GC动作，G1收集器仍然可以通过并发的方式让Java程序继续执行。

分代收集：与其他收集器一样，分代概念在G1中依然得以保留。虽然G1可以不需其他收集器配合就能独立管理整个GC堆，但它能够采用不同的方式去处理新创建的对象和已经存活了一段时间、熬过多次GC的旧对象以获取更好的收集效果。






















Hotspot JVM架构：
ClassLoader ,运行期数据区域（runtime data areas), 执行引擎（JIT compiler + GC)

JVM内部关键的几个部分：
heap, JIT compiler, GC



性能调优主要目标一般有两个：响应性，吞吐率

throughput:
单位时间内处理的交易
单位时间内处理的jobs
单位时间内处理的数据库请求
等等

G1 is a server-style garbage collector,

G1 is designed for application that:
1. 和应用程序线程并行操作，类似于CMS收集器（ Concurrent Mark-Sweep Collector (CMS)）
2. 

One difference is that G1 is a compacting collector



Serial， paralel, CMS

sections:
young, old(tenured), permanent(permanent)
young = eden + survivor (= s0 + s1)

heap regions
c
