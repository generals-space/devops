#!/bin/bash

yum install -y \
readline-devel zlib-devel \
pam-devel libxml2-devel libxslt-devel openldap-devel \
python-devel openssl-devel \
perl-ExtUtils-Embed \
gcc-c++ make cmake \
tcl tcl-devel \
## ossp-uuid需要uuid-devel
uuid-devel

./configure \
--prefix=/opt/pgsql  --with-pgport=1921 \
--with-perl  --with-tcl  --with-python  --with-openssl \
--with-pam --without-ldap  --with-ossp-uuid \
--with-libxml --with-libxslt \
--with-blocksize=32 --with-wal-blocksize=32 \
--enable-thread-safety 

## 貌似install-world= install + install-doc
make world && make install-world  

## 创建用户组和用户：
groupadd postgres
useradd -g postgres postgres

## 配在postgres用户的环境变量文件中
export PGPORT=1921
export PGDATA=/data01/pg_root
export PGHOST=$PGDATA
export LANG=en_US.utf8
export PGHOME=/opt/pgsql
export LD_LIBRARY_PATH=$PGHOME/lib:/lib64:/usr/lib64:/usr/local/lib64:/lib:/usr/lib:/usr/local/lib
export DATE=`date +"%Y%m%d%H%M"`
export PATH=$PGHOME/bin:$PATH:.
export MANPATH=$PGHOME/share/man:$MANPATH

su - postgres
initdb

## 配置服务项
cp /opt/postgresql-版本号/contrib/start-scripts/linux /etc/init.d/postgresql

## pg配置文件在上面$PGDATA路径下`postgresql.conf`

pg_ctl start