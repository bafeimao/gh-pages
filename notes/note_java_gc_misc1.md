一个精通GC的人往往是一个好的Java开发者
如果你对GC的处理过程感兴趣，说明你已经具备较大规模应用的开发经验

Stop-the-world意味着 JVM 因为要执行GC而停止了应用程序的执行。当Stop-the-world发生时，除了GC所需的线程以外，所有线程都处于等待状态，直到GC任务完成。GC优化很多时候就是指减少Stop-the-world发生的时间。

在Java程序中不能显式地分配和注销内存。有些人把相关的对象设置为null或者调用System.gc()来试图显式地清理内存。设置为null至少没什么坏处，但是调用System.gc()会显著地影响系统性能，必须彻底杜绝

两种假设:
大多数对象会很快变得不可达
只有很少的由老对象（创建时间较长的对象）指向新生对象的引用

持久代（ permanent generation ）也被称为方法区（method area）。他用来保存类常量以及字符串常量。因此，这个区域不是用来永久的存储那些从老年代存活下来的对象。这个区域也可能发生GC。并且发生在这个区域上的GC事件也会被算为major GC。

无论哪种垃圾回收算法，在回收时都会发生Stop-The-World

分代垃圾回收

Java程序代码中不会显示的声明和释放一块内存空间

GC的创建基于两大假设：
a）大量实例对象短时间内变得不可达（unreachable）

b）只有少量老的实例对象的引用指向新的对象

这些假设被成为“弱代假设”——weakgenerational hypothesis。所以为了呈现这种假设、HotSpot VM物理上被划分为两块区域——“年轻代”和“年老代”（younggeneration and old generation）。

young generation , old generation, + permanent generation

young = eden + 2( survivors)

permanent generation, alias: methods area, class & meta

当young generation发生GCC时要如何检查该对象是否被old区应用呢？

old generation: has a cardtable, 512k
card table: <o1@old>, {o2@old}, {o3@old}


TODO？
Method Area
TLAB (Thread local allocation buffers)

Bump-the-pointer












































