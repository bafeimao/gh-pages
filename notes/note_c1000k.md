note_c1000k

file-max决定了当前内核可以打开的最大的文件句柄数
[game@game001 ~]$ cat /proc/sys/fs/file-max
1620760

file-max一般为内存大小（KB）的10%来计算，如果使用shell，可以这样计算：
grep -r MemTotal /proc/meminfo | awk '{printf("%d",$2/10)}'

查看当前kernel的句柄;
[game@game001 ~]$ cat /proc/sys/fs/file-nr
1056	0	1620760

@62
Before connect:
[root@inu-dev2 ~]# netstat -ant|awk '{print $6}'|uniq -c|sort -nr
     52 ESTABLISHED
      9 LISTEN
      5 ESTABLISHED
      3 LISTEN
      1 Foreign
      1 established)
After 10w connect:
[root@inu-dev2 ~]# netstat -ant|awk '{print $6}'|uniq -c|sort -nr
  64294 ESTABLISHED
     53 ESTABLISHED
      9 LISTEN
      3 LISTEN
      1 Foreign
      1 established)

[root@inu-dev2 ~]# netstat -ant|awk '{print $6}'|sort|uniq -c|sort -nr
  64346 ESTABLISHED
     12 LISTEN
      1 Foreign
      1 established)

客户端报错，因为无法再建立更多的连接了
java.net.SocketException: No buffer space available (maximum connections reached?): connect
	at sun.nio.ch.Net.connect0(Native Method)
	at sun.nio.ch.Net.connect(Net.java:484)
	at sun.nio.ch.Net.connect(Net.java:476)
	at sun.nio.ch.SocketChannelImpl.connect(SocketChannelImpl.java:675)
	at java.nio.channels.SocketChannel.open(SocketChannel.java:184)
	at com.xy.bench.Bench.connectServer(Bench.java:52)
	at com.xy.bench.Bench.main(Bench.java:43)

07-29 16:41:01.540 [nioEventLoopGroup-2-2] WARN  Slf4JLogger[151] - An exceptionCaught() event was fired, and it reached at the tail of the pipeline. It usually means the last handler in the pipeline did not handle the exception.
java.io.IOException: 系统中打开的文件过多
  at sun.nio.ch.ServerSocketChannelImpl.accept0(Native Method)
  at sun.nio.ch.ServerSocketChannelImpl.accept(ServerSocketChannelImpl.java:250)
  at io.netty.channel.socket.nio.NioServerSocketChannel.doReadMessages(NioServerSocketChannel.java:135)
  at io.netty.channel.nio.AbstractNioMessageChannel$NioMessageUnsafe.read(AbstractNioMessageChannel.java:69)
  at io.netty.channel.nio.NioEventLoop.processSelectedKey(NioEventLoop.java:511)
  at io.netty.channel.nio.NioEventLoop.processSelectedKeysOptimized(NioEventLoop.java:468)
  at io.netty.channel.nio.NioEventLoop.processSelectedKeys(NioEventLoop.java:382)
  at io.netty.channel.nio.NioEventLoop.run(NioEventLoop.java:354)
  at io.netty.util.concurrent.SingleThreadEventExecutor$2.run(SingleThreadEventExecutor.java:112)
  at io.netty.util.concurrent.DefaultThreadFactory$DefaultRunnableDecorator.run(DefaultThreadFactory.java:137)
  at java.lang.Thread.run(Thread.java:745)

07-29 16:49:13.802 [nioEventLoopGroup-2-6] WARN  Slf4JLogger[151] - An exceptionCaught() event was fired, and it reached at the tail of the pipeline. It usually means the last handler in the pipeline did not handle the exception.
java.io.IOException: 无法分配内存
  at sun.nio.ch.ServerSocketChannelImpl.accept0(Native Method)
  at sun.nio.ch.ServerSocketChannelImpl.accept(ServerSocketChannelImpl.java:250)
  at io.netty.channel.socket.nio.NioServerSocketChannel.doReadMessages(NioServerSocketChannel.java:135)
  at io.netty.channel.nio.AbstractNioMessageChannel$NioMessageUnsafe.read(AbstractNioMessageChannel.java:69)
  at io.netty.channel.nio.NioEventLoop.processSelectedKey(NioEventLoop.java:511)
  at io.netty.channel.nio.NioEventLoop.processSelectedKeysOptimized(NioEventLoop.java:468)
  at io.netty.channel.nio.NioEventLoop.processSelectedKeys(NioEventLoop.java:382)
  at io.netty.channel.nio.NioEventLoop.run(NioEventLoop.java:354)
  at io.netty.util.concurrent.SingleThreadEventExecutor$2.run(SingleThreadEventExecutor.java:112)
  at io.netty.util.concurrent.DefaultThreadFactory$DefaultRunnableDecorator.run(DefaultThreadFactory.java:137)
  at java.lang.Thread.run(Thread.java:745)
