## nginx镜像封装
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f nginx.sh -t reg01.sky-mobi.com/huoshu/nginx:1.0.0 .
FROM reg01.sky-mobi.com/huoshu/base:1.0.0
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "generals.space@gmail.com"
## 环境变量, 使docker容器支持中文
ENV LANG zh_CN.UTF-8
################################################################
RUN yum install nginx -y \
    && yum clean all
COPY nginx.conf /etc/nginx/nginx.conf
CMD service nginx start && tail -f /etc/yum.conf

## 启动命令, 挂载配置文件目录及日志目录, 映射端口
## docker run -d --restart=always \
## --net huoshu --ip=172.21.0.2 -p 80:80 -p 81:81 \
## -v /opt/apps:/opt/apps \
## -v /opt/apps/nginx.conf.d:/etc/nginx/conf.d \
## -v /var/log/nginx:/var/log/nginx \
## reg01.sky-mobi.com/huoshu/nginx:1.0.0

################################################################
## nginx.conf

## user nginx;
## worker_processes 8;
## error_log /var/log/error.log;
## pid /var/run/nginx.pid;
## 
## include /usr/share/nginx/modules/*.conf;
## 
## events {
##     worker_connections 65535;
## }
## 
## http {
##     log_format  main  '$remote_addr - [$time_local] "$request" '
##                       '$status $body_bytes_sent "$http_referer" '
##                       '"$http_user_agent" "$http_x_forwarded_for"';
## 
##     access_log  /var/log/nginx/access.log  main;
## 
##     sendfile            on;
##     tcp_nopush          on;
##     tcp_nodelay         on;
##     keepalive_timeout   65;
##     types_hash_max_size 2048;
## 
##     include             /etc/nginx/mime.types;
##     default_type        application/octet-stream;
## 
##     include /etc/nginx/conf.d/*.conf;
## }
