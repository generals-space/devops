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
