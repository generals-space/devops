#!/bin/bash
redis_path=$(pwd)
if [ $1 == 'clean' ]; then
	echo '清除pid文件'
	rm -rf $redis_path/run/* 
	echo '清除log文件'
	rm -rf $redis_path/log/*
        read -p '是否清除数据文件?[y/n]' ops
        if [ $ops == 'y' ]; then
		echo '清除rdb, aof数据文件...'
		rm -rf $redis_path/data/* 
        fi;
fi;

if [ $1 == 'binpath' ]; then
	export PATH=$PATH:$redis_path/bin
fi

if [ $1 == 'init' ]; then
	## 创建目录
	mkdir -p $redis_path/bin $redis_path/log $redis_path/run 
	## data目录中存储rdb, aof持久化文件
	mkdir -p $redis_path/data
	rm -f $redis_path/*.conf
	mv $redis_path/runtest* $redis_path/bin
	ln -s $redis_path/src/redis-benchmark   $redis_path/bin/redis-benchmark
	ln -s $redis_path/src/redis-check-aof   $redis_path/bin/redis-check-aof
	ln -s $redis_path/src/redis-check-dump  $redis_path/bin/redis-check-dump
	ln -s $redis_path/src/redis-cli         $redis_path/bin/redis-cli
	ln -s $redis_path/src/redis-server      $redis_path/bin/redis-server
	ln -s $redis_path/src/redis-trib.rb     $redis_path/bin/redis-trib
	ln -s $redis_path/src/redis-sentinel    $redis_path/bin/redis-sentinel
	## 如果redis没有加入环境变量, 则手动加入
	already_in_path=$( echo $PATH | grep "$redis_path" | wc -l )
	if [ $already_in_path -ne 1 ]; then
		echo 'export PATH=$PATH:'${redis_path}/bin >> /etc/profile
		source /etc/profile
		source ~/.bashrc
	fi
fi

