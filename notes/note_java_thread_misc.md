### 优点：

1. 资源利用率更好
2. 程序设计在某些情况下更简单
3. 程序响应更快
 
### 多线程的代价

1. 设计更复杂
2. 上下文切换的开销
3. 增加资源消耗

### 并发编程模型
【http://ifeve.com/%E5%B9%B6%E5%8F%91%E7%BC%96%E7%A8%8B%E6%A8%A1%E5%9E%8B/】
1. 并行工作者模型
并行工作者模式的优点是，它很容易理解。你只需添加更多的工作者来提高系统的并行度。

并行工作者模型的缺点
一旦共享状态潜入到并行工作者模型中，将会使情况变得复杂起来
线程需要避免竟态，死锁以及很多其他共享状态的并发性问题
此外，在等待访问共享数据结构时，线程之间的互相等待将会丢失部分并行性。
会导致在这些共享数据结构上出现竞争状态
高竞争基本上会导致执行时出现一定程度的串行化

解决：
1. 非阻塞并发算法
2. 可持久化的数据结构（String, CopyOnWriteArrayList等）
虽然可持久化的数据结构在解决共享数据结构的并发修改时显得很优雅，但是可持久化的数据结构的表现往往不尽人意。

很难在任何特定的时间点推断系统的状态

2. 流水线模式
通常使用非阻塞的IO来设计使用流水线并发模型的系统




----
在临界区中使用适当的同步就可以避免竞态条件。

基础类型的局部变量是线程安全的

局部的对象引用

对象的局部引用和基础类型的局部变量不太一样。尽管引用本身没有被共享，但引用所指的对象并没有存储在线程的栈内。所有的对象都存在共享堆中。如果在某个方法中创建的对象不会逃逸出（译者注：即该对象不会被其它方法获得，也不会被非局部变量引用到）该方法，那么它就是线程安全的。实际上，哪怕将这个对象作为参数传给其它方法，只要别的线程获取不到这个对象，那它仍是线程安全的。下面是一个线程安全的局部引用样例：

---

AtomicInteger:

1.7:

    public final int getAndSet(int newValue) {
        for (;;) {
            int current = get();
            if (compareAndSet(current, newValue))
                return current;
        }
    }

public final boolean compareAndSet(int expect, int update) {
        return unsafe.compareAndSwapInt(this, valueOffset, expect, update);
    }

1.8:

  public final int getAndSet(int newValue) {
        return unsafe.getAndSetInt(this, valueOffset, newValue);
    }

【http://ifeve.com/enhanced-cas-in-jdk8/】

降低锁粒度
不要长时间持有不必要的锁
分别用不同的锁来保护同一个类中多个独立的状态变量
而不是对整个类域只使用一个锁。

独占锁：是一种悲观锁，synchronized就是一种独占锁，会导致其它所有需要锁的线程挂起，等待持有锁的线程释放锁。

乐观锁：每次不加锁，假设没有冲突去完成某项操作，如果因为冲突失败就重试，直到成功为止。

1、非阻塞算法 （nonblocking algorithms）

一个线程的失败或者挂起不应该影响其他线程的失败或挂起的算法。

https://en.wikipedia.org/wiki/Non-blocking_algorithm

CAS看起来很爽，但是会导致“ABA问题”。


https://en.wikipedia.org/wiki/ABA_problem












