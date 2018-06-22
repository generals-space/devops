## skycmdb 环境镜像: 安装源码编译, 安装pip, 设置镜像源等
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f ./gunicorn.sh -t reg01.sky-mobi.com/skycmdb/gunicorn:1.0.0 .

FROM reg01.sky-mobi.com/base/python:2.7.0
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "generals.space@gmail.com"
## 环境变量, 使docker容器支持中文
ENV LANG en_US.UTF-8

RUN yum install -y unixODBC* freetds* nginx openldap-devel \
    && yum clean all \
    && source /etc/profile \
    && pip install gunicorn>=19.7.1 eventlet \
    && rm -f /etc/nginx/conf.d/*

COPY skycmdb2.conf /etc/nginx/conf.d/skycmdb2.conf

## skycmdb2.conf配置文件
## server {
##     listen       80 default;
## 
##     access_log  /opt/skycmdb/logs/nginx_skycmdb.log  main;
##     error_log /opt/skycmdb/logs/nginx_skycmdb.err.log;
## 
##     proxy_set_header Host $http_host;
##     proxy_set_header X-Real-IP $remote_addr;
##     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
##     proxy_set_header X-Forwarded-Proto $scheme;
## 
##     location / {
##             proxy_pass http://127.0.0.1:5000;
##     }
##     ## 内嵌idc网络监控
##     location ^~ /map_ping {
##         proxy_pass http://192.168.164.138;
##     }
##     location ~ \.(gif|jpg|jpeg|png|bmp|ico|js|css|html)$ {
##         root /opt/skycmdb/skycmdb;
##         ## expires 30d;
##         add_header Cache-Control no-store; 
##     }
##     location /socket.io {
##         ## 额外添加的配置, nginx代理websocket时, 解决客户端连接经常断开的问题
##         ## proxy_read_timeout 600s;
##         ## proxy_send_timeout 600s;
##         ## proxy_connect_timeout 600s;
##         proxy_http_version 1.1;
##         proxy_buffering off;
##         proxy_set_header Upgrade $http_upgrade;        proxy_set_header Connection "Upgrade";
##         proxy_pass http://127.0.0.1:5000/socket.io;    
##     }
## }
