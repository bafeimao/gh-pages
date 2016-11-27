    protected final boolean tryAcquire(int acquires) {
            final Thread current = Thread.currentThread();
            int c = getState(); // [1]
            if (c == 0) {
                // [2]
                if (!hasQueuedPredecessors() &&
                    compareAndSetState(0, acquires)) {
                    setExclusiveOwnerThread(current);
                    return true;
                }
            }
            // [3]
            else if (current == getExclusiveOwnerThread()) {
                int nextc = c + acquires;
                if (nextc < 0)
                    throw new Error("Maximum lock count exceeded");
                setState(nextc); // [4]
                return true;
            }
            return false; [5]
        }
  
该方法用于在“独占模式”下尝试获取锁（同步器的state表示的），如果获取成功返回true，反之false，首先在[1]处获得state状态（state是volatile类型的，线程间可见），然后判断如果state=0表示没有其他线程占用锁，因此可以立即获取并返回true；如果c不等于0，这里分两种情况：
1. 如果同步器的“owner == 当前线程”，允许再次获取锁，这就是重进入机制（在[3]处）
2. 如果同步器的“owner！= 当前线程”，则返回false，因为被其他线程占用了. (在[5]处)

解释一下[2]处的代码：
在并发情况下，有可能多个线程同时获得state=0，他们会同时进入到[2]处，此时就要判断队列是否已经有其他线程在排队，如果有则返回false，如果没有，则尝试CAS操作修改state状态从而竞争锁资源。哪个线程竞争到了就将state修改为参数acquires指定的值，同时将exclusiveOwnerThread设置为自己，表示这个坑已经被我占了，你们其他线程都去排队去吧。

以在火车上上厕所为例，假设厕所只有一个，要上厕所的人有多个，厕所门上的标记（有人/没人）用来告诉其他人是否要等待。



AQS(owner=t1, state=1)
head                                        tail
node1(null) <-> node2(t2) <-> node3(t3) <-> node4(t4)

hasQueuedPredecessors：检查是否有其他线程比当前线程等待时间更长











































