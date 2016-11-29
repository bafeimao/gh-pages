## 使用verbosegc输出GC结果

```
# java -jar -verbosegc xxx.jar
```

输出的信息如：
```
[GC 65536K->6204K(249344K), 0.0081203 secs]
```

该选项还可以连同以下参数一起使用：

```
-XX:+PrintGCDetails
-XX:+PrintGCTimeStamps
-XX:+PrintGCDateStamps
-XX:+PrintHeapAtGC
-XX:+PrintGCApplicationConcurrentTime
-XX:+PrintGCApplicationStoppedTime
```

**-XX:+PrintGCTimeStamps**

```
4.642: [GC 71723K->7209K(249344K), 0.0074042 secs]
```

**-XX:+PrintGCDateStamps**

```
2016-11-10T10:55:57.215+0800: [GC 65536K->6172K(249344K), 0.0114077 secs]
```

**-XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps**

```
2016-11-10T10:55:16.211+0800: 3.672: [GC 65536K->6190K(249344K), 0.0212505 secs]
```

**-XX:+PrintGCDetails**

```
[GC [PSYoungGen: 65536K->6308K(76288K)] 65536K->6316K(249344K), 0.0117296 secs] [Times: user=0.03 sys=0.00, real=0.01 secs]
```

**使用-verbosegc实际上等同于使用-XX:+PrintGC:**

```
$ java -XX:+PrintCommandLineFlags -version

-XX:InitialHeapSize=266340672 -XX:MaxHeapSize=4261450752 -XX:+PrintCommandLineFlags -XX:+UseCompressedOops -XX:-UseLargePagesIndividualAllocation -XX:+UseParallelGC

$ java -XX:+PrintCommandLineFlags -verbosegc -version

-XX:InitialHeapSize=266340672 -XX:MaxHeapSize=4261450752 -XX:+PrintCommandLineFlags **-XX:+PrintGC** -XX:+UseCompressedOops -XX:-UseLargePagesIndividua
lAllocation -XX:+UseParallelGC
java version "1.7.0_80"
Java(TM) SE Runtime Environment (build 1.7.0_80-b15)
Java HotSpot(TM) 64-Bit Server VM (build 24.80-b11, mixed mode)
```

## 使用-Xloggc将GC信息输出到文件中

在java程序启动时添加：`-Xloggc:/tmp/gs.vgc`选项，即可开启记录GC信息到文件

文件`gs.vgc`内容如下:

```
Java HotSpot(TM) 64-Bit Server VM (24.80-b11) for windows-amd64 JRE (1.7.0_80-b15), built on Apr 10 2015 11:26:34 by "java_re" with unknown MS VC++:1600
Memory: 4k page, physical 16646292k(8243612k free), swap 33423508k(19467160k free)
CommandLine flags: -XX:InitialHeapSize=104857600 -XX:MaxHeapSize=157286400 -XX:MaxPermSize=62914560 -XX:NewRatio=4 -XX:+PrintGC -XX:-PrintGCDetails -XX:+PrintGCTimeStamps -XX:+UseCompressedOops -XX:-UseLargePagesIndividualAllocation -XX:+UseParallelGC
0.969: [GC 15360K->3545K(99840K), 0.0052412 secs]
1.475: [GC 18905K->4257K(99840K), 0.0045741 secs]
2.116: [GC 19617K->5558K(99840K), 0.0065919 secs]
...

```

通过文件内容看出使用了`-Xloggc:e:\gs.vgc`选项后实际上默认隐式添加了`-XX:+PrintGC和XX:+PrintGCTimeStamps`

上述的gs.vgc文件肉眼分析不直观，可以借助HPJmeter工具查看更方便：

也可以加上：`-XX:+PrintGCDateStamps`,输出的结果里会带上日期：

```
2016-11-09T14:48:37.189+0800: 3.794: [GC 31101K->12979K(107008K), 0.0102915 secs]
```

但是，带上日期后HPJmeter打开就会报错了。
