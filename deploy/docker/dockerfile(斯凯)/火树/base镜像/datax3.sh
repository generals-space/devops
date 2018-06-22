## DataX3 基于jdk8, 用作基础镜像
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f datax3.sh -t reg01.sky-mobi.com/huoshu/datax:3.0.0 .
FROM reg01.sky-mobi.com/huoshu/jdk:8.0.0
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "generals.space@gmail.com"
## 环境变量, 使docker容器支持中文
ENV LANG en_US.UTF-8

################################################################
RUN mkdir /opt/datax3 \
    && curl http://172.16.4.101/datax.tar.gz -o /opt/datax3/datax.tar.gz \
    && cd /opt/datax3 && tar -zxf datax.tar.gz \
    && rm -f datax.tar.gz
