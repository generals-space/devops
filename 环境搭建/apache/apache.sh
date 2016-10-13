#!/bin/bash

## 基础依赖
yum install gcc gcc-c++ make automake vim

#####################################################################
## 1. apache部分

## 1.1 安装必选依赖与编译依赖
yum install apr apr-util pcre-devel
yum install zlib zlib-devel openssl openssl-devel

## 1.2编译选项
cd apache
tar -zxf ./httpd-2.4.23.tar.gz
cd ./httpd-2.4.23
./configure --prefix=/usr/local/apache2 \
--with-z --with-pcre --with-apr --with-apr-util \
--enable-so --enable-ssl --enable-cgi --enable-rewrite --enable-deflate \
--enable-modules=most --enable-mpms-shared=all --with-mpm=event
