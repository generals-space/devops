## Tomcat 基础镜像
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## REQUIRE: 需要如下文件通过远程download以减少镜像空间占用
#### 1. tomcat包

FROM docker.sky-mobi.com:5000/jdk:8.0.0
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "generals.space@gmail.com"
## 环境变量, 使docker容器支持中文
ENV LANG en_US.UTF-8
################################################################
## JDK6
RUN curl http://172.16.4.101/software/tomcat/apache-tomcat-8.5.4.tar.gz -o \
    /usr/local/apache-tomcat-8.5.4.tar.gz \
    && cd /usr/local && tar -zxf apache-tomcat-8.5.4.tar.gz \
    && rm -f apache-tomcat-8.5.4.tar.gz \
    && rm -rf /usr/local/apache-tomcat-8.5.4/webapps/*
