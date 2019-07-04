# redis自动化部署

author: general
e-mail: generals.space@gmail.com
date: 2016-08-08

host列表在production与stage文件, 执行playbook命令时需要指定.

在当前目录，进行redis源码包的上传, 编译及初始化

init操作是编译安装redis的过程, 不包括创建服务与启动. `roles/init/files`目录下需要下载有redis的源码文件, 以便将其拷贝到目标服务器. 注意其版本号默认为3.0.7, 源码包名为`redis-3.0.7.tar.gz`这种格式. 


```
$ ansible-playbook -i production init.yml
```

如果是其他版本的redis, 记得在命令行指定`pkg_version`参数. ansible-playbook的`-e`选项可以添加额外的变量, 传入到playbook执行过程中, 不过最好有一个默认值以防忘记在命令行指定.

```
$ ansible-playbook -i production init.yml -e pkg_version=3.0.8
```
------

然后可以使用`service.yml`安装指定服务. 需要指定的变量有: 服务名称, 端口, 额外追加配置. 默认值在roles/common/default/main.yml

```
$ ansible-playbook -i production service.yml
```

默认新建一个服务会自动启动, 可以在命令行通过指定`auto_start=no`只创建服务配置文件, 但不启动. roles/service/tasks/main.yml中条件判断的注释, `when`指令中的变量不需要使用{{}}

```
$ ansible-playbook -i production service.yml -e auto_start=no
```

## checklist

不同的项目需要修改的地方有:

- production文件中host主机配置

- 根目录下, 不同主调playbook文件对不同分组的引用(就是hosts字段的值)

- 模板文件可能需要订制

- init.yml/service.yml中变量的设置
