# tomcat自动化部署


```
$ ansible-playbook -i production init.yml
```


可以单独安装jdk, 也可以单独安装tomcat

```
$ ansible-playbook -i production jdk.yml
$ ansible-playbook -i production tomcat.yml
```

> 注意, 由于拷贝文件的模块放在`roles/common`下, 所以jdk与tomcat的源码包也应该放在`roles/common/files/`目录下, 或是在`jdk.yml`, `tomcat.yml`指定远程下载路径url
