RpcChannel
	host, port
	callMethod()
	handleResponse()

RpcController

RpcServer : Server
	start()
	stop()

RpcException : RuntimeException
	errorCode
	errorMessage

ErrorCode
	BAD_REQUEST, SERVICE_NOT_FOUND,  METHOD_NOT_FOUND, RPC_ERROR, RPC_FAILED

RpcCallback<T>
	run(T me)

----------------------------------------------------------------------------------------------------

调用1：
RpcCallBack<User> callback = new RpcCallback<User>() {}

RpcChannel channel = new RpcChannel(host, port);
UserService.Stub userService = UserService.newStub(channel);

service.view(channel.newController(), request, callback);

----------------------------------------------------------------------------------------------------

调用2：
HelloService helloService = RpcClient.create(HelloService.class);
String result = helloService.hello("World");

AsyncProxy<HelloService> helloSerice  = rpcClient.createAsync(HelloService.class);
RPCFuture future = helloSerice.call("hello", "world");
Object result = future.get();



// Aproach-1
UserService userService = ServiceProxyFactory.newBlockingStub(HelloService.class, channel);
String result = userService.say("hello");

// Aproach-2
Stub<UserService> userService = ServiceProxyFactory.newStub(HelloService.class, channel);
RpcFuture future = userService.say("hello");
Object result = future.get();


// 创建非阻塞式的Service Stub
ServiceProxyFacotry.newStub(HelloService.class, channel, new Invocation(service) {
	service.say("hello");
});

channel.callAsync(new Invocation(service) { });