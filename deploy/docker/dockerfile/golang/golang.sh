## JDK6 基础镜像
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## REQUIRE: 需要如下文件通过远程download以减少镜像空间占用

FROM generals/centos6:latest
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "generals.space@gmail.com"
## 环境变量, 使docker容器支持中文
ENV LANG en_US.UTF-8

RUN yum install git -y \
    && curl https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz -o /usr/local/go1.10.3.linux-amd64.tar.gz \
    && cd /usr/local \
    && tar -zxf go1.10.3.linux-amd64.tar.gz \
    && rm -f go1.10.3.linux-amd64.tar.gz

RUN mkdir -p /root/go/{bin,pkg,src} \
    && echo 'export GOPATH=/root/go' >> /etc/profile \
    && echo 'export GOPATH=/root/go' >> /root/.bashrc \
    && echo 'export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin' >> /etc/profile \
    && echo 'export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin' >> /root/.bashrc