JNDI：java naming and directory interface
===

如果不用JNDI:
c3p0.jdbcUrl=jdbc:mysql://{host}:{port}/{jdbc.catalog}?xxx
驱动要改，导致jdbc:mysql需要变更
数据库服务器迁移导致的地址和端口号发生变化：host:port要改
数据库改名：jdbc.catalog要改
...

有了JNDI：

---

javax.management.ObjectName

{domain}:{key-property-list}

ObjectName:com.sun.management:type=HotSpotDiagnostic
ClassName:sun.management.HotSpotDiagnostic







---

TODO:

- [ ] J2EE容器
- [ ] bbb
- [ ] ccc
