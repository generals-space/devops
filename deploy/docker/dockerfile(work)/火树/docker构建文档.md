# docker构建文档

> 文档内容请拷贝到[作业部落](https://www.zybuluo.com/mdeditor)以获得更好的排版格式和阅读效果.

`base`目录中是用到的基础镜像.

主要原理就是把工程拷贝到依赖的基础镜像中, 设置好启动命令...就可以了.

以`hdc-manager.sh`为例.

```
## hdc-manager工程包, 基于tomcat
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f hdc-manager.sh -t reg01.sky-mobi.com/huoshu/hdc-manager:1.0.0 .
FROM reg01.sky-mobi.com/huoshu/tomcat:latest
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "generals.space@gmail.com"
## 环境变量, 使docker容器支持中文
ENV LANG en_US.UTF-8

COPY se /usr/local/apache-tomcat-8.5.4/webapps/se

CMD echo "$ORACLE_ADDR jdbc.oracle.addr" >> /etc/hosts \
    && source /etc/profile \
    && /usr/local/apache-tomcat-8.5.4/bin/startup.sh \
    && tail -f /etc/yum.conf
```

`FROM`: 表示所依赖的基础镜像, `hdc-manager`依赖`tomcat`镜像.

`MAINTAINER`: 创建者信息, 可以不用管.

`ENV`: 设置环境变量, 与bash命令行中`export`的功能类似.

`COPY`: 会拷贝与构建文件相同路径下的文件到容器内部, 不存在的路径将会自动创建. 上面是将`war`包拷贝到`webapps`的`se`目录下. **注意`se`后的斜线**, 如果没有这个斜线, war包将会被拷贝成名为`se`的文件.

`RUN`: 可以执行shell命令, 这里是进入`se`目录, 解压war包并删除原文件. 注意`source`命令, java的环境变量在docker中无法自动生效, 手动加载一下.

`CMD`: 指定容器启动时执行的操作. 将启动时定义的oracle地址变量写入`hosts`文件, 执行`tomcat`的`startup`脚本, 然后执行一下永远不会退出的命令. 就可以了.

`A && B`: 表示只有`A`语句执行完毕且成功后才能执行`B`语句.

------

构建命令, 注意镜像版本号.