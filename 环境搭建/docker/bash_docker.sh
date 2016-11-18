# Some useful commands to use docker.
# Author: yeasy@github
# Created:2014-09-25
## 《docker--从入门到实践》

## 查看docker容器的PID, 参数可以是容器名或容器ID
alias docker-pid="sudo docker inspect --format '{{.State.Pid}}'"
## 查看docker容器的IP
alias docker-ip="sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}'"

## function(): 进入docker容器
## param: 目标容器名/容器ID
## param: [要执行的命令及其参数], 可选, 如果没有此参数将以交互模式进入容器
## 其实现参考了https://github.com/jpetazzo/nsenter/blob/master/docker-enter
function docker-enter() {
    #if [ -e $(dirname "$0")/nsenter ]; then
    #Change for centos bash running
    if [ -e $(dirname '$0')/nsenter ]; then
        # with boot2docker, nsenter is not in the PATH but it is in the same folder
        NSENTER=$(dirname "$0")/nsenter
    else
	## nsenter命令已经在环境变量中
        NSENTER=$(which nsenter)
    fi
    ## 如果$NSENTER字符串为空, 则说明nsenter未安装
    [ -z "$NSENTER" ] && echo "WARN Cannot find nsenter" && return

    ## 需要一个参数, 目标容器的PID, 还可以指定要执行的命令(而不进入容器)
    if [ -z "$1" ]; then
        echo "Usage: $(basename "$0") CONTAINER [COMMAND [ARG]...]"
        echo ""
        echo "Enters the Docker CONTAINER and executes the specified COMMAND."
        echo "If COMMAND is not specified, runs an interactive shell in CONTAINER."
    else
        PID=$(sudo docker inspect --format "{{.State.Pid}}" "$1")
        if [ -z "$PID" ]; then
            echo "WARN Cannot find the given container"
            return
        fi
        shift

        OPTS="--target $PID --mount --uts --ipc --net --pid"

        if [ -z "$1" ]; then
	    ## 没有为容器指定的命令, 则进入容器
	    ## 其实还是执行了命令, 执行 `su - root` 以清除宿主机的环境变量
	    ## 初始化容器的环境变量并登陆.
            #sudo $NSENTER "$OPTS" su - root
            sudo $NSENTER --target $PID --mount --uts --ipc --net --pid su - root
        else
            ## env命令可以清除宿主机的环境变量
	    ## 向目标容器运行指定命令
            sudo $NSENTER --target $PID --mount --uts --ipc --net --pid env -i $@
        fi
    fi
}

## 为正在运行时的docker容器添加端口映射
## 可满足在创建容器时未曾考虑过的映射需求
## param1: 目标容器, 可以是名称或id, 必选
## param2: 待映射的容器端口, 必选
## param3: 被映射到宿主机端口, 可选. 如不指定, 默认与param1中指定的端口保持一致
## 注意: 此端口映射功能需要iptables服务开启
function docker-map() {
	if [[ -z $1 || -z $2 ]]; then
		echo '抱歉, 您必须指定目标容器及待映射的容器端口'
		echo 'syntax: docker-map {container_name | container_id} {container_port} [host_port]'
	##	exit 1
                return 
	fi

	if [[ $(echo $2 | egrep '[^0-9]+' | wc -l) > 0 ]]; then
		echo '容器端口值不合法, 必须为数字'
	##	exit 1
                return 
	elif [[ $(echo $3 | egrep '[^0-9]+' | wc -l) > 0 ]]; then
		echo '主机端口值不合法, 必须为数字'
	##	exit 1
                return 
	fi
	
	container_ip=$(docker-ip $1)
    local result=$?
    ## 容器名错误则退出
	if (( $result != 0 )); then return $result; fi
	container_port=$2
	host_port=$3
	## 三目运算, 第1个参数可以是0或非0数字, 或者空或者非空字符串, 作为判断条件
	## 第2, 3个参数必须为数字
	host_port=$(( host_port ? host_port : container_port ))
	echo $container_ip $container_port $host_port
	## nat表上的DOCKER链被合并入PREROUTING链. 
	## 在tcp请求包流入主机时首先将其对宿主机端口host_port的请求重写为对指定容器的指定端口
	iptables -t nat -A DOCKER -p tcp -m tcp --dport $host_port -j DNAT --to $container_ip:$container_port
	## 将上面的请求包转发出去, 目标就是$container_ip:$container_port, 并添加MASQUERADE标记, 并且src必须指定为$host_ip, 只允许宿主机ip访问
	iptables -t nat -A POSTROUTING -p tcp -m tcp --src $host_ip --dst $container_ip --dport $container_port -j MASQUERADE
	## filter表上的DOCKER链被合并入INPUT链. 打开目标容器指定端口的INPUT链上的ACCEPT规则, 接受外部连接
	iptables -t filter -A DOCKER -p tcp -m tcp --dst $container_ip --dport $container_port -j ACCEPT
}
