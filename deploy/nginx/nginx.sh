#!/bin/bash

## nginx源码编译

## 安装依赖
yum install -y gcc gcc-c++ make glibc glibc-common
## nginx必选依赖, 不必指定
yum install -y pcre pcre-devel
## nginx 开启`--with-http_perl_module`选项
yum install -y perl perl-ExtUtils-Embed
## nginx 开启`--with-http_ssl_module`选项
yum install -y openssl openssl-devel
## nginx 开启`--with-http_image_filter_module`选项
yum install -y gd gd-devel
## nginx 开启`--with-http_image_filter_module`选项
yum install -y GeoIP GeoIP-devel
## 编译选项

./configure \
--prefix=/usr/local/nginx \
--user=nginx --group=nginx \
--with-file-aio --with-ipv6 --with-http_ssl_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_image_filter_module --with-http_geoip_module \
--with-http_sub_module --with-http_dav_module \
--with-http_flv_module --with-http_mp4_module \
--with-http_gunzip_module --with-http_gzip_static_module \
--with-http_random_index_module --with-http_secure_link_module \
--with-http_degradation_module --with-http_stub_status_module \
--with-http_perl_module --with-mail --with-mail_ssl_module \
--with-pcre --with-pcre-jit --with-debug

## 第三方模块

## nginx-dav-ext-module, github可以找到
## 依赖 expat-devel
## 编译选项 `--with-http_dav_module --add-module=目标模块路径`

make && make install

## 创建nginx用户
## 在$NGINX/conf/nginx.conf文件中记得把`user`字段的值修改为nginx
useradd -s /sbin/nologin nginx
