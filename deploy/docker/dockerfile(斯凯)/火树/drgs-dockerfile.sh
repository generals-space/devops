## drgs工程包, 基于datax3
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f drgs-dockerfile.sh -t reg01.sky-mobi.com/huoshu/drgs:1.0.0 .
FROM reg01.sky-mobi.com/huoshu/datax:3.0.0
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "generals.space@gmail.com"
## 环境变量, 使docker容器支持中文
ENV LANG en_US.UTF-8

## 注意, 没有预先创建eltloader目录, 所以最后的斜线不能省略
COPY drgs-0.0.1-SNAPSHOT.jar /opt/drgs/
COPY drgs.sh /opt/drgs/

## profile中的环境变量需要手动加载, 否则没法用
CMD echo "$ORACLE_ADDR jdbc.oracle.addr" >> /etc/hosts \
    && source /etc/profile \
    && chmod 755 /opt/drgs/*.sh \
    && cd /opt/drgs && ./drgs.sh start \
    && tail -f /etc/yum.conf

## 启动命令
## docker run -d --restart=always \
## --net huoshu --ip 172.21.1.5 -p 9998:9998 \
## -e LANG=en_US.UTF-8 \
## -e ORACLE_ADDR=172.16.4.101 \
## -v /var/log/drgs:/opt/drgs/log \
## reg01.sky-mobi.com/huoshu/drgs:1.0.0