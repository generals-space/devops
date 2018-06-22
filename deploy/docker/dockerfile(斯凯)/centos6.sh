## CentOS6基础镜像, 安装gcc,vim等必要组件
## 使用方法 docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f CentOS6 -t docker.sky-mobi.com:5000/centos:6.0.0 .
FROM daocloud.io/centos:6
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "generals.space@gmail.com"
## 环境变量, 使docker容器支持中文
## ENV LANG C.UTF-8

################################################################
## 官方镜像完善
## 导入公司内网源...wget命令还需要另外安装, 直接用curl
RUN rm -f /etc/yum.repos.d/* 
#### yum clean all可以减少镜像大小...效果明显
RUN curl http://192.168.166.220/software/yum.repos.d/CentOS-Base-Skymobi_San_Dun.repo -o /etc/yum.repos.d/CentOS-Base-Skymobi_San_Dun.repo \
    && curl http://192.168.166.220/software/yum.repos.d/CentOS-Epel-Skymobi_San_Dun.repo -o /etc/yum.repos.d/CentOS-Epel-Skymobi_San_Dun.repo \ 
    && yum update -y \
    && yum install -y gcc gcc-c++ glibc-common make vim \
    && yum clean all
#### 容器时区调整及时间同步操作(`\cp -f`强制覆盖)
#### 猜测容器与宿主机保持时钟同步, 只是时间显示可能根据时区配置而有所不同
RUN \cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
