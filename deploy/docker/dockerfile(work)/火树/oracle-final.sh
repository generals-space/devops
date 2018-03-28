## oracle-final工程包, 基于tomcat
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f oracle-final.sh -t reg01.sky-mobi.com/huoshu/oracle-final:1.0.2 .
FROM reg01.sky-mobi.com/huoshu/oracle-final:1.0.2
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "generals.space@gmail.com"
## 环境变量, 使docker容器支持中文
ENV LANG en_US.UTF-8

CMD /bin/bash -c 'set -e && tail -f /etc/yum.conf'

## docker run -d --privileged  --restart=always \
## --shm-size 2147483648 \
## --name oracle
## -e LANG=en_US.UTF-8
## -p 1521:1521 \
## -v /opt/oracle:/opt/oracle \
## reg01.sky-mobi.com/huoshu/oracle-final:1.0.3