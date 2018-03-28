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
    && sed -i "s/jdbc.cas.addr/${CAS_ADDR}/g" /xxx/test.conf \
    && source /etc/profile \
    && /usr/local/apache-tomcat-8.5.4/bin/startup.sh \
    && tail -f /etc/yum.conf

## 启动命令
## docker run -d --restart=always \
## --net huoshu --ip=172.21.1.2 -p 8180:8080 \
## -v /var/log/hdc-manager:/usr/local/apache-tomcat-8.5.4/logs \
## -e ORACLE_ADDR=172.16.4.101 \
## reg01.sky-mobi.com/huoshu/hdc-manager:1.0.0