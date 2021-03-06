#ansible

## 角色介绍

galaxy这里把角色定位成`通用功能模块`, 每个角色完成一个任务. 

为了能与其他任务配合, 需要在当前任务里添加很多东西, 比如`notify`回调通知, 

为了能方便传参数到角色内部, 变量定义应该在角色外部, 调用之前. 角色内部只要限制好变量默认值, 以及变量缺失等异常情况即可.

### file_push

指定文件推送至远程, `file_push.yml`描述了其使用方法

**特点**

- 批量化, 可使用`file_list`指定文件列表, 按照执行顺序来看, 是会对每个文件单独执行一次`file_push.yml`中的操作.

- 可指定本地files目录中的文件或是从网络上的url下载文件到目标主机组.

- 提供解压操作, 使用ansible内置的`unarchive`指令, 推荐压缩格式为`tar.gz`或`tar.bz2`.

- 文件需要放在`file_push/files`目录, 或是`common/files`目录, 建议前者.

- 提供复制后的权限管理操作, 方便后续的可执行文件拥有执行权限, 目标用户的修改权限等.

- 提供完成提醒操作, 但处理操作不能写在`file_push`角色中.

**注意**

- 如果目标主机目标位置指定路径已经存在, 则`file_push`会先将原路径删掉再拷贝

- 模板文件最好单独

`file_list`中的键名需要遵循一定的规则, 需要解压的文件, 键名需要是其解压后的目录名. 你需要先解压一次, 看看那到底是什么.

文件的`name`是文件的全名, 如果`src_path`为`/tmp/nginx.tar.gz`, 那`name`需要是`nginx.tar.gz`. 如果`src_path`是`http://xxx.xxxx.xxx/nginx.tar.gz`也一样.