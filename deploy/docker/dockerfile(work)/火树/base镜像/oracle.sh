## oracle依赖环境封装, 基础镜像
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f oracle-base.sh -t reg01.sky-mobi.com/huoshu/oracle-base:1.0.0 .
FROM reg01.sky-mobi.com/huoshu/base:1.0.0
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "generals.space@gmail.com"
## 环境变量, 使docker容器支持中文
ENV LANG en_US.UTF-8

################################################################
RUN yum install -y openssh wget \
    gcc gcc-c++ glibc glibc-common glibc-devel \
    binutils compat-libstdc++-33 elfutils-libelf \
    elfutils-libelf-devel libaio libaio-devel libgcc \
    libstdc++ libstdc++-devel make numactl sysstat libXp \
    unixODBC unixODBC-devel \
    && yum clean all

COPY sysctl.conf /etc/sysctl.conf
COPY limit.conf /tmp/limit.conf
COPY oracle.env /tmp/oracle.env
COPY init.sh /root/init.sh

RUN cat /tmp/limit.conf >> /etc/security/limits.conf \
    && echo 'session required pam_limits.so' >> /etc/pam.d/login \
    && groupadd oinstall && groupadd dba && groupadd oper \
    && useradd -g oinstall -G dba,oper oracle \
    && cat /tmp/oracle.env >> /home/oracle/.bash_profile \
    && mkdir /opt/oraInventory && chown oracle:oinstall /opt/oraInventory

## 启动命令, 不管是安装oracle还是启动oracle容器, 都要按照如下命令
## --shm-size可以设置容器/dev/shm的值, oracle要求至少大于1G(docker默认64M)
## 单位为byte, 2G * 1024 * 1024 * 1024 = 2147483648 bytes
## docker run -it --privileged  --restart=always \
## --shm-size 2147483648 \
## -p 1521:1521 -v /opt/oracle:/opt/oracle \
## reg01.sky-mobi.com/huoshu/oracle:1.0.0 /bin/bash

###############################################################
## 启动脚本init.sh

## #!/bin/bash
## sysctl -p
## chown oracle:oinstall /opt/oracle

################################################################
## limit.conf

## oracle soft nproc 2047
## oracle hard nproc 16384
## oracle soft nofile 1024
## oracle hard nofile 65536
## oracle soft stack 10240

################################################################
## sysctl.conf

## fs.file-max = 6815744
## fs.aio-max-nr=1048576
## kernel.shmall = 2097152
## kernel.shmmax = 2147483648
## kernel.shmmni = 4096
## kernel.sem = 250 32000 100 128
## net.ipv4.ip_local_port_range = 9000 65500
## net.core.rmem_default = 262144
## net.core.rmem_max = 4194304
## net.core.wmem_default = 262144
## net.core.wmem_max = 1048576

################################################################
## 环境变量 oracle.env

## export ORACLE_BASE=/opt/oracle #安装目录
## export ORACLE_HOME=$ORACLE_BASE/11g #oracle家目录
## export ORACLE_SID=orcl #实例名
## export LD_LIBRARY_PATH=$ORACLE_HOME/lib
## export PATH=$PATH:$ORACLE_HOME/bin:$HOME/bin
