## Tomcat 基于jdk8, 用作基础镜像
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f tomcat.sh -t reg01.sky-mobi.com/huoshu/tomcat:8.0.0 .
FROM reg01.sky-mobi.com/huoshu/jdk:latest
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "generals.space@gmail.com"
################################################################
RUN curl http://172.16.4.101/apache-tomcat-8.5.4.tar.gz -o /usr/local/apache-tomcat-8.5.4.tar.gz \
    && cd /usr/local && tar -zxf apache-tomcat-8.5.4.tar.gz \
    && rm -f apache-tomcat-8.5.4.tar.gz \
    && rm -rf /usr/local/apache-tomcat-8.5.4/webapps/*

COPY tomcat-context.xml /usr/local/apache-tomcat-8.5.4/conf/context.xml
