打印线程dump信息的几种方法

`jcmd <pid> Thread.print > /tmp/gs.tdump`
以文本形式输出

`jstack <pid> > /tmp/gs.tdump`
以文本形式输出

`jcmd <pid> GC.heap_dump > /tmp/gs.jcmd.hprof`
以二进制hprof格式输出堆栈信息，然后用相关查看器查看，如：VisualVM，HPJmeter,IBM Heap Analyzer

`jmap -dump:live,format=b,file=/tmp/gs.jmap.hprof <pid>`
以二进制hprof格式输出堆栈信息

 
