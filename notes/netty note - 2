netty note - 2

method-chaining

ChannelOption



EventExecutorGroup
	children: EventExecutor[]
	terminationFuture



EventExecutor
	EventExecutorGroup
		AbstractEventExecutorGroup
			MultiThreadEventExecutorGroup


nioEventLoopGroup-poolId=




NioEventLoopGroup
	children: NioEventLoop[8]
			selector
			selectedKeys
			provider: WindowsSelectorProvider
			wakenUp ???
			ioRatio ???
			cancelledKeys = 0
			needsToSelectAgain ???
			parent: NioEventLoopGroup
			taskQueue
			thread
			threadProperties
			threadLock
			shutdownHooks
			addTaskWakesUp
			lastExecutionTime
			state
			gracefulShutdownQuietPeriod
			terminationFuture
			scheduledTaskQueue

	childIndex
	terminatedChildren
	terminationFuture
	chooser


@SuppressWarnings("ClassNameSameAsAncestorName")


Future<V>
	cancel()
	isCancelled()
	isDone()
	get()
	get(TimeUnit unit, long timeout)
 
RunnableFuture<V> extends Runnable, Future<V>
	run();

FutureTask<V> extends RunnableFuture<V>
	表示可取消的异步计算

selectorProvider 
	SelectorProvider.provider()

NioServerSocketChannel

NioEventLoop
	执行两类任务：I/O任务(SelectionKey中ready的任务，如：accept，connect，read，write)和非I/O任务(register0，bind, channelActive)

fields:	
	selector, selectedKeys, provider, wakenUp, ioRatio, cancelledKeys, needsToSelectAgain, parent, taskQueue, thread, threadProperties, threadLock
	shutdownHooks, addTaskWakesUp, ...



Selector:
		selectNow()
			选择一组已经准备好IO操作的channel

		select(timeout)
			选择一组已经准备好IO操作的channel，该方法是阻塞式的，有四种情况才会返回：
			1. 至少有一个channel被选择了（selected)(有一个channe的IO操作就绪）
			2. 超时时间超过
			3. 运行该Selector的线程被中断（Interrupted）
			4. Selector的wakeup方法被调用


NioServerSocketChannel


NioSocketChannel
	config, flushTask, ch:SocketChannelImpl, readInterestOp, selectionKey, readPending, 

channel.register(selector, ops, att)
将channel注册到



interface Channel

	localAddress(), remoteAddress()
	eventLoop(), config(), parent(), metadata(), 

	bind(), connect(), close(), disconnect(), deregister(),read(), write(), writeAndFlush()


	 DatagramChannel



	每个Channel都会被注册到一个EventLoop中
	每个EventLoop都有一个Selector
	为什么channel还有parent???
	registered, open, active

Channel <- SocketChannel <- NioSocketChannel

EvnetLoopGroup bossGroup = new EventLoopGroup(1);
EventLoopGroup workerGroup = new EventLoopGroup(0);

serverBootstrap.group(bossGroup, workerGroup)
	.channel(NioServerSocketChannel.class)
	.option(ChannelOption.TCP_NODELAY, true)
	.handler

  
MultiThreadEventExecutorGroup:
	threadFactory = {DefaultThreadFactory@8646} 
	 nextId = {AtomicInteger@8719} "0"
	 prefix = {String@8720} "nioEventLoopGroup-3-"
	 daemon = false
	 priority = 10

serverBootstrap
	childGroup
		children: SingleThreadEventExecutor[8]


SocketServerBootstrap diagram:
	实例化bossGroup = new NioEventLoopGroup, workerGroup = new NioEventLoopGroup
	设置Bootstrap的各种参数，包括bossGroup(children*1), workerGroup(children*8)
 
 	bootstrap.bind(port)
 		initAndRegister()
 			使用channelFactory产生一个channel实例（NioServerSocketChannel）
 			初始化channel






TODO
----------------

线程priority=5和=10的区别？
SingleThreadEventExecutor
MultithnreadEventExecutorGroup
NioEventLoop
PriorityQueue
    private final Semaphore threadLock = new Semaphore(0);
    MpscLinkedQueue

ServerBootstrap类中的options()和attr()的区别？

 