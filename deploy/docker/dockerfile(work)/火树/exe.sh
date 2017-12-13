## exe工程包, 基于datax3
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f exe.sh -t reg01.sky-mobi.com/huoshu/exe:1.0.0 .
FROM reg01.sky-mobi.com/huoshu/datax3:1.0.0
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "generals.space@gmail.com"
