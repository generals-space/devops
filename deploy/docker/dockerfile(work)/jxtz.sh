## 极限挑战镜像
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f jxtz.sh -t reg01.sky-mobi.com/jxtz/jxtz:x.x.x .
## REQUIRE: 需要如下文件通过远程download以减少镜像空间占用

FROM  reg01.sky-mobi.com/base/jdk:6.0.0
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "jiale.huang@sky-mobi.com"
## 环境变量, 使docker容器支持中文
ENV LANG zh_CN.UTF-8
################################################################
## JDK6
## 注意环境变量写入时是单引号
EXPOSE 8822
RUN curl http://192.168.166.220/software/game/jxtz/game-jxtz.tar.gz -o /opt/game-jxtz.tar.gz \
    && cd /opt && tar -zxf /opt/game-jxtz.tar.gz \
    && rm -f /opt/game-jxtz.tar.gz
CMD cd /opt/game-jxtz/bin && ./start.sh product && tail -f /etc/yum.conf
