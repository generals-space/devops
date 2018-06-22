最好将编译好的`docker*`系二进制文件链接至`/usr/bin`目录下, 因为如果放在如`/usr/local/docker/bin`目录中然后将此目录加入到PATH环境变量中, 启动容器时也依然会报错说在$PATH中找不到`shim`或`runc`可执行文件. 如下 

```
$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/usr/local/docker/bin:/root/bin
$ docker run -it daocloud.io/centos:6 /bin/bash
docker: Error response from daemon: shim error: docker-runc not installed on system.
```

## 3. dockerd服务

### 3.2 daemon.json

`dockerd`配置文件, 需要是严格的json格式, 不可以增加自定义的键, 也不能添加注释.

其中的键名与`dockerd -h`显示出来的稍微有一些差异, 主要就是json文件里大部分都变成了复数形式...详细配置见[官方文档](https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file)

`tls*`系列的键如果没有确定的证书, 就不要写了, 因为如果赋值为空, `dockerd`也会去寻找并且报目标目录不存在什么的导致启动失败.

`dockerd`启动后会生成`.sock`文件, 供`docker`工具通信(如`docker search|pull`等操作都是连接dockerd才能完成的). 默认位置在`/var/run/docker.sock`, 如果在`daemon.json`中配置了其他路径, 执行docker操作时会报dockerd服务未启动的错误, 因为它找不到`.sock`文件. 虽然`docker`命令有提供一个`-H`参数可以指定连接哪一个主机上的`dockerd`, 但好像不起作用, 应该是一个bug.

## 4. runc

runc的各种子命令, 需要container-id的, 目前必须是完整id, 如果是短id, 可能会报`container "*" does not exist`的错误.