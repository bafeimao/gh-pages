A thread state. A thread can be in one of the following states:

## NEW
A thread that has not yet started is in this state.
线程创建了，但是还没有启动

**RUNNABLE**
A thread executing in the Java virtual machine is in this state.
线程正在JVM中执行

**BLOCKED**
A thread that is blocked waiting for a monitor lock is in this state.
线程被一个监视器锁阻塞住。当前线程正在等待监视器锁以便进入同步快。
进入同步块有两种情况：
1. 第一次尝试进入
2. 被唤醒（notify/notifyAll),然后重新竞争监视器锁

**WAITING**
A thread that is waiting indefinitely for another thread to perform a particular action is in this state.
线程正在无限期等待其他线程执行一个特殊操作

执行以下操作会导致该状态：
. Object.wait()
. Thread.join()
. LockSupport.park()

**TIMED_WAITING**
A thread that is waiting for another thread to perform an action for up to a specified waiting time is in this state.
带超时的等待

执行以下操作会导致该状态：
.Thread.sleep(timeout)
.Object.wait(timeout)
.Thread.join(timeout)
.LockSupport.parkNanos(timeout)
.LockSupport.parkUntil(timeout)

**TERMINATED**
A thread that has exited is in this state.
线程已经完成了执行

A thread can be in only one state at a given point in time. These states are virtual machine states which do not reflect any operating system thread states.
一个线程某个时刻只能有一种状态，这些状态对应虚拟机中的状态而非操作系统线程状态

