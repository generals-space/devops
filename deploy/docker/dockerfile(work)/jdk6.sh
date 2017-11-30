## JDK6 基础镜像
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f jdk6.sh -t docker.sky-mobi.com:5000/jdk:6.0.0 .
## REQUIRE: 需要如下文件通过远程download以减少镜像空间占用
#### 1. jdk包

FROM docker.sky-mobi.com:5000/centos:6.0.0
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "jiale.huang@sky-mobi.com"
## 环境变量, 使docker容器支持中文
ENV LANG zh_CN.UTF-8
################################################################
## JDK6
## 注意环境变量写入时是单引号
RUN curl http://192.168.166.220/software/jdk/jdk-6u45-linux-x64-rpm.bin -o /tmp/jdk-6u45-linux-x64-rpm.bin \
    && chmod 755 /tmp/jdk-6u45-linux-x64-rpm.bin \
    && bash /tmp/jdk-6u45-linux-x64-rpm.bin \
    && echo 'export JAVA_HOME=/usr/local/jdk1.6.0_45' >> /etc/profile \
    && echo 'export CLASSPATH=$JAVA_HOME/lib:$JAVA_HOME/jre/lib' >> /etc/profile \
    && echo 'export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH' >> /etc/profile \
    && echo 'source /etc/profile' >> /root/.bashrc \
    && rm -f /tmp/jdk-6u45-linux-x64-rpm.bin

