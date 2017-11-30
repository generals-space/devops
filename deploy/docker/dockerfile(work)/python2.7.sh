## Python 2.7 基础镜像: 安装源码编译, 安装pip, 设置镜像源等
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## REQUIRE: 需要如下文件通过远程download以减少镜像空间占用
#### 1. python源码包
#### 2. get-pip.py文件
#### 3. pip.conf文件

FROM docker.sky-mobi.com:5000/centos:6.0.0
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "generals.space@gmail.com"
## 环境变量, 使docker容器支持中文
ENV LANG zh_CN.UTF-8
################################################################
## Python
RUN yum -y install python-devel openssl-devel sqlite-devel \
    && yum clean all
RUN curl http://192.168.166.220/software/python/Python-2.7.12.tgz -o /tmp/Python-2.7.12.tgz \
    && cd /tmp && tar -zxf ./Python-2.7.12.tgz \
    && cd /tmp/Python-2.7.12 \
    && ./configure --prefix=/usr/local/python2.7 \
    && make && make install \
    && rm -rf /tmp/Python-2.7.12* \
    && echo 'PATH=$PATH:/usr/local/python2.7/bin' >> /etc/profile \
    && echo 'source /etc/profile' >> /root/.bashrc

## 修改系统默认python版本, 替换yum使用的python版本
RUN rm -f /usr/bin/python && ln -s /usr/local/python2.7/bin/python /usr/bin/python \
    && sed -i 's/\#\!\/usr\/bin\/python$/\#\!\/usr\/bin\/python2.6/' /usr/bin/yum

## 安装pip, 设置镜像源
RUN curl http://192.168.166.220/software/python/get-pip.py -o /tmp/get-pip.py \
    && cd /tmp && python get-pip.py \
    && rm -rf /tmp/get-pip.py \
    && curl http://192.168.166.220/software/python/pip.conf -o /etc/pip.conf
