静默安装参考

[ oracle11g静默安装（修正） ](http://blog.itpub.net/29510932/viewspace-1135313/)

[静默安装Oracle时提示："[SEVERE] - Email Address Not Specified"](http://blog.51cto.com/binuu/1744641)

./runInstaller -silent -ignoreSysPrereqs -ignorePrereq -responseFile /home/oracle/database/db_install.rsp

-silent指的是静默安装，-ignorePrereq忽略prerequisite的检查结果，responseFile是种子文件

`-responseFile`必须为绝对路径

`oraInventory`不能在oracle base路径下
mkdir /opt/oraInventory
chown oracle:oinstall /opt/oraInventory

安装完数据库, 执行了两个脚本, 但实例没启动, 要手动启动, 参数如下.

[Oracle 数据库启动与关闭 各种方式详解整理](http://blog.csdn.net/lutinghuan/article/details/7484062)

进入sqlplus后手动`startup`

```
[oracle@dd29483217a1 ~]$ sqlplus  / as sysdba;

SQL*Plus: Release 11.2.0.1.0 Production on Wed Dec 6 18:17:54 2017

Copyright (c) 1982, 2009, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> startup
ORA-01078: failure in processing system parameters
LRM-00109: could not open parameter file '/opt/oracle/11g/dbs/initorcl.ora'
SQL> 

```

[Oracle12c连接问题ORA-28040：没有匹配的验证协议](http://blog.csdn.net/wangl2014/article/details/53506120)


启动后执行/root/init.sh脚本, 使sysctl配置生效, 修改数据存储目录属主, 
然后以oracle用户身份启动监听器和数据库实例
启动监听：lsnrctl  start
启动实例：   sqlplus  / as dba; 然后 startup

## 静默安装后初始化

静态安装完成后, 可以启动监听器, 但是还没有数据库实例.

oracle的的数据库类似于数据文件的概念, 而数据库实例才是真正响应客户端请求的服务.

我们需要创建一个数据库实例提供这样的服务.

### 建立参数文件

这个参数文件在创建数据库的时候会调用到. 文件名为`init` + `sid`名称 + '.ora'.

这里把sid命名为`orcl`, 所以文件名为`initorcl.ora`.

这个文件要放置在`$ORACLE_HOME/dbs`目录下.

```
instance_name = orcl 
service_names = orcl
db_cache_size=2097152000
java_pool_size=16777216
large_pool_size=16777216
shared_pool_size=335544320
streams_pool_size=0
background_dump_dest='/opt/oracle/admin/orcl/bdump'
compatible='10.2.0.1.0'
control_files='/opt/oracle/oradata/control01.ctl','/opt/oracle/oradata/control02.ctl','/opt/oracle/oradata/control03.ctl'
db_block_size=8192
db_domain=''
db_file_multiblock_read_count=16
db_name='orcl'
job_queue_processes=10
open_cursors=300
pga_aggregate_target=825229312
processes=150
remote_login_passwordfile='NONE'
sga_target=2476736512
undo_management='AUTO'
undo_tablespace='UNDOTBS1'
user_dump_dest='/opt/oracle/admin/orcl/udump'
```

### 启动数据库到nomount状态

```
sqlplus "/as sysdba"
SQL> startup nomount
```

### 创建数据库

在sqlplus命令行中执行如下命令.

其中数据库名`orcl`与`initorcl`文件对应.

```
Create database orcl
datafile '/opt/oracle/oradata/system01.dbf' size 300M reuse autoextend on next 10240K maxsize 1024m
extent management local
sysaux datafile '/opt/oracle/oradata/sysaux01.dbf'
size 120M reuse autoextend on next 10240K maxsize 1024m
default temporary tablespace temp
tempfile '/opt/oracle/oradata/temp01.dbf' size 1024M reuse autoextend on next 640K maxsize 2048m
undo tablespace "UNDOTBS1" 
datafile '/opt/oracle/oradata/undotbs01.dbf' size 1024M reuse autoextend on next 5120K maxsize 2048m
logfile
group 1 ('/opt/oracle/oradata/redo01.log') size 500m,
group 2 ('/opt/oracle/oradata/redo02.log') size 500m,
group 3 ('/opt/oracle/oradata/redo03.log') size 500m
CHARACTER SET UTF8
NATIONAL CHARACTER SET UTF8;
8
```

### 安装数据字典. 

`@?`可以在sqlplus命令行直接执行sql文件中的语句.

```
@?/rdbms/admin/catalog.sql
@?/rdbms/admin/catproc.sql
conn system/manager
@?/sqlplus/admin/pupbld.sql
```

退出sqlplus命令行, 因为下面的语句在system/manager下无权限执行, 重新以system用户登录, 再执行:

```
create spfile from pfile;
```