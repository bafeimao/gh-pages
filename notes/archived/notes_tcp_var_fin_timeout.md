see: https://www.frozentux.net/ipsysctl-tutorial/chunkyhtml/tcpvariables.html

3.3.7. tcp_fin_timeout

The tcp_fin_timeout variable tells kernel how long to keep sockets in the state FIN-WAIT-2 if you were the one closing the socket. This is used if the other peer is broken for some reason and don't close its side, or the other peer may even crash unexpectedly. Each socket left in memory takes approximately 1.5Kb of memory, and hence this may eat a lot of memory if you have a moderate webserver or something alike.

This value takes an integer value which is per default set to 60 seconds. This used to be 180 seconds in 2.2 kernels, but was reduced due to the problems mentioned above with webservers and problems that arose from getting huge amounts of connections.

Also see the tcp_max_orphans and tcp_orphan_retries variables for more information.

ktgu:

如果对方对FIN进行了确认，则主动关闭端进入FIN-WAIT-2状态，此时等待对方发送FIN，从而让自己进入TIME-WAIT状态，但是此时对方可能已经挂了，此种情况将会导致主动关闭方永久的停留在FIN-WAIT-2状态，设置tcp_fin_timeout参数的目的就是告诉内核保持FIN-WAIT-2状态多久时间.

默认60秒，2.2内核中通常设为3分钟。

