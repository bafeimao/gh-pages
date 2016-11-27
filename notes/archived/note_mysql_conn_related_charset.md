note_mysql_conn_releated_charset

客户端通过一个连接（connection）发送一个查询给服务器，服务器通过connection返回一个结果集或错误给客户端，都将会涉及到charset和collation

当服务器接收到一个客户端的请求时会做如下处理：
接收时：首先将query从character_set_client字符集转换为character_set_connection
返回时：将character_set_server字符集转换为character_set_results

连接相关的变量共有三个：
character_set_client 
character_set_connection 
character_set_results 

两种方式可以设置这三个变量：
1： 通过：SET NAMES 'charset_name' [COLLATE 'collation_name']
set names utf8mb4

2. 也可以通过三条语句分别设置：
SET character_set_client = charset_name;
SET character_set_results = charset_name;
SET character_set_connection = charset_name;

***（1）（2）是等效的***

检查当前的charset设置：
show variables like 'character%';
------------------------------------
character_set_client	utf8
character_set_connection	utf8
character_set_database	utf8mb4
character_set_filesystem	binary
character_set_results	utf8
character_set_server	utf8
character_set_system	utf8
character_sets_dir	/usr/share/mysql/charsets/

执行set names语句：
set names utf8mb4
show variables like 'character%';
------------------------------------
character_set_client	utf8mb4
character_set_connection	utf8mb4
character_set_database	utf8mb4
character_set_filesystem	binary
character_set_results	utf8mb4
character_set_server	utf8
character_set_system	utf8
character_sets_dir	/usr/share/mysql/charsets/

执行后发现这三个发生了变化：
character_set_client	utf8mb4
character_set_connection	utf8mb4
character_set_results	utf8mb4



