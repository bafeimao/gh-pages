title: 基于IPVS的IP负载均衡技术
s: ipvs-based-load-balance-in-detail
date: 2012-07-25 23:58:46
tags: [ipvs,load balance,linux]
---

随着互联网的高速发展，应用规模日益膨胀，越来越多的应用面临大流量，高并发的压力，因此大型互联网应用开始对构建高可用，高可扩展，不间断的服务提出了更高的要求。为应对大规模高并发的要求，分布式集群以及负载均衡等技术应运而生，本文主要讲解基于IP的负载均衡技术。

> IP负载均衡技术工作在IP层，并且在运行在操作系统内核中，相比于其他工作在应用层（如HTTP层）的负载均衡技术（如：HTTP重定向负载均衡，反向代理负载均衡）而言，它的分发效率是最高的。

先说明几个重要的名词解释：

> *	Director（调度器，又叫负载均衡器/负载分发设备/负载分流设备）
*	RS（真实服务器，隐藏在Director后面的一组提供服务的机器）
*	DIP（调度服务器的IP）
*	VIP（虚拟IP，该IP用户调度器，用于集群对外提供服务的IP）
*	RIP（真实服务器的IP）
*	CIP（客户端IP）

IP负载均衡主要包括以下几种工作模式：

## VS/NAT模式

VS/NAT（Virtual Server via Network Address Translation）的意思是“网络地址转换”，其原理是：调度器（也称之为：负载均衡器，Director等）收到来自客户端的“请求报文”后，根据指定的调度算法，将请求报文转发（负载分发）给隐藏在调度器后面的一组“真实服务器”（以下称RS）中的某台服务器去处理，当真实服务器处理完成后，又将报文发给调度器，调度器再一次修改IP数据包内种中的源地址和源端口，然后将响应报文发回给客户端，至此，完成整个负载分发过程。

IPVS模块是linux内核自带的，它工作在内核IP层，根据制定的调度算法和工作模式（NAT,DR，TUN)对负载进行分发，同时linux还提供ipvsadm管理工具，方便我们对IPVS进行配置。IPVS还内置提供了多种调度策略，并且内部还维护着一个“客户端连接->真实服务器”的Hash映射表，该hash表的作用是将客户端的后续报文都转发到同一台机器进行处理。

很多硬件负载均衡设备就是采用NAT原理的。

### 基本要求
*	调度器（Director）至少需要绑定两个IP（DIP和VIP），其中VIP是作为集群中对外服务的唯一接口；DIP用于连接内部RS服务器组，使调度器和RS服务器组连接在内部LAN中
*	调度器需要配置成可以转发IP数据报（设置ip_forward=1）
*	RS必须设置默认网关为DIP，以便响应报文能够发回到Director
*	RS和Director必须在同一个子网中，否则RS不能正确将“响应报文”发送到Director
*	如果client和调度器位于同一网段，那么就不能使用VS/NAT模式，此时可配置成VS/DR模式。（请思考为什么？）

### 报文转发的详细处理流程

*	来自客户端的请求报文发送到调度器（通过VIP）
*	调度器网卡根据数据帧首部MAC地址发现是发给自己的，因此收下该数据帧并将其发给上层网卡驱动程序，网卡驱动去掉帧首部得到IP数据包内容并将其传给IP层处理。
*	IPVS模块通过调度算法（或从连接映射hash表中找到映射，如果之前已经映射过的话），得到一台真实服务器（Real Server / RS），假设为RS1。
*	修改IP数据报首部的“目标IP地址”和“目标端口”为RS1的IP和端口，然后将该数据包直接又发回给本机ARP模块处理
*	ARP模块为IP地址找到对应的mac地址（这里是RS1网卡所对应的MAC地址，关于ARP如何做地址映射可《参考TCP/IP详解-卷一》）
*	网卡驱动重新封装数据帧，并直接将数据帧发送到位于同一网络的RS1机器的网络接口卡
*	RS1收到从调度器发来的数据帧，发现目标mac地址是自己，同时IP数据包内容中的目标地址也是本主机地址，所以就会处理该报文并交由响应端口对应的应用程序去处理
*	当RS处理完成后，会设置响应报文中的“目标IP地址=CIP(CIP表示客户端IP), 源IP地址=RIP”，源端口=RS1的对应端口”
*	RS搜索本机路由表，发现CIP并不是一个直接相连的主机也不是位于同一共享网络中，因此使用默认路由(DIP)进行路由转发，此时响应报文被发送到DIP（即调度器的IP）。
*	调度器收到来自RS的响应报文，再次修改源IP地址为VIP以及源端口为调度器的端口，然后将报文重新发回给客户端

至此，对报文的完整流程处理结束，报文被发回客户端


### 存在的问题

请求报文和响应报文都要经过调度器，因此调度器将会成为整个集群的瓶颈，这主要来自于：
*	调度器对报文处理的速度
*	调度器网卡出口带宽两方面，响应报文往往比请求报文要大的多，当这些响应报文都要经过调度器时，调度器网卡出口带宽将会是个瓶颈

由于IPVS工作在内核，处理速度非常高，因此调度器的主要瓶颈来自于调度器的网卡带宽上。

### 解决方案

*	为应付不断增长的流量，可以升级调度器的网卡为千兆网卡或万兆网卡，同时调度器与RS服务器组连接的交换机也要换成千兆或万兆的。除此以外，还要考虑调度器总线带宽，看操作系统和硬件配置能否应付处理的了那么大的流量。
*	结合DNS-RR。将大的VS/NAT集群根据某种策略（如地域或其他）划分成多个小得集群，然后和DNS轮询混合使用
*	考虑到多数应用请求报文小而响应报文大的这种非对称性特点，我们可以将VS/NAT模式换成VS/DR模式，这将会极大的提升调度器的吞吐率

### 补充说明：
> 调度器不但会修改“目标IP”还会修改“目标端口”，因此该模式支持端口映射（其他模式不支持）


## VS/DR模式
       
VS/DR（直接路由）模式是对NAT模式的一种改进，该模式充分考虑到多数互联网服务的“非对称特性”（即请求报文小，响应报文大）特点，让Director仅接受请求报文，并且不修改数据包的情况下，直接将报文转发给RS处理（链路层数据帧目标地址发生了变化而已,IP数据报内容原封不动），当目标服务器处理完成后，直接将“响应报文”发送给Client，而不用在发给Director，因此，使用该模式调度器的吞吐率会得到了极大的提升。

和NAT模式的一个显著的区别在于：在NAT模式下，需要在RS上设置网关为VIP，但在DR模式下，需要将VIP映射到RS服务器的本地“环回接口（loopback/lo interface)”上，这是因为DR模式Direcotor并没有对请求报文内容进行任何修改，仅仅只是转发报文给RS，如果没有在RS上映射VIP地址，当RS收到Director转发的报文时发现“目标IP地址=VIP"并不是本机，所以就会简单的丢弃掉该报文，这不是我们期望的，如果希望RS能够接受报文，最简单办法就是将VIP映射到本地“环回接口”上。这样Director就能够正确的处理从Director转发过来的报文了。（为什么不能将VIP映射到本地网卡上呢？请思考！）


### 基本要求
*	与RS必须在同一个网络里，因为Director是直接修改数据帧的“目标mac地址”为RS的mac地址，因此，如果RS和Director不在一个直接相连的网络里（需要通过路由器路由）的话，RS将收不到该数据帧。
*	DR模式不要求Director开启路由转发
*	DR模式一定不能将网关设置到DIP，因为这将导致报文又发回到Director，这不是期望的结果
*	在RS上需要将VIP绑定到lo接口上
 `$ ifconfig lo:0 inet VIP netmask 255.255.255.255` ）


---

### FAQ:

A：为什么当Client和负载均衡器位于同一子网中时不可使用NAT模式？

A：在DR模式下，为什么不能在RS上将VIP映射到本地网卡上，而是映射到环回接口呢？
---
Q: 因为lo接口是一个non-arp网络设备，它不会响应ARP请求，而其他接口会响应ARP请求。我们知道Director上的VIP是必须要对外的，整个集群的前端应该只有Director来接受“目标IP地址=VIP”的请求，如果在RS上将VIP映射到能够响应ARP请求的网络设备接口上，那么就会出现Director和RS都告诉ARP请求端它们各自的mac地址，这时就会造成混乱，请求报文可能不会发送到Director上而是直接被RS接收到了。