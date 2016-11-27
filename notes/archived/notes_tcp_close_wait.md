close_wait状态发生在被动关闭的一端

主动关闭方发出FIN后进入FIN_WAIT_1状态，当被动关闭方TCP协议栈收到FIN时会立即发送一个ack，发完ack后进入close_wait状态, 然后通知上层应用程序执行sokcet的close操作，如果close被调用，则发出FIN，从而使被动关闭方进入LAST_ACK状态；如果上层应用一直不调用socket.close()操作，那么被动关闭的一方将永远不能发出FIN,从而使自己一直停留在CLOSE_WAIT状态，主动关闭方由于收不到对端的FIN，则停留在FIN_WAIT_2状态。

但是TCP也不可能永远保持在这种状态（主动关闭方：FIN_WAIT_2,被动关闭方CLOSE_WAIT）,因为这样会造成TCP连接永远不会关闭的状态出现，这会造成系统资源的浪费（每个socket连接占用1.5k字节，Each socket left in memory takes approximately 1.5Kb of memory）

操作系统是通过tcp_fin_timeout这个参数来控制TCP停留在FIN_WAIT_2状态的超时时间的。该值默认为60秒，在2.2内核中一般使用180秒。（见注1）

收到主动关闭放发来的FIN，表示对端已经不再有数据需要发送，此时连接处于半关闭状态，当主动关闭方收到ack时候会进入FIN_WAIT_2状态，此时如果主动关闭方一直收不到对方发来的FIN，在tcp_fin_timeout超时时间内就一直保持着这种半关闭的状态（主动关闭方处于FIN_WAIT_2,被动关闭方处于CLOSE_WAIT），直到被动关闭方发出FIN从而使自己进入LAST_ACK，而主动关闭方进入TIME_WAIT，或者由于FIN_WAIT_2状态等待超时，从而主动关闭方发出RST重置连接。

Q:CLOSE_WAIT状态发生在那一端？
A:被动关闭的一端

Q:为什么叫CLOSE_WAIT?在WAIT谁？
A:等待上层应用关闭socket,但调用socket.close()的时候会向主动关闭方发出FIN，从而是自己进入LAST_ACK状态，主动关闭方收到FIN后进入TIME_WAIT状态

Q:半关闭状态时主动关闭方处于什么状态？被动关闭方处于什么状态？
A:主动关闭方处于FIN_WAIT_2状态，被动关闭方处于CLOSE_WAIT状态

Q:半关闭和半打开的区别?
A: 处于半关闭状态时两端都存在，只是被动关闭方还没有发出FIN而已。而半打开状态是另一方已经消失了。

Q:CLOSE_WAIT状态到底要停留多久？
A:一直等到主动关闭方停留在FIN_WAIT_2超时后向被动关闭方发出RST。被动关闭方收到RST后进入CLOSE状态。（需要注意的是RST报文段不会导致另一端产生任何响应，另一端根本不进行确认。收到RST的一方将终止该连接，并通知应用层连接复位）

注1：
@see: https://www.frozentux.net/ipsysctl-tutorial/chunkyhtml/tcpvariables.html

3.3.7. tcp_fin_timeout

The tcp_fin_timeout variable tells kernel how long to keep sockets in the state FIN-WAIT-2 if you were the one closing the socket. This is used if the other peer is broken for some reason and don't close its side, or the other peer may even crash unexpectedly. Each socket left in memory takes approximately 1.5Kb of memory, and hence this may eat a lot of memory if you have a moderate webserver or something alike.

This value takes an integer value which is per default set to 60 seconds. This used to be 180 seconds in 2.2 kernels, but was reduced due to the problems mentioned above with webservers and problems that arose from getting huge amounts of connections.

Also see the tcp_max_orphans and tcp_orphan_retries variables for more information.)
