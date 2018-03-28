## 支付VPN环境镜像
## 使用方法: docker build -f dockerfile文件名 -t 镜像文件名 Dockerfile文件所在目录
## docker build -f pay-vpn.sh -t reg01.sky-mobi.com/vpn-reset-service/pptp:x.x.x .

## 源镜像已经对192和172在iptables中做了兼容
FROM  reg01.sky-mobi.com/vpn-reset-service/pptp:base
################################################################
## docker镜像通用设置
## 创建者信息
MAINTAINER general "jiale.huang@sky-mobi.com"

## 环境变量, 使docker容器支持中文
ENV LANG zh_CN.UTF-8
################################################################
## 拷贝初始化脚本
COPY initEnv.sh /usr/bin/initEnv
COPY iptables /etc/sysconfig/iptables
COPY sysctl.conf /etc/sysctl.conf

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && chmod 755 /usr/bin/initEnv \
    && rm -f /etc/yum.repos.d/*
    ## ...添加DNS这句居然也不生效, 只能写在启动命令中了
    ## && echo 'nameserver 114.114.114.114' > /etc/resolv.conf
    ## 在构建镜像时无权进行这种操作, 只有在启动之后再进行了.
    ## && echo 'net.ipv4.conf.all.send_redirects=0' >> /etc/sysctl.conf \
    ## && echo 'net.ipv4.conf.default.send_redirects=0' >> /etc/sysctl.conf \
    ## && echo 'net.ipv4.conf.eth0.send_redirects=0' >> /etc/sysctl \
    ## && sysctl -p

## 构建镜像时无法解析阿里云域名, 用COPY代替
COPY CentOS-Base-Aliyun.repo /etc/yum.repos.d/CentOS-Base-Aliyun.repo
COPY CentOS-Epel-Aliyun.repo /etc/yum.repos.d/CentOS-Epel-Aliyun.repo

## runningEnv环境变量由启动容器时通过-e参数指定
CMD echo 'nameserver 114.114.114.114' > /etc/resolv.conf \
    && tail -f /etc/yum.conf
    ## 改到启动后手动执行吧...
    ## && /bin/bash /root/.init/initEnv.sh $runningEnv \


#######################################################################
## 启动命令备忘
## docker run -d --privileged=true --net=macnet --restart=always \
## --ip=192.168.171.3 --name=192.168.171.3 --hostname=192-168-171-3 \
## -v /root/docker_share_dir:/root/docker_share_dir \
## reg01.sky-mobi.com/vpn-reset-service/pptp:latest

######################################################################
## 拷贝文件部分
######################################################################

######################################################################
## 初始化脚本 initEnv.sh

## #!/bin/bash
## 
## if [[ $1 == 'product' ]]; then
##     route add -net 192.168.0.0/16 gw 192.168.171.1 dev eth0
##     route del -net 0.0.0.0/0 dev eth0
## elif  [[ $1 == 'test' ]]; then
##     route add -host 115.236.18.194/32 gw 172.16.19.1 dev eth0
##     route add -net 172.16.0.0/16 gw 172.16.19.1 dev eth0
## fi
## 
## sysctl -p
## service iptables restart

######################################################################
## iptables

## *nat
## :PREROUTING ACCEPT [124:5078]
## :POSTROUTING ACCEPT [1:40]
## :OUTPUT ACCEPT [0:0]
## ## -A POSTROUTING -s 192.168.0.0/16 ! -d 192.168.0.0/16 -j MASQUERADE 
## -A POSTROUTING -j MASQUERADE 
## COMMIT
## 
## *filter
## :INPUT ACCEPT [0:0]
## :FORWARD ACCEPT [0:0]
## :OUTPUT ACCEPT [1365:134614]
## -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT 
## -A INPUT -p icmp -j ACCEPT 
## -A INPUT -p vrrp -j ACCEPT 
## -A INPUT -p gre -j ACCEPT 
## -A INPUT -i lo -j ACCEPT 
## -A INPUT -p tcp -m tcp --dport 5666 -j ACCEPT 
## -A INPUT -p udp --dport 161 -j ACCEPT
## -A INPUT -s 192.168.0.0/16 -j ACCEPT 
## -A INPUT -s 172.16.0.0/16 -j ACCEPT 
## -A INPUT -p tcp -m state --state NEW -m tcp --dport 7401 -j ACCEPT 
## -A INPUT -p tcp -m state --state NEW -m tcp --dport 1723 -j ACCEPT 
## -A INPUT -p tcp -m state --state NEW -m tcp --dport 8082 -j ACCEPT 
## -A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
## -A INPUT -p tcp -m state --state NEW -m tcp --dport 5900 -j ACCEPT
## -A INPUT -p tcp -m state --state NEW -m tcp --dport 5901 -j ACCEPT
## -A INPUT -p tcp -m state --state NEW -m tcp --dport 6001 -j ACCEPT
## -A INPUT -j REJECT --reject-with icmp-host-prohibited 
## -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
## -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT 
## ## -A FORWARD -d 192.168.0.0/16 -j ACCEPT 
## ## -A FORWARD -s 192.168.0.0/16 -j ACCEPT 
## -A FORWARD -j ACCEPT 
## #-A FORWARD -j REJECT --reject-with icmp-host-prohibited 
## COMMIT
## *mangle
## :PREROUTING ACCEPT [75:5548]
## :INPUT ACCEPT [75:5548]
## :FORWARD ACCEPT [0:0]
## :OUTPUT ACCEPT [59:5060]
## :POSTROUTING ACCEPT [59:5060]
## COMMIT
## 


###################################################################################
## sysctl.conf

## ## 开启转发
## net.ipv4.ip_forward = 1
## net.ipv4.conf.default.rp_filter = 1
## net.ipv4.conf.default.accept_source_route = 0
## ## 关闭icmp转发
## net.ipv4.conf.all.send_redirects = 0
## net.ipv4.conf.default.send_redirects = 0
## net.ipv4.conf.eth0.send_redirects = 0
## kernel.sysrq = 0
## kernel.core_uses_pid = 1
## kernel.msgmnb = 65536
## kernel.msgmax = 65536
## kernel.shmmax = 68719476736
## kernel.shmall = 4294967296