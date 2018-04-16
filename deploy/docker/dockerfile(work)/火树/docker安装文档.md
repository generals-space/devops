# docker安装文档

> 文档内容请拷贝到[作业部落](https://www.zybuluo.com/mdeditor)以获得更好的排版格式和阅读效果.

## 1. docker环境安装

系统要求: CentOS 7

通过yum安装docker, 首先配置yum镜像源, 使用阿里云镜像.

```bash
curl -o /etc/yum.repos.d/docker-ce.repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

然后安装并设置开机启动

```bash
yum install docker-ce
systemctl enable docker
```

在启动docker服务前, 配置docker存储目录(镜像/容器), 将其存储到容量比较大的分区. 这里假设为`/opt`.

```bash
mkdir /etc/docker
touch /etc/docker/daemon.json
```

写入`/etc/docker/daemon.json`的内容.

```json
{
    "data-root": "/opt/docker",
    "registry-mirrors": [
        "https://registry.docker-cn.com", 
        "https://docker.mirrors.ustc.edu.cn"
    ]
}
```

> docker-ce将`graph`字段修改为`data-root`

其中`data-root`字段为docker所有的镜像, 容器存放的位置, `/opt/docker`目录不必预先存在, 启动docker服务时会自动创建.

`registry-mirrors`字段为国内镜像源加速列表(在`火树`的使用场景中, 由于没有网络连接, 其实没什么用).

最后, 启动docker服务.

```
systemctl start docker
```

------

## 1.1 拷贝快捷命令

将`bash_docker.sh`文件中的内容追加到`/root/.bashrc`文件尾部, 然后`source /root/.bashrc`使之生效. 

该文件中包含了1个常用命令`docker-enter`. 

docker-enter 容器名/容器id: 进入目标容器, 将得到一个bash命令行

```
$ docker ps
CONTAINER ID        IMAGE                                          COMMAND                  CREATED             STATUS              PORTS                      NAMES
c98790552123        reg01.sky-mobi.com/huoshu/nginx:1.0.0          "/bin/sh -c 'servi..."   2 hours ago         Up 2 hours          0.0.0.0:80-81->80-81/tcp   quizzical_shannon
$ docker-enter c98790552123
[root@c98790552123 ~]# 
```

### 1.2 自定义网络

默认每台宿主机上启动的docker容器都在一个小型局域网内, 类似于虚拟机, 所有的流量通过宿主机做`nat`转发, 这也是一般路由器的工作方式.

但是这种方式类似于`dhcp`, 每次启动容器所获取的IP并不确定. 为了保证各工程容器地址固定, 我们需要创建自定义的docker局域网, 并在启动容器的时候指定该容器的IP. 

注意: 这个操作的目的是保持**工程容器**的地址固定, 比如, 写在工程配置文件中的redis与oracle地址, nginx配置文件中后端工程监听的IP与端口地址等, 不方便频繁变动的情况.

不过目前oracle在一台单独的服务器上, 所以并不需要创建的这个网络. 只在redis与工程容器所在的服务器上执行如下操作即可. 如下

```
$ docker network create --subnet=172.21.0.0/16 huoshu
```

在当前宿主机上创建一个小型局域网`subnet`, 不与外界连通. `huoshu`即为该网段名称, 启动一个docker容器时可以显示指定`--net huoshu`从而自动获取一个该网段内的IP.

约定`redis`运行在`172.21.0.3`这个地址, 工程配置文件不再需要再作修改.

自定义网络环境下, 容器与其宿主机本身的端口无法连通(但默认网络可以), 我们还需要添加一句如下代码, 使得容器内可以直接连接宿主机的端口, 无论通过`172.21.0.1`还是宿主机的物理IP, 都行.

```
$ iptables -I INPUT_direct -s 172.21.0.0/16 -j ACCEPT
```

## 2. docker的基本操作

### 2.1 关于save和load - 本地存储/拷贝镜像的方法

一般镜像的传播都是通过`pull/push`的方式, 通过镜像仓库完成转发. 鉴于`火树`此次的应用场景, 可以将镜像保存在本地, 然后拷贝于其他拥有docker环境的服务器上, 同样可以继续使用.

当前系统中的镜像列表可以通过`docker images`命令查看, 结果如下.

```
$ docker images
REPOSITORY                         TAG      IMAGE ID            CREATED             SIZE
reg01.sky-mobi.com/huoshu/redis    1.0.0    7a0e963024cf        6 hours ago         370MB
reg01.sky-mobi.com/huoshu/nginx    1.0.0    99e4c2104361        7 days ago          453MB
reg01.sky-mobi.com/huoshu/base     1.0.0    62925dab3a8e        7 days ago          330MB
```

使用如下命令可以将`nginx`镜像打包成`tar`文件.

```
$ docker save -o nginx-1.0.0.tar reg01.sky-mobi.com/huoshu/nginx:1.0.0
$ ls
nginx-1.0.0.tar
```

将`nginx-1.0.0.tar`文件拷贝到另一台拥有docker环境的服务器上, 加载它.

```
$ docker load < ./nginx-1.0.0.tar 
c97485ea5599: Loading layer [==================================================>]    125MB/125MB
834571917b0e: Loading layer [==================================================>]  3.584kB/3.584kB
Loaded image: reg01.sky-mobi.com/huoshu/nginx:1.0.0
$ docker images
REPOSITORY                                TAG                 IMAGE ID            CREATED             SIZE
reg01.sky-mobi.com/huoshu/nginx           1.0.0               99e4c2104361        7 days ago          453MB
```

可以看到**`load`之后会保持镜像名不变, 所以工程升级时, 打的镜像版本号也要不同, 不然会发生冲突**.

### 2.2 oracle地址的指定

约定在工程中oracle的地址统一写作`jdbc.oracle.addr`这个域名, 然后在有用到oracle的容器启动时, 在命令行中指定`ORACLE_ADDR`这个环境变量为实际oracle所在服务器地址(通过docker的`-e`选项可以实现). 

在容器启动过程中, 会将`ORACLE_ADDR`变量指定的地址与`jdbc.oracle.addr`写入容器本身的`/etc/hosts`文件, 即可实现该域名与oracle服务器地址的解析.