参考文章

[指令文档](https://docs.docker.com/engine/reference/builder/)

[最佳实践](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)


```
$ docker build -f ./CentOS6 -t docker.generals.space:5000/centos6:1.0.0 .
```

> call, `docker build`时, 镜像名竟然不能有大写字母...

## 最佳实践

### 1. 

`Dockerfile`文件建议放在某个空目录中, 然后将`build`过程中所需要的文件放到这个目录中. 可以使用`.dockerignore`文件排除当前一个文件或目录, 其语法类似于`.gitignore`.

### 2. 

可以使用多行参数, 类似于shell脚本, 可以使用反斜线`\`连接.

## 3. 缓存

`build`过程中docker会将每一层都建立镜像, 出错后重新开始时就不必再重新建立之前的镜像层.

使用`docker build --no-cache=true`禁用缓存.

### 3.1 dockerfile缓存机制

#### 3.1.1

初始的基础镜像必然会从缓存层去寻找, 之后的指令就会比较缓存层子镜像是由父级镜像执行哪一条指令生成的了, 而比较的正是待执行的指令字符串.

#### 3.1.2

通过`ADD`和`COPY`指令拷贝到构建容器中的文件, docker只会检查他们的md5值(...可能是md5吧, 实际叫checksum值), 而不关心他们的`last-modified`与`last-accessed`时间.

如果当前build的镜像的ADD或COPY指令要拷贝的文件与已经存在的镜像层所包含的文件的checksum值相同, 就会用缓存层代替.

#### 3.1.3

除了`ADD`和`COPY`, 其他的命令就不会比较文件检验值了, 比如`RUN apt-get -y update`, 这种操作生成的tmp类型文件也许是随机的, 这种情况下就单纯比较生成该缓存层时的指令字符串了.


## 4. 指令

`COPY`与`ADD`比较相似, 后者在拷贝过程中还会自动解压已经后缀的压缩包, 不过官方推荐使用`COPY`, 更透明.

多个文件最好单独COPY, 比如如果直接拷贝一个目录, 那么该目录中任何一个文件变动都将导致缓存层失效而无法重用, 很浪费.

COPY与ADD指令只能使用相对路径, 相对于当前dockerfile. 无法使用绝对路径. 但是这两个好像复制进去的文件会占用镜像本身的空间.

官方的最佳实践提倡, 考虑到镜像大小, 不使用COPY或ADD, 取代的是使用`curl`或`wget`这种, 从远程下载到本地, 并在同一条指令中完成编译操作, 然后及时删除该文件. 这样, 文件不会占用该层的空间. 如下示例

```
ADD http://example.com/big.tar.xz /usr/src/things/
RUN tar -xJf /usr/src/things/big.tar.xz -C /usr/src/things
RUN make -C /usr/src/things all
```

```
RUN mkdir -p /usr/src/things \
    && curl -SL http://example.com/big.tar.xz \
    | tar -xJC /usr/src/things \
    && make -C /usr/src/things all
```

第一种是不被提倡的, 鼓励第二种.

`VOLUME`不能作为临时挂载进容器的方法, 它只能将容器内部的某一目录作为数据卷让其他容器挂载, 所以拷贝文件什么的操作用它是没有效果的.

`ENV`指令只在当前build过程中有效, 之后启动的容器及子镜像中都无法继承这些变量, 将这些变量写入`/etc/profile`是一个更好的选择.

猜测容器与宿主机保持时钟同步, 只是时间显示可能根据时区配置而有所不同. 所以在容器内部执行`ntpdate cn.pool.ntp.org`可能会出现`ntpdate[81]: Can't adjust the time of day: Operation not permitted`错误.