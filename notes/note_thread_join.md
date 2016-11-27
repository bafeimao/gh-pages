请理解下面一段代码的含义（假设代码运行在main线程中）：

```
Thread t1 = new Thread(new EventThread("e1"));
t1.start();
Thread t2 = new Thread(new EventThread("e2"));
t2.start();
while (true) {
   try {
      t1.join();
      t2.join();
      break;
   } catch (InterruptedException e) {
      e.printStackTrace();
   }
}
```

上述代码所要达到期望的目标是：
* main线程调用t1.join()后main线程进入waiting状态，等待t1线程执行完成
* t1线程结束后通知（notfiy)main线程，main线程重新进入可运行状态
* main线程调用t2.join()，继续之前调用t1.join()系统的流程
* t2线程完成后回到main线程，整个流程结束

NOTE:
* 上述代码存在一个认知误区，很多人认为t1,t2是串行执行的，但其实t1和t2是并行执行的
* 执行t1.join()时并不会对t2线程产生影响
* join方法内部实际是调用的wait方法从而让调用方进入waiting（on monitor)状态,
* 此例中main方法调用t1.join()后将会导致main方法进入t1的monitor等待队列，直到t1执行完毕后被唤醒（notify)，当t1结束时唤醒main线程，main线程状态将会由waiting状态变为runnable状态等待执行
* 当main方法再次获得CPU时间片执行时，执行t2.join()































