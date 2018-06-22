## JDK8 基础镜像
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f jdk8.sh -t reg01.sky-mobi.com/base/jdk:8.0.0 .
## REQUIRE: 需要如下文件通过远程download以减少镜像空间占用
#### 1. jdk包

FROM reg01.sky-mobi.com/base/centos:6.0.0
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "jiale.huang@sky-mobi.com"
## 环境变量, 使docker容器支持中文
ENV LANG en_US.UTF-8
################################################################
## JDK8
## 注意环境变量写入时是单引号
RUN curl http://192.168.166.220/software/jdk/jdk-8u101-linux-x64.tar.gz -o /usr/local/jdk-8u101-linux-x64.tar.gz \
    && cd /usr/local && tar -zxf jdk-8u101-linux-x64.tar.gz \
    && echo 'export JAVA_HOME=/usr/local/jdk1.8.0_101' >> /etc/profile \
    && echo 'export CLASSPATH=$JAVA_HOME/lib:$JAVA_HOME/jre/lib' >> /etc/profile \
    && echo 'export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH' >> /etc/profile \
    && echo 'source /etc/profile' >> /root/.bashrc \
    && rm -f /usr/local/jdk-8u101-linux-x64.tar.gz
