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
