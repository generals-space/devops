#!/bin/env bash
## function: nginx日志文件压缩备份
## 1. 需要定义nginx日志文件路径
## 2. 需要使用crontab定时执行, 注意`date_format`变量格式需要随crontab的时间间隔自主修改, 默认为1天1分割.


## 是否启用压缩
need_compress=1
## 待切割日志文件目录
log_path=/usr/local/nginx/logs
## 分割后或是备份后的日志的存放目录
bak_path=$log_path
## 待分割的日志文件, 只分割以log结尾的文件(排除可能存在的pid和已经被分割/压缩过的文件)
log_files=$(ls $log_path/*.log)
## 通过pid文件获取nginx主进程号
nginx_pid=$log_path/nginx.pid
## date_format=$(date -d "30 min ago" "+%Y-%m-%d_%H-%M")
date_format=$(date -d "1 day ago" "+%Y-%m-%d_%H-%M")

mkdir -p $bak_path
for i in ${log_files}
do
    log_name=${bak_path:-/opt}/$(basename ${i}).${date_format}
    mv -v $log_path/$(basename ${i}) $log_name
    if [[ $need_compress != 0 ]]; then gzip $log_name; fi
    kill -USR1 $(cat ${nginx_pid})
done
