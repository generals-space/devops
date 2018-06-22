## skycmdb 工程镜像: 安装源码编译, 安装pip, 设置镜像源等
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f ./skycmdb.sh -t reg01.sky-mobi.com/skycmdb/skycmdb:1.0.0 .

FROM reg01.sky-mobi.com/skycmdb/gunicorn:1.0.0
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "generals.space@gmail.com"
## 环境变量, 使docker容器支持中文
ENV LANG en_US.UTF-8
ENV PYTHONUNBUFFERED=1
ENV RUNNING_ENV=dev

RUN useradd -m -d /opt/skycmdb skycmdb \
    ## 允许nginx用户进入skycmdb家目录
    && chmod 705 /opt/skycmdb
COPY skycmdb /opt/skycmdb/skycmdb
RUN chown -R skycmdb:skycmdb /opt/skycmdb \
    && source /etc/profile \
    && pip install -r /opt/skycmdb/skycmdb/requirements.txt

CMD service nginx start \
    && source /etc/profile \
    && sed -in "s/env = 'live'/env = '${RUNNING_ENV}'/g" /opt/skycmdb/skycmdb/conf/config.py \
    && gunicorn -k eventlet -w 1 -c /opt/skycmdb/skycmdb/conf/pro/gunicorn.py SKY:application \
    && tail -f /etc/yum.conf

## 启动命令
## docker run -d --restart=always \
## --name=skycmdb --hostname=skycmdb \
## -e RUNNING_ENV=dev \
## -p 3001:80 \
## -v /opt/skycmdb_log:/var/log/nginx \
## -v /opt/skycmdb_log:/opt/skycmdb/logs \
## reg01.sky-mobi.com/skycmdb/skycmdb:1.0.0