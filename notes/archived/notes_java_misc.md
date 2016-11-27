-Xms100m -Xmx150m -Dserver.id=1 -Djdbc.catalog=inuyasha-server-dev1 -XX:NewRatio=4 -XX:MaxPermSize=59m

## jstat

C:\Users\Administrator>jstat -help
Usage: jstat -help|-options
       jstat -<option> [-t] [-h<lines>] <vmid> [<interval> [<count>]]

Definitions:
  <option>      An option reported by the -options option
  <vmid>        Virtual Machine Identifier. A vmid takes the following form:
                     <lvmid>[@<hostname>[:<port>]]
                Where <lvmid> is the local vm identifier for the target
                Java virtual machine, typically a process id; <hostname> is
                the name of the host running the target Java virtual machine;
                and <port> is the port number for the rmiregistry on the
                target host. See the jvmstat documentation for a more complete
                description of the Virtual Machine Identifier.
  <lines>       Number of samples between header lines.
  <interval>    Sampling interval. The following forms are allowed:
                    <n>["ms"|"s"]
                Where <n> is an integer and the suffix specifies the units as
                milliseconds("ms") or seconds("s"). The default units are "ms".
  <count>       Number of samples to take before terminating.
  -J<flag>      Pass <flag> directly to the runtime system.

C:\Users\Administrator>jstat -options
-class
-compiler
-gc
-gccapacity
-gccause
-gcnew
-gcnewcapacity
-gcold
-gcoldcapacity
-gcpermcapacity
-gcutil
-printcompilation

ImportNew
首页所有文章资讯Web架构基础技术书籍教程Java小组工具资源
成为JavaGC专家（2）—如何监控Java垃圾回收机制
2012/12/28 | 分类： 基础技术, 教程 | 3 条评论 | 标签： GC, JAVAGC专家, JVM
分享到： 98
本文作者： ImportNew - 王晓杰 未经许可，禁止转载！
本文是成为Java GC专家系列文章的第二篇。在第一篇《深入浅出Java垃圾回收机制》中我们学习了不同GC算法的执行过程，GC是如何工作的，什么是新生代和老年代，你应该了解的JDK7中的5种GC类型，以及这5种类型对于应用性能的影响。

在本文中，我将解释JVM到底是如何执行垃圾回收处理的。

什么是GC监控？

垃圾回收收集监控指的是搞清楚JVM如何执行GC的过程，例如，我们可以查明：

1.        何时一个新生代中的对象被移动到老年代时，所花费的时间。

2.       Stop-the-world 何时发生的，持续了多长时间。

GC监控是为了鉴别JVM是否在高效地执行GC，以及是否有必要进行额外的性能调优。基于以上信息，我们可以修改应用程序或者调整GC算法（GC优化）。

如何监控GC

有很多种方法可以监控GC，但其差别仅仅是GC操作通过何种方式展现而已。GC操作是由JVM来完成，而GC监控工具只是将JVM提供的GC信息展现给你，因此，不论你使用何种方式监控GC都将得到相同的结果。所以你也就不必去学习所有的监控GC的方法。但是因为学习每种监控方法不会占用太多时间，了解多一点可以帮助你根据不同的场景选择最为合适的方式。

下面所列的工具以及JVM参数并不适用于所有的HVM供应商。这是因为并没有关于GC信息的强制标准。本文我们将使用HotSpot JVM (Oracle JVM)。因为NHN 一直在使用Oracle (Sun) JVM，所以用它作为示例来解释我们提到的工具和JVM参数更容易些。
首先，GC监控方法根据访问的接口不同，可以分成CUI 和GUI 两大类。CUI GC监控方法使用一个独立的叫做”jstat”的CUI应用，或者在启动JVM的时候选择JVM参数”verbosegc”。
GUI GC监控由一个单独的图形化应用来完成，其中三个最常用的应用是”jconsole”, “jvisualvm” 和 “Visual GC”。
下面我们来详细学习每种方法。

jstat

jstat 是HotSpot JVM提供的一个监控工具。其他监控工具还有jps 和jstatd。有些时候，你可能需要同时使用三种工具来监控你的应用。jstat 不仅提供GC操作的信息，还提供类装载操作的信息以及运行时编译器操作的信息。本文将只涉及jstat能够提供的信息中与监控GC操作信息相关的功能。
jstat 被放置在$JDK_HOME/bin。因此只要java 和 javac能执行，jstat 同样可以执行。
你可以在命令行环境下执行如下语句。

 

1
2
3
4
5
6
7
8
$> jstat –gc  $<vmid$> 1000
 
S0C       S1C       S0U    S1U      EC         EU          OC         OU         PC         PU         YGC     YGCT    FGC      FGCT     GCT
3008.0   3072.0    0.0     1511.1   343360.0   46383.0     699072.0   283690.2   75392.0    41064.3    2540    18.454    4      1.133    19.588
3008.0   3072.0    0.0     1511.1   343360.0   47530.9     699072.0   283690.2   75392.0    41064.3    2540    18.454    4      1.133    19.588
3008.0   3072.0    0.0     1511.1   343360.0   47793.0     699072.0   283690.2   75392.0    41064.3    2540    18.454    4      1.133    19.588
 
$>
在上图的例子中，实际的数据会按照如下列输出：

1
S0C    S1C     S0U     S1U    EC     EU     OC     OU     PC
vmid (虚拟机 ID)，正如其名字描述的，它是虚拟机的ID，Java应用不论运行在本地还是远程的机器都会拥有自己独立的vmid。运行在本地机器上的vmid称之为lvmid (本地vmid)，通常是PID。如果想得到PID的值你可以使用ps命令或者windows任务管理器，但我们推荐使用jps来获取，因为PID和lvmid有时会不一致。jps 通过Java PS实现，jps命令会返回vmids和main方法的信息，正如ps命令展现PIDS和进程名字那样。
首先通过jps命令找到你要监控的Java应用的vmid，并把它作为jstat的参数。当几个WAS实例运行在同一台设备上时，如果你只使用jps命令，将只能看到启动（bootstrap）信息。我们建议在这种情况下使用ps -ef | grep java与jps配合使用。
想要得到GC性能相关的数据需要持续不断地监控，因此在执行jstat时，要规则地输出GC监控的信息。
例如，执行”jstat –gc 1000″ (或 1s)会每隔一秒展示GC监控数据。”jstat –gc 1000 10″会每隔1秒展现一次，且一共10次。

参数名称

描述

gc

输出每个堆区域的当前可用空间以及已用空间（伊甸园，幸存者等等），GC执行的总次数，GC操作累计所花费的时间。

gccapactiy

输出每个堆区域的最小空间限制（ms）/最大空间限制（mx），当前大小，每个区域之上执行GC的次数。（不输出当前已用空间以及GC执行时间）。

gccause

输出-gcutil提供的信息以及最后一次执行GC的发生原因和当前所执行的GC的发生原因

gcnew

输出新生代空间的GC性能数据

gcnewcapacity

输出新生代空间的大小的统计数据。

gcold

输出老年代空间的GC性能数据。

gcoldcapacity

输出老年代空间的大小的统计数据。

gcpermcapacity

输出持久带空间的大小的统计数据。

gcutil

输出每个堆区域使用占比，以及GC执行的总次数和GC操作所花费的事件。

 C:\Users\Administrator>jstat -gc 6088
 S0C    S1C    S0U    S1U      EC       EU        OC         OU       PC     PU    YGC     YGCT    FGC    FGCT     GCT
1024.0 1024.0 224.0   0.0   18432.0  16616.4   81920.0    60724.2   61440.0 60958.6     84    0.388   0      0.000    0.388

C:\Users\Administrator>jstat -gccapacity 6088
 NGCMN    NGCMX     NGC     S0C   S1C       EC      OGCMN      OGCMX       OGC         OC      PGCMN    PGCMX     PGC       PC     YGC    FGC
 20480.0  30720.0  20480.0 1024.0 1024.0  18432.0    81920.0   122880.0    81920.0    81920.0  21504.0  61440.0  61440.0  61440.0     85     0

C:\Users\Administrator>jstat -gccause 6088
  S0     S1     E      O      P     YGC     YGCT    FGC    FGCT     GCT    LGCC                 GCC
  0.00  51.57  11.53  74.29  99.22     85    0.391     0    0.000    0.391 Allocation Failure   No GC

C:\Users\Administrator>jstat -gcnew 6088
 S0C    S1C    S0U    S1U   TT MTT  DSS      EC       EU     YGC     YGCT
1024.0 1024.0    0.0  528.1  1  15 1024.0  18432.0   2475.8     85    0.391

C:\Users\Administrator>jstat -gcnewcapacity 6088
  NGCMN      NGCMX       NGC      S0CMX     S0C     S1CMX     S1C       ECMX        EC      YGC   FGC
   20480.0    30720.0    20480.0  10240.0   1024.0  10240.0   1024.0    29696.0    18432.0    85     0

C:\Users\Administrator>jstat -gcold 6088
   PC       PU        OC          OU       YGC    FGC    FGCT     GCT
 61440.0  60958.6     81920.0     60860.0     85     0    0.000    0.391

C:\Users\Administrator>jstat -gcoldcapacity 6088
   OGCMN       OGCMX        OGC         OC       YGC   FGC    FGCT     GCT
    81920.0    122880.0     81920.0     81920.0    85     0    0.000    0.391

C:\Users\Administrator>jstat -gcpermcapacity 6088
  PGCMN      PGCMX       PGC         PC      YGC   FGC    FGCT     GCT
   21504.0    61440.0    61440.0    61440.0    85     0    0.000    0.391

C:\Users\Administrator>jstat -gcutil 6088
  S0     S1     E      O      P     YGC     YGCT    FGC    FGCT     GCT
 21.88   0.00   6.26  74.84  99.22     86    0.394     0    0.000    0.394

 你可以只关心那些最常用的命令，你会经常用到 -gcutil (或-gccause), -gc and –gccapacity。

·         -gcutil 被用于检查堆间的使用情况，GC执行的次数以及GC操作所花费的时间。

·         -gccapacity以及其他的参数可以用于检查实际分配内存的大小。

[@http://www.importnew.com/3146.html]

如果GC执行时间满足下面所有的条件，就意味着无需进行GC优化了。
Minor GC执行的很快（小于50ms）
Minor GC执行的并不频繁（大概10秒一次）
Full GC执行的很快（小于1s）
Full GC执行的并不频繁（10分钟一次）


打印jvm当前的flags：
C:\Users\Administrator>jcmd GameServer VM.flags
23752:
-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=C:\Users\ADMINI~1\AppData\Local\Temp\visualvm.dat\localhost_23752 -XX:InitialHeapSize=266340672 -XX:MaxHeapSize=4263510016 -XX:+UseCompressedOops -XX:-UseLargePagesIndividualAllocation -XX:+UseParallelGC


对以上flags的解释：

-XX:+HeapDumpOnOutOfMemoryError  
-XX:HeapDumpPath=C:\Users\ADMINI~1\AppData\Local\Temp\visualvm.dat\localhost_23752
出现OOME时生成堆dump，并设置堆存储的地址

启动java进程时没有设置任何参数，这些都是默认值
-XX:MaxHeapSize=4263510016 (3.970703125G)
-XX:InitialHeapSize=266340672 (254.0022583007813M)

从Visual GC标签页中可以看出：
MaxHeapSize = eden(1.323G) + Old Gen(2.647G)   = 3.97G ？

*** S0(451M) + s1(451M)到底算不算到MaxHeapSize中呢?

---

* 不设置任何flags的情况：
C:\Users\Administrator>jcmd MiscTests VM.flags
18980:
-XX:InitialHeapSize=266340672 -XX:MaxHeapSize=4263510016 -XX:+UseCompressedOops -XX:-UseLargePagesIndividualAllocation -XX:+UseParallelGC

> gukt:
> -XX:InitialHeapSize=266340672(254M) -XX:MaxHeapSize=4263510016(3.97G)
> Eden(64m) + S0(10.5m) + S1(10.5m) + old(169m) = 254m
> 
> 此时观察：
> Perm Gen (max: 82m, capacity:21m): used:13.12m

* 使用-Xmn256m的情况：
```
C:\Users\Administrator>jcmd MiscTests VM.flags
11592:
-XX:InitialHeapSize=273888048 -XX:MaxHeapSize=4263510016 -XX:MaxNewSize=268435456(gukt:256m) -XX:NewSize=268435456(gukt:256m) -XX:+UseCompressedOops -XX:-UseLargePagesIndividualAllocation -XX:+UseParallelGC
```

> gukt:
> -XX:InitialHeapSize=273888048(261.1999m) -XX:MaxHeapSize=4263510016(3.97G)
> eden(192m)+s0(32m)+s1(32m)+old(5.5m)=261.5m(大致差不多)
> 
> size=18100000

gukt

---

-XX:+HeapDumpOnOutOfMemoryError  
-XX:HeapDumpPath=C:\Users\ADMINI~1\AppData\Local\Temp\visualvm.dat\localhost_23752
出现OOME时生成堆dump，并设置堆存储的地址

---




GC优化归纳了两个目的：

一个是将转移到老年代的对象数量降到最少
另一个是减少Full GC的执行时间

1. 某些比较大的对象会在被创建在伊甸园空间后，直接转移到老年代空间
2. 老年代空间上的GC处理会新生代花费更多的时间,
3. 减少被移到老年代对象的数据可以显著地减少Full GC的频率

减少Full GC执行时间
Full GC的执行时间比Minor GC要长很多

1. 如果你试图通过消减老年代空间来减少Full GC的执行时间，可能会导致OutOfMemoryError 或者 Full GC执行的次数会增加
2. 与之相反，如果你试图通过增加老年代空间来减少Full GC执行次数，执行时间会增加。

年轻代值大，minor GC次数就少

-XX:NewRatio=3
表明young gen / old gen = 1/3 ,也就是说young gen(eden + s0 + s1)占总堆大小的1/4

HotSpot JVM的  NewRatio默认值是2，表明old gen占2/3，young gen占1/3
new gen设置的比较大可以容纳更多的new objects，可以减少比较慢的major GC次数。

To size the Java heap:

Decide the total amount of memory you can afford for the JVM. Accordingly, graph your own performance metric against young generation sizes to find the best setting.

Make plenty of memory available to the young generation. The default is calculated from NewRatio and the -Xmx setting.

Larger eden or younger generation spaces increase the spacing between full GCs. But young space collections could take a proportionally longer time. In general, keep the eden size between one fourth and one third the maximum heap size. The old generation must be larger than the new generation.

-XX:+PrintTenuringDistribution
该
Use the option -XX:+PrintTenuringDistribution to show the threshold and ages of the objects in the new generation. It is useful for observing the lifetime distribution of an application.



【1】https://docs.oracle.com/cd/E19900-01/819-4742/abeik/index.html


-Xms512m -Xmx1G -Xmn256m


---

java.lang.OutOfMemoryError: GC overhead limit exceeded


---
# Hexo on windows
安装Git
https://git-scm.com/downloads

安装node.js
https://nodejs.org/en/download/

检查环境
C:\portable\nodejs>git --version
git version 2.10.2.windows.1

C:\portable\nodejs>node -v
v0.12.5

C:\portable\nodejs>npm -v
2.11.2

安装Hexo

使用淘宝NPM镜像
npm install -g cnpm --registry=https://registry.npm.taobao.org

使用淘宝NPM安装Hexo
$ cnpm install -g hexo-cli

继续输入以下命令
$ cnpm install hexo --save

e:\>hexo -v
hexo-cli: 1.0.2
os: Windows_NT 10.0.10586 win32 x64
http_parser: 2.7.0
node: 6.9.1
v8: 5.1.281.84
uv: 1.9.1
zlib: 1.2.8
ares: 1.10.1-DEV
icu: 57.1
modules: 48
openssl: 1.0.2j

---
MiscTests
-verbosegc -Xmx1G -XX:+PrintTenuringDistribution

public static void main(String[] args) throws InterruptedException {

        Set<Object> set1 = new HashSet<>();

        int n = 10000;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < 100000; j++) {
                set1.add(new Object());
            }

            System.out.println("size=" + set1.size());

            TimeUnit.MILLISECONDS.sleep(1000);
        }

        System.out.println(set1.size());

        Thread.sleep(10000000);

    }
    
size=100000
[GC
Desired survivor size 11010048 bytes, new threshold 7 (max 15)
 65436K->15794K(249344K), 0.0210672 secs]
size=200000
size=300000


