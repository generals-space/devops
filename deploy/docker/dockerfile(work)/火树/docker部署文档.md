# docker部署文档

> 文档内容请拷贝到[作业部落](https://www.zybuluo.com/mdeditor)以获得更好的排版格式和阅读效果.

其中`oracle`, `redis`在第一次部署完成后不再需要大的变动, 工程容器则需要经常升级, `nginx`容器也需要经常重启.

**注意点:**

1. `docker run`中`-v`选项是将宿主机目录挂载到容器中的指定目录, 这是一个覆盖的操作.

2. 挂载的日志目录务必放在宿主机的空间较大的分区上, 以免日志满而造成服务无法运行. 该文档中认为`/opt`是空间较大的分区.

3. docker服务会接管宿主机的防火墙, 容器与宿主机的端口映射都是有docker通过iptables完成的, 所以不要再执行关闭或清空防火墙的操作.

## 1. oracle容器操作

### 启动容器

```
$ docker run -d --privileged  --restart=always \
--shm-size 2147483648 \
-p 1521:1521 \
-v /opt/oracle:/opt/oracle \
reg01.sky-mobi.com/huoshu/oracle-final:1.0.3
```

使用`docker-enter`进入容器, 执行初始化脚本, 并启动数据实例

```bash
## 执行初始化脚本, 使sysctl配置生效
bash /root/init.sh 
## 切换用户
su - oracle
## 启动oracle监听器
lsnrctl  start
## 进入sqlplus命令行
sqlplus "/as sysdba"
SQL> startup
ORACLE instance started.

Total System Global Area 3206836224 bytes
Fixed Size		    2217632 bytes
Variable Size		  369101152 bytes
Database Buffers	 2818572288 bytes
Redo Buffers		   16945152 bytes
Database mounted.
Database opened.
SQL> 
```

退出容器, 回到宿主机命令行.

如果`oracle`容器在独立的服务器上, 则不需要指定IP, 只需要映射容器的1521端口到宿主机本身的1521端口上即可.

**注意:**

由于`--restart=always`启动参数的存在, 容器异常崩溃时会自动重启. 其他容器都设置了启动时自动运行其中的服务的规则, 但是`oracle`容器没有这个配置, 所以oracle容器挂掉后依然需要手动进入容器再执行一遍上述操作.

数据存储目录需要单独打包. 启动时也应把这个目录挂载出来, 以防容器崩溃时数据丢失.

## 2. nginx容器操作

### 2.1 启动容器

```
docker run -d --restart=always \
--net huoshu --ip=172.21.0.2 -p 80:80 -p 81:81 \
-v /opt/apps/front:/opt/apps \
-v /opt/apps/front/nginx.conf.d:/etc/nginx/conf.d \
-v /var/log/nginx:/var/log/nginx \
reg01.sky-mobi.com/huoshu/nginx:1.0.0
```

------

**关于升级**

上述启动命令中挂载的`/opt/apps/front`的目标结构如下.

```
$ tree -L 2
.
├── bi_FE
├── hdc_FE
└── nginx.conf.d
    ├── bi.conf
    └── hdc.conf
```

其中`nginx.conf.d`挂载到nginx容器的`/etc/nginx/conf.d`目录, 所以可以直接在宿主机上编辑这个文件再重启容器中的nginx.

另外, 由于`/opt/apps/front`目录整个挂载到容器中, 在nginx容器运行期间, 这个目录不可删除. 升级前端工程时需要将新的工程包放到这个`/opt/apps/front`目录下, 替换掉原来的工程目录, 然后重启nginx.

> 不可删除的原因, nginx容器持有`/opt/apps/front`目录的句柄, 删除这个目录只是删除了它的索引, 实际存储块还在. 新建的目录不会重新挂载到容器.

### 2.2 nginx重启命令

不用进入容器就可以执行命令, 使用`docker exec 容器id 目标命令`, 如下

```
$ docker exec c98790552123 nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
$ docker exec c98790552123 nginx -s reload
```

当然, `docker-enter`进入容器再操作也是一样的.

## 3. redis容器操作

启动命令: 映射端口, 挂载存储及日志目录(都在`/var/log`目录下).

```
$ docker run -d --restart=always \
--net huoshu --ip=172.21.0.3 -p 6379:6379 \
-v /var/log/redis:/var/log/redis \
reg01.sky-mobi.com/huoshu/redis:1.0.0
```

## 4. 工程容器

注意: 

1. `--net`, `--ip`与`-p`选项指定的值与nginx的配置文件对应, 不要轻易修改.

2. `ORACLE_ADDR`变量, 不同医院的oracle地址要在启动时指定, 根据实际情况修改.

`etlloader`

```
$ docker run -d --restart=always --name etlloader \
--net huoshu --ip 172.21.1.4 -p 8380:8080 \
-e ORACLE_ADDR=172.16.4.101 \
-v /var/log/etlloader:/opt/etlloader/consolelog \
reg01.sky-mobi.com/huoshu/etlloader:1.0.0
```

`skydata-se`

```
$ docker run -d --restart=always --name skydata-se \
--net huoshu --ip=172.21.1.3 -p 8280:8080 \
-v /var/log/skydata-se:/usr/local/apache-tomcat-8.5.4/logs \
-e ORACLE_ADDR=172.16.4.101 \
reg01.sky-mobi.com/huoshu/skydata-se:1.0.0
```

`hdc-manager`

```
$ docker run -d --restart=always --name hdc-manager \
--net huoshu --ip=172.21.1.2 -p 8180:8080 \
-v /var/log/hdc-manager:/usr/local/apache-tomcat-8.5.4/logs \
-e ORACLE_ADDR=172.16.4.101 \
reg01.sky-mobi.com/huoshu/hdc-manager:1.0.0
```

`drgs`

```
$ docker run -d --restart=always \
--net huoshu --ip 172.21.1.5 -p 9998:9998 \
-e ORACLE_ADDR=172.16.4.101 \
-v /var/log/drgs:/opt/drgs/log \
reg01.sky-mobi.com/huoshu/drgs:1.0.0
```