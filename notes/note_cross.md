SELECT * FROM Task WHERE type=4 and state=1

19297,^4.34%
240+10.416 = 250.416 == 250(20647)(diff=1350)

fangcom
19138^1.29%
1000,
ARI名义利率
EAR:实际利率
1000+360=1360=37.78
年12%??acutal:21-23%!!! -_-!!!
非还本付息的信用贷，
Mr.Nua

合肥是从2016.06-20开始实行网签的



// 利用代理工厂（ProxyFactory）创建一个代理类Stub，利用这个Stub可以远程调用指定的方法
// 这种方式调用是阻塞式的，直到远程服务器返回
RoleService roleService = ProxyFactory.newBlockingStub(RoleService.class, rpcChannel);
Role role = roleService.getRoleByAccountName("john");
System.out.println(role);

// New Stub
Stub<RoleService> roleService = ProxyFactory.newStub(RoleService.class, rpcChannel);
RpcFuture future = roleService.invoke("getRoleByAccountName", "john").addListener(new RpcCallback() {
            @Override
            public void success(Object result) {
                System.out.println("success:" + result);
            }

            @Override
            public void fail(Throwable e) {
                System.out.println("error:" + e);
            }
        });

// 同步阻塞调用一直到有返回值回来
Object result = future.get();