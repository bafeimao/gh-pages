notes_tcp_timeout_and_retry
超时或重传
通过对收到的数据进行确认来提供可靠的传输层。

但发送端发的数据可能丢失，确认也可能会丢失。TCP在发送端设置一个定时器（重传定时器）来解决这个问题，当定时器溢出时还没收到ack（可能发送的数据丢了，也有可能ack丢了），TCP就会自动重传改数据

不管何种实现，关键之处在于选择各自不同的策略：设定“超时间隔”（多久没收到ack就重传）和“重传频率”（重传多少次）

一般地，按1.5秒的倍乘关系设定每次重传的“超时间隔时间”，重传频率取值12次，如果仍然收不到ack，则放弃发送并发送一个复位信号（RST)，约9分钟退出。（tcp_ip_abort_interval变量） ，且其默认值为2分钟，而不是最常用的9分钟





