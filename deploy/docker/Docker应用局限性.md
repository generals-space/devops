# 不适用于docker完成的任务

keepalived

lvs, ipvsadm等涉及内核的工作

fastdfs, glusterfs等文件存储驱动使用docker也极为不便(基础服务如, 计算, 网络, 存储等不应该让docker完成)

## docker可以胜任的工作

redis, mongo, mysql等集群环境, 使用compose十分方便

python, php, node, c, java等开发/运行环境.

------

docker端口映射是一个很大的麻烦, 建议用一个`--net=host`的容器安装haproxy, 完成端口转发的功能, 实在比iptables要方便太多.