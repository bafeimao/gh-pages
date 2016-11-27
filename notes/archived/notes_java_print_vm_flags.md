-XX:+PrintCommandLineFlags 打印出JVM初始化完毕后所有跟初始化的默认值不同的参数及他们的值

```
C:\Users\Administrator>java -XX:+PrintCommandLineFlags  -version
-XX:InitialHeapSize=266340672 -XX:MaxHeapSize=4261450752 -XX:+PrintCommandLineFlags -XX:+UseCompressedOops -XX:-UseLargePagesIndividualAllocation -
XX:+UseParallelGC
java version "1.7.0_80"
Java(TM) SE Runtime Environment (build 1.7.0_80-b15)
Java HotSpot(TM) 64-Bit Server VM (build 24.80-b11, mixed mode)
```

`-XX:+PrintFlagsFinal`
显示所有可设置的参数及”参数处理”后的默认值

```
     bool PrintOldPLAB                              = false           {product}
     bool PrintOopAddress                           = false           {product}
     bool PrintPLAB                                 = false           {product}
     bool PrintParallelOldGCPhaseTimes              = false           {product}
     bool PrintPromotionFailure                     = false           {product}
     bool PrintReferenceGC                          = false           {product}
     bool PrintRevisitStats                         = false           {product}
```

  
