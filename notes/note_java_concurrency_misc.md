Building blocks
===

委托给线程安全的类去管理状态是非常有效的策略

java平台包含了一组并行构建块（concurrent building blocks)，包括线程安全集合，各种同步器（synchronizer)

Vector&Hashtable从jdk1.0中就存在了，自jdk1.2以后有了他们的同步版本（再Collections中），包括：
SynchronizedCollection，SynchronizedList，SynchronizedSet，SynchronizedSortedSet，SynchronizedMap，SynchronizedSortedMap等，这些类封装了状态和同步了每个公共方法以提供线程安全保障

NOTE:虽然这些同步集合类提供的方式是线程安全的，但是并不能保证这些方法的组合操作是线程安全的，比如：iteration，navigation，或put-if-absent操作。

比如：
public static Object getLast(Vector list) {
    int lastIndex = list.size() - 1; // line 1
    return list.get(lastIndex);
}

public static void deleteLast(Vector list) {
    int lastIndex = list.size() - 1;
    list.remove(lastIndex);
}
假设集合大小为10，线程A执行getLast的第一行获得lastIndex=9，然后切换到线程B执行deleteLast，执行完毕后集合大小变为9，然后线程A再继续执行list.get(9)，此时会抛出ArrayIndexOutOfBoundsException

在Vector上迭代也会产生因size被其他线程改变而造成的并发风险，比如：


迭代依赖于Vector集合不要在迭代过程中被修改，这在单线程环境中不会存在问题，但在多线程环境中A线程执行迭代操作到一半，B线程可以去修改该集合，因此当再次切换到线程A运行时也会抛出ArrayIndexOutOfBoundsException

尽管迭代会因其他线程对集合进行了修改而抛出异常，但并不表示Vector不是线程安全的。


Iterators and ConcurrentModificationException
===

同步容器的迭代器（Iterator）设计时并没有考虑并发修改问题，而是提供了fail-fast的机制，这意味着，容器会在迭代过程中及时发现集合已经被修改了并抛出unchecked的ConcurrentModificationException


具体实现是：和一个modification计数器关联，如果当迭代过程发现modification count发生了变化，那么hasNext或next方法就会抛出ConcurrentModificationException
然而这些操作并没有使用同步协调机制

在整个迭代期间锁住集合并不好，


---


