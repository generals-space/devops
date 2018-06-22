# docker部署文档(三)-关于oracle容器重启后导致应用容器启动失败的解决办法

<!date!>: 2018-02-28

> 文档内容请拷贝到[作业部落](https://www.zybuluo.com/mdeditor)以获得更好的排版格式和阅读效果.

注意:

1. 如果应用工程没有变动, 那oracle服务重启后, 应用会自动重新连接, 服务也会恢复正常. 

2. 但是如果应用工程在启动时oracle未运行, 数据库连接失败会直接导致工程启动失败, oracle重新运行后也无法恢复, 只能重启应用工程.

为实现**服务器启动** -> **docker服务启动** -> **oracle容器启动** -> **oracle服务启动** -> **应用容器启动**的顺序保持不变. 以及实现docker服务启动后, 添加防火墙规则允许容器内部访问宿主机, 需要做如下修改.

## 1. 修改oracle容器的`init.sh`脚本

`oracle`容器中, `/root/init.sh`脚本原来是使`sysctl`内核参数及`ulimit`生效的, 现在修改如下

```bash
#!/bin/bash
sysctl -p
chown oracle:oinstall /opt/oracle
su - oracle << EOF
lsnrctl  start
sqlplus "/as sysdba" << EOF
startup
EOF
## 上面的EOF将被两个'<<'符号共用.
echo 'complete...'
```

`oracle`容器启动后没有运行服务, 进入到容器中, 执行这个脚本就可以启动oracle了.

## 2. 实现docker服务启动后按顺序启动数据库与应用容器

编辑`/usr/lib/systemd/system/docker.service`文件(这是一个类`.ini`的配置文件). 在`[Service]`块中添加如下行

```
ExecStartPost=/bin/bash /root/onDockerStart.sh
```

`ExecStartPost`表示在docker服务启动后执行的操作, 上述行表示在docker服务启动后, 执行`onDockerStart.sh`脚本. 脚本内容如下

```bash
#!/bin/bash
## 解除容器内部访问宿主机的限制
## 有些情况下可能不存在INPUT_direct链
iptables -I INPUT_direct -s 172.21.0.0/16 -j ACCEPT || iptables -I INPUT -s 172.21.0.0/16 -j ACCEPT

## 启动oracle
oracle_cid=$(docker ps | grep oracle-final | awk '{print $1}')
docker exec $oracle_cid bash /root/init.sh

exit 0
```

> 对于应用与数据库分离的情况, 只要保证数据库已经启动, 然后重启启动`{cas,skydata-se,drgs,hdc-manager,etlloader}`这些容器就可以了.

`docker stop|start {cas,skydata-se,drgs,hdc-manager,etlloader}`