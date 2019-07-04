file-push
=========

指定文件推送至远程.

特点
------------

- 批量化, 可使用`file_list`字段指定文件列表.

- 可指定本地files目录中的文件或是从网络上的url下载文件到目标主机组, 也可以是模板文件(当然, 你需要指定模板变量)

- 提供解压操作, 使用ansible内置的`unarchive`指令, 推荐压缩格式为`tar.gz`或`tar.bz2`.

- 提供复制后的权限管理操作, 方便后续的可执行文件拥有执行权限, 目标用户的修改权限等.

- 提供完成提醒操作(但处理操作不能写在`file_push`角色中).

角色变量
------------

只需要在`vars`字段定义一个`file_list`变量, 这是一个列表文件, 把你想要推送的文件和其信息都写在这里, 然后调用此角色, 就可以完成. 只需要一次.

如果你想要推送一个模板文件, 除了在`vars`中定义模板变量以外, 还要记得在调用角色时将这些变量传进去.

```yml
    vars:
        file_list:
            ## file which need to be unpacked, the key need to be the directory name. So you need unpack it first and see what it exactly be.
            apache-tomcat-8.5.8:
                name: apache-tomcat-8.5.8.tar.gz
                type: url
                src_path: http://mirrors.hust.edu.cn/apache/tomcat/tomcat-8/v8.5.8/bin/apache-tomcat-8.5.8.tar.gz
                dst_path: /usr/local/tomcat
                need_unpack: 'yes'
                need_clear: 'yes'
                with_owner:
                    user: tomcat
                    group: tomcat
            yum.conf:
                name: yum.conf
                type: file
                src_path: /etc/yum.conf
                dst_path: /etc/yum.conf
                need_unpack: 'no'
                need_clear: 'no'
                with_permission: 700
                with_notify: 'completed'
```

`file_list`的每个成员都需要事先定义其属性. 如下

> 注意: 如果一个文件是压缩文件, 而你想推送之后将其解压到指定位置, 那此成员的键名应该是这个压缩包解压后的目录名(或文件名). 如第一项里面, `apache-tomcat-8.5.8.tar.gz`解压之后为`apache-tomcat-8.5.8`. 如果你不清楚解压后的名称, 建议你事先解压一下看看.

- `name`: 该项目的完整名称. **必选**. 如果你给出的文件路径为`/tmp/apache-tomcat-8.5.8.tar.gz`或`http://mirrors.hust.edu.cn/apache/tomcat/tomcat-8/v8.5.8/bin/apache-tomcat-8.5.8.tar.gz`这种, 则这个值应该是`apache-tomcat-8.5.8.tar.gz`.

- `type`: 该项目的类型. 可以是`file(本地文件)`/`url(一个url路径)`/`tpl(本地模板文件)`. 可选, 默认为'file'. 根据此值的不同, 指定不同的`src_path`的值.

- `src_path`/`dst_path`: 文件源路径与推送到远程主机上的目标路径, **Required**.

- `need_unpack`: 是否需要解压, 可选. 其值可以是`yes`/`no`. 默认不解压.

- `need_clear`: 是否清理暂存文件, 可选. 'yes'/'no'. 默认清理(一般只有压缩包才需要此选项).

- `with_owner`: 设置文件在远程主机上的属主, 可选. 要使用这个选项, 必须同时指定此项的`user`与`group`两个子项, 否则会出错. (你可以使用`ignore_errors: True`忽略). 注意: **这里指定的用户与组必须事先存在**

- `with_permission`: 指定该项推送到远程后的权限配置, 可选. 默认`755`.

- `with_notify`: 可以指定一个通知名称, 当当前项的推送任务完成后, 抛出这个通知. 可选.

示例
------------

在`generals-space.file-push/tests/test_file_push.yml`有一个示例. 首先从`galaxy`网站上安装该角色(也可以直接在github上下载).

```
$ ansible-galaxy install generals-space.file-push
```

安装好后, 该角色会存在于`/etc/ansible/roles`下. 拷贝这个角色的`test_file_push.yml`文件到你指定的路径, 确定`stage`文件中的主机组名与`test_file_push.yml`中`hosts`字段的值相同. 

```
$ tree 
.
├── stage
├── roles
└── test_file_push.yml
```

然后执行如下命令

```
$ ansible-playbook -i ./stage test_file_push.yml
```

注意
------------

- 如果目标主机目标位置指定路径已经存在, 则`file_push`会先将原路径删掉再拷贝

- 暂存目录在远程主机的`/tmp`目录, 如果该目录下已经存在将要推送的文件, 会先删除.

- 多文件建议打包而不是直接传输目录. 没有提供目录传输支持, 也不会考虑.

- 文件不建议放在`files`目录, 要避免上传的文件加入到git仓库中, 否则每次更新都需要`ignore`新文件才行.

- `file_list`中的键名需要遵循一定的规则, 需要解压的文件, 键名需要是其解压后的目录名. 你需要先解压一次, 看看那到底是什么.

general

generals.space@gmail.com
