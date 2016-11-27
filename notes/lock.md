
        final boolean nonfairTryAcquire(int acquires) {
            final Thread current = Thread.currentThread();
            int c = getState();
            if (c == 0) {
                if (compareAndSetState(0, acquires)) {
                    setExclusiveOwnerThread(current);
                    return true;
                }
            }
            else if (current == getExclusiveOwnerThread()) {
                int nextc = c + acquires;
                if (nextc < 0) // overflow
                    throw new Error("Maximum lock count exceeded");
                setState(nextc);
                return true;
            }
            return false;
        }

以上：
1. 只在获取锁的时候才进行CAS操作，重进入的时候只需要直接调用setState即可，因为不存在争用
2. state可以被同一个线程改变多次，但一旦被改为非0的就不能再被其他线程获取到，只能等owner线程将其修改为0（释放锁）

        protected final boolean tryAcquire(int acquires) {
            final Thread current = Thread.currentThread();
            int c = getState();
            if (c == 0) {
                if (!hasQueuedPredecessors() &&
                    compareAndSetState(0, acquires)) {
                    setExclusiveOwnerThread(current);
                    return true;
                }
            }
            else if (current == getExclusiveOwnerThread()) {
                int nextc = c + acquires;
                if (nextc < 0)
                    throw new Error("Maximum lock count exceeded");
                setState(nextc);
                return true;
            }
            return false;
        }

比较UnfairSync和FairSync的的tryAcquire方法的唯一不同是在FairSync中多了!hasQueuedPredecessors()判断。


/**
         * Performs lock.  Try immediate barge, backing up to normal
         * acquire on failure.
         */
        final void lock() {
            if (compareAndSetState(0, 1))
                setExclusiveOwnerThread(Thread.currentThread());
            else
                acquire(1);
        }

非公平的方式获得锁
 
        final boolean nonfairTryAcquire(int acquires) {
            final Thread current = Thread.currentThread();
            int c = getState();
            if (c == 0) {
                if (compareAndSetState(0, acquires)) {
                    setExclusiveOwnerThread(current);
                    return true;
                }
            }
            else if (current == getExclusiveOwnerThread()) {
                int nextc = c + acquires;
                if (nextc < 0) // overflow
                    throw new Error("Maximum lock count exceeded");
                setState(nextc);
                return true;
            }
            return false;
        }


    final boolean nonfairTryAcquire(int acquires) {
            final Thread current = Thread.currentThread();
            int c = getState();
            if (c == 0) {
                if (compareAndSetState(0, acquires)) {
                    setExclusiveOwnerThread(current);
                    return true;
                }
            }
            else if (current == getExclusiveOwnerThread()) {
                int nextc = c + acquires;
                if (nextc < 0) // overflow
                    throw new Error("Maximum lock count exceeded");
                setState(nextc);
                return true;
            }
            return false;
        }

1. 立即再次尝试获取锁（有可能之前的线程占有锁时间非常短，此时已经释放了，这是为了效率考虑）
2. 这里支持重进入（Reentrant)，如果是同一个线程再次要求获得锁是允许的，同时会累加lock count
3. 如果还是没有获取不到，则返回false表示获取失败，下面就开始进入AQS的方法的acquireQueued方法了

public final void acquire(int arg) {
        if (!tryAcquire(arg) &&
            acquireQueued(addWaiter(Node.EXCLUSIVE), arg))
            selfInterrupt();
    }

先看看addWaiter方法

    private Node addWaiter(Node mode) {
        Node node = new Node(Thread.currentThread(), mode);
        // Try the fast path of enq; backup to full enq on failure
        Node pred = tail;
        if (pred != null) {
            node.prev = pred;
            if (compareAndSetTail(pred, node)) {
                pred.next = node;
                return node;
            }
        }
        enq(node);
        return node;
    }

该方法将要获取锁的线程包装成Node对象，并插入到队列的tail节点后，先立即尝试设置tail指向该节点，如果失败，则调用enq()方法，实际上enq方法内部执行的是"失败后重试的CAS操作",知道挂成功为止。

1. 先尝试将节点挂在tail节点（如果有的话）后面，如果挂成功了（其他线程此时也可能也会挂节点到tail节点后，因此可能会失败）则可以提前退出了，
2. 否则就调用enq方法执行失败重试的CAS操作，直到挂成功为止
3. 要好好理解这个方法，这个方法再acquireShared


    private Node enq(final Node node) {
        for (;;) {
            Node t = tail;
            if (t == null) { // Must initialize
                if (compareAndSetHead(new Node()))
                    tail = head;
            } else {
                node.prev = t;
                if (compareAndSetTail(t, node)) {
                    t.next = node;
                    return t;
                }
            }
        }
    }

1. 如果对垒还没有初始化过（head和tail都指向null），则实例化一个占位节点，让head指向这个占位节点
2. 不断失败重试，直到将node挂到tail节点后面为止

下面要看看acquireQueued(addWaiter(Node.EXCLUSIVE), arg)这个方法了

     final boolean acquireQueued(final Node node, int arg) {
        boolean failed = true;
        try {
            boolean interrupted = false;
            for (;;) {
                final Node p = node.predecessor();
                if (p == head && tryAcquire(arg)) {
                    setHead(node);
                    p.next = null; // help GC
                    failed = false;
                    return interrupted;
                }
                if (shouldParkAfterFailedAcquire(p, node) &&
                    parkAndCheckInterrupt())
                    interrupted = true;
            }
        } finally {
            if (failed)
                cancelAcquire(node);
        }
    }
 
这里的参数node是刚刚调用完addWaiter后添加到队列中的节点（addWaiter会确保一定会将node成功添加到列尾），当一个node成功入列后就立即进入自旋（for循环体内的逻辑）。

假设现在的队列是这样的：
head                                                        tail
|                                                             |
node0(null) <-> node1(t2) <-> node2(t3) <-> node3(t4) <-> node4(t5)

由代码可以看出：假设现在其他线程释放了其占有的锁，在fair模式下（公平模式下），node1会先得到锁（head.next指向的节点），而node2，node3节点还需要继续自旋。当node1成功获得锁后，会将head指向node1，node0处于游离状态将会被GC回收。同步器内部队列的FIFO原则也在该段代码里体现了。

两个问题：
fail什么时候为true呢

shouldParkAfterFailedAcquire方法执行的逻辑是：如果前置节点等待标记位是Node.SIGNAL，则返回true（让后续逻辑可以执行LockSupport将该节点线程park），

由于同步器框架还支持cancel操作，因此如果发现前置节点是已经cancel掉了（waitStatus=1)，则从当前节点位置向前搜索队列，直到找到没被cancel的节点。如果前置节点的waitStatus=0,-2(PROPAGATE),-3(CONDITION)

shouldParkAfterFailedAcquire是在tryAcquire之后执行的，这样做是避免能够得到锁的时候却让线程park掉了，只有在当前获取不到锁的情况下才会去判断是否要park住线程。

有了shouldParkAfterFailedAcquire的存在，会让可以进入park的线程不用不停的自旋（毕竟自旋的代价是很高的），

根据前面的队列例子：假设node2被cancel了（超时或interrupted)，node3会往前索索到发现node1没有cannel（waitStatus=0)，则将node1.next=node3, node3.pre=node1，换句话说是让node2出列，并设置node1.waitStatus=SIGNAL，当设置成功后node3对应的线程就可以安心的睡眠去了（因为node1是否锁的时候会通知它）


    private void cancelAcquire(Node node) {
        // Ignore if node doesn't exist
        if (node == null)
            return;

        node.thread = null;

        // Skip cancelled predecessors
        Node pred = node.prev;
        while (pred.waitStatus > 0)
            node.prev = pred = pred.prev;

        // predNext is the apparent node to unsplice. CASes below will
        // fail if not, in which case, we lost race vs another cancel
        // or signal, so no further action is necessary.
        Node predNext = pred.next;

        // Can use unconditional write instead of CAS here.
        // After this atomic step, other Nodes can skip past us.
        // Before, we are free of interference from other threads.
        node.waitStatus = Node.CANCELLED;

        // If we are the tail, remove ourselves.
        if (node == tail && compareAndSetTail(node, pred)) {
            compareAndSetNext(pred, predNext, null);
        } else {
            // If successor needs signal, try to set pred's next-link
            // so it will get one. Otherwise wake it up to propagate.
            int ws;
            if (pred != head &&
                ((ws = pred.waitStatus) == Node.SIGNAL ||
                 (ws <= 0 && compareAndSetWaitStatus(pred, ws, Node.SIGNAL))) &&
                pred.thread != null) {
                Node next = node.next;
                if (next != null && next.waitStatus <= 0)
                    compareAndSetNext(pred, predNext, next);
            } else {
                unparkSuccessor(node);
            }

            node.next = node; // help GC
        }
    }

假设queue是这样的：

head                                                        tail
|                                                             |
node0(null) <-> node1(t2) <-> node2(t3) <-> node3(t4) <-> node4(t5)

如果要取消的节点是尾巴节点，处理比较简单，将tail指向最近的非canceled节点即可：
假设cancel的节点是node4,而此时node2,node3的ws=CANCELD,则将tail指向node1，然后方法退出

如果要取消的节点不是尾巴节点（比如node3),假设此时node2(ws=1),则将找到node3的前置有效节点为node1,此时分两种情况处理：
1. node1状态本来就是SIGNAL或本次可以成功设置其状态为SIGNAL则设置node1指向node4即可退出
2. 如果node1的ws不是SINGAL或没有被设置成SIGNAL成功，则unpark下一个节点（node4）
 
 
    public final void acquire(int arg) {
        if (!tryAcquire(arg) &&
            acquireQueued(addWaiter(Node.EXCLUSIVE), arg))
            selfInterrupt();
    }

    public final void acquireInterruptibly(int arg)
            throws InterruptedException {
        if (Thread.interrupted())
            throw new InterruptedException();
        if (!tryAcquire(arg))
            doAcquireInterruptibly(arg);
    }

acquireInterruptibly的和acquire处理流程和逻辑基本类似，唯一不同的是acquireInterruptibly内部在自旋到某个时间点的时候发现该线程已经被interrupted了，则可以抛出InterruptedException，而acquire是发现了线程已经被interrupt了后自行关闭自己（Thread.currentThread().interrupt()）

acquireShared和acquired的区别
    
    public final void acquireShared(int arg) {
        if (tryAcquireShared(arg) < 0)
            doAcquireShared(arg);
    }

1. acquireShared调用的是同步器的模板方法tryAcquireShared
2. 如果子类没有实现tryAcquireShared方法，则表示子类不支持共享方式获取锁（调用acquireShared时会抛出UnsupportedOperationException）
3. Semaphore提供了对tryAcquireShared的实现，可以参考
4. 

争用AQS的state变量

排他模式下：
通常来说设置同步器（synchronizer）state从0到1后其他线程就不能对其进行修改了，但是因为其也支持“可重进入”，因此owner线程可以再次修改state增加其值

对于share模式：

    final int nonfairTryAcquireShared(int acquires) {
            for (;;) {
                int available = getState();
                int remaining = available - acquires;
                if (remaining < 0 ||
                    compareAndSetState(available, remaining))
                    return remaining;
            }
        }

1. 内部进行CAS操作，失败后不断重试。直到设置成功，在无法获得锁的时候，返回值<0,
2. 注意tryAcquireShared返回的是int值,而tryAcquire返回bool值


    public final void acquireShared(int arg) {
        if (tryAcquireShared(arg) < 0)
            doAcquireShared(arg);
    }

1. 如果tryAcquireShared返回值大于1，则acquireShared直接返回不自旋（表示获得了锁）

 
AQS管理一个内部同步状态state（比如表示已加锁或已解锁），更新state，












公平和不公平的策略区别在于：不公平方案会让一个线程立即得到锁而之前排队的线程缺得不到，极端情况下，可能会造成线程饥饿或让队列中的线程等待时间变长。




-------------------
内置锁(Intrinsic lock/Monitor lock)与同步

内置锁可以提供排他地访问互斥资源

每个对象都有一个内置锁



在linux中可以使用vmstat观察上下文切换的次数







































































































































































































































































































