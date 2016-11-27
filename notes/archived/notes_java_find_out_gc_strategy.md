# 如何获取当前JVM使用的GC算法？

### 通过jmap命令得到heap信息

`C:\Users\Administrator>jmap -heap 14932`

```
Attaching to process ID 14932, please wait...
Debugger attached successfully.
Server compiler detected.
JVM version is 24.80-b11

using thread-local object allocation.
Parallel GC with 4 thread(s)

**[gukt]：这里表明用的是Parallel GC算法，并且使用了4个并行线程**

Heap Configuration:
   MinHeapFreeRatio = 0
   MaxHeapFreeRatio = 100
   MaxHeapSize      = 4263510016 (4066.0MB)
   NewSize          = 1310720 (1.25MB)
   MaxNewSize       = 17592186044415 MB
   OldSize          = 5439488 (5.1875MB)
   NewRatio         = 2
   SurvivorRatio    = 8
   PermSize         = 21757952 (20.75MB)
   MaxPermSize      = 85983232 (82.0MB)
   G1HeapRegionSize = 0 (0.0MB)

Heap Usage:
PS Young Generation
Eden Space:
   capacity = 8388608 (8.0MB)
   used     = 4985504 (4.754547119140625MB)
   free     = 3403104 (3.245452880859375MB)
   59.43183898925781% used
From Space:
   capacity = 3145728 (3.0MB)
   used     = 1753456 (1.6722259521484375MB)
   free     = 1392272 (1.3277740478515625MB)
   55.740865071614586% used
To Space:
   capacity = 3145728 (3.0MB)
   used     = 0 (0.0MB)
   free     = 3145728 (3.0MB)
   0.0% used
PS Old Generation
   capacity = 158859264 (151.5MB)
   used     = 157279416 (149.99333953857422MB)
   free     = 1579848 (1.5066604614257812MB)
   99.00550464592358% used
PS Perm Generation
   capacity = 85983232 (82.0MB)
   used     = 83561424 (79.69038391113281MB)
   free     = 2421808 (2.3096160888671875MB)
   97.1833950135766% used

25855 interned Strings occupying 2738352 bytes.
```

### 利用jcmd命令

`C:\>jcmd 24192 VM.flags`

```
24192:
-XX:InitialHeapSize=266340672 -XX:MaxHeapSize=4263510016 -XX:MaxPermSize=209715200 -XX:+UseCompressedOops -XX:-UseLargePagesIndividualAllocation -XX:+UseParallelGC
```

### 利用jstat打印GC统计信息时顺便传递-XX:+PrintCommandLineFlags这个flag给运行时系统，这样打印gc统计信息前会先打出当期VM的flags

```
C:\Users\Administrator>jstat -J-XX:+PrintCommandLineFlags -gc 20360
-XX:InitialHeapSize=8388608 -XX:MaxHeapSize=4261450752 -XX:+PrintCommandLineFlags -XX:+UseCompressedOops -XX:-UseLargePagesIndividualAllocation -XX
:+UseParallelGC
 S0C    S1C    S0U    S1U      EC       EU        OC         OU       PC     PU    YGC     YGCT    FGC    FGCT     GCT
29696.0 38400.0 29686.7  0.0   242688.0 103039.7  173056.0   39590.1   80896.0 80676.0     10    0.197   0      0.000    0.197
```

### 通过使用-XX:+PrintCommandLineFlags查看默认flag设置

`C:\Users\Administrator>java -XX:+PrintCommandLineFlags -version`

```
-XX:InitialHeapSize=266340672 -XX:MaxHeapSize=4261450752 -XX:+PrintCommandLineFlags -XX:+UseCompressedOops -XX:-UseLargePagesIndividualAllocation -XX:+UseParallelGC
java version "1.7.0_80"
Java(TM) SE Runtime Environment (build 1.7.0_80-b15)
Java HotSpot(TM) 64-Bit Server VM (build 24.80-b11, mixed mode)
```

** [gukt] :  -XX:UseParallelGC表明我们现在默认使用的是Parallel GC **

**NOTE:**
以上命令用于显示不同操作系统上默认JVM参数配置
以上结果是在windows上得到的，下面的是在某台linux上运行的，由于配置不同得到的默认参数配置也不同。

```
[root@inu-dev1 ~]# java -XX:+PrintCommandLineFlags -version
-XX:InitialHeapSize=523770752 -XX:MaxHeapSize=8380332032 -XX:+PrintCommandLineFlags -XX:+UseCompressedOops -XX:+UseParallelGC
java version "1.7.0_80"
Java(TM) SE Runtime Environment (build 1.7.0_80-b15)
Java HotSpot(TM) 64-Bit Server VM (build 24.80-b11, mixed mode)
```

### References

[1] http://www.techpaste.com/2012/02/default-jvm-settings-gc-jit-java-heap-sizes-xms-xmx-operating-systems/#more-3569
