#!/bin/bash

## 源码安装php
## 需要配置的只有filename与prefix变量, 其中prefix可以留空, 默认为/usr/local/php

## 开启严格模式, 有一条命令出错就会终止执行
set -e


pre_install ()
{
  ## php源码编译前依赖安装
  yum install -y gcc gcc-c++ make
  yum install -y \
  libxml2 libxml2-devel \
  libvpx libvpx-devel \
  libjpeg libjpeg-devel \
  libpng libpng-devel \
  libXpm libXpm-devel \
  t1lib t1lib-devel \
  freetype freetype-devel \
  gd gd-devel \
  readline readline-devel \
  curl libcurl-devel \
  zlib zlib-devel \
  bzip2 bzip2-devel \
  openssl openssl-devel \
  libmcrypt libmcrypt-devel \
  mhash mhash-devel \
  mcrypt
}

## function: compile
#### param1: source_path, 源码目录. 必选 
#### param2: prefix, 安装目录. 可选(默认为user/local/php)
compile ()
{
  ## 用于执行php的依赖安装与源码编译
  ## 而不包括php与fpm的配置, 与服务安装

  if [ -n "$1" ]; then source_path=$1; else echo '请指定源码目录'; fi
  if [ -n "$2" ]; then prefix=$2; fi

  ## 编译选项
  ####注意: --with-mysql=mysqlnd表示使用php官方的mysql驱动, 所以编译php前不需要安装mysql
  ## ./configure \
  cd $source_path && ./configure \
  --prefix=$prefix \
  --with-config-file-path=$prefix/etc \
  --enable-inline-optimization \
  --enable-pcntl --enable-mysqlnd \
  --enable-opcache --enable-sockets \
  --enable-sysvmsg --enable-sysvsem --enable-sysvshm \
  --enable-shmop \
  --enable-zip --enable-ftp \
  --enable-soap --enable-xml \
  --enable-mbstring \
  --enable-shared \
  --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd \
  --enable-fpm --with-fpm-user=www --with-fpm-group=www \
  --with-pcre-regex --with-iconv \
  --with-gettext --with-readline --with-pear \
  --with-zlib --with-bz2 \
  --with-gd --with-xmlrpc --with-curl \
  --with-mcrypt --with-openssl --with-mhash --with-imap-ssl \
  --disable-rpath --disable-fileinfo \
  --disable-debug
  make && make install
}

begin(){
  ## 脚本当前所在路径
  base_dir=$(pwd)
  ## 源码压缩包路径
  unpkg=$filename
  pkg=$unpkg.tar.gz
  ## 源码包解压后的路径(绝对路径)
  source_path=$base_dir/$unpkg

  ## 安装依赖
  ## pre_install
  ## 解压到当前目录
  tar -zxf $pkg
  ## 源码编译
  #### compile.sh会先进入源码目录再执行configure命令
  compile $source_path $prefix

  ## 清理安装文件
  rm -rf $source_path
}

## 源码包名
filename=php-5.4.45
## 目录安装路径
prefix=/usr/local/php
## 开始执行
begin