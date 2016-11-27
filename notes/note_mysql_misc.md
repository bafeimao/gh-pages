c3p0如何支持建立连接时发送SET NAMES语句

<!-- 数据连接池 -->
<bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource" destroy-method="close">
	...
    
    <property name="connectionCustomizerClassName" value="com.mchange.v2.c3p0.example.InitSqlConnectionCustomizer"/>
    <property name="extensions">
        <map>
            <entry key="initSql" value="SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci"/>
        </map>
    </property>
</bean>