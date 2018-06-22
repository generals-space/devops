## redis镜像
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f redis.sh -t reg01.sky-mobi.com/huoshu/redis:1.0.0 .
## REQUIRE: 需要如下文件通过远程download以减少镜像空间占用

FROM reg01.sky-mobi.com/huoshu/base:1.0.0
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "generals.space@gmail.com"
## 环境变量, 使docker容器支持中文
ENV LANG en_US.UTF-8
################################################################
## 注意环境变量写入时是单引号
RUN curl http://172.16.4.101/redis-2.8.3.tar.gz -o /usr/local/redis-2.8.3.tar.gz \
    && cd /usr/local && tar -zxf redis-2.8.3.tar.gz \
    && rm -f redis-2.8.3.tar.gz \
    && cd redis-2.8.3 && make \
    && ln -s /usr/local/redis-2.8.3/src/redis-server /usr/bin/redis-server \
    && ln -s /usr/local/redis-2.8.3/src/redis-cli /usr/bin/redis-cli \
    && mkdir /var/log/redis

COPY redis.conf /usr/local/redis-2.8.3/redis.conf
CMD /usr/bin/redis-server /usr/local/redis-2.8.3/redis.conf && tail -f /etc/yum.conf

## 启动命令 映射端口, 挂载存储及日志目录
## docker run -d --restart=always \
## --net huoshu --ip=172.21.0.3 -p 6379:6379 \
## -v /var/log/redis:/var/log/redis \
## reg01.sky-mobi.com/huoshu/redis:latest