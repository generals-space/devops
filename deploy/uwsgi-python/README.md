注意uwsgi的emperor启动用户与vassals的启动用户对目标工程目录的权限配置

uwsgi的emperor模式类似nginx的虚拟主机的机制

启动

```
uwsgi emperor.ini的路径
```

重启

```
uwsgi --reload pid文件路径
```

停止

```
uwsgi --stop pid文件路径
```

别名设置

可放置在`/root/.bashrc`, 供root用户使用(root启动uwsgi时进程权限依然是`uid`中指定的用户), 也可以放置在`/etc/profile`中, 全局调用.

```shell
alias uwsgi-start='/usr/local/uwsgi/bin/uwsgi /usr/local/uwsgi/etc/emperor.ini'
alias uwsgi-reload='/usr/local/uwsgi/bin/uwsgi --reload /usr/local/uwsgi/var/run/uwsgi.pid'
alias uwsgi-stop='/usr/local/uwsgi/bin/uwsgi --stop /usr/local/uwsgi/var/run/uwsgi.pid'
```

命令调用

```
## 启动
$ uwsgi-start
## 重启
$ uwsgi-reload
## 关闭
$ uwsgi-stop
```

------

CentOS7的启动脚本`uwsgi.service`, 放在`/usr/lib/systemd/system`目录下, 赋予其执行权限755.

然后执行`systemctl daemon-reload`重新加载服务脚本列表.

```
## 启动
$ systemctl start uwsgi
## 重启, 注意是restart不是reload
$ systemctl restart uwsgi
## 关闭
$ systemctl stop uwsgi
```