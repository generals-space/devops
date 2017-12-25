## CentOS6基础镜像, 安装gcc,vim等必要组件
## 使用方法 docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f base.sh -t reg01.sky-mobi.com/huoshu/base:1.0.0 .
FROM centos:6
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "generals.space@gmail.com"
## 环境变量, 使docker容器支持中文
ENV LANG en_US.UTF-8

################################################################
## 官方镜像完善
RUN rm -f /etc/yum.repos.d/* 
#### yum clean all可以减少镜像大小...效果明显
RUN curl http://mirrors.aliyun.com/repo/Centos-6.repo -o /etc/yum.repos.d/Centos-6.repo \
    && curl http://mirrors.aliyun.com/repo/epel-6.repo -o /etc/yum.repos.d/epel-6.repo \ 
    && yum update -y \
    && yum install -y gcc gcc-c++ glibc-common make vim \
    && yum clean all
#### 容器时区调整及时间同步操作(`\cp -f`强制覆盖)
#### 猜测容器与宿主机保持时钟同步, 只是时间显示可能根据时区配置而有所不同
RUN \cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
