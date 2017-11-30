#!/bin/bash

## 基础依赖
yum install -y gcc gcc-c++ make automake

## 1.1 必选依赖与编译依赖
yum install -y zlib zlib-devel openssl openssl-devel

## 编译apr
./configure --prefix=/usr/local/apr && make && make install
## 编译apr-util
./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr && make && make install
#####################################################################

## 1. apache部分

## 1.2编译选项
cd apache
tar -zxf ./httpd-2.4.23.tar.gz
cd ./httpd-2.4.23
./configure --prefix=/usr/local/apache2 \
--with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util \
--with-z --with-pcre \
--enable-so --enable-ssl --enable-cgi --enable-rewrite --enable-deflate \
--enable-modules=most --enable-mpms-shared=all --with-mpm=event
