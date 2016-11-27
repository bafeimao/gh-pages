线程的状态通常有6种（也可理解成7种)：
new, runnable(ready/running), waiting, timed-waiting, blocked, terminated

线程刚刚创建后没有执行start()方法前的状态为New
执行start方法后线程就键入了runnable状态（但是何时运行还需要操作系统的调度），一旦线程被thread schedluer选中则进入running状态。
如果线程调用sleep(timeout)则进入timed-waiting状态

**哪些操作可以让线程进入timed_waiting状态？**
thread.sleep(timeout), object.wait(timeout)，LockSupport.parkNanos(timeout), LockSupport.parkUntil(timeout)

**哪些操作可以让线程进入waiting状态？**
object.wait(), thread1.join(), LockSupport.park()
NOTE: 其中wait和park会让当前调用线程进入wait状态，而thread1.join()是让thread1进入waiting状态

**wait(timeout)和sleep(timeout)的区别**
1. 两者都可以让线程进入timed_waiting状态，但wait方法是Object类定义的，sleep方法是Thread类定义的，因此，wait方法被调用时会让调用线程进入timed_waiting状态，而thread1.sleep(timeout)会让thread1进入timed_waiting状态
2. wait执行后会释放对象monitor，而sleep方法不会释放锁（如果有的话）

**yield和sleep的区别？**
thread1.yield()调用后，thread1会让出cpu时间片给同优先级的其他线程执行的机会，但是,如果此时没有同优先级的其他线程，则thread1***仍然会继续执行***，这和thread1.sleep(timeout)不同，sleep方法允许低优先级的线程获得运行的机会（


总结：
1. yield()、sleep()、join()都是Thread类定义的方法，不涉及同步方法，因此也不会使线程切换到blocked状态，也不涉及object monitor的释
2. wait()、notify()、notifyAll()是Object类定义的方法，wait()方法会立刻释放object monitor
3. notify()和notifyAll()方法只是唤醒此前调用了wait()方法的线程，但是自己并不会释放锁

