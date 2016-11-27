note_msyql_charset_collation

##### 服务端charset&collation

可以在启动mysqld时指定参数：--character-set-server 以及 --collation-server

如果没有指定，则使用默认值：
--character-set-server=latin1
--collation-server=latin1_swedish_ci

因此，以下几个命令效果一样：
shell> mysqld
shell> mysqld --character-set-server=latin1
shell> mysqld --character-set-server=latin1 --collation-server=latin1_swedish_ci

如果要修改这两个默认选项的值，可以重新编译
shell> cmake . -DDEFAULT_CHARSET=latin1
shell> cmake . -DDEFAULT_CHARSET=latin1 -DDEFAULT_COLLATION=latin1_german1_ci

使用CREATE DATABASE语句创建数据时，如果没有指定character-set和collation，则使用character-set-server和collation-server值
创建数据库时最好不要依赖mysql默认值，建议指定字符集和排序规则

创建数据库并指定字符集和排序规则(http://dev.mysql.com/doc/refman/5.7/en/charset-database.html)：
CREATE DATABASE mydb DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

*** 当mydb数据库创建后，在mydb中创建表时，所有的字符列都将使用utf8mb4字符集和utf8mb4_general_ci排序规则 ***

修改数据库字符集和排序规则：
ALTER DATABASE mydb DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;

查看当前服务器的字符集和排序规则:
SHOW VARIABLES like 'character%';
SHOW VARIABLES like 'collation%';
也可以使用：
SHOW CHARSET where charset like 'utf8%';
SHOW CHARSET like 'utf8%';
SHOW COLLATION where collation like 'utf8mb4%';
SHOW COLLATION like 'utf8mb4%';
或者：
SELECT @@character_set_database, @@collation_database, @@character_set_server, @@collation_server;

这些变量可以在运行时被改变:
set character_set_server=utf8mb4;
set character_set_client=utf8mb4;
