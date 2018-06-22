## etlloader工程包, 基于datax3
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f etlloader-separate.sh -t reg01.sky-mobi.com/huoshu/etlloader-separate:1.0.0 .
FROM reg01.sky-mobi.com/huoshu/datax:3.0.0
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "generals.space@gmail.com"
## 环境变量, 使docker容器支持中文
ENV LANG en_US.UTF-8
RUN echo 'LANG=en_US.UTF-8' >> /root/.bashrc
## profile中的环境变量需要手动加载, 否则没法用
CMD echo "$ORACLE_ADDR jdbc.oracle.addr" >> /etc/hosts \
    && source /etc/profile \
    && chmod 755 /opt/etlloader/*.sh \
    && cd /opt/etlloader && ./run.sh start && ./exe.sh start \
    && tail -f /etc/yum.conf

## 启动命令
## docker run -d --restart=always \
## --net huoshu --ip 172.21.1.4 -p 8380:8380 \
## -e ORACLE_ADDR=172.16.4.101 \
## -e LANG='en_US.UTF-8' \
## -v /opt/apps/etlloader:/opt/etlloader \
## -v /var/log/etlloader:/opt/etlloader/consolelog \
## reg01.sky-mobi.com/huoshu/etlloader-separate:1.0.0